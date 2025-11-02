import Foundation

// MARK: - Recording Configuration

struct RecordingConfig: Equatable, Sendable {
    var width: Int = 1280
    var height: Int = 720
    var frameRate: Int = 1
    var segmentDuration: TimeInterval = 900  // 15 minutes
    var showsCursor: Bool = false
    var capturesAudio: Bool = false

    static let `default` = RecordingConfig()
}

// MARK: - Recording Session

struct RecordingSession: Equatable, Sendable, Codable {
    let sessionID: String
    let startTime: Date
    let displayID: UInt32
    var segments: [RecordingSegment]
    let baseDirectory: URL

    init(
        sessionID: String,
        startTime: Date,
        displayID: UInt32,
        segments: [RecordingSegment] = [],
        baseDirectory: URL
    ) {
        self.sessionID = sessionID
        self.startTime = startTime
        self.displayID = displayID
        self.segments = segments
        self.baseDirectory = baseDirectory
    }

    var sessionDirectory: URL {
        baseDirectory.appendingPathComponent(sessionID)
    }

    var manifestPath: URL {
        sessionDirectory.appendingPathComponent("session.json")
    }
}

// MARK: - Recording Segment

struct RecordingSegment: Equatable, Sendable, Codable {
    let index: Int
    let startTime: Date
    var endTime: Date?
    var duration: TimeInterval {
        guard let endTime = endTime else {
            return Date().timeIntervalSince(startTime)
        }
        return endTime.timeIntervalSince(startTime)
    }

    var filename: String {
        String(format: "rec_segment_%03d.mp4", index)
    }
}

// MARK: - Recording Stop Mode

enum RecordingStopMode: Equatable, Sendable {
    case keep
    case cancelAndDelete
}

// MARK: - Recording Error

enum RecordingError: Error, Equatable, LocalizedError {
    case permissionDenied
    case noDisplayFound
    case captureStreamFailed(String)
    case writerCreationFailed(String)
    case sessionDirectoryCreationFailed(String)
    case alreadyRecording
    case notRecording

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return
                "Screen recording permission denied. Please enable in System Settings → Privacy & Security → Screen Recording."
        case .noDisplayFound:
            return "No display found to record."
        case .captureStreamFailed(let message):
            return "Failed to start capture stream: \(message)"
        case .writerCreationFailed(let message):
            return "Failed to create video writer: \(message)"
        case .sessionDirectoryCreationFailed(let message):
            return "Failed to create session directory: \(message)"
        case .alreadyRecording:
            return "A recording session is already in progress."
        case .notRecording:
            return "No recording session in progress."
        }
    }
}
