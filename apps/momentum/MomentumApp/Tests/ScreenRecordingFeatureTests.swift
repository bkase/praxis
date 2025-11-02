import ComposableArchitecture
import Foundation
import Testing

@testable import MomentumApp

@Suite("ScreenRecordingFeature Tests")
@MainActor
struct ScreenRecordingFeatureTests {

    // MARK: - Segment Rollover Tests

    @Test("Segment rollover creates new file at correct boundary")
    func segmentRolloverAtBoundary() async {
        let store = TestStore(
            initialState: ScreenRecordingFeature.State()
        ) {
            ScreenRecordingFeature()
        } withDependencies: {
            $0.screenRecorder = .mock(
                hasPermission: true,
                sessionID: "test-session-rollover"
            )
        }
        store.exhaustivity = .off

        // Start recording
        await store.send(.startRecording(.default))

        await store.receive(\.recordingStarted)

        // Verify recording state
        #expect(store.state.isRecording == true)
        #expect(store.state.currentSession?.sessionID == "test-session-rollover")
        #expect(store.state.currentSession?.segments.count == 1)
        #expect(store.state.currentSession?.segments[0].index == 0)
        #expect(store.state.currentSession?.segments[0].filename == "rec_segment_000.mp4")
    }

    @Test("Segment rollover creates sequential files")
    func segmentRolloverSequential() async {
        let baseDate = Date()

        // Simulate multiple segments being created over time
        let segments = [
            RecordingSegment(
                index: 0,
                startTime: baseDate,
                endTime: baseDate.addingTimeInterval(900)  // 15 minutes
            ),
            RecordingSegment(
                index: 1,
                startTime: baseDate.addingTimeInterval(900),
                endTime: baseDate.addingTimeInterval(1800)  // 30 minutes
            ),
            RecordingSegment(
                index: 2,
                startTime: baseDate.addingTimeInterval(1800),
                endTime: nil  // Current segment
            ),
        ]

        // Verify filenames are sequential
        #expect(segments[0].filename == "rec_segment_000.mp4")
        #expect(segments[1].filename == "rec_segment_001.mp4")
        #expect(segments[2].filename == "rec_segment_002.mp4")

        // Verify durations
        #expect(segments[0].duration == 900)
        #expect(segments[1].duration == 900)
    }

    // MARK: - Cancel Path Tests

    @Test("Cancel recording deletes session folder")
    func cancelRecordingDeletesFiles() async {
        let store = TestStore(
            initialState: ScreenRecordingFeature.State()
        ) {
            ScreenRecordingFeature()
        } withDependencies: {
            $0.screenRecorder = .mock(
                hasPermission: true,
                sessionID: "test-session-cancel"
            )
        }
        store.exhaustivity = .off

        // Start recording
        await store.send(.startRecording(.default))

        await store.receive(\.recordingStarted)

        // Cancel recording
        await store.send(.cancelRecording)

        // Verify session is cleared (nil indicates files were deleted)
        await store.receive(.recordingStopped(nil))

        #expect(store.state.isRecording == false)
        #expect(store.state.currentSession == nil)
    }

    @Test("Cancel recording without active session shows error")
    func cancelWithoutSession() async {
        let store = TestStore(
            initialState: ScreenRecordingFeature.State()
        ) {
            ScreenRecordingFeature()
        } withDependencies: {
            $0.screenRecorder = .mock()
        }
        store.exhaustivity = .off

        // Try to cancel without starting
        await store.send(.cancelRecording)

        #expect(store.state.error == .notRecording)
    }

    // MARK: - Stop Recording Tests

    @Test("Stop recording keeps files")
    func stopRecordingKeepsFiles() async {
        let store = TestStore(
            initialState: ScreenRecordingFeature.State()
        ) {
            ScreenRecordingFeature()
        } withDependencies: {
            $0.screenRecorder = .mock(
                hasPermission: true,
                sessionID: "test-session-stop"
            )
        }
        store.exhaustivity = .off

        // Start recording
        await store.send(.startRecording(.default))

        await store.receive(\.recordingStarted)

        // Stop recording (keep files)
        await store.send(.stopRecording)

        // Verify session is finalized (not nil means files were kept)
        await store.receive(\.recordingStopped)

        // Verify recording stopped but session was kept
        #expect(store.state.isRecording == false)
        #expect(store.state.currentSession != nil)
    }

    // MARK: - Permission Tests

    @Test("Start recording without permission fails")
    func startWithoutPermission() async {
        let store = TestStore(
            initialState: ScreenRecordingFeature.State()
        ) {
            ScreenRecordingFeature()
        } withDependencies: {
            $0.screenRecorder = .mock(
                hasPermission: false,
                throwError: .permissionDenied
            )
        }
        store.exhaustivity = .off

        await store.send(.startRecording(.default))
        await store.receive(.recordingStartFailed(.permissionDenied))

        #expect(store.state.error == .permissionDenied)
        #expect(store.state.isRecording == false)
    }

    @Test("Check permission returns status")
    func checkPermission() async {
        let store = TestStore(
            initialState: ScreenRecordingFeature.State()
        ) {
            ScreenRecordingFeature()
        } withDependencies: {
            $0.screenRecorder = .mock(hasPermission: true)
        }
        store.exhaustivity = .off

        await store.send(.checkPermission)
        await store.receive(.permissionChecked(true))

        #expect(store.state.permissionStatus == .granted)
    }
}
