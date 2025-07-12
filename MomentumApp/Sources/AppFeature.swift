import ComposableArchitecture
import Foundation
import Observation
import Sharing

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.sessionData) var sessionData: SessionData? = nil
        @Shared(.lastGoal) var lastGoal = ""
        @Shared(.lastTimeMinutes) var lastTimeMinutes = "30"
        @Shared(.analysisHistory) var analysisHistory: [AnalysisResult] = []
        
        var isLoading = false
        var error: AppError?
        var reflectionPath: String?
        
        // Derive session state from shared data
        var session: SessionState {
            if let analysis = analysisHistory.last {
                return .analyzed(analysis: analysis)
            } else if let reflectionPath = reflectionPath {
                return .awaitingAnalysis(reflectionPath: reflectionPath)
            } else if let sessionData = sessionData {
                return .active(
                    goal: sessionData.goal,
                    startTime: sessionData.startDate,
                    expectedMinutes: sessionData.expectedMinutes
                )
            } else {
                return .preparing(PreparationState(
                    goal: lastGoal,
                    timeInput: lastTimeMinutes
                ))
            }
        }
        
        // For child reducer scope
        var preparation: PreparationFeature.State? {
            get {
                guard case let .preparing(preparationState) = session else { return nil }
                return PreparationFeature.State(preparationState: preparationState)
            }
            set {
                // Updates are handled through shared state
            }
        }

        var errorMessage: String? {
            error?.errorDescription
        }

        var errorRecovery: String? {
            error?.recoverySuggestion
        }
    }

    enum Action: Equatable {
        case preparation(PreparationFeature.Action)
        case startButtonTapped
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
            case let .preparation(preparationAction):
                // Handle checklist loading errors
                if case let .checklistItemsLoaded(.failure(error)) = preparationAction {
                    if let appError = error as? AppError {
                        state.error = appError
                    } else {
                        state.error = .unexpected(error.localizedDescription)
                    }
                }
                return .none
                
            case .startButtonTapped:
                guard state.sessionData == nil else {
                    state.error = .sessionAlreadyActive
                    return .none
                }
                
                guard case let .preparing(preparationState) = state.session else {
                    return .none
                }
                
                guard let minutes = UInt64(preparationState.timeInput) else {
                    state.error = .invalidInput(reason: "Time must be a positive number")
                    return .none
                }
                
                // Save last used values
                state.$lastGoal.withLock { $0 = preparationState.goal }
                state.$lastTimeMinutes.withLock { $0 = preparationState.timeInput }

                state.isLoading = true
                state.error = nil

                return .run { send in
                    await send(
                        .rustCoreResponse(
                            await TaskResult {
                                try await .sessionStarted(
                                    rustCoreClient.start(preparationState.goal, Int(minutes)))
                            }
                        ))
                }
                .cancellable(id: CancelID.rustOperation)

            case .stopButtonTapped:
                guard state.sessionData != nil else {
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
                guard let reflectionPath = state.reflectionPath else {
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
                    state.$sessionData.withLock { $0 = sessionData }
                    state.reflectionPath = nil
                    state.$analysisHistory.withLock { $0 = [] }

                case let .sessionStopped(reflectionPath):
                    state.$sessionData.withLock { $0 = nil }
                    state.reflectionPath = reflectionPath

                case let .analysisComplete(analysis):
                    state.reflectionPath = nil
                    state.$analysisHistory.withLock { $0.append(analysis) }
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
                state.$sessionData.withLock { $0 = nil }
                state.reflectionPath = nil
                state.$analysisHistory.withLock { $0 = [] }
                state.error = nil
                state.isLoading = false
                return .cancel(id: CancelID.rustOperation)

            case .cancelCurrentOperation:
                state.isLoading = false
                return .cancel(id: CancelID.rustOperation)
            }
        }
        .ifLet(\.preparation, action: \.preparation) {
            PreparationFeature()
        }
    }
}