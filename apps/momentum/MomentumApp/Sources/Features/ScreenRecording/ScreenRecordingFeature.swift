import ComposableArchitecture
import Foundation

// MARK: - Screen Recording Feature

@Reducer
struct ScreenRecordingFeature {

    // MARK: - State

    @ObservableState
    struct State: Equatable {
        var isRecording = false
        var currentSession: RecordingSession?
        var permissionStatus: PermissionStatus = .unknown
        var error: RecordingError?

        enum PermissionStatus: Equatable {
            case unknown
            case granted
            case denied
        }
    }

    // MARK: - Action

    enum Action: Equatable, Sendable {
        case checkPermission
        case permissionChecked(Bool)
        case requestPermission
        case permissionRequested(Bool)

        case startRecording(RecordingConfig = .default)
        case recordingStarted(RecordingSession)
        case recordingStartFailed(RecordingError)

        case stopRecording
        case cancelRecording

        case recordingStopped(RecordingSession?)
        case recordingStopFailed(RecordingError)

        case clearError
    }

    // MARK: - Dependencies

    @Dependency(\.screenRecorder) var screenRecorder

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .checkPermission:
                return .run { send in
                    let hasPermission = await screenRecorder.checkPermission()
                    await send(.permissionChecked(hasPermission))
                }

            case .permissionChecked(let granted):
                state.permissionStatus = granted ? .granted : .denied
                return .none

            case .requestPermission:
                return .run { send in
                    let granted = await screenRecorder.requestPermission()
                    await send(.permissionRequested(granted))
                }

            case .permissionRequested(let granted):
                state.permissionStatus = granted ? .granted : .denied
                if !granted {
                    state.error = .permissionDenied
                }
                return .none

            case .startRecording(let config):
                guard !state.isRecording else {
                    state.error = .alreadyRecording
                    return .none
                }

                state.error = nil

                return .run { send in
                    do {
                        let session = try await screenRecorder.start(config)
                        await send(.recordingStarted(session))
                    } catch let error as RecordingError {
                        await send(.recordingStartFailed(error))
                    } catch {
                        await send(.recordingStartFailed(.captureStreamFailed(error.localizedDescription)))
                    }
                }

            case .recordingStarted(let session):
                state.isRecording = true
                state.currentSession = session
                return .none

            case .recordingStartFailed(let error):
                state.error = error
                state.isRecording = false
                return .none

            case .stopRecording:
                guard state.isRecording else {
                    state.error = .notRecording
                    return .none
                }

                return .run { send in
                    do {
                        let session = try await screenRecorder.stop(.keep)
                        await send(.recordingStopped(session))
                    } catch let error as RecordingError {
                        await send(.recordingStopFailed(error))
                    } catch {
                        await send(.recordingStopFailed(.captureStreamFailed(error.localizedDescription)))
                    }
                }

            case .cancelRecording:
                guard state.isRecording else {
                    state.error = .notRecording
                    return .none
                }

                return .run { send in
                    do {
                        _ = try await screenRecorder.stop(.cancelAndDelete)
                        await send(.recordingStopped(nil))
                    } catch let error as RecordingError {
                        await send(.recordingStopFailed(error))
                    } catch {
                        await send(.recordingStopFailed(.captureStreamFailed(error.localizedDescription)))
                    }
                }

            case .recordingStopped(let session):
                state.isRecording = false
                state.currentSession = session
                return .none

            case .recordingStopFailed(let error):
                state.error = error
                // Keep recording state as-is since stop failed
                return .none

            case .clearError:
                state.error = nil
                return .none
            }
        }
    }
}
