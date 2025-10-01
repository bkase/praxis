Excellent point. A clear, unambiguous definition of the `session.json` state file is crucial for decoupling the front and back ends. My apologies for omitting it.

Here is the updated Software Design Document, now versioned to 1.2, with the detailed specification for `session.json` included in the "Data Models" section.

---

### **Software Design Document: "Momentum"**

- **Version:** 1.2
- **Date:** July 5, 2025
- **Status:** Final
- **Author:** World's Best Software Architect

### 1. Introduction & Guiding Philosophy

This document outlines the software architecture for the **Momentum** macOS application, version 2.3. This version evolves the architecture to incorporate industry best practices for state management and testability, drawing inspiration from **The Composable Architecture (TCA)** for the SwiftUI layer and a parallel Elm-like architecture for the Rust core.

The primary goal is to create a highly testable, maintainable, and decoupled system. The user interface (SwiftUI) and the core logic (Rust) will be developed as independent, modular components that communicate through a well-defined, side-effect-managed interface. The project structure and build process will be managed by **Tuist**, ensuring consistency and scalability.

### 2. Architectural Goals & Principles

- **State-Driven & Unidirectional:** Both the GUI and the core logic will adhere to a unidirectional data flow. State changes will be the result of explicit actions, making the system's behavior predictable and easy to reason about.
- **Extreme Testability:** The architecture is designed from the ground up for unit and integration testing. Side effects (file I/O, API calls, process execution) will be managed as dependencies that can be mocked or controlled during tests.
- **Decoupling:** The SwiftUI GUI is completely decoupled from the Rust CLI. The GUI dispatches actions to a "feature" reducer, which in turn invokes the `RustCoreClient` dependency. This abstraction allows the entire UI to be tested without ever executing the Rust binary.
- **Modularity & Scalability:** The project will be managed by **Tuist**, defining a clear structure for the main app, its tests, and any future modules. This approach supports clean dependency management and scalable development.
- **Local-First & Performant:** All session state remains on the local file system. The UI is a lightweight, native SwiftUI application, while the core logic is a pre-compiled, efficient Rust binary.

### 3. System Architecture

The architecture is cleanly separated into two main parts: the SwiftUI Application and the Rust Core. Communication is unidirectional and managed through a dedicated `RustCoreClient` dependency, which invokes the Rust executable as a subprocess.

```
+------------------------------------+      +--------------------------------+
|     SwiftUI GUI (TCA-powered)      |      |       File System (Disk)       |
|          (Menu Bar App)            |      |                                |
+------------------------------------+      +--------------------------------+
| - State (AppFeature.State)         |      | - session.json (transient state) |
| - Actions (AppFeature.Action)      |<---->| - YYYY-MM-DD-HHMM.md (log)     |
| - Reducer (AppFeature)             |      | - template.md                  |
| - Dependencies (@DependencyClient) |      +----^----------------------^----+
+-----------------|------------------+           |                      |
                  |                              | (Reads)              | (Reads)
   (Calls `RustCoreClient.start()`, etc.)        |                      |
                  |                              v                      v
+-----------------v------------------+      +----|----------------------|----------------+
|     RustCoreClient (Dependency)    |      |    |                      |                |
+------------------------------------+      |    |                      |                |
| - func start(...) -> ProcessResult |      |    |                      |                |
| - func stop(...)  -> ProcessResult |      |    |                      |                |
| - func analyze(...) -> ProcessResult|      |    |                      |                |
+-----------------|------------------+      |    |                      |                |
                  | (Executes `momentum`)    |    |                      |                |
                  v                          |    |                      |                |
+-----------------+------------------+      +----|----------------------|----------------+      +----------------+
|   Rust Core CLI (`momentum`)       |           |                      |                |      |   Claude API   |
+------------------------------------+           |                      |                |      +----------------+
| - `start`: Creates session.json    |---------->|                      |                |<---->| - LLM endpoint |
| - `stop`: Creates reflection file  |---------------------------------->|                |      +----------------+
| - `analyze`: Reads file, -> stdout |<----------------------------------+                |
+------------------------------------+
```

### 4. Project Generation & Structure (Tuist)

The entire project workspace will be defined in a `Project.swift` file using **Tuist**. This provides a single source of truth for the project structure, dependencies, and build settings.

- **`Project.swift` Definition:**
  - Defines a workspace named `Momentum`.
  - Defines the main application target, `MomentumApp`.
  - Specifies dependencies, including `swift-composable-architecture`.
  - Includes a build phase to compile the Rust CLI and copy the binary into the app's `Resources` directory.
  - Defines test targets for both the app (`MomentumAppTests`) and the core logic (`MomentumCoreTests`).

### 5. Component Breakdown

#### 5.1. Rust Core CLI (`momentum`)

The core logic is a testable, state-driven Rust application. It does **not** use `stdin` for control flow.

- **Architecture (Elm-like):**
  - **`State`:** A struct representing the current application state (e.g., `SessionActive { path: PathBuf }`, `Idle`).
  - **`Action`:** An enum representing the commands (`Start { goal: String, time: u64 }`, `Stop`, `Analyze { path: PathBuf }`).
  - **`Environment`:** A struct holding all dependencies with side effects (e.g., `file_system`, `api_client`, `clock`). This allows for easy mocking in tests.
  - **`update(state, action, environment)`:** A pure function that takes the current state and an action, and returns the new state and any effects (like writing a file or making an API call) to be executed by the runtime.
- **Commands:**
  - `momentum start --goal <GOAL> --time <MINUTES>`
    - **Input:** Command-line flags.
    - **Action:** Creates `session.json` in the app's data directory.
    - **Output (stdout):** Path to the `session.json` file.
  - `momentum stop`
    - **Input:** None. Reads the path from the existing `session.json`.
    - **Action:** Creates the `YYYY-MM-DD-HHMM.md` reflection file from a template. Updates `session.json` with the path to this new markdown file.
    - **Output (stdout):** The absolute path to the newly created markdown file.
  - `momentum analyze --file <PATH>`
    - **Input:** Flag pointing to the markdown file to be analyzed.
    - **Action:** Reads the file content, queries the Claude API.
    - **Output (stdout):** The raw JSON suggestion received from the Claude API. **The file is not modified.**

#### 5.2. SwiftUI GUI Application (TCA)

The UI will be built using **The Composable Architecture (TCA)**. This ensures a testable, state-driven UI.

- **Main Reducer (`AppFeature.swift`):**
  - **`State`:** Holds the application's UI state, such as `var session: SessionState?`, where `SessionState` can be an enum like `.active(goal, startTime)`, `.awaitingAnalysis(reflectionPath)`, etc.
  - **`Action`:** Represents all user and system events, e.g., `.startButtonTapped`, `.stopButtonTapped`, `.analyzeButtonTapped`, `.rustCoreClient(ProcessResult)`.
  - **`Reducer`:** The core of the feature's logic. It processes actions to mutate state and return effects. For example, on `.startButtonTapped`, it returns an effect that calls `RustCoreClient.start()`. The result of that effect is fed back into the system via the `.rustCoreClient` action.
- **Dependencies:**
  - **`RustCoreClient.swift`:** Defined using `@DependencyClient`. This client is the _only_ part of the Swift application that knows how to execute the Rust binary.
    - **Live Implementation:** Uses `Foundation.Process` to run `momentum` commands. It will be located in `Momentum.app/Contents/Resources/`.
    - **Test Implementation:** Provides mock implementations (`testValue`) that return canned responses (e.g., a hardcoded file path or a sample JSON string) without actually running the process. This is critical for testing.
    - **Preview Implementation:** Can be used to provide sample data for SwiftUI Previews.
- **Views:**
  - The views (`IdleView`, `ActiveSessionView`, etc.) are simple, inert SwiftUI views that take a `Store` as input. They read state from the store to render themselves and send user actions back to the store.

### 6. Data Models

This section defines the core data structures used for state management and communication.

#### 6.1. State File: `session.json`

This file is the single source of truth for an active session. It is created by `momentum start`, updated by `momentum stop`, and deleted by `momentum analyze` (or the GUI app after analysis). It resides in a dedicated application support directory.

```json
{
  "goal": "string",
  "start_time": "u64",
  "time_expected": "u64",
  "reflection_file_path": "string"
}
```

- **`goal`**: `string`
  - **Description:** The user-defined objective for the focus session.
  - **Set by:** `momentum start`
- **`start_time`**: `u64`
  - **Description:** A Unix timestamp (seconds since epoch) marking when the session began.
  - **Set by:** `momentum start`
- **`time_expected`**: `u64`
  - **Description:** The user's estimated time for the session, in minutes.
  - **Set by:** `momentum start`
- **`reflection_file_path`**: `string`
  - **Description:** The absolute path to the generated markdown reflection file. This field is added _after_ the `stop` command is run.
  - **Set by:** `momentum stop`

#### 6.2. Session Template: `template.md`

This file is a read-only template embedded within the app's resources. `momentum stop` uses it to create the reflection log.

Use `reflection-template.md` as the template

#### 6.3. Analysis Output: `stdout` from `analyze`

The `momentum analyze` command does not modify any files. It prints its result directly to `stdout`. The `RustCoreClient` in the Swift app is responsible for capturing this output.

- **Format:** A raw JSON string.
- **Example:**

  ```json
  {
    "summary": "You got distracted by social media.",
    "suggestion": "Consider using a site blocker during your next session.",
    "reasoning": "Your reflection mentioned checking Twitter, which broke your focus."
  }
  ```

### 7. Testing Strategy

A primary goal of this architecture is testability. We will have two distinct suites of unit tests.

#### 7.1. Swift / TCA Tests (`swift test`)

- **Goal:** To test the SwiftUI application logic (the `AppFeature` reducer) in complete isolation from the Rust core.
- **Methodology:**
  - Use `TestStore` from the TCA library.
  - Override the `RustCoreClient` dependency with a `testValue`.
  - We can simulate various scenarios:
    - The `start` command succeeding or failing.
    - The `stop` command returning a specific file path.
    - The `analyze` command returning a valid JSON suggestion or an error.
  - **Example Test Flow:**
    1. Create a `TestStore` for `AppFeature`.
    2. Send the `.startButtonTapped` action.
    3. Assert that the application's state transitions correctly (e.g., `isLoading` becomes true).
    4. The test store will simulate the `RustCoreClient` returning a successful result.
    5. Assert that the state updates to `.active` with the correct session data.

#### 7.2. Rust Core Tests (`cargo test`)

- **Goal:** To test the Rust business logic (the `update` function) in complete isolation from the real file system and network.
- **Methodology:**
  - The Elm-like architecture makes the `update` function pure and easy to test.
  - Create a mock `Environment` for testing.
    - `file_system.write` calls will append to an in-memory `Vec<String>` instead of writing to disk.
    - `file_system.read` calls will return a hardcoded string.
    - `api_client.fetch_suggestion` will return a `Ok(mock_json)`.
  - **Example Test Flow:**
    1. Initialize a starting `State` (e.g., `State::Idle`).
    2. Define an `Action` (e.g., `Action::Start { ... }`).
    3. Instantiate a mock `Environment`.
    4. Call `let (newState, _effect) = update(initialState, action, mock_environment)`.
    5. Assert that `newState` has the expected values (e.g., `State::SessionActive { ... }`).
    6. Assert that the mock `Environment`'s in-memory file system contains the expected `session.json` content.

This comprehensive, layered testing strategy ensures that both the UI and core logic are independently verifiable, leading to a highly reliable application.

