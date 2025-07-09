import ComposableArchitecture
import Foundation
import Observation

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var session: SessionState = .idle
        var isLoading = false
        var error: AppError?

        var errorMessage: String? {
            error?.errorDescription
        }

        var errorRecovery: String? {
            error?.recoverySuggestion
        }

    }

    enum Action: Equatable {
        case startButtonTapped(goal: Goal, minutes: Minutes)
        case stopButtonTapped
        case analyzeButtonTapped
        case rustCoreResponse(TaskResult<RustCoreResponse>)
        case clearError
        case resetToIdle
        case cancelCurrentOperation
    }

    enum RustCoreResponse: Equatable {
        case sessionStarted(SessionData)
        case sessionStopped(reflectionPath: String)
        case analysisComplete(AnalysisResult)
    }

    @Dependency(\.rustCoreClient) var rustCoreClient

    enum CancelID { case rustOperation }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .startButtonTapped(goal, minutes):
                guard case .idle = state.session else {
                    state.error = .sessionAlreadyActive
                    return .none
                }

                state.isLoading = true
                state.error = nil

                return .run { send in
                    await send(
                        .rustCoreResponse(
                            await TaskResult {
                                try await .sessionStarted(
                                    rustCoreClient.start(goal.value, minutes.value))
                            }
                        ))
                }
                .cancellable(id: CancelID.rustOperation)

            case .stopButtonTapped:
                guard case .active = state.session else {
                    state.error = .noActiveSession
                    return .none
                }

                state.isLoading = true
                state.error = nil

                return .run { send in
                    await send(
                        .rustCoreResponse(
                            await TaskResult {
                                try await .sessionStopped(reflectionPath: rustCoreClient.stop())
                            }
                        ))
                }
                .cancellable(id: CancelID.rustOperation)

            case .analyzeButtonTapped:
                guard case let .awaitingAnalysis(reflectionPath) = state.session else {
                    state.error = .noReflectionToAnalyze
                    return .none
                }

                state.isLoading = true
                state.error = nil

                return .run { send in
                    await send(
                        .rustCoreResponse(
                            await TaskResult {
                                try await .analysisComplete(rustCoreClient.analyze(reflectionPath))
                            }
                        ))
                }
                .cancellable(id: CancelID.rustOperation)

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
                if let rustError = error as? RustCoreError {
                    state.error = .rustCore(rustError)
                } else {
                    state.error = .unexpected(error.localizedDescription)
                }
                return .none

            case .clearError:
                state.error = nil
                return .none

            case .resetToIdle:
                state.session = .idle
                state.error = nil
                state.isLoading = false
                return .cancel(id: CancelID.rustOperation)

            case .cancelCurrentOperation:
                state.isLoading = false
                return .cancel(id: CancelID.rustOperation)
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

