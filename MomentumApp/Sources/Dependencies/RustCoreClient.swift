import ComposableArchitecture
import Foundation

// MARK: - Supporting Types

struct SessionData: Equatable, Decodable {
    let goal: String
    let startTime: UInt64
    let timeExpected: UInt64
    let reflectionFilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case goal
        case startTime = "start_time"
        case timeExpected = "time_expected"
        case reflectionFilePath = "reflection_file_path"
    }
}

enum RustCoreError: LocalizedError, Equatable {
    case binaryNotFound
    case invalidOutput(String)
    case commandFailed(command: String, stderr: String)
    case decodingFailed(Error)
    case sessionLoadFailed(path: String, error: Error)
    
    static func == (lhs: RustCoreError, rhs: RustCoreError) -> Bool {
        switch (lhs, rhs) {
        case (.binaryNotFound, .binaryNotFound):
            return true
        case let (.invalidOutput(l), .invalidOutput(r)):
            return l == r
        case let (.commandFailed(lCommand, lStderr), .commandFailed(rCommand, rStderr)):
            return lCommand == rCommand && lStderr == rStderr
        case let (.decodingFailed(lError), .decodingFailed(rError)):
            return lError.localizedDescription == rError.localizedDescription
        case let (.sessionLoadFailed(lPath, lError), .sessionLoadFailed(rPath, rError)):
            return lPath == rPath && lError.localizedDescription == rError.localizedDescription
        default:
            return false
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .binaryNotFound:
            return "Momentum CLI binary not found in app bundle"
        case .invalidOutput(let message):
            return "Invalid output from command: \(message)"
        case .commandFailed(let command, let stderr):
            return "Command '\(command)' failed: \(stderr)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .sessionLoadFailed(let path, let error):
            return "Failed to load session from \(path): \(error.localizedDescription)"
        }
    }
}

// Move AnalysisResult here so it's available to both files
struct AnalysisResult: Equatable, Decodable {
    let summary: String
    let suggestion: String
    let reasoning: String
}

@DependencyClient
struct RustCoreClient {
    var start: @Sendable (String, Int) async throws -> SessionData
    var stop: @Sendable () async throws -> String
    var analyze: @Sendable (String) async throws -> AnalysisResult
}

extension RustCoreClient: DependencyKey {
    static let liveValue = Self(
        start: { goal, minutes in
            let (output, _) = try await executeCommand(
                "start",
                arguments: ["--goal", goal, "--time", String(minutes)]
            )
            
            guard let sessionPath = output?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !sessionPath.isEmpty else {
                throw RustCoreError.invalidOutput("start command returned no session path")
            }
            
            do {
                return try loadSession(from: sessionPath)
            } catch {
                throw RustCoreError.sessionLoadFailed(path: sessionPath, error: error)
            }
        },
        stop: {
            let (output, _) = try await executeCommand("stop", arguments: [])
            
            guard let reflectionPath = output?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !reflectionPath.isEmpty else {
                throw RustCoreError.invalidOutput("stop command returned no reflection path")
            }
            
            return reflectionPath
        },
        analyze: { filePath in
            let (output, _) = try await executeCommand(
                "analyze",
                arguments: ["--file", filePath]
            )
            
            guard let analysisJson = output,
                  !analysisJson.isEmpty,
                  let data = analysisJson.data(using: .utf8) else {
                throw RustCoreError.invalidOutput("analyze command returned no JSON")
            }
            
            do {
                return try JSONDecoder().decode(AnalysisResult.self, from: data)
            } catch {
                throw RustCoreError.decodingFailed(error)
            }
        }
    )
    
    static let testValue = Self(
        start: { goal, minutes in
            SessionData(
                goal: goal,
                startTime: 1700000000, // Fixed timestamp for testing
                timeExpected: UInt64(minutes),
                reflectionFilePath: nil
            )
        },
        stop: {
            "/tmp/test-reflection.md"
        },
        analyze: { _ in
            AnalysisResult(
                summary: "Test analysis summary",
                suggestion: "Test suggestion",
                reasoning: "Test reasoning"
            )
        }
    )
}

extension DependencyValues {
    var rustCoreClient: RustCoreClient {
        get { self[RustCoreClient.self] }
        set { self[RustCoreClient.self] = newValue }
    }
}

// MARK: - Helper Functions

@MainActor
private func executeCommand(_ command: String, arguments: [String]) async throws -> (output: String?, error: String?) {
    try await withCheckedThrowingContinuation { continuation in
        Task {
            let task = Process()
            
            // Get the path to the momentum binary in the app bundle
            #if DEBUG
            // During development, try to use the binary from the build directory first
            let devPath = "\(FileManager.default.currentDirectoryPath)/momentum/target/release/momentum"
            if FileManager.default.fileExists(atPath: devPath) {
                task.executableURL = URL(fileURLWithPath: devPath)
            } else if let binaryPath = Bundle.main.path(forResource: "momentum", ofType: nil) {
                task.executableURL = URL(fileURLWithPath: binaryPath)
            } else {
                continuation.resume(throwing: RustCoreError.binaryNotFound)
                return
            }
            #else
            // In release builds, only look in the app bundle
            guard let binaryPath = Bundle.main.path(forResource: "momentum", ofType: nil) else {
                continuation.resume(throwing: RustCoreError.binaryNotFound)
                return
            }
            task.executableURL = URL(fileURLWithPath: binaryPath)
            #endif
            
            task.arguments = [command] + arguments
            
            // Set environment variables
            var environment = ProcessInfo.processInfo.environment
            // Set a dummy API key if not present (the mock implementation doesn't use it)
            if environment["ANTHROPIC_API_KEY"] == nil {
                environment["ANTHROPIC_API_KEY"] = "dummy-key-for-development"
            }
            task.environment = environment
            
            let outputPipe = Pipe()
            let errorPipe = Pipe()
            
            task.standardOutput = outputPipe
            task.standardError = errorPipe
            
            task.terminationHandler = { process in
                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                
                let output = String(data: outputData, encoding: .utf8)
                let error = String(data: errorData, encoding: .utf8)
                
                if process.terminationStatus != 0 {
                    let stderr = error?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown error"
                    continuation.resume(throwing: RustCoreError.commandFailed(command: command, stderr: stderr))
                } else {
                    continuation.resume(returning: (output, error))
                }
            }
            
            do {
                try task.run()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

private func loadSession(from path: String) throws -> SessionData {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    return try JSONDecoder().decode(SessionData.self, from: data)
}