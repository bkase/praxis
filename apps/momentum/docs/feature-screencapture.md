Here’s the **simplified version of your Screen Recording Feature Spec** reflecting your two requested changes:

* ✅ **Testing plan simplified** — keep only unit tests for “segment rollover” and “cancel path”.
* ✅ **Removed floating indicator window** — now use the **menubar icon turning red** to indicate recording status.

---

# Screen Recording Feature Spec (macOS, ScreenCaptureKit)

## 0) Goal & Scope

Record the **entire screen** at **1 FPS** and **720p** using **ScreenCaptureKit**, producing **H.264 MP4 segments** of **≤15 minutes** each.
If the session lasts an hour, create four files (3×15 min + 1×5 min).
Files are stored in the app’s **Application Support** directory for later processing.

The recording state is indicated by the **menubar icon** turning **red** while active.
Clicking the icon stops or cancels recording:

* **Stop:** finalize the current segment, keep all files.
* **Cancel:** stop and **delete all session files**.

---

## 1) User Experience

### 1.1 Start

* User initiates recording (menu item or programmatic trigger).
* If missing screen recording permission, present explainer with link to System Settings → Privacy & Security → Screen Recording.

### 1.2 During Recording

* The **menubar icon turns red** to signal active recording.
* No additional UI is shown on screen.
* MP4 files roll over every **15 minutes** automatically.

### 1.3 Stopping

* **Click menubar icon → Stop Recording:** finalize current segment and persist all files.
* **Click menubar icon → Cancel & Delete:** immediately stop recording and delete session folder.

---

## 2) Functional Requirements

| Aspect         | Requirement                                                                |
| -------------- | -------------------------------------------------------------------------- |
| Source         | Entire display                                                             |
| Frame rate     | 1 FPS                                                                      |
| Resolution     | 1280×720 (downscaled)                                                      |
| Codec          | H.264 (AVAssetWriter)                                                      |
| Container      | MP4                                                                        |
| Segment length | ≤ 900 s (15 min)                                                           |
| Storage        | `~/Library/Application Support/<bundle-id>/ScreenRecordings/<session-id>/` |
| File names     | `rec_segment_000.mp4`, `rec_segment_001.mp4`, etc.                         |

---

## 3) Technical Architecture

### Modules

* **ScreenRecorderManager** — handles SCK setup, segmentation, encoding, and lifecycle.
* **MenuBarController** — owns menu icon, toggles red while recording, exposes Stop/Cancel commands.
* **RecordingSession** — holds session metadata (paths, duration, etc.).
* **RecordingStore** — JSON metadata persistence for crash recovery.

### Data Flow

1. `startRecording()` initializes a new session and ScreenCaptureKit stream.
2. Capture frames → enforce 1 FPS → write to MP4 via AVAssetWriter.
3. Every 900 s → close file and open new one.
4. `stopRecording()` finalizes current file; `cancelRecording()` stops and deletes session folder.

### File Layout

```
~/Library/Application Support/<bundle-id>/ScreenRecordings/
└── 2025-10-07T19-42-23Z_4f12/
    ├── rec_segment_000.mp4
    ├── rec_segment_001.mp4
    └── session.json
```

---

## 4) Core Implementation Details

### ScreenCaptureKit Configuration

* Use `SCShareableContent.current` → pick primary display.
* Create `SCContentFilter(display:)` (no excluded windows needed).
* `SCStreamConfiguration`:

  ```swift
  config.width = 1280
  config.height = 720
  config.minimumFrameInterval = CMTime(value: 1, timescale: 1)
  config.showsCursor = false
  config.capturesAudio = false
  ```
* Downsample to 1 FPS by skipping frames with < 1 s elapsed since the last write.

### AVAssetWriter

* Codec: H.264 (`AVVideoCodecType.h264`)
* Average bitrate: ~800 kbps
* Max keyframe interval: 2 s
* Create new writer every 900 s or earlier if stopped.

### File Finalization

* Write temporary `.tmp` files, rename to `.mp4` when finalized.
* Maintain a `session.json` manifest with start time, display ID, segment list, and durations.

---

## 5) Public API

```swift
enum RecordingStopMode { case keep, cancelAndDelete }

protocol ScreenRecordingControlling {
  func start(config: RecordingConfig) async throws
  func stop(mode: RecordingStopMode) async
  var isRecording: Bool { get }
  var currentSession: RecordingSession? { get }
}
```

---

## 6) Testing Plan (Simplified)

**Unit Tests Only**

| Test                 | Description                                                                          | Expected                        |
| -------------------- | ------------------------------------------------------------------------------------ | ------------------------------- |
| **Segment Rollover** | Simulate frame timestamps over > 900 s; assert new file created at correct boundary. | 15 min file rollover verified.  |
| **Cancel Path**      | Simulate cancel command; assert session folder deleted and no partial files remain.  | Session folder deleted cleanly. |

*(Integration/UI tests, FPS accuracy tests, and indicator tests are out of scope.)*

---

## 7) Acceptance Criteria

* ✅ Captures full screen at 1 FPS, 720p.
* ✅ Writes MP4 segments ≤ 15 min each.
* ✅ Menubar icon turns red while recording, restores normal color when stopped.
* ✅ “Stop” keeps files; “Cancel” deletes them.
* ✅ Unit tests for segmentation and cancel behavior pass.
* ✅ All files stored locally in app directory.

---

Would you like me to produce a **code skeleton** next (e.g., Swift types, menu bar handler, and ScreenCaptureKit setup boilerplate) so your engineers can plug in directly?
