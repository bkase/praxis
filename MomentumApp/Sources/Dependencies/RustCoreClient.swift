import ComposableArchitecture
import Foundation

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