import Foundation

// MARK: - Session Data

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

// MARK: - Analysis Result

struct AnalysisResult: Equatable, Decodable {
    let summary: String
    let suggestion: String
    let reasoning: String
}

// MARK: - Rust Core Errors

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