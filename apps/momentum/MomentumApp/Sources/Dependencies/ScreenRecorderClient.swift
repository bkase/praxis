import ComposableArchitecture
import Dependencies
import Foundation

// MARK: - Screen Recorder Client

@DependencyClient
struct ScreenRecorderClient: Sendable {
    var checkPermission: @Sendable () async -> Bool = { false }
    var requestPermission: @Sendable () async -> Bool = { false }
    var start: @Sendable (RecordingConfig) async throws -> RecordingSession
    var stop: @Sendable (RecordingStopMode) async throws -> RecordingSession?
    var currentSession: @Sendable () async -> RecordingSession?
    var isRecording: @Sendable () async -> Bool = { false }
}

// MARK: - Dependency Key

extension ScreenRecorderClient: DependencyKey {
    static let liveValue = ScreenRecorderClient(
        checkPermission: {
            await ScreenRecorderManager.shared.checkPermission()
        },
        requestPermission: {
            await ScreenRecorderManager.shared.requestPermission()
        },
        start: { config in
            try await ScreenRecorderManager.shared.start(config: config)
        },
        stop: { mode in
            try await ScreenRecorderManager.shared.stop(mode: mode)
        },
        currentSession: {
            await MainActor.run { ScreenRecorderManager.shared.currentSession }
        },
        isRecording: {
            await MainActor.run { ScreenRecorderManager.shared.isRecording }
        }
    )

    static let testValue = ScreenRecorderClient(
        checkPermission: { true },
        requestPermission: { true },
        start: { _ in
            RecordingSession(
                sessionID: "test",
                startTime: Date(),
                displayID: 1,
                segments: [],
                baseDirectory: URL(fileURLWithPath: "/tmp")
            )
        },
        stop: { _ in nil },
        currentSession: { nil },
        isRecording: { false }
    )
}

extension DependencyValues {
    var screenRecorder: ScreenRecorderClient {
        get { self[ScreenRecorderClient.self] }
        set { self[ScreenRecorderClient.self] = newValue }
    }
}

// MARK: - Mock Implementation

extension ScreenRecorderClient {
    static func mock(
        hasPermission: Bool = true,
        sessionID: String = "test-session",
        throwError: RecordingError? = nil
    ) -> Self {
        let mockSession = LockIsolated<RecordingSession?>(nil)

        return ScreenRecorderClient(
            checkPermission: { hasPermission },
            requestPermission: { hasPermission },
            start: { config in
                if let error = throwError { throw error }
                if mockSession.value != nil { throw RecordingError.alreadyRecording }

                let session = RecordingSession(
                    sessionID: sessionID,
                    startTime: Date(),
                    displayID: 1,
                    segments: [
                        RecordingSegment(
                            index: 0,
                            startTime: Date(),
                            endTime: nil
                        )
                    ],
                    baseDirectory: URL(fileURLWithPath: "/tmp/test-recordings")
                )
                mockSession.setValue(session)
                return session
            },
            stop: { mode in
                guard var session = mockSession.value else {
                    throw RecordingError.notRecording
                }

                if mode == .cancelAndDelete {
                    mockSession.setValue(nil)
                    return nil
                }

                // Finalize the last segment
                session.segments[session.segments.count - 1].endTime = Date()
                mockSession.setValue(nil)
                return session
            },
            currentSession: { mockSession.value },
            isRecording: { mockSession.value != nil }
        )
    }
}
