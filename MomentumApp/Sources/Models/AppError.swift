import Foundation

enum AppError: LocalizedError, Equatable {
    case sessionAlreadyActive
    case noActiveSession
    case noReflectionToAnalyze
    case rustCore(RustCoreError)
    case invalidInput(reason: String)
    case unexpected(String)
    
    var errorDescription: String? {
        switch self {
        case .sessionAlreadyActive:
            return "A session is already active"
        case .noActiveSession:
            return "No active session to stop"
        case .noReflectionToAnalyze:
            return "No reflection file to analyze"
        case .rustCore(let error):
            return error.errorDescription
        case .invalidInput(let reason):
            return reason
        case .unexpected(let message):
            return "Unexpected error: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .sessionAlreadyActive:
            return "Please stop the current session before starting a new one"
        case .noActiveSession:
            return "Start a new session first"
        case .noReflectionToAnalyze:
            return "Complete a session to create a reflection file"
        case .rustCore:
            return "Check your API key and network connection"
        case .invalidInput:
            return "Please check your input and try again"
        case .unexpected:
            return "Please try again or restart the app"
        }
    }
}