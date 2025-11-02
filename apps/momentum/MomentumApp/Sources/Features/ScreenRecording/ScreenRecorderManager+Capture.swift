@preconcurrency import AVFoundation
@preconcurrency import CoreMedia
import Foundation
@preconcurrency import ScreenCaptureKit

// MARK: - Capture Stream Management

extension ScreenRecorderManager: SCStreamDelegate, SCStreamOutput {

    func startCapture(
        display: SCDisplay, config: RecordingConfig, session: RecordingSession
    )
        async throws
    {
        // Create content filter
        let filter = SCContentFilter(display: display, excludingWindows: [])

        // Create stream configuration
        let streamConfig = SCStreamConfiguration()
        streamConfig.width = config.width
        streamConfig.height = config.height
        streamConfig.minimumFrameInterval = CMTime(value: 1, timescale: CMTimeScale(config.frameRate))
        streamConfig.showsCursor = config.showsCursor
        streamConfig.capturesAudio = config.capturesAudio
        streamConfig.queueDepth = 5

        // Create stream
        let stream = SCStream(filter: filter, configuration: streamConfig, delegate: self)

        do {
            // Add output handler
            try stream.addStreamOutput(self, type: .screen, sampleHandlerQueue: .main)

            // Start capture
            try await stream.startCapture()

            self.captureStream = stream

            // Create first segment
            try await startNewSegment(session: session, config: config)

        } catch {
            throw RecordingError.captureStreamFailed(error.localizedDescription)
        }
    }

    func stopCapture() async {
        guard let stream = captureStream else { return }

        do {
            try await stream.stopCapture()

            // Finalize current writer
            await finalizeCurrentWriter()

        } catch {
            print("Error stopping capture: \(error)")
        }

        captureStream = nil
    }

    // MARK: - SCStreamDelegate

    nonisolated func stream(_ stream: SCStream, didStopWithError error: Error) {
        Task { @MainActor in
            print("Stream stopped with error: \(error)")
            cleanup()
        }
    }

    // MARK: - SCStreamOutput

    nonisolated func stream(
        _ stream: SCStream,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
        of type: SCStreamOutputType
    ) {
        Task { @MainActor [sampleBuffer] in
            await handleSampleBuffer(sampleBuffer)
        }
    }

    // MARK: - Sample Buffer Handling

    private func handleSampleBuffer(_ sampleBuffer: CMSampleBuffer) async {
        guard let config = currentConfig,
            let session = currentSession,
            isRecording
        else { return }

        // Get presentation timestamp
        let presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)

        // Track first frame as baseline for timestamp remapping
        if firstFrameTime == nil {
            firstFrameTime = presentationTime
        }

        // Enforce frame rate (1 FPS)
        if let lastTime = lastFrameTime {
            let elapsed = CMTimeGetSeconds(presentationTime - lastTime)
            if elapsed < 1.0 / Double(config.frameRate) {
                return  // Skip frame
            }
        }

        // Check if we need to roll over to a new segment
        if let segmentStart = segmentStartTime {
            let elapsed = Date().timeIntervalSince(segmentStart)
            if elapsed >= config.segmentDuration {
                await rolloverSegment(session: session, config: config)
            }
        }

        // Write frame with remapped timestamp
        guard let input = videoWriterInput,
            input.isReadyForMoreMediaData,
            let firstTime = firstFrameTime
        else { return }

        // Remap timestamp to be relative to first frame (starting from 0)
        let adjustedTime = presentationTime - firstTime

        // Create new sample buffer with adjusted timing
        guard let adjustedBuffer = createAdjustedSampleBuffer(sampleBuffer, withPresentationTime: adjustedTime)
        else { return }

        input.append(adjustedBuffer)
        lastFrameTime = presentationTime
    }

    private func createAdjustedSampleBuffer(
        _ originalBuffer: CMSampleBuffer,
        withPresentationTime newTime: CMTime
    ) -> CMSampleBuffer? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(originalBuffer) else {
            return nil
        }

        var timingInfo = CMSampleTimingInfo(
            duration: CMTime(value: 1, timescale: CMTimeScale(currentConfig?.frameRate ?? 1)),
            presentationTimeStamp: newTime,
            decodeTimeStamp: .invalid
        )

        var formatDescription: CMFormatDescription?
        CMVideoFormatDescriptionCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: imageBuffer,
            formatDescriptionOut: &formatDescription
        )

        guard let formatDesc = formatDescription else {
            return nil
        }

        var sampleBuffer: CMSampleBuffer?
        CMSampleBufferCreateReadyWithImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: imageBuffer,
            formatDescription: formatDesc,
            sampleTiming: &timingInfo,
            sampleBufferOut: &sampleBuffer
        )

        return sampleBuffer
    }

    private func rolloverSegment(session: RecordingSession, config: RecordingConfig) async {
        // Finalize current writer
        await finalizeCurrentWriter()

        // Start new segment
        do {
            currentSegmentIndex += 1
            try await startNewSegment(session: session, config: config)
        } catch {
            print("Error starting new segment: \(error)")
            isRecording = false
        }
    }

    private func finalizeCurrentWriter() async {
        guard let writer = videoWriter,
            let input = videoWriterInput
        else { return }

        input.markAsFinished()

        await writer.finishWriting()

        // Move .tmp file to .mp4
        if let session = currentSession,
            currentSegmentIndex < session.segments.count
        {
            let segment = session.segments[currentSegmentIndex]
            let tmpURL = session.sessionDirectory.appendingPathComponent("\(segment.filename).tmp")
            let finalURL = session.sessionDirectory.appendingPathComponent(segment.filename)

            try? FileManager.default.moveItem(at: tmpURL, to: finalURL)
        }

        videoWriter = nil
        videoWriterInput = nil
    }
}
