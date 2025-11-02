@preconcurrency import AVFoundation
import CoreMedia
import Foundation
@preconcurrency import ScreenCaptureKit

// MARK: - Screen Recorder Manager

@MainActor
final class ScreenRecorderManager: NSObject {
    static let shared = ScreenRecorderManager()

    internal(set) var currentSession: RecordingSession?
    internal(set) var isRecording = false

    internal var captureStream: SCStream?
    internal var videoWriter: AVAssetWriter?
    internal var videoWriterInput: AVAssetWriterInput?
    internal var currentConfig: RecordingConfig?
    internal var lastFrameTime: CMTime?
    internal var firstFrameTime: CMTime?
    internal var currentSegmentIndex = 0
    internal var segmentStartTime: Date?

    private let baseDirectory: URL

    private override init() {
        // Get Application Support directory
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!
        let bundleID = Bundle.main.bundleIdentifier ?? "com.momentum.app"
        self.baseDirectory =
            appSupport
            .appendingPathComponent(bundleID)
            .appendingPathComponent("ScreenRecordings")

        super.init()

        // Create base directory if needed
        try? FileManager.default.createDirectory(
            at: baseDirectory,
            withIntermediateDirectories: true
        )
    }

    // MARK: - Permission Management

    func checkPermission() async -> Bool {
        // Check if we can get shareable content
        do {
            _ = try await SCShareableContent.current
            return true
        } catch {
            return false
        }
    }

    func requestPermission() async -> Bool {
        // On macOS, screen recording permission is granted via System Settings
        // We can only check if permission is available
        await checkPermission()
    }

    // MARK: - Recording Control

    func start(config: RecordingConfig) async throws -> RecordingSession {
        guard !isRecording else {
            throw RecordingError.alreadyRecording
        }

        // Check permission
        let hasPermission = await checkPermission()
        guard hasPermission else {
            throw RecordingError.permissionDenied
        }

        // Get shareable content
        let content = try await SCShareableContent.current
        guard let display = content.displays.first else {
            throw RecordingError.noDisplayFound
        }

        // Create session
        let sessionID = createSessionID()
        let session = RecordingSession(
            sessionID: sessionID,
            startTime: Date(),
            displayID: display.displayID,
            segments: [],
            baseDirectory: baseDirectory
        )

        // Create session directory
        try createSessionDirectory(for: session)

        // Store session
        self.currentSession = session
        self.currentConfig = config
        self.currentSegmentIndex = 0
        self.isRecording = true

        // Start capture - clean up state if this fails
        do {
            try await startCapture(display: display, config: config, session: session)
        } catch {
            // Clean up state and session directory so subsequent attempts can succeed
            cleanup()
            try? FileManager.default.removeItem(at: session.sessionDirectory)
            throw error
        }

        return session
    }

    func stop(mode: RecordingStopMode) async throws -> RecordingSession? {
        guard isRecording else {
            throw RecordingError.notRecording
        }

        // Stop capture and finalize
        await stopCapture()

        guard let session = currentSession else {
            return nil
        }

        if mode == .cancelAndDelete {
            // Delete session directory
            try? FileManager.default.removeItem(at: session.sessionDirectory)
            cleanup()
            return nil
        }

        // Finalize session
        let finalizedSession = try finalizeSession(session)

        cleanup()
        return finalizedSession
    }

    // MARK: - Private Helpers

    private func createSessionID() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        let timestamp = formatter.string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: ".", with: "-")

        let random = String(format: "%04x", Int.random(in: 0..<65536))
        return "\(timestamp)_\(random)"
    }

    private func createSessionDirectory(for session: RecordingSession) throws {
        do {
            try FileManager.default.createDirectory(
                at: session.sessionDirectory,
                withIntermediateDirectories: true
            )
        } catch {
            throw RecordingError.sessionDirectoryCreationFailed(error.localizedDescription)
        }
    }

    private func finalizeSession(_ session: RecordingSession) throws -> RecordingSession {
        var updatedSession = session

        // Finalize last segment
        if !updatedSession.segments.isEmpty {
            let lastIndex = updatedSession.segments.count - 1
            updatedSession.segments[lastIndex].endTime = Date()
        }

        // Write session manifest
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let data = try encoder.encode(updatedSession)
        try data.write(to: updatedSession.manifestPath)

        return updatedSession
    }

    internal func cleanup() {
        currentSession = nil
        currentConfig = nil
        captureStream = nil
        videoWriter = nil
        videoWriterInput = nil
        lastFrameTime = nil
        firstFrameTime = nil
        currentSegmentIndex = 0
        segmentStartTime = nil
        isRecording = false
    }
}
