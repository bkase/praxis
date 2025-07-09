import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var session: SessionState = .idle
        var isLoading = false
        var errorMessage: String?
        
        mutating func prepareForLoading() {
            isLoading = true
            errorMessage = nil
        }
    }
    
    enum Action: Equatable {
        case startButtonTapped(goal: String, minutes: Int)
        case stopButtonTapped
        case analyzeButtonTapped
        case rustCoreResponse(TaskResult<RustCoreResponse>)
        case clearError
        case resetToIdle
    }
    
    enum RustCoreResponse: Equatable {
        case sessionStarted(SessionData)
        case sessionStopped(reflectionPath: String)
        case analysisComplete(AnalysisResult)
    }
    
    @Dependency(\.rustCoreClient) var rustCoreClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .startButtonTapped(goal, minutes):
                guard case .idle = state.session else {
                    state.errorMessage = "A session is already active"
                    return .none
                }
                
                state.prepareForLoading()
                
                return .run { send in
                    await send(.rustCoreResponse(
                        TaskResult {
                            .sessionStarted(try await rustCoreClient.start(goal, minutes))
                        }
                    ))
                }
                
            case .stopButtonTapped:
                guard case .active = state.session else {
                    state.errorMessage = "No active session to stop"
                    return .none
                }
                
                state.prepareForLoading()
                
                return .run { send in
                    await send(.rustCoreResponse(
                        TaskResult {
                            .sessionStopped(reflectionPath: try await rustCoreClient.stop())
                        }
                    ))
                }
                
            case .analyzeButtonTapped:
                guard case let .awaitingAnalysis(reflectionPath) = state.session else {
                    state.errorMessage = "No reflection file to analyze"
                    return .none
                }
                
                state.prepareForLoading()
                
                return .run { send in
                    await send(.rustCoreResponse(
                        TaskResult {
                            .analysisComplete(try await rustCoreClient.analyze(reflectionPath))
                        }
                    ))
                }
                
            case let .rustCoreResponse(.success(response)):
                state.isLoading = false
                
                switch response {
                case let .sessionStarted(sessionData):
                    state.session = .active(
                        goal: sessionData.goal,
                        startTime: Date(timeIntervalSince1970: TimeInterval(sessionData.startTime)),
                        expectedMinutes: sessionData.timeExpected
                    )
                    
                case let .sessionStopped(reflectionPath):
                    state.session = .awaitingAnalysis(reflectionPath: reflectionPath)
                    
                case let .analysisComplete(analysis):
                    state.session = .analyzed(analysis: analysis)
                }
                
                return .none
                
            case let .rustCoreResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .clearError:
                state.errorMessage = nil
                return .none
                
            case .resetToIdle:
                state.session = .idle
                state.errorMessage = nil
                state.isLoading = false
                return .none
            }
        }
    }
}

// MARK: - Supporting Types

enum SessionState: Equatable {
    case idle
    case active(goal: String, startTime: Date, expectedMinutes: UInt64)
    case awaitingAnalysis(reflectionPath: String)
    case analyzed(analysis: AnalysisResult)
}

// AnalysisResult is now defined in RustCoreClient.swift