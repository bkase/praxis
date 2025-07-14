import ComposableArchitecture
import Foundation
import Observation
import Sharing

@Reducer
struct AppFeature {
    @Reducer(state: .equatable, action: .equatable)
    enum Destination {
        case preparation(PreparationFeature)
        case activeSession(ActiveSessionFeature)
        case reflection(ReflectionFeature)
        case analysis(AnalysisFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        @Shared(.sessionData) var sessionData: SessionData? = nil
        @Shared(.lastGoal) var lastGoal = ""
        @Shared(.lastTimeMinutes) var lastTimeMinutes = "30"
        @Shared(.analysisHistory) var analysisHistory: [AnalysisResult] = []
        
        @Presents var destination: Destination.State?
        @Presents var alert: AlertState<Alert>?
        @Presents var confirmationDialog: ConfirmationDialogState<ConfirmationDialog>?
        
        var isLoading = false
        var reflectionPath: String?
        
        enum Alert: Equatable {
            case dismiss
            case retry
            case openSettings
            case contactSupport
        }
        
        enum ConfirmationDialog: Equatable {
            case confirmStopSession
            case confirmReset
            case cancel
        }
        
        init() {
            // Initialize destination based on shared state
            if let analysis = analysisHistory.last {
                self.destination = .analysis(AnalysisFeature.State(analysis: analysis))
            } else if let sessionData = sessionData {
                self.destination = .activeSession(ActiveSessionFeature.State(
                    goal: sessionData.goal,
                    startTime: sessionData.startDate,
                    expectedMinutes: sessionData.expectedMinutes
                ))
            } else {
                self.destination = .preparation(PreparationFeature.State(
                    goal: lastGoal,
                    timeInput: lastTimeMinutes
                ))
            }
        }
    }

    enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        case alert(PresentationAction<State.Alert>)
        case confirmationDialog(PresentationAction<State.ConfirmationDialog>)
        case onAppear
        case rustCoreResponse(TaskResult<RustCoreResponse>)
        case startSession(goal: String, minutes: UInt64)
        case stopSession
        case analyzeReflection(path: String)
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
            case .onAppear:
                // Set initial destination based on current state
                if let analysis = state.analysisHistory.last {
                    state.destination = .analysis(AnalysisFeature.State(analysis: analysis))
                } else if let reflectionPath = state.reflectionPath {
                    state.destination = .reflection(ReflectionFeature.State(reflectionPath: reflectionPath))
                } else if let sessionData = state.sessionData {
                    state.destination = .activeSession(ActiveSessionFeature.State(
                        goal: sessionData.goal,
                        startTime: sessionData.startDate,
                        expectedMinutes: sessionData.expectedMinutes
                    ))
                } else {
                    state.destination = .preparation(PreparationFeature.State(
                        goal: state.lastGoal,
                        timeInput: state.lastTimeMinutes
                    ))
                }
                return .none
                
            // Removed checklistItemsLoaded case as it's no longer used
                
            case .destination(.presented(.preparation(.goalChanged(let goal)))):
                // Save goal to shared state
                state.$lastGoal.withLock { $0 = goal }
                return .none
                
            case .destination(.presented(.preparation(.timeInputChanged(let time)))):
                // Save time to shared state
                state.$lastTimeMinutes.withLock { $0 = time }
                return .none
                
            case .destination(.presented(.preparation(.startButtonTapped))):
                return Self.handleStartFromPreparation(state: &state)
                
            case .destination(.presented(.activeSession(.stopButtonTapped))):
                state.confirmationDialog = .stopSession()
                return .none
                
            case .destination(.presented(.reflection(.analyzeButtonTapped))):
                if let path = state.reflectionPath {
                    return .send(.analyzeReflection(path: path))
                }
                return .none
                
            case .destination(.presented(.reflection(.cancelButtonTapped))):
                state.destination = nil
                state.reflectionPath = nil
                // Go back to preparation
                state.destination = .preparation(PreparationFeature.State(
                    goal: state.lastGoal,
                    timeInput: state.lastTimeMinutes
                ))
                return .none
                
            case .destination(.presented(.analysis(.resetButtonTapped))):
                state.confirmationDialog = .resetToIdle()
                return .none
                
            case .destination(.presented(.analysis(.dismissButtonTapped))):
                state.destination = nil
                // Keep analysis in history but go to preparation
                state.destination = .preparation(PreparationFeature.State(
                    goal: state.lastGoal,
                    timeInput: state.lastTimeMinutes
                ))
                return .none
                
            case let .startSession(goal, minutes):
                guard state.sessionData == nil else {
                    state.alert = .sessionAlreadyActive()
                    return .none
                }

                state.isLoading = true
                state.alert = nil

                return .run { send in
                    await send(
                        .rustCoreResponse(
                            await TaskResult {
                                try await .sessionStarted(
                                    rustCoreClient.start(goal, Int(minutes))
                                )
                            }
                        )
                    )
                }
                .cancellable(id: CancelID.rustOperation)

            case .stopSession:
                guard state.sessionData != nil else {
                    state.alert = .noActiveSession()
                    return .none
                }

                state.isLoading = true
                state.alert = nil

                return .run { send in
                    await send(
                        .rustCoreResponse(
                            await TaskResult {
                                try await .sessionStopped(reflectionPath: rustCoreClient.stop())
                            }
                        )
                    )
                }
                .cancellable(id: CancelID.rustOperation)

            case let .analyzeReflection(path):
                state.isLoading = true
                state.alert = nil

                return .run { send in
                    await send(
                        .rustCoreResponse(
                            await TaskResult {
                                try await .analysisComplete(rustCoreClient.analyze(path))
                            }
                        )
                    )
                }
                .cancellable(id: CancelID.rustOperation)

            case let .rustCoreResponse(.success(response)):
                state.isLoading = false

                switch response {
                case let .sessionStarted(sessionData):
                    state.$sessionData.withLock { $0 = sessionData }
                    state.reflectionPath = nil
                    state.$analysisHistory.withLock { $0 = [] }
                    state.destination = .activeSession(ActiveSessionFeature.State(
                        goal: sessionData.goal,
                        startTime: sessionData.startDate,
                        expectedMinutes: sessionData.expectedMinutes
                    ))

                case let .sessionStopped(reflectionPath):
                    state.$sessionData.withLock { $0 = nil }
                    state.reflectionPath = reflectionPath
                    state.destination = .reflection(ReflectionFeature.State(reflectionPath: reflectionPath))

                case let .analysisComplete(analysis):
                    state.reflectionPath = nil
                    state.$analysisHistory.withLock { $0.append(analysis) }
                    state.destination = .analysis(AnalysisFeature.State(analysis: analysis))
                }

                return .none

            case let .rustCoreResponse(.failure(error)):
                state.isLoading = false
                
                state.alert = .error(error)
                
                return .none

            case .resetToIdle:
                state.$sessionData.withLock { $0 = nil }
                state.reflectionPath = nil
                state.$analysisHistory.withLock { $0 = [] }
                state.alert = nil
                state.isLoading = false
                state.destination = .preparation(PreparationFeature.State(
                    goal: state.lastGoal,
                    timeInput: state.lastTimeMinutes
                ))
                return .cancel(id: CancelID.rustOperation)

            case .cancelCurrentOperation:
                state.isLoading = false
                return .cancel(id: CancelID.rustOperation)
                
            case .alert(.presented(.dismiss)):
                // Alert dismissed, no action needed
                return .none
                
            case .alert(.presented(.retry)):
                // Retry the last failed operation
                // For now, we'll just dismiss the alert
                state.alert = nil
                return .none
                
            case .alert(.presented(.openSettings)):
                // TODO: Open settings when implemented
                state.alert = nil
                return .none
                
            case .alert(.presented(.contactSupport)):
                // TODO: Open support link when implemented
                state.alert = nil
                return .none
                
            case .alert(.dismiss):
                return .none
                
            case .confirmationDialog(.presented(.confirmStopSession)):
                state.confirmationDialog = nil
                return .send(.stopSession)
                
            case .confirmationDialog(.presented(.confirmReset)):
                state.confirmationDialog = nil
                return .send(.resetToIdle)
                
            case .confirmationDialog(.presented(.cancel)):
                state.confirmationDialog = nil
                return .none
                
            case .confirmationDialog(.dismiss):
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$confirmationDialog, action: \.confirmationDialog)
    }
}

// Extension to handle start session from preparation
extension AppFeature {
    static func handleStartFromPreparation(state: inout State) -> Effect<Action> {
        guard case let .preparation(preparationState) = state.destination else {
            return .none
        }
        
        guard let minutes = UInt64(preparationState.timeInput) else {
            state.alert = .invalidTime()
            return .none
        }
        
        return .send(.startSession(goal: preparationState.goal, minutes: minutes))
    }
}

// MARK: - Alert Helpers

extension AlertState where Action == AppFeature.State.Alert {
    static func sessionAlreadyActive() -> Self {
        AlertState {
            TextState("Session Already Active")
        } actions: {
            ButtonState(action: .dismiss) {
                TextState("OK")
            }
        } message: {
            TextState("Please stop the current session before starting a new one.")
        }
    }
    
    static func noActiveSession() -> Self {
        AlertState {
            TextState("No Active Session")
        } actions: {
            ButtonState(action: .dismiss) {
                TextState("OK")
            }
        } message: {
            TextState("There is no active session to stop.")
        }
    }
    
    static func invalidTime() -> Self {
        AlertState {
            TextState("Invalid Time")
        } actions: {
            ButtonState(action: .dismiss) {
                TextState("OK")
            }
        } message: {
            TextState("Time must be a positive number.")
        }
    }
    
    static func error(_ error: Error) -> Self {
        if let rustError = error as? RustCoreError {
            return rustCoreError(rustError)
        } else if let appError = error as? AppError {
            return Self.appError(appError)
        } else {
            return genericError(error)
        }
    }
    
    static func rustCoreError(_ error: RustCoreError) -> Self {
        let appError = AppError.rustCore(error)
        return AlertState {
            TextState(appError.errorDescription ?? "Error")
        } actions: {
            // Check if error is related to API key
            if case let .commandFailed(_, stderr) = error,
               stderr.contains("ANTHROPIC_API_KEY") {
                ButtonState(action: .openSettings) {
                    TextState("Open Settings")
                }
            }
            ButtonState(role: .cancel, action: .dismiss) {
                TextState("OK")
            }
        } message: {
            if let recovery = appError.recoverySuggestion {
                TextState(recovery)
            } else {
                TextState("An error occurred while communicating with the Rust core.")
            }
        }
    }
    
    static func appError(_ error: AppError) -> Self {
        AlertState {
            TextState(error.errorDescription ?? "Error")
        } actions: {
            ButtonState(action: .dismiss) {
                TextState("OK")
            }
        } message: {
            if let recovery = error.recoverySuggestion {
                TextState(recovery)
            } else {
                TextState("An unexpected error occurred.")
            }
        }
    }
    
    static func genericError(_ error: Error) -> Self {
        AlertState {
            TextState("Error")
        } actions: {
            ButtonState(action: .dismiss) {
                TextState("OK")
            }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}

// MARK: - Confirmation Dialog Helpers

extension ConfirmationDialogState where Action == AppFeature.State.ConfirmationDialog {
    static func stopSession() -> Self {
        ConfirmationDialogState {
            TextState("Stop Session?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmStopSession) {
                TextState("Stop Session")
            }
            ButtonState(role: .cancel, action: .cancel) {
                TextState("Continue Working")
            }
        } message: {
            TextState("Are you sure you want to stop the current session? You'll be prompted to write a reflection.")
        }
    }
    
    static func resetToIdle() -> Self {
        ConfirmationDialogState {
            TextState("Reset App?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmReset) {
                TextState("Reset")
            }
            ButtonState(role: .cancel, action: .cancel) {
                TextState("Cancel")
            }
        } message: {
            TextState("This will clear all session data and return to the preparation screen.")
        }
    }
}