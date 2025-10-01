Excellent. This is a crucial step in the design process—transitioning from a specification with illustrative code to a pure architectural blueprint that empowers engineers to own the implementation. This revised SDD removes all code samples, focusing solely on the "what" and "how" at a structural level.

Here is the updated Software Design Document, focused on architecture and design patterns, without prescriptive code.

---

### **Software Design Document: "Momentum"**

*   **Feature:** Integrated Pre-Session Checklist
*   **Version:** 1.3
*   **Date:** July 5, 2025
*   **Status:** Final
*   **Author:** World's Best Software Architect

### 1. Introduction & Guiding Philosophy

This document details the software design for adding the **Integrated Pre-Session Checklist** feature to the existing Momentum application. Building upon the established TCA-driven SwiftUI app and the Elm-like Rust core, this design introduces the checklist as a core component of the session preparation phase.

The guiding principle is to implement this feature entirely within the SwiftUI application layer, treating the checklist's state as ephemeral UI state. This maintains the strict decoupling from the Rust backend and reinforces the application's testability and modularity.

### 2. Architectural Impact Analysis

*   **SwiftUI Application (TCA):** This component will see the majority of the changes. The `AppFeature` reducer and its corresponding view for the idle state will be updated to manage the new checklist state and logic. A new dependency for loading the checklist will be introduced.
*   **Rust Core CLI (`momentum`):** **No changes are required.** The Rust CLI remains completely unaware of the checklist feature. The `momentum start` command is only invoked *after* the checklist is completed in the UI.
*   **Communication Bridge:** The interface between the Swift app and the Rust CLI is unchanged.
*   **Project Generation (Tuist):** The `Project.swift` file will be updated to include the default `checklist.json` as a resource.

### 3. Component Breakdown & Design

#### 3.1. SwiftUI GUI Application (TCA)

The application's core logic, managed by TCA, will be extended to handle the new state and actions related to the checklist.

*   **State (`AppFeature.State`):**
    *   The feature's top-level `SessionState` enum will be refined. The existing `.idle` case will be replaced with a `.preparing(PreparationState)` case to more accurately reflect its purpose.
    *   A new `PreparationState` struct will be created to encapsulate all data for the preparation screen. It will contain properties for the user's `goal` string, their `timeInput` string, and an `IdentifiedArrayOf<ChecklistItem>` to hold the checklist data.
    *   The `ChecklistItem` struct will be defined as `Identifiable` and `Equatable`, containing properties for `id`, `text`, and `isCompleted`.
    *   Crucially, `PreparationState` will include a computed property, `isStartButtonEnabled`, which derives its boolean value from the other state properties to determine if the session can be started.

*   **Action (`AppFeature.Action`):**
    *   The top-level `Action` enum will be expanded to drive the new workflow.
    *   An `.onAppear` action will be added to trigger the loading of the checklist when the view is first presented.
    *   A `.checklistItemsLoaded(TaskResult<[ChecklistItem]>)` action will be used to deliver the loaded checklist data back into the reducer.
    *   A bindable `.preparation` action, scoped to the `PreparationState`, will handle all user-driven changes on the preparation screen, such as text field input and checkbox toggles.

*   **Reducer (`AppFeature` Logic):**
    *   The logic within the main reducer will be updated to handle the new actions.
    *   The reducer will respond to the `.onAppear` action by executing an effect that calls the new `ChecklistClient`.
    *   Upon receiving the `.checklistItemsLoaded` action, the reducer will populate the `PreparationState.checklist` array. Error cases will be handled by updating the `error` state.
    *   A `BindingReducer` will be composed into the main reducer, scoped to the `.preparation` state and action, to automatically handle state mutations from the UI.
    *   The logic for the `.startButtonTapped` action will be updated to read the `goal` and `timeInput` from the `PreparationState` before proceeding with the existing `RustCoreClient` effect.

*   **Dependencies (`ChecklistClient.swift`):**
    *   A new dependency, `ChecklistClient`, will be defined using the `@DependencyClient` macro.
    *   Its interface will expose a single `async` function: `load() async throws -> [ChecklistItem]`.
    *   The **Live Implementation** will contain the logic to find `checklist.json` in the application support directory, or copy it from the app bundle on first launch, then parse and return its content.
    *   The **Test Implementation** will be configured to immediately return a hardcoded array of `ChecklistItem`s, enabling complete isolation for unit tests.

*   **Views (`PreparationView.swift`):**
    *   The existing `IdleView` will be renamed to `PreparationView.swift` to better reflect its new role.
    *   This view will render the UI for the `.preparing` state, including the goal field, time field, and a `ForEach` view to display the list of checklist items.
    *   The "Start Focus" button's `.disabled()` modifier will be bound to the `isStartButtonEnabled` computed property from the state.
    *   The time input field will be styled with a red border when its content cannot be parsed into a positive integer.

#### 3.2. Project Configuration (Tuist)

*   **`Project.swift`:** The Tuist project definition will be updated to include the new `checklist.json` file in the `MomentumApp/Resources` directory, ensuring it is bundled with the application.

### 4. Data Models

This section defines the core data structures used for state management and communication.

#### 4.1. File: `checklist.json`

This file defines the content of the pre-session checklist. It resides in the user's Application Support directory for Momentum.

*   **Structure:** A JSON array of objects.

    ```json
    [
      {
        "id": "a unique string identifier",
        "text": "The display text for the checklist item."
      }
    ]
    ```

*   **Default Content:**

    ```json
    [
      { "id": "check-rested", "text": "Rested, if not take 10min to lie down" },
      { "id": "check-hungry", "text": "Not hungry, if so, get a snack first" },
      { "id": "check-time", "text": "Enough time set aside to not be rushed" },
      { "id": "check-bathroom", "text": "Bathroom Break" },
      { "id": "check-playlist", "text": "Choose a good playlist and be ready to start it" },
      { "id": "check-disturb", "text": "Tell anyone around me to not disturb me for expected time" },
      { "id": "check-materials", "text": "Materials for the task in place. Physical and Virtual" },
      { "id": "check-water", "text": "Water or tea nearby" },
      { "id": "check-start", "text": "Ready to start the timer" }
    ]
    ```

### 5. Testing Strategy

The existing testing methodologies will be extended to cover the new feature.

#### 5.1. Swift / TCA Tests (`swift test`)

*   **Goal:** Test the new `PreparationState` logic within the `AppFeature` reducer.
*   **Methodology:**
    1.  Create a `TestStore` for `AppFeature`.
    2.  Override the `ChecklistClient` dependency to return a specific, known checklist.
    3.  Send an `.onAppear` action and assert that the store's state is correctly populated with the checklist items from the mock client.
    4.  Send a series of bindable actions that simulate the user checking off each item.
    5.  Assert that the `isStartButtonEnabled` computed property remains `false` throughout this process.
    6.  Send actions to populate the `goal` and `timeInput` fields.
    7.  After the last required input is provided, assert that `isStartButtonEnabled` becomes `true`.
    8.  Send the `.startButtonTapped` action and assert that the `RustCoreClient.start` effect is correctly initiated with the expected parameters.

#### 5.2. Rust Core Tests (`cargo test`)

*   No changes or new tests are required for the Rust core for this feature.