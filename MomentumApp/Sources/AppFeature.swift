import ComposableArchitecture
import Foundation
import Observation
import IdentifiedCollections

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var session: SessionState = .preparing(PreparationState())
        var isLoading = false
        var error: AppError?

        var errorMessage: String? {
            error?.errorDescription
        }

        var errorRecovery: String? {
            error?.recoverySuggestion
        }

    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case checklistItemsLoaded(TaskResult<[ChecklistItem]>)
        case startButtonTapped
        case stopButtonTapped
        case analyzeButtonTapped
        case rustCoreResponse(TaskResult<RustCoreResponse>)
        case clearError
        case resetToIdle
        case cancelCurrentOperation
        case preparation(PreparationAction)
    }
    
    enum PreparationAction: Equatable {
        case checklistItemToggled(ChecklistItem.ID)
    }

    enum RustCoreResponse: Equatable {
        case sessionStarted(SessionData)
        case sessionStopped(reflectionPath: String)
        case analysisComplete(AnalysisResult)
    }

    @Dependency(\.rustCoreClient) var rustCoreClient
    @Dependency(\.checklistClient) var checklistClient

    enum CancelID { case rustOperation }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return .run { send in
                    await send(
                        .checklistItemsLoaded(
                            await TaskResult {
                                try await checklistClient.load()
                            }
                        )
                    )
                }
                
            case let .checklistItemsLoaded(.success(items)):
                guard case .preparing(var preparationState) = state.session else {
                    return .none
                }
                preparationState.checklist = IdentifiedArray(uniqueElements: items)
                state.session = .preparing(preparationState)
                return .none
                
            case let .checklistItemsLoaded(.failure(error)):
                if let appError = error as? AppError {
                    state.error = appError
                } else {
                    state.error = .unexpected(error.localizedDescription)
                }
                return .none
                
            case let .preparation(.checklistItemToggled(id)):
                guard case .preparing(var preparationState) = state.session else {
                    return .none
                }
                preparationState.checklist[id: id]?.isCompleted.toggle()
                state.session = .preparing(preparationState)
                return .none
            case .startButtonTapped:
                guard case let .preparing(preparationState) = state.session else {
                    state.error = .sessionAlreadyActive
                    return .none
                }
                
                guard let minutes = UInt64(preparationState.timeInput) else {
                    state.error = .invalidInput(reason: "Time must be a positive number")
                    return .none
                }

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
                state.session = .preparing(PreparationState())
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
    case preparing(PreparationState)
    case active(goal: String, startTime: Date, expectedMinutes: UInt64)
    case awaitingAnalysis(reflectionPath: String)
    case analyzed(analysis: AnalysisResult)
}

struct PreparationState: Equatable {
    var goal: String = ""
    var timeInput: String = ""
    var checklist: IdentifiedArrayOf<ChecklistItem> = []
    
    var isStartButtonEnabled: Bool {
        !goal.isEmpty &&
        Int(timeInput).map { $0 > 0 } == true &&
        checklist.allSatisfy { $0.isCompleted }
    }
}

// AnalysisResult is now defined in RustCoreClient.swift

