@preconcurrency import AVFoundation
import CoreMedia
import Foundation

// MARK: - Video Writer Management

extension ScreenRecorderManager {

    func startNewSegment(session: RecordingSession, config: RecordingConfig) async throws {
        // Create segment metadata
        let segment = RecordingSegment(
            index: currentSegmentIndex,
            startTime: Date(),
            endTime: nil
        )

        // Update session
        var updatedSession = session
        updatedSession.segments.append(segment)
        currentSession = updatedSession

        segmentStartTime = Date()

        // Create video writer
        try createVideoWriter(for: segment, in: session, config: config)
    }

    private func createVideoWriter(
        for segment: RecordingSegment,
        in session: RecordingSession,
        config: RecordingConfig
    ) throws {
        let tmpURL = session.sessionDirectory.appendingPathComponent("\(segment.filename).tmp")

        // Remove existing temp file if present
        try? FileManager.default.removeItem(at: tmpURL)

        // Create AVAssetWriter
        let writer: AVAssetWriter
        do {
            writer = try AVAssetWriter(outputURL: tmpURL, fileType: .mp4)
        } catch {
            throw RecordingError.writerCreationFailed(error.localizedDescription)
        }

        // Create video input
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: config.width,
            AVVideoHeightKey: config.height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 800_000,  // 800 kbps
                AVVideoMaxKeyFrameIntervalKey: 2,
            ] as [String: Any],
        ]

        let input = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        input.expectsMediaDataInRealTime = true

        guard writer.canAdd(input) else {
            throw RecordingError.writerCreationFailed("Cannot add video input to writer")
        }

        writer.add(input)

        // Start writing
        guard writer.startWriting() else {
            if let error = writer.error {
                throw RecordingError.writerCreationFailed(error.localizedDescription)
            }
            throw RecordingError.writerCreationFailed("Unknown error starting writer")
        }

        writer.startSession(atSourceTime: .zero)

        self.videoWriter = writer
        self.videoWriterInput = input
        self.lastFrameTime = nil
        self.firstFrameTime = nil  // Reset for new segment
    }
}
