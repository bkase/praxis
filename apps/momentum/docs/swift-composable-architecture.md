<!--
Downloaded via https://llm.codes by @steipete on July 12, 2025 at 12:16 PM
Source URL: https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture
Total pages processed: 187
URLs filtered: Yes
Content de-duplicated: Yes
Availability strings filtered: Yes
Code blocks only: No
-->

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture

Framework

# ComposableArchitecture

The Composable Architecture (TCA, for short) is a library for building applications in a consistent and understandable way, with composition, testing, and ergonomics in mind. It can be used in SwiftUI, UIKit, and more, and on any Apple platform (iOS, macOS, tvOS, and watchOS).

## Additional Resources

- GitHub Repo

- Discussions

- Point-Free Videos

## Overview

This library provides a few core tools that can be used to build applications of varying purpose and complexity. It provides compelling stories that you can follow to solve many problems you encounter day-to-day when building applications, such as:

- **State management**

How to manage the state of your application using simple value types, and share state across many screens so that mutations in one screen can be immediately observed in another screen.

- **Composition**

How to break down large features into smaller components that can be extracted to their own, isolated modules and be easily glued back together to form the feature.

- **Side effects**

How to let certain parts of the application talk to the outside world in the most testable and understandable way possible.

- **Testing**

How to not only test a feature built in the architecture, but also write integration tests for features that have been composed of many parts, and write end-to-end tests to understand how side effects influence your application. This allows you to make strong guarantees that your business logic is running in the way you expect.

- **Ergonomics**

How to accomplish all of the above in a simple API with as few concepts and moving parts as possible.

## Topics

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

### Tutorials

Meet the Composable Architecture

Building SyncUps

The SyncUps application is a recreation of one of Apple’s more interesting demo applications, Scrumdinger. We recreate it from scratch using the Composable Architecture, with a focus on domain modeling, controlling dependencies, and testability.

### State management

`protocol Reducer`

A protocol that describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any.

`struct Effect`

`class Store`

A store represents the runtime that powers the application. It is the object that you will pass around to views that need to interact with the application.

### Testing

`class TestStore`

A testable runtime for a reducer.

### Integrations

Adopting Swift concurrency

Learn how to write safe, concurrent effects using Swift’s structured concurrency.

Integrating the Composable Architecture into a SwiftUI application.

Observation backport

Learn how the Observation framework from Swift 5.9 was backported to support iOS 16 and earlier, as well as the caveats of using the backported tools.

Integrating the Composable Architecture into a UIKit application.

### Migration guides

Learn how to upgrade your application to the newest version of the Composable Architecture.

### Structures

`struct AppStorageKeyPathKey`

A type defining a user defaults persistence strategy via key path.

Deprecated

### Enumerations

`enum IdentifiedAction`

A wrapper type for actions that can be presented in a list.

### Extended Modules

PerceptionCore

Sharing

SwiftNavigation

SwiftUICore

## See Also

### Related Documentation

The collection of videos from that dive deep into the development of the library.

Point-Free Videos

- ComposableArchitecture
- Additional Resources
- Overview
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/

Framework

# ComposableArchitecture

The Composable Architecture (TCA, for short) is a library for building applications in a consistent and understandable way, with composition, testing, and ergonomics in mind. It can be used in SwiftUI, UIKit, and more, and on any Apple platform (iOS, macOS, tvOS, and watchOS).

## Additional Resources

- GitHub Repo

- Discussions

- Point-Free Videos

## Overview

This library provides a few core tools that can be used to build applications of varying purpose and complexity. It provides compelling stories that you can follow to solve many problems you encounter day-to-day when building applications, such as:

- **State management**

How to manage the state of your application using simple value types, and share state across many screens so that mutations in one screen can be immediately observed in another screen.

- **Composition**

How to break down large features into smaller components that can be extracted to their own, isolated modules and be easily glued back together to form the feature.

- **Side effects**

How to let certain parts of the application talk to the outside world in the most testable and understandable way possible.

- **Testing**

How to not only test a feature built in the architecture, but also write integration tests for features that have been composed of many parts, and write end-to-end tests to understand how side effects influence your application. This allows you to make strong guarantees that your business logic is running in the way you expect.

- **Ergonomics**

How to accomplish all of the above in a simple API with as few concepts and moving parts as possible.

## Topics

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

### Tutorials

Meet the Composable Architecture

Building SyncUps

The SyncUps application is a recreation of one of Apple’s more interesting demo applications, Scrumdinger. We recreate it from scratch using the Composable Architecture, with a focus on domain modeling, controlling dependencies, and testability.

### State management

`protocol Reducer`

A protocol that describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any.

`struct Effect`

`class Store`

A store represents the runtime that powers the application. It is the object that you will pass around to views that need to interact with the application.

### Testing

`class TestStore`

A testable runtime for a reducer.

### Integrations

Adopting Swift concurrency

Learn how to write safe, concurrent effects using Swift’s structured concurrency.

Integrating the Composable Architecture into a SwiftUI application.

Observation backport

Learn how the Observation framework from Swift 5.9 was backported to support iOS 16 and earlier, as well as the caveats of using the backported tools.

Integrating the Composable Architecture into a UIKit application.

### Migration guides

Learn how to upgrade your application to the newest version of the Composable Architecture.

### Structures

`struct AppStorageKeyPathKey`

A type defining a user defaults persistence strategy via key path.

Deprecated

### Enumerations

`enum IdentifiedAction`

A wrapper type for actions that can be presented in a list.

### Extended Modules

PerceptionCore

Sharing

SwiftNavigation

SwiftUICore

## See Also

### Related Documentation

The collection of videos from that dive deep into the development of the library.

Point-Free Videos

- ComposableArchitecture
- Additional Resources
- Overview
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/gettingstarted

- ComposableArchitecture
- Getting started

Article

# Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

## Adding the Composable Architecture as a dependency

To use the Composable Architecture in a SwiftPM project, add it to the dependencies of your Package.swift and specify the `ComposableArchitecture` product in any targets that need access to the library:

let package = Package(
dependencies: [\
.package(\
url: "https://github.com/pointfreeco/swift-composable-architecture",\
from: "1.0.0"\
),\
],
targets: [\
.target(\

dependencies: [\
.product(\
name: "ComposableArchitecture",\
package: "swift-composable-architecture"\
)\
]\
)\
]
)

## Writing your first feature

To build a feature using the Composable Architecture you define some types and values that model your domain:

- **State**: A type that describes the data your feature needs to perform its logic and render its UI.

- **Action**: A type that represents all of the actions that can happen in your feature, such as user actions, notifications, event sources and more.

- **Reducer**: A function that describes how to evolve the current state of the app to the next state given an action. The reducer is also responsible for returning any effects that should be run, such as API requests, which can be done by returning an `Effect` value.

- **Store**: The runtime that actually drives your feature. You send all user actions to the store so that the store can run the reducer and effects, and you can observe state changes in the store so that you can update UI.

The benefits of doing this are that you will instantly unlock testability of your feature, and you will be able to break large, complex features into smaller domains that can be glued together.

As a basic example, consider a UI that shows a number along with “+” and “−” buttons that increment and decrement the number. To make things interesting, suppose there is also a button that when tapped makes an API request to fetch a random fact about that number and displays it in the view.

To implement this feature we create a new type that will house the domain and behavior of the feature, and it will be annotated with the `@Reducer` macro:

import ComposableArchitecture

@Reducer
struct Feature {
}

In here we need to define a type for the feature’s state, which consists of an integer for the current count, as well as an optional string that represents the fact being presented:

@Reducer
struct Feature {
@ObservableState
struct State: Equatable {
var count = 0
var numberFact: String?
}
}

We also need to define a type for the feature’s actions. There are the obvious actions, such as tapping the decrement button, increment button, or fact button. But there are also some slightly non-obvious ones, such as the action that occurs when we receive a response from the fact API request:

@Reducer
struct Feature {
@ObservableState
struct State: Equatable { /* ... */ }
enum Action {
case decrementButtonTapped
case incrementButtonTapped
case numberFactButtonTapped
case numberFactResponse(String)
}
}

And then we implement the `body` property, which is responsible for composing the actual logic and behavior for the feature. In it we can use the `Reduce` reducer to describe how to change the current state to the next state, and what effects need to be executed. Some actions don’t need to execute effects, and they can return `.none` to represent that:

@Reducer
struct Feature {
@ObservableState
struct State: Equatable { /* ... */ }
enum Action { /* ... */ }

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none

case .incrementButtonTapped:
state.count += 1
return .none

case .numberFactButtonTapped:
return .run { [count = state.count] send in
let (data, _) = try await URLSession.shared.data(
from: URL(string: "http://numbersapi.com/\(count)/trivia")!
)
await send(
.numberFactResponse(String(decoding: data, as: UTF8.self))
)
}

case let .numberFactResponse(fact):
state.numberFact = fact
return .none
}
}
}
}

struct FeatureView: View {

Form {
Section {
Text("\(store.count)")
Button("Decrement") { store.send(.decrementButtonTapped) }
Button("Increment") { store.send(.incrementButtonTapped) }
}

Section {
Button("Number fact") { store.send(.numberFactButtonTapped) }
}

if let fact = store.numberFact {
Text(fact)
}
}
}
}

It is also straightforward to have a UIKit controller driven off of this store. You can observe state changes in the store in `viewDidLoad`, and then populate the UI components with data from the store. The code is a bit longer than the SwiftUI version, so we have collapsed it here:

class FeatureViewController: UIViewController {

self.store = store
super.init(nibName: nil, bundle: nil)
}

required init?(coder: NSCoder) {
fatalError("init(coder:) has not been implemented")
}

override func viewDidLoad() {
super.viewDidLoad()

let countLabel = UILabel()
let decrementButton = UIButton()
let incrementButton = UIButton()
let factLabel = UILabel()

// Omitted: Add subviews and set up constraints...

observe { [weak self] in
guard let self
else { return }

countLabel.text = "\(self.store.count)"
factLabel.text = self.store.numberFact
}
}

@objc private func incrementButtonTapped() {
self.store.send(.incrementButtonTapped)
}
@objc private func decrementButtonTapped() {
self.store.send(.decrementButtonTapped)
}
@objc private func factButtonTapped() {
self.store.send(.numberFactButtonTapped)
}
}

Once we are ready to display this view, for example in the app’s entry point, we can construct a store. This can be done by specifying the initial state to start the application in, as well as the reducer that will power the application:

@main
struct MyApp: App {
var body: some Scene {
WindowGroup {
FeatureView(
store: Store(initialState: Feature.State()) {
Feature()
}
)
}
}
}

And that is enough to get something on the screen to play around with. It’s definitely a few more steps than if you were to do this in a vanilla SwiftUI way, but there are a few benefits. It gives us a consistent manner to apply state mutations, instead of scattering logic in some observable objects and in various action closures of UI components. It also gives us a concise way of expressing side effects. And we can immediately test this logic, including the effects, without doing much additional work.

## Testing your feature

To test use a `TestStore`, which can be created with the same information as the `Store`, but it does extra work to allow you to assert how your feature evolves as actions are sent:

@Test
func basics() async {
let store = TestStore(initialState: Feature.State()) {
Feature()
}
}

Once the test store is created we can use it to make an assertion of an entire user flow of steps. Each step of the way we need to prove that state changed how we expect. For example, we can simulate the user flow of tapping on the increment and decrement buttons:

// Test that tapping on the increment/decrement buttons changes the count
await store.send(.incrementButtonTapped) {
$0.count = 1
}
await store.send(.decrementButtonTapped) {
$0.count = 0
}

Further, if a step causes an effect to be executed, which feeds data back into the store, we must assert on that. For example, if we simulate the user tapping on the fact button we expect to receive a fact response back with the fact, which then causes the `numberFact` state to be populated:

await store.send(.numberFactButtonTapped)

await store.receive(\.numberFactResponse) {
$0.numberFact = ???
}

// ...
}

Then we can use it in the `reduce` implementation:

case .numberFactButtonTapped:
return .run { [count = state.count] send in
let fact = try await self.numberFact(count)
await send(.numberFactResponse(fact))
}

And in the entry point of the application we can provide a version of the dependency that actually interacts with the real world API server:

@main
struct MyApp: App {
var body: some Scene {
WindowGroup {
FeatureView(
store: Store(initialState: Feature.State()) {
Feature(
numberFact: { number in
let (data, _) = try await URLSession.shared.data(
from: URL(string: "http://numbersapi.com/\(number)")!
)
return String(decoding: data, as: UTF8.self)
}
)
}
)
}
}
}

But in tests we can use a mock dependency that immediately returns a deterministic, predictable fact:

@Test
func basics() async {
let store = TestStore(initialState: Feature.State()) {
Feature(numberFact: { "\($0) is a good number Brent" })
}
}

With that little bit of upfront work we can finish the test by simulating the user tapping on the fact button, and then receiving the response from the dependency to present the fact:

await store.receive(\.numberFactResponse) {
$0.numberFact = "0 is a good number Brent"
}

We can also improve the ergonomics of using the `numberFact` dependency in our application. Over time the application may evolve into many features, and some of those features may also want access to `numberFact`, and explicitly passing it through all layers can get annoying. There is a process you can follow to “register” dependencies with the library, making them instantly available to any layer in the application.

We can start by wrapping the number fact functionality in a new type:

struct NumberFactClient {

}

And then registering that type with the dependency management system by conforming the client to the `DependencyKey` protocol, which requires you to specify the live value to use when running the application in simulators or devices:

extension NumberFactClient: DependencyKey {
static let liveValue = Self(
fetch: { number in
let (data, _) = try await URLSession.shared
.data(from: URL(string: "http://numbersapi.com/\(number)")!
)
return String(decoding: data, as: UTF8.self)
}
)
}

extension DependencyValues {
var numberFact: NumberFactClient {
get { self[NumberFactClient.self] }
set { self[NumberFactClient.self] = newValue }
}
}

With that little bit of upfront work done you can instantly start making use of the dependency in any feature by using the `@Dependency` property wrapper:

@Reducer
struct Feature {

+ @Dependency(\.numberFact) var numberFact

…

- try await self.numberFact(count)
+ try await self.numberFact.fetch(count)
}

This code works exactly as it did before, but you no longer have to explicitly pass the dependency when constructing the feature’s reducer. When running the app in previews, the simulator or on a device, the live dependency will be provided to the reducer, and in tests the test dependency will be provided.

This means the entry point to the application no longer needs to construct dependencies:

And the test store can be constructed without specifying any dependencies, but you can still override any dependency you need to for the purpose of the test:

let store = TestStore(initialState: Feature.State()) {
Feature()
} withDependencies: {
$0.numberFact.fetch = { "\($0) is a good number Brent" }
}

// ...

That is the basics of building and testing a feature in the Composable Architecture. There are _a lot_ more things to be explored. Be sure to check out the Meet the Composable Architecture tutorial, as well as dedicated articles on Dependencies, Testing, Navigation, Performance, and more. Also, the Examples directory has a bunch of projects to explore to see more advanced usages.

## See Also

### Essentials

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

- Getting started
- Adding the Composable Architecture as a dependency
- Writing your first feature
- Testing your feature
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/dependencymanagement

- ComposableArchitecture
- Dependencies

Article

# Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

## Overview

Dependencies in an application are the types and functions that need to interact with outside systems that you do not control. Classic examples of this are API clients that make network requests to servers, but also seemingly innocuous things such as `UUID` and `Date` initializers, and even clocks, can be thought of as dependencies.

By controlling the dependencies our features need to do their job we gain the ability to completely alter the execution context a feature runs in. This means in tests and Xcode previews you can provide a mock version of an API client that immediately returns some stubbed data rather than making a live network request to a server.

## Overriding dependencies

It is possible to change the dependencies for just one particular reducer inside a larger composed reducer. This can be handy when running a feature in a more controlled environment where it may not be appropriate to communicate with the outside world.

For example, suppose you want to teach users how to use your feature through an onboarding experience. In such an experience it may not be appropriate for the user’s actions to cause data to be written to disk, or user defaults to be written, or any number of things. It would be better to use mock versions of those dependencies so that the user can interact with your feature in a fully controlled environment.

To do this you can use the `dependency(_:_:)` method to override a reducer’s dependency with another value:

@Reducer
struct Onboarding {

Reduce { state, action in
// Additional onboarding logic
}
Feature()
.dependency(\.userDefaults, .mock)
.dependency(\.database, .mock)
}
}

This will cause the `Feature` reducer to use a mock user defaults and database dependency, as well as any reducer `Feature` uses under the hood, _and_ any effects produced by `Feature`.

## See Also

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

- Dependencies
- Overview
- Overriding dependencies
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/testingtca

- ComposableArchitecture
- Testing

Article

# Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

## Overview

The testability of features built in the Composable Architecture is the #1 priority of the library. It should be possible to test not only how state changes when actions are sent into the store, but also how effects are executed and feed data back into the system.

- Testing state changes

- Testing effects

- Non-exhaustive testing

- Testing gotchas

## Testing state changes

State changes are by far the simplest thing to test in features built with the library. A `Reducer`’s first responsibility is to mutate the current state based on the action received into the system. To test this we can technically run a piece of mutable state through the reducer and then assert on how it changed after, like this:

@Reducer
struct Feature {
@ObservableState
struct State: Equatable {
var count = 0
}
enum Action {
case incrementButtonTapped
case decrementButtonTapped
}

Reduce { state, action in
switch action {
case .incrementButtonTapped:
state.count += 1
return .none
case .decrementButtonTapped:
state.count -= 1
return .none
}
}
}
}

@Test
func basics() {
let feature = Feature()
var currentState = Feature.State(count: 0)
_ = feature.reduce(into: &currentState, action: .incrementButtonTapped)
#expect(currentState == State(count: 1))

_ = feature.reduce(into: &currentState, action: .decrementButtonTapped)
#expect(currentState == State(count: 0))
}

This will technically work, but it’s a lot boilerplate for something that should be quite simple.

The library comes with a tool specifically designed to make testing like this much simpler and more concise. It’s called `TestStore`, and it is constructed similarly to `Store` by providing the initial state of the feature and the `Reducer` that runs the feature’s logic:

import Testing

@MainActor
struct CounterTests {
@Test
func basics() async {
let store = TestStore(initialState: Feature.State(count: 0)) {
Feature()
}
}
}

Test stores have a `TestStore/send(_:assert:fileID:file:line:column:)-8f2pl` method, but it behaves differently from stores and view stores. You provide an action to send into the system, but then you must also provide a trailing closure to describe how the state of the feature changed after sending the action:

await store.send(.incrementButtonTapped) {
// ...
}

This closure is handed a mutable variable that represents the state of the feature _before_ sending the action, and it is your job to make the appropriate mutations to it to get it into the shape it should be after sending the action:

await store.send(.incrementButtonTapped) {
$0.count = 1
}

If your mutation is incorrect, meaning you perform a mutation that is different from what happened in the `Reducer`, then you will get a test failure with a nicely formatted message showing exactly what part of the state does not match:

await store.send(.incrementButtonTapped) {
$0.count = 999
}

You can also send multiple actions to emulate a script of user actions and assert each step of the way how the state evolved:

await store.send(.incrementButtonTapped) {
$0.count = 1
}
await store.send(.incrementButtonTapped) {
$0.count = 2
}
await store.send(.decrementButtonTapped) {
$0.count = 1
}

Test stores do expose a `state` property, which can be useful for performing assertions on computed properties you might have defined on your state. For example, if `State` had a computed property for checking if `count` was prime, we could test it like so:

store.send(.incrementButtonTapped) {
$0.count = 3
}
XCTAssertTrue(store.state.isPrime)

However, when inside the trailing closure of `TestStore/send(_:assert:fileID:file:line:column:)-8f2pl`, the `state` property is equal to the state _before_ sending the action, not after. That prevents you from being able to use an escape hatch to get around needing to actually describe the state mutation, like so:

store.send(.incrementButtonTapped) {
$0 = store.state // ❌ store.state is the previous, not current, state.
}

## Testing effects

Testing state mutations as shown in the previous section is powerful, but is only half the story when it comes to testing features built in the Composable Architecture. The second responsibility of `Reducer` s, after mutating state from an action, is to return an `Effect` that encapsulates a unit of work that runs in the outside world and feeds data back into the system.

Effects form a major part of a feature’s logic. They can perform network requests to external services, load and save data to disk, start and stop timers, interact with Apple frameworks (Core Location, Core Motion, Speech Recognition, etc.), and more.

As a simple example, suppose we have a feature with a button such that when you tap it, it starts a timer that counts up until you reach 5, and then stops. This can be accomplished using the `run(priority:operation:catch:fileID:filePath:line:column:)` helper on `Effect`, which provides you with an asynchronous context to operate in and can send multiple actions back into the system:

@Reducer
struct Feature {
@ObservableState
struct State: Equatable {
var count = 0
}
enum Action {
case startTimerButtonTapped
case timerTick
}

Reduce { state, action in
switch action {
case .startTimerButtonTapped:
state.count = 0
return .run { send in
for _ in 1...5 {
try await Task.sleep(for: .seconds(1))
await send(.timerTick)
}
}

case .timerTick:
state.count += 1
return .none
}
}
}
}

To test this we can start off similar to how we did in the previous section when testing state mutations:

@MainActor
struct TimerTests {
@Test
func basics() async {
let store = TestStore(initialState: Feature.State(count: 0)) {
Feature()
}
}
}

With the basics set up, we can send an action into the system to assert on what happens, such as the `.startTimerButtonTapped` action. This time we don’t actually expect state to change at first because when starting the timer we don’t change state, and so in this case we can leave off the trailing closure:

await store.send(.startTimerButtonTapped)

However, if we run the test as-is with no further interactions with the test store, we get a failure:

This is happening because `TestStore` requires you to exhaustively prove how the entire system of your feature evolves over time. If an effect is still running when the test finishes and the test store did _not_ fail then it could be hiding potential bugs. Perhaps the effect is not supposed to be running, or perhaps the data it feeds into the system later is wrong. The test store requires all effects to finish.

To get this test passing we need to assert on the actions that are sent back into the system by the effect. We do this by using the `TestStore/receive(_:timeout:assert:fileID:file:line:column:)-53wic` method, which allows you to assert which action you expect to receive from an effect, as well as how the state changes after receiving that effect:

await store.receive(\.timerTick) {
$0.count = 1
}

However, if we run this test we still get a failure because we asserted a `timerTick` action was going to be received, but after waiting around for a small amount of time no action was received:

This is because our timer is on a 1 second interval, and by default `TestStore/receive(_:timeout:assert:fileID:file:line:column:)-53wic` only waits for a fraction of a second. This is because typically you should not be performing real time-based asynchrony in effects, and instead using a controlled entity, such as a clock, that can be sped up in tests. We will demonstrate this in a moment, so for now let’s increase the timeout:

await store.receive(\.timerTick, timeout: .seconds(2)) {
$0.count = 1
}

This assertion now passes, but the overall test is still failing because there are still more actions to receive. The timer should tick 5 times in total, so we need five `receive` assertions:

await store.receive(\.timerTick, timeout: .seconds(2)) {
$0.count = 1
}
await store.receive(\.timerTick, timeout: .seconds(2)) {
$0.count = 2
}
await store.receive(\.timerTick, timeout: .seconds(2)) {
$0.count = 3
}
await store.receive(\.timerTick, timeout: .seconds(2)) {
$0.count = 4
}
await store.receive(\.timerTick, timeout: .seconds(2)) {
$0.count = 5
}

Now the full test suite passes, and we have exhaustively proven how effects are executed in this feature. If in the future we tweak the logic of the effect, like say have it emit 10 times instead of 5, then we will immediately get a test failure letting us know that we have not properly asserted on how the features evolve over time.

However, there is something not ideal about how this feature is structured, and that is the fact that we are doing actual, uncontrolled time-based asynchrony in the effect:

return .run { send in
for _ in 1...5 {
try await Task.sleep(for: .seconds(1)) // ⬅️
await send(.timerTick)
}
}

This means for our test to run we must actually wait for 5 real world seconds to pass so that we can receive all of the actions from the timer. This makes our test suite far too slow. What if in the future we need to test a feature that has a timer that emits hundreds or thousands of times? We cannot hold up our test suite for minutes or hours just to test that one feature.

To fix this we need to add a dependency to the reducer that aids in performing time-based asynchrony, but in a way that is controllable. One way to do this is to add a clock as a `@Dependency` to the reducer:

import Clocks

@Reducer
struct Feature {
struct State { /* ... */ }
enum Action { /* ... */ }
@Dependency(\.continuousClock) var clock
// ...
}

And then the timer effect in the reducer can make use of the clock to sleep rather than reaching out to the uncontrollable `Task.sleep` method:

return .run { send in
for _ in 1...5 {
try await self.clock.sleep(for: .seconds(1))
await send(.timerTick)
}
}

By having a clock as a dependency in the feature we can supply a controlled version in tests, such as an immediate clock that does not suspend at all when you ask it to sleep:

let store = TestStore(initialState: Feature.State(count: 0)) {
Feature()
} withDependencies: {
$0.continuousClock = ImmediateClock()
}

With that small change we can drop the `timeout` arguments from the `TestStore/receive(_:timeout:assert:fileID:file:line:column:)-53wic` invocations:

await store.receive(\.timerTick) {
$0.count = 1
}
await store.receive(\.timerTick) {
$0.count = 2
}
await store.receive(\.timerTick) {
$0.count = 3
}
await store.receive(\.timerTick) {
$0.count = 4
}
await store.receive(\.timerTick) {
$0.count = 5
}

…and the test still passes, but now does so immediately.

The more time you take to control the dependencies your features use, the easier it will be to write tests for your features. To learn more about designing dependencies and how to best leverage dependencies, read the Dependencies article.

## Non-exhaustive testing

The previous sections describe in detail how to write tests in the Composable Architecture that exhaustively prove how the entire feature evolves over time. You must assert on how every piece of state changes, how every effect feeds data back into the system, and you must even make sure that all effects complete before the test store is deallocated. This can be powerful, but it can also be a nuisance, especially for highly composed features. This is why sometimes you may want to test in a non-exhaustive style.

This style of testing is most useful for testing the integration of multiple features where you want to focus on just a certain slice of the behavior. Exhaustive testing can still be important to use for leaf node features, where you truly do want to assert on everything happening inside the feature.

For example, suppose you have a tab-based application where the 3rd tab is a login screen. The user can fill in some data on the screen, then tap the “Submit” button, and then a series of events happens to log the user in. Once the user is logged in, the 3rd tab switches from a login screen to a profile screen, _and_ the selected tab switches to the first tab, which is an activity screen.

When writing tests for the login feature we will want to do that in the exhaustive style so that we can prove exactly how the feature would behave in production. But, suppose we wanted to write an integration test that proves after the user taps the “Login” button that ultimately the selected tab switches to the first tab.

In order to test such a complex flow we must test the integration of multiple features, which means dealing with complex, nested state and effects. We can emulate this flow in a test by sending actions that mimic the user logging in, and then eventually assert that the selected tab switched to activity:

let store = TestStore(initialState: AppFeature.State()) {
AppFeature()
}

// 1️⃣ Emulate user tapping on submit button.
await store.send(\.login.submitButtonTapped) {
// 2️⃣ Assert how all state changes in the login feature
$0.login?.isLoading = true
// ...
}

// 3️⃣ Login feature performs API request to login, and
// sends response back into system.
await store.receive(\.login.loginResponse.success) {
// 4️⃣ Assert how all state changes in the login feature
$0.login?.isLoading = false
// ...
}

// 5️⃣ Login feature sends a delegate action to let parent
// feature know it has successfully logged in.
await store.receive(\.login.delegate.didLogin) {
// 6️⃣ Assert how all of app state changes due to that action.
$0.authenticatedTab = .loggedIn(
Profile.State(...)
)
// ...
// 7️⃣ *Finally* assert that the selected tab switches to activity.
$0.selectedTab = .activity
}

Doing this with exhaustive testing is verbose, and there are a few problems with this:

- We need to be intimately knowledgeable in how the login feature works so that we can assert on how its state changes and how its effects feed data back into the system.

- If the login feature were to change its logic we may get test failures here even though the logic we are actually trying to test doesn’t really care about those changes.

- This test is very long, and so if there are other similar but slightly different flows we want to test we will be tempted to copy-and-paste the whole thing, leading to lots of duplicated, fragile tests.

Non-exhaustive testing allows us to test the high-level flow that we are concerned with, that of login causing the selected tab to switch to activity, without having to worry about what is happening inside the login feature. To do this, we can turn off `exhaustivity` in the test store, and then just assert on what we are interested in:

let store = TestStore(initialState: AppFeature.State()) {
AppFeature()
}
store.exhaustivity = .off // ⬅️

await store.send(\.login.submitButtonTapped)
await store.receive(\.login.delegate.didLogin) {
$0.selectedTab = .activity
}

In particular, we did not assert on how the login’s state changed or how the login’s effects fed data back into the system. We just assert that when the “Submit” button is tapped that eventually we get the `didLogin` delegate action and that causes the selected tab to flip to activity. Now the login feature is free to make any change it wants to make without affecting this integration test.

Using `off` for `exhaustivity` causes all un-asserted changes to pass without any notification. If you would like to see what test failures are being suppressed without actually causing a failure, you can use `Exhaustivity.off(showSkippedAssertions:)`:

let store = TestStore(initialState: AppFeature.State()) {
AppFeature()
}
store.exhaustivity = .off(showSkippedAssertions: true) // ⬅️

When this is run you will get grey, informational boxes on each assertion where some change wasn’t fully asserted on:

The test still passes, and none of these notifications are test failures. They just let you know what things you are not explicitly asserting against, and can be useful to see when tracking down bugs that happen in production but that aren’t currently detected in tests.

#### Understanding non-exhaustive testing

It can be important to understand how non-exhaustive testing works under the hood because it does limit the ways in which you can assert on state changes.

When you construct an _exhaustive_ test store, which is the default, the `$0` used inside the trailing closure of `TestStore/send(_:assert:fileID:file:line:column:)-8f2pl` represents the state _before_ the action is sent:

let store = TestStore(/* ... */)
// ℹ️ "on" is the default so technically this is not needed
store.exhaustivity = .on

store.send(.buttonTapped) {
$0 // Represents the state *before* the action was sent
}

This forces you to apply any mutations necessary to `$0` to match the state _after_ the action is sent.

Non-exhaustive test stores flip this on its head. In such a test store, the `$0` handed to the trailing closure of `send` represents the state _after_ the action was sent:

let store = TestStore(/* ... */)
store.exhaustivity = .off

store.send(.buttonTapped) {
$0 // Represents the state *after* the action was sent
}

This means you don’t have to make any mutations to `$0` at all and the assertion will already pass. But, if you do make a mutation, then it must match what is already in the state, thus allowing you to assert on only the state changes you are interested in.

However, this difference between how `TestStore` behaves when run in exhaustive mode versus non-exhaustive mode does restrict the kinds of mutations you can make inside the trailing closure of `send`. For example, suppose you had an action in your feature that removes the last element of a collection:

case .removeButtonTapped:
state.values.removeLast()
return .none

To test this in an exhaustive store it is completely fine to do this:

await store.send(.removeButtonTapped) {
$0.values.removeLast()
}

This works because `$0` is the state before the action is sent, and so we can remove the last element to prove that the reducer does the same work.

However, in a non-exhaustive store this will not work:

store.exhaustivity = .off
await store.send(.removeButtonTapped) {
$0.values.removeLast() // ❌
}

This will either fail, or possibly even crash the test suite. This is because in a non-exhaustive test store, `$0` in the trailing closure of `send` represents the state _after_ the action has been sent, and so the last element has already been removed. By executing `$0.values.removeLast()` we are just removing an additional element from the end.

So, for non-exhaustive test stores you cannot use “relative” mutations for assertions. That is, you cannot mutate via methods like `removeLast`, `append`, and anything that incrementally applies a mutation. Instead you must perform an “absolute” mutation, where you fully replace the collection with its final value:

store.exhaustivity = .off
await store.send(.removeButtonTapped) {
$0.values = []
}

Or you can weaken the assertion by asserting only on the count of its elements rather than the content of the element:

store.exhaustivity = .off
await store.send(.removeButtonTapped) {
XCTAssertEqual($0.values.count, 0)
}

Further, when using non-exhaustive test stores that also show skipped assertions (via `Exhaustivity.off(showSkippedAssertions:)`), then there is another caveat to keep in mind. In such test stores, the trailing closure of `TestStore/send(_:assert:fileID:file:line:column:)-8f2pl` is invoked _twice_ by the test store. First with `$0` representing the state after the action is sent to see if it does not match the true state, and then again with `$0` representing the state before the action is sent so that we can show what state assertions were skipped.

Because the test store can invoke your trailing assertion closure twice you must be careful if your closure performs any side effects, because those effects will be executed twice. For example, suppose you have a domain model that uses the controllable `@Dependency(\.uuid)` to generate a UUID:

struct Model: Equatable {
let id: UUID
init() {
@Dependency(\.uuid) var uuid
self.id = uuid()
}
}

This is a perfectly fine to pattern to adopt in the Composable Architecture, but it does cause trouble when using non-exhaustive test stores and showing skipped assertions. To see this, consider the following simple reducer that appends a new model to an array when an action is sent:

@Reducer
struct Feature {
struct State: Equatable {
var values: [Model] = []
}
enum Action {
case addButtonTapped
}

Reduce { state, action in
switch action {
case .addButtonTapped:
state.values.append(Model())
return .none
}
}
}
}

We’d like to be able to write a test for this by asserting that when the `addButtonTapped` action is sent a model is append to the `values` array:

@Test
func add() async {
let store = TestStore(initialState: Feature.State()) {
Feature()
} withDependencies: {
$0.uuid = .incrementing
}
store.exhaustivity = .off(showSkippedAssertions: true)

await store.send(.addButtonTapped) {
$0.values = [Model()]
}
}

While we would expect this simple test to pass, it fails when `showSkippedAssertions` is set to `true`:

This is happening because the trailing closure is invoked twice, and the side effect that is executed when the closure is first invoked is bleeding over into when it is invoked a second time.

In particular, when the closure is evaluated the first time it causes `Model()` to be constructed, which secretly generates the next auto-incrementing UUID. Then, when we run the closure again _another_ `Model()` is constructed, which causes another auto-incrementing UUID to be generated, and that value does not match our expectations.

If you want to use the `showSkippedAssertions` option for `Exhaustivity.off(showSkippedAssertions:)` then you should avoid performing any kind of side effect in `send`, including using `@Dependency` directly in your models’ initializers. Instead force those values to be provided at the moment of initializing the model:

struct Model: Equatable {
let id: UUID
init(id: UUID) {
self.id = id
}
}

And then move the responsibility of generating new IDs to the reducer:

@Reducer
struct Feature {
// ...
@Dependency(\.uuid) var uuid

Reduce { state, action in
switch action {
case .addButtonTapped:
state.values.append(Model(id: self.uuid()))
return .none
}
}
}
}

And now you can write the test more simply by providing the ID explicitly:

await store.send(.addButtonTapped) {
$0.values = [\
Model(id: UUID(0))\
]
}

And it works if you send the action multiple times:

await store.send(.addButtonTapped) {
$0.values = [\
Model(id: UUID(0))\
]
}
await store.send(.addButtonTapped) {
$0.values = [\
Model(id: UUID(0)),\
Model(id: UUID(1))\
]
}

## Testing gotchas

### Testing host application

This is not well known, but when an application target runs tests it actually boots up a simulator and runs your actual application entry point in the simulator. This means while tests are running, your application’s code is separately also running. This can be a huge gotcha because it means you may be unknowingly making network requests, tracking analytics, writing data to user defaults or to the disk, and more.

This usually flies under the radar and you just won’t know it’s happening, which can be problematic. But, once you start using this library and start controlling your dependencies, the problem can surface in a very visible manner. Typically, when a dependency is used in a test context without being overridden, a test failure occurs. This makes it possible for your test to pass successfully, yet for some mysterious reason the test suite fails. This happens because the code in the _app host_ is now running in a test context, and accessing dependencies will cause test failures.

This only happens when running tests in a _application target_, that is, a target that is specifically used to launch the application for a simulator or device. This does not happen when running tests for frameworks or SPM libraries, which is yet another good reason to modularize your code base.

However, if you aren’t in a position to modularize your code base right now, there is a quick fix. Our XCTest Dynamic Overlay library, which is transitively included with this library, comes with a property you can check to see if tests are currently running. If they are, you can omit the entire entry point of your application:

import SwiftUI
import ComposableArchitecture

@main
struct MyApp: App {
var body: some Scene {
WindowGroup {
if TestContext.current == nil{
// Your real root view
}
}
}
}

That will allow tests to run in the application target without your actual application code interfering.

### Statically linking your tests target to ComposableArchitecture

If you statically link the `ComposableArchitecture` module to your tests target, its implementation may clash with the implementation that is statically linked to the app itself. The most usually manifests by getting mysterious test failures telling you that you are using live dependencies in your tests even though you have overridden your dependencies.

In such cases Xcode will display multiple warnings in the console similar to:

The solution is to remove the static link to `ComposableArchitecture` from your test target, as you transitively get access to it through the app itself. In Xcode, go to “Build Phases” and remove “ComposableArchitecture” from the “Link Binary With Libraries” section. When using SwiftPM, remove the “ComposableArchitecture” entry from the `testTarget`‘s’ `dependencies` array in `Package.swift`.

### Long-living test stores

Test stores should always be created in individual tests when possible, rather than as a shared instance variable on the test class:

@MainActor
struct FeatureTests {
// 👎 Don't do this:
- let store = TestStore(initialState: Feature.State()) {
- Feature()
- }

@Test
func basics() async {
// 👍 Do this:
+ let store = TestStore(initialState: Feature.State()) {
+ Feature()
+ }
// ...
}
}

This allows you to be very precise in each test: you can start the store in a very specific state, and override just the dependencies a test cares about.

More crucially, test stores that are held onto by the test class will not be deinitialized during a test run, and so various exhaustive assertions made during deinitialization will not be made, _e.g._ that the test store has unreceived actions that should be asserted against, or in-flight effects that should complete.

If a test store does _not_ deinitialize at the end of a test, you must explicitly call `finish(timeout:fileID:file:line:column:)` at the end of the test to retain exhaustive coverage:

await store.finish()

## See Also

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

- Testing
- Overview
- Testing state changes
- Testing effects
- Non-exhaustive testing
- Testing gotchas
- Testing host application
- Statically linking your tests target to ComposableArchitecture
- Long-living test stores
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/navigation

- ComposableArchitecture
- Navigation

API Collection

# Navigation

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

## Overview

State-driven navigation is a powerful concept in application development, but can be tricky to master. The Composable Architecture provides the tools necessary to model your domains as concisely as possible and drive navigation from state, but there are a few concepts to learn in order to best use these tools.

## Topics

### Essentials

What is navigation?

Learn about the two main forms of state-driven navigation, tree-based and stack-based navigation, as well as their tradeoffs.

### Tree-based navigation

Tree-based navigation

Learn about tree-based navigation, that is navigation modeled with optionals and enums, including how to model your domains, how to integrate features, how to test your features, and more.

`macro Presents()`

Wraps a property with `PresentationState` and observes it.

`enum PresentationAction`

A wrapper type for actions that can be presented.

### Stack-based navigation

Stack-based navigation

Learn about stack-based navigation, that is navigation modeled with collections, including how to model your domains, how to integrate features, how to test your features, and more.

`struct StackState`

A list of data representing the content of a navigation stack.

`enum StackAction`

A wrapper type for actions that can be presented in a navigation stack.

`typealias StackActionOf`

A convenience type alias for referring to a stack action of a given reducer’s domain.

`struct StackElementID`

An opaque type that identifies an element of `StackState`.

### Dismissal

`struct DismissEffect`

An effect that dismisses the current presentation.

`var dismiss: DismissEffect`

`var isPresented: Bool`

A Boolean value that indicates whether the current feature is being presented from a parent feature.

## See Also

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

- Navigation
- Overview
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/sharingstate

- ComposableArchitecture
- Sharing state

Article

# Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

## Overview

Sharing state is the process of letting many features have access to the same data so that when any feature makes a change to this data it is instantly visible to every other feature. Such sharing can be really handy, but also does not play nicely with value types, which are copied rather than shared. Because the Composable Architecture highly prefers modeling domains with value types rather than reference types, sharing state can be tricky.

This is why the library comes with a few tools for sharing state with many parts of your application. The majority of these tools exist outside of the Composable Architecture, and are in a separate library called Sharing. You can refer to that library’s documentation for more information, but we have also repeated some of the most important concepts in this article.

There are two main kinds of shared state in the library: explicitly passed state and persisted state. And there are 3 persistence strategies shipped with the library: in-memory, user defaults, and file storage. You can also implement your own persistence strategy if you want to use something other than user defaults or the file system, such as SQLite.

- “Source of truth”

- Explicit shared state

- Persisted shared state

- In-memory

- User defaults

- File storage

- Custom persistence
- Observing changes to shared state

- Initialization rules

- Deriving shared state

- Concurrent mutations to shared state

- Testing shared state

- Testing when using persistence

- Testing when using custom persistence strategies

- Overriding shared state in tests

- UI Testing

- Testing tips
- Read-only shared state

- Type-safe keys

- Shared state in pre-observation apps

- Gotchas of @Shared

## “Source of truth”

First a quick discussion on defining exactly what “shared state” is. A common concept thrown around in architectural discussions is “single source of truth.” This is the idea that the complete state of an application, even its navigation, can be driven off a single piece of data. It’s a great idea, in theory, but in practice it can be quite difficult to completely embrace.

First of all, a _single_ piece of data to drive _all_ of application state is just not feasible. There is a lot of state in an application that is fine to be local to a view and does not need global representation. For example, the state of whether a button is being pressed is probably fine to reside privately inside the button.

And second, applications typically do not have a _single_ source of truth. That is far too simplistic. If your application loads data from an API, or from disk, or from user defaults, then the “truth” for that data does not lie in your application. It lies externally.

In reality, there are _two_ sources of “truth” in any application:

1. There is the state the application needs to execute its logic and behavior. This is the kind of state that determines if a button is enabled or disabled, drives navigation such as sheets and drill-downs, and handles validation of forms. Such state only makes sense for the application.

2. Then there is a second source of “truth” in an application, which is the data that lies in some external system and needs to be loaded into the application. Such state is best modeled as a dependency or using the shared state tools discussed in this article.

## Explicit shared state

This is the simplest kind of shared state to get started with. It allows you to share state amongst many features without any persistence. The data is only held in memory, and will be cleared out the next time the application is run.

To share data in this style, use the `@Shared` property wrapper with no arguments. For example, suppose you have a feature that holds a count and you want to be able to hand a shared reference to that count to other features. You can do so by holding onto a `@Shared` property in the feature’s state:

@Reducer
struct ParentFeature {
@ObservableState
struct State {
@Shared var count: Int
// Other properties
}
// ...
}

Then suppose that this feature can present a child feature that wants access to this shared `count` value. It too would hold onto a `@Shared` property to a count:

@Reducer
struct ChildFeature {
@ObservableState
struct State {
@Shared var count: Int
// Other properties
}
// ...
}

When the parent features creates the child feature’s state, it can pass a _reference_ to the shared count rather than the actual count value by using the `$count` projected value:

case .presentButtonTapped:
state.child = ChildFeature.State(count: state.$count)
// ...

Now any mutation the `ChildFeature` makes to its `count` will be instantly made to the `ParentFeature`’s count too.

## Persisted shared state

Explicitly shared state discussed above is a nice, lightweight way to share a piece of data with many parts of your application. However, sometimes you want to share state with the entire application without having to pass it around explicitly. One can do this by passing a `SharedKey` to the `@Shared` property wrapper, and the library comes with three persistence strategies, as well as the ability to create custom persistence strategies.

#### In-memory

This is the simplest persistence strategy in that it doesn’t actually persist at all. It keeps the data in memory and makes it available to every part of the application, but when the app is relaunched the data will be reset

If you would like to persist your shared value across application launches, then you can use the `appStorage` strategy with `@Shared` in order to automatically persist any changes to the value to user defaults. It works similarly to in-memory sharing discussed above. It requires a key to store the value in user defaults, as well as a default value that will be used when there is no value in the user defaults:

@Shared(.appStorage("count")) var count = 0

That small change will guarantee that all changes to `count` are persisted and will be automatically loaded the next time the application launches.

This form of persistence only works for simple data types because that is what works best with `UserDefaults`. This includes strings, booleans, integers, doubles, URLs, data, and more. If you need to store more complex data, such as custom data types serialized to JSON, then you will want to use the `.fileStorage` strategy or a custom persistence strategy.

#### File storage

If you would like to persist your shared value across application launches, and your value is complex (such as a custom data type), then you can use the `fileStorage` strategy with `@Shared`. It automatically persists any changes to the file system.

It works similarly to the in-memory sharing discussed above, but it requires a URL to store the data on disk, as well as a default value that will be used when there is no data in the file system:

@Shared(.fileStorage(URL(/* ... */)) var users: [User] = []

This strategy works by serializing your value to JSON to save to disk, and then deserializing JSON when loading from disk. For this reason the value held in `@Shared(.fileStorage(…))` must conform to `Codable`.

#### Custom persistence

It is possible to define all new persistence strategies for the times that user defaults or JSON files are not sufficient. To do so, define a type that conforms to the `SharedKey` protocol:

public final class CustomSharedKey: SharedKey {
// ...
}

And then define a static function on the `SharedKey` protocol for creating your new persistence strategy:

extension SharedReaderKey {

CustomPersistence(/* ... */)
}
}

With those steps done you can make use of the strategy in the same way one does for `appStorage` and `fileStorage`:

@Shared(.custom(/* ... */)) var myValue: Value

The `SharedKey` protocol represents loading from _and_ saving to some external storage, such as the file system or user defaults. Sometimes saving is not a valid operation for the external system, such as if your server holds onto a remote configuration file that your app uses to customize its appearance or behavior. In those situations you can conform to the `SharedReaderKey` protocol. See Read-only shared state for more information.

## Observing changes to shared state

The `@Shared` property wrapper exposes a `publisher` property so that you can observe changes to the reference from any part of your application. For example, if some feature in your app wants to listen for changes to some shared `count` value, then it can introduce an `onAppear` action that kicks off a long-living effect that subscribes to changes of `count`:

case .onAppear:
return .publisher {
state.$count.publisher
.map(Action.countUpdated)
}

case .countUpdated(let count):
// Do something with count
return .none

Note that you will have to be careful for features that both hold onto shared state and subscribe to changes to that state. It is possible to introduce an infinite loop if you do something like this:

case .countUpdated(let count):
state.count = count + 1
return .none

If `count` changes, then `$count.publisher` emits, causing the `countUpdated` action to be sent, causing the shared `count` to be mutated, causing `$count.publisher` to emit, and so on.

## Initialization rules

Because the state sharing tools use property wrappers there are special rules that must be followed when writing custom initializers for your types. These rules apply to _any_ kind of property wrapper, including those that ship with vanilla SwiftUI (e.g. `@State`, `@StateObject`, etc.), but the rules can be quite confusing and so below we describe the various ways to initialize shared state.

It is common to need to provide a custom initializer to your feature’s `State` type, especially when modularizing. When using `@Shared` in your `State` that can become complicated. Depending on your exact situation you can do one of the following:

- You are using non-persisted shared state (i.e. no argument is passed to `@Shared`), and the “source of truth” of the state lives with the parent feature. Then the initializer should take a `Shared` value and you can assign through the underscored property:

public struct State {
@Shared public var count: Int
// other fields

self._count = count
// other assignments
}
}

- You are using non-persisted shared state ( _i.e._ no argument is passed to `@Shared`), and the “source of truth” of the state lives within the feature you are initializing. Then the initializer should take a plain, non- `Shared` value and you construct the `Shared` value in the initializer:

public init(count: Int, /* other fields */) {
self._count = Shared(count)
// other assignments
}
}

- You are using a persistence strategy with shared state ( _e.g._ `appStorage`, `fileStorage`, _etc._), then the initializer should take a plain, non- `Shared` value and you construct the `Shared` value in the initializer using the initializer which takes a `SharedKey` as the second argument:

public init(count: Int, /* other fields */) {
self._count = Shared(wrappedValue: count, .appStorage("count"))
// other assignments
}
}

The declaration of `count` can use `@Shared` without an argument because the persistence strategy is specified in the initializer.

## Deriving shared state

@Reducer
struct PhoneNumberFeature {
struct State {
@Shared var phoneNumber: String
}
// ...
}

case .nextButtonTapped:
state.path.append(
PhoneNumberFeature.State(phoneNumber: state.$signUpData.phoneNumber)
)

It can be instructive to think of `@Shared` as the Composable Architecture analogue of `@Bindable` in vanilla SwiftUI. You use it to express that the actual “source of truth” of the value lies elsewhere, but you want to be able to read its most current value and write to it.

This also works for persistence strategies. If a parent feature holds onto a `@Shared` piece of state with a persistence strategy:

@Reducer
struct ParentFeature {
struct State {
@Shared(.fileStorage(.currentUser)) var currentUser
}
// ...
}

…and a child feature wants access to just a shared _piece_ of `currentUser`, such as their name, then they can do so by holding onto a simple, unadorned `@Shared`:

@Reducer
struct ChildFeature {
struct State {
@Shared var currentUserName: String
}
// ...
}

And then the parent can pass along `$currentUser.name` to the child feature when constructing its state:

case .editNameButtonTapped:
state.destination = .editName(
EditNameFeature(name: state.$currentUser.name)
)

Any changes the child feature makes to its shared `name` will be automatically made to the parent’s shared `currentUser`, and further those changes will be automatically persisted thanks to the `.fileStorage` persistence strategy used. This means the child feature gets to describe that it needs access to shared state without describing the persistence strategy, and the parent can be responsible for persisting and deriving shared state to pass to the child.

If your shared state is a collection, and in particular an `IdentifiedArray`, then we have another tool for deriving shared state to a particular element of the array. You can subscript into a `Shared` collection with the `[id:]` subscript, and that will give a piece of shared optional state, which you can then unwrap to turn into honest shared state using a special `Shared` initializer:

guard let todo = Shared($todos[id: todoID])
else { return }

## Concurrent mutations to shared state

While the `@Shared` property wrapper makes it possible to treat shared state _mostly_ like regular state, you do have to perform some extra steps to mutate shared state. This is because shared state is technically a reference deep down, even though we take extra steps to make it appear value-like. And this means it’s possible to mutate the same piece of shared state from multiple threads, and hence race conditions are possible. See Mutating Shared State for a more in-depth explanation.

To mutate a piece of shared state in an isolated fashion, use the `withLock` method defined on the `@Shared` projected value:

state.$count.withLock { $0 += 1 }

That locks the entire unit of work of reading the current count, incrementing it, and storing it back in the reference.

Technically it is still possible to write code that has race conditions, such as this silly example:

let currentCount = state.count
state.$count.withLock { $0 = currentCount + 1 }

But there is no way to 100% prevent race conditions in code. Even actors are susceptible to problems due to re-entrancy. To avoid problems like the above we recommend wrapping as many mutations of the shared state as possible in a single `withLock`. That will make sure that the full unit of work is guarded by a lock.

## Testing shared state

Shared state behaves quite a bit different from the regular state held in Composable Architecture features. It is capable of being changed by any part of the application, not just when an action is sent to the store, and it has reference semantics rather than value semantics. Typically references cause serious problems with testing, especially exhaustive testing that the library prefers (see Testing), because references cannot be copied and so one cannot inspect the changes before and after an action is sent.

For this reason, the `@Shared` property wrapper does extra work during testing to preserve a previous snapshot of the state so that one can still exhaustively assert on shared state, even though it is a reference.

For the most part, shared state can be tested just like any regular state held in your features. For example, consider the following simple counter feature that uses in-memory shared state for the count:

@Reducer
struct Feature {
struct State: Equatable {
@Shared var count: Int
}
enum Action {
case incrementButtonTapped
}

Reduce { state, action in
switch action {
case .incrementButtonTapped:
state.$count.withLock { $0 += 1 }
return .none
}
}
}
}

This feature can be tested in a similar same way as when you are using non-shared state:

@Test
func increment() async {
let store = TestStore(initialState: Feature.State(count: Shared(0))) {
Feature()
}

await store.send(.incrementButtonTapped) {
$0.$count.withLock { $0 = 1 }
}
}

This test passes because we have described how the state changes. But even better, if we mutate the `count` incorrectly:

await store.send(.incrementButtonTapped) {
$0.$count.withLock { $0 = 2 }
}
}

…we immediately get a test failure letting us know exactly what went wrong:

❌ State was not expected to change, but a change occurred: …

− Feature.State(_count: 2)
+ Feature.State(_count: 1)

(Expected: −, Actual: +)

This works even though the `@Shared` count is a reference type. The `TestStore` and `@Shared` type work in unison to snapshot the state before and after the action is sent, allowing us to still assert in an exhaustive manner.

However, exhaustively testing shared state is more complicated than testing non-shared state in features. Shared state can be captured in effects and mutated directly, without ever sending an action into system. This is in stark contrast to regular state, which can only ever be mutated when sending an action.

For example, it is possible to alter the `incrementButtonTapped` action so that it captures the shared state in an effect, and then increments from the effect:

case .incrementButtonTapped:
return .run { [sharedCount = state.$count] _ in
await sharedCount.withLock { $0 += 1 }
}

The only reason this is possible is because `@Shared` state is reference-like, and hence can technically be mutated from anywhere.

However, how does this affect testing? Since the `count` is no longer incremented directly in the reducer we can drop the trailing closure from the test store assertion:

@Test
func increment() async {
let store = TestStore(initialState: SimpleFeature.State(count: Shared(0))) {
SimpleFeature()
}
await store.send(.incrementButtonTapped)
}

This is technically correct, but we aren’t testing the behavior of the effect at all.

Luckily the `TestStore` has our back. If you run this test you will immediately get a failure letting you know that the shared count was mutated but we did not assert on the changes:

− 0
+ 1

(Before: −, After: +)

In order to get this test passing we have to explicitly assert on the shared counter state at the end of the test, which we can do using the `assert(_:fileID:file:line:column:)` method:

@Test
func increment() async {
let store = TestStore(initialState: SimpleFeature.State(count: Shared(0))) {
SimpleFeature()
}
await store.send(.incrementButtonTapped)
store.assert {
$0.$count.withLock { $0 = 1 }
}
}

Now the test passes.

So, even though the `@Shared` type opens our application up to a little bit more uncertainty due to its reference semantics, it is still possible to get exhaustive test coverage on its changes.

#### Testing when using persistence

It is also possible to test when using one of the persistence strategies provided by the library, which are `appStorage` and `fileStorage`. Typically persistence is difficult to test because the persisted data bleeds over from test to test, making it difficult to exhaustively prove how each test behaves in isolation.

But the `.appStorage` and `.fileStorage` strategies do extra work to make sure that happens. By default the `.appStorage` strategy uses a non-persisting user defaults so that changes are not actually persisted across test runs. And the `.fileStorage` strategy uses a mock file system so that changes to state are not actually persisted to the file system.

This means that if we altered the `SimpleFeature` of the Testing shared state section above to use app storage:

struct State: Equatable {
@Shared(.appStorage("count")) var count: Int
}

…then the test for this feature can be written in the same way as before and will still pass.

#### Testing when using custom persistence strategies

When creating your own custom persistence strategies you must careful to do so in a style that is amenable to testing. For example, the `appStorage` persistence strategy that comes with the library injects a `defaultAppStorage` dependency so that one can inject a custom `UserDefaults` in order to execute in a controlled environment. By default `defaultAppStorage` uses a non-persisting user defaults, but you can also customize it to use any kind of defaults.

Similarly the `fileStorage` persistence strategy uses an internal dependency for changing how files are written to the disk and loaded from disk. In tests the dependency will forgo any interaction with the file system and instead write data to a `[URL: Data]` dictionary, and load data from that dictionary. That emulates how the file system works, but without persisting any data to the global file system, which can bleed over into other tests.

#### Overriding shared state in tests

When testing features that use `@Shared` with a persistence strategy you may want to set the initial value of that state for the test. Typically this can be done by declaring the shared state at the beginning of the test so that its default value can be specified:

@Test
func basics() {
@Shared(.appStorage("count")) var count = 42

// Shared state will be 42 for all features using it.
let store = TestStore(…)
}

However, if your test suite is a part of an app target, then the entry point of the app will execute and potentially cause an early access of `@Shared`, thus capturing a different default value than what is specified above. This quirk of tests in app targets is documented in Testing gotchas of the Testing article, and a similar quirk exists for Xcode previews and is discussed below in Gotchas of @Shared.

The most robust workaround to this issue is to simply not execute your app’s entry point when tests are running, which we detail in Testing host application. This makes it so that you are not accidentally execute network requests, tracking analytics, etc. while running tests.

You can also work around this issue by simply setting the shared state again after initializing it:

@Test
func basics() {
@Shared(.appStorage("count")) var count = 42
count = 42 // NB: Set again to override any value set by the app target.

#### UI Testing

When UI testing your app you must take extra care so that shared state is not persisted across app runs because that can cause one test to bleed over into another test, making it difficult to write deterministic tests that always pass. To fix this, you can set an environment value from your UI test target, and then if that value is present in the app target you can override the `defaultAppStorage` and `defaultFileStorage` dependencies so that they use in-memory storage, i.e. they do not persist ever:

@main
struct EntryPoint: App {
let store = Store(initialState: AppFeature.State()) {
AppFeature()
} withDependencies: {
if ProcessInfo.processInfo.environment["UITesting"] == "true" {
$0.defaultAppStorage = UserDefaults(
suiteName:"\(NSTemporaryDirectory())\(UUID().uuidString)"
)!
$0.defaultFileStorage = .inMemory
}
}
}

#### Testing tips

There is something you can do to make testing features with shared state more robust and catch more potential future problems when you refactor your code. Right now suppose you have two features using `@Shared(.appStorage("count"))`:

@Reducer
struct Feature1 {
struct State {
@Shared(.appStorage("count")) var count = 0
}
// ...
}

@Reducer
struct Feature2 {
struct State {
@Shared(.appStorage("count")) var count = 0
}
// ...
}

And suppose you wrote a test that proves one of these counts is incremented when a button is tapped:

await store.send(.feature1(.buttonTapped)) {
$0.feature1.count = 1
}

Because both features are using `@Shared` you can be sure that both counts are kept in sync, and so you do not need to assert on `feature2.count`.

However, if someday during a long, complex refactor you accidentally removed `@Shared` from the second feature:

@Reducer
struct Feature2 {
struct State {
var count = 0
}
// ...
}

…then all of your code would continue compiling, and the test would still pass, but you may have introduced a bug by not having these two pieces of state in sync anymore.

You could also fix this by forcing yourself to assert on all shared state in your features, even though technically it’s not necessary:

await store.send(.feature1(.buttonTapped)) {
$0.feature1.count = 1
$0.feature2.count = 1
}

If you are worried about these kinds of bugs you can make your tests more robust by not asserting on the shared state in the argument handed to the trailing closure of `TestStore`’s `send`, and instead capture a reference to the shared state in the test and mutate it in the trailing closure:

@Test
func increment() async {
@Shared(.appStorage("count")) var count = 0
let store = TestStore(initialState: ParentFeature.State()) {
ParentFeature()
}

await store.send(.feature1(.buttonTapped)) {
// Mutate $0 to expected value.
count = 1
}
}

This will fail if you accidentally remove a `@Shared` from one of your features.

Further, you can enforce this pattern in your codebase by making all `@Shared` properties `fileprivate` so that they can never be mutated outside their file scope:

struct State {
@Shared(.appStorage("count")) fileprivate var count = 0
}

## Read-only shared state

The `@Shared` property wrapper described above gives you access to a piece of shared state that is both readable and writable. That is by far the most common use case when it comes to shared state, but there are times when one wants to express access to shared state for which you are not allowed to write to it, or possibly it doesn’t even make sense to write to it.

For those times there is the `@SharedReader` property wrapper. It represents a reference to some piece of state shared with multiple parts of the application, but you are not allowed to write to it. Every persistence strategy discussed above works with `SharedReader`, however if you try to mutate the state you will get a compiler error:

@SharedReader(.appStorage("isOn")) var isOn = false
isOn = true // 🛑

It is also possible to make custom persistence strategies that only have the notion of loading and subscribing, but cannot write. To do this you will conform only to the `SharedReaderKey` protocol instead of the full `SharedKey` protocol.

For example, you could create a `.remoteConfig` strategy that loads (and subscribes to) a remote configuration file held on your server so that it is kept automatically in sync:

@SharedReader(.remoteConfig) var remoteConfig

## Type-safe keys

Due to the nature of persisting data to external systems, you lose some type safety when shuffling data from your app to the persistence storage and back. For example, if you are using the `fileStorage` strategy to save an array of users to disk you might do so like this:

extension URL {
static let users = URL(/* ... */))
}

@Shared(.fileStorage(.users)) var users: [User] = []

And say you have used this file storage users in multiple places throughout your application.

But then, someday in the future you may decide to refactor this data to be an identified array instead of a plain array:

// Somewhere else in the application

But if you forget to convert _all_ shared user arrays to the new identified array your application will still compile, but it will be broken. The two types of storage will not share state.

To add some type-safety and reusability to this process you can extend the `SharedReaderKey` protocol to add a static variable for describing the details of your persistence:

extension SharedReaderKey where Self == FileStorageKey<IdentifiedArrayOf<User>> {
static var users: Self {
fileStorage(.users)
}
}

Then when using `@Shared` you can specify this key directly without `.fileStorage`:

And now that the type is baked into the key you cannot accidentally use the wrong type because you will get an immediate compiler error:

@Shared(.users) var users = User

This technique works for all types of persistence strategies. For example, a type-safe `.inMemory` key can be constructed like so:

extension SharedReaderKey where Self == InMemoryKey<IdentifiedArrayOf<User>> {
static var users: Self {
inMemory("users")
}
}

And a type-safe `.appStorage` key can be constructed like so:

static var count: Self {
appStorage("count")
}
}

And this technique also works on custom persistence strategies.

Further, you can also bake in the default of the shared value into your key by doing the following:

extension SharedReaderKey where Self == FileStorageKey<IdentifiedArrayOf<User>>.Default {
static var users: Self {
Self[.fileStorage(.users), default: []]
}
}

And now anytime you reference the shared users state you can leave off the default value, and you can even leave off the type annotation:

@Shared(.users) var users

## Shared state in pre-observation apps

It is possible to use `@Shared` in features that have not yet been updated with the observation tools released in 1.7, such as the `ObservableState()` macro. In the reducer you can use `@Shared` regardless of your use of the observation tools.

However, if you are deploying to iOS 16 or earlier, then you must use `WithPerceptionTracking` in your views if you are accessing shared state. For example, the following view:

struct FeatureView: View {

Form {
Text(store.sharedCount.description)
}
}
}

…will not update properly when `sharedCount` changes. This view will even generate a runtime warning letting you know something is wrong:

The fix is to wrap the body of the view in `WithPerceptionTracking`:

WithPerceptionTracking {
Form {
Text(store.sharedCount.description)
}
}
}
}

## Gotchas of @Shared

There are a few gotchas to be aware of when using shared state in the Composable Architecture.

#### Hashability

Because the `@Shared` type is equatable based on its wrapped value, and because the value is held in a reference and can change over time, it cannot be hashable. This also means that types containing `@Shared` properties should not compute their hashes from shared values.

#### Codability

The `@Shared` type is not conditionally encodable or decodable because the source of truth of the wrapped value is rarely local: it might be derived from some other shared value, or it might rely on loading the value from a backing persistence strategy.

When introducing shared state to a data type that is encodable or decodable, you must provide your own implementations of `encode(to:)` and `init(from:)` that do the appropriate thing.

For example, if the data type is sharing state with a persistence strategy, you can decode by delegating to the memberwise initializer that implicitly loads the shared value from the property wrapper’s persistence strategy, or you can explicitly initialize a shared value. And for encoding you can often skip encoding the shared value:

struct AppState {
@Shared(.appStorage("launchCount")) var launchCount = 0
var todos: [String] = []
}

extension AppState: Codable {
enum CodingKeys: String, CodingKey { case todos }

init(from decoder: any Decoder) throws {
let container = try decoder.container(keyedBy: CodingKeys.self)

// Use the property wrapper default via the memberwise initializer:
try self.init(
todos: container.decode([String].self, forKey: .todos)
)

// Or initialize the shared storage manually:
self._launchCount = Shared(wrappedValue: 0, .appStorage("launchCount"))
self.todos = try container.decode([String].self, forKey: .todos)
}

func encode(to encoder: any Encoder) throws {
var container = encoder.container(keyedBy: CodingKeys.self)
try container.encode(self.todos, forKey: .todos)
// Skip encoding the launch count.
}
}

#### Tests

While shared properties are compatible with the Composable Architecture’s testing tools, assertions may not correspond directly to a particular action when several actions are received by effects.

Take this simple example, in which a `tap` action kicks off an effect that returns a `response`, which finally mutates some shared state:

@Reducer
struct Feature {
struct State: Equatable {
@Shared(value: false) var bool
}
enum Action {
case tap
case response
}

Reduce { state, action in
switch action {
case .tap:
return .run { send in
await send(.response)
}
case .response:
state.$bool.withLock { $0.toggle() }
return .none
}
}
}
}

We would expect to assert against this mutation when the test store receives the `response` action, but this will fail:

// ❌ State was not expected to change, but a change occurred: …
//
// Feature.State(
// - _shared: #1 false
// + _shared: #1 true
//   )
//
// (Expected: −, Actual: +)
await store.send(.tap)

// ❌ Expected state to change, but no change occurred.
await store.receive(.response) {
$0.$shared.withLock { $0 = true }
}

This is due to an implementation detail of the `TestStore` that predates `@Shared`, in which the test store eagerly processes all actions received _before_ you have asserted on them. As such, you must always assert against shared state mutations in the first action:

await store.send(.tap) { // ✅
$0.$shared.withLock { $0 = true }
}

// ❌ Expected state to change, but no change occurred.
await store.receive(.response) // ✅

In a future major version of the Composable Architecture, we will be able to introduce a breaking change that allows you to assert against shared state mutations in the action that performed the mutation.

## See Also

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

- Sharing state
- Overview
- “Source of truth”
- Explicit shared state
- Persisted shared state
- Observing changes to shared state
- Initialization rules
- Deriving shared state
- Concurrent mutations to shared state
- Testing shared state
- Read-only shared state
- Type-safe keys
- Shared state in pre-observation apps
- Gotchas of @Shared
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/performance

- ComposableArchitecture
- Performance

Article

# Performance

Learn how to improve the performance of features built in the Composable Architecture.

## Overview

As your features and application grow you may run into performance problems, such as reducers becoming slow to execute, SwiftUI view bodies executing more often than expected, and more. This article outlines a few common pitfalls when developing features in the library, and how to fix them.

- Sharing logic with actions

- CPU-intensive calculations

- High-frequency actions

- Store scoping

### Sharing logic with actions

There is a common pattern of using actions to share logic across multiple parts of a reducer. This is an inefficient way to share logic. Sending actions is not as lightweight of an operation as, say, calling a method on a class. Actions travel through multiple layers of an application, and at each layer a reducer can intercept and reinterpret the action.

For example, suppose that there are 3 UI components in your feature such that when any is changed you want to update the corresponding field of state, but then you also want to make some mutations and execute an effect. That common mutation and effect could be put into its own action and then each user action can return an effect that immediately emits that shared action:

@Reducer
struct Feature {
@ObservableState
struct State { /* ... */ }
enum Action { /* ... */ }

Reduce { state, action in
switch action {
case .buttonTapped:
state.count += 1
return .send(.sharedComputation)

case .toggleChanged:
state.isEnabled.toggle()
return .send(.sharedComputation)

case let .textFieldChanged(text):
state.description = text
return .send(.sharedComputation)

case .sharedComputation:
// Some shared work to compute something.
return .run { send in
// A shared effect to compute something
}
}
}
}
}

This is one way of sharing the logic and effect, but we are now incurring the cost of two actions even though the user performed a single action. That is not going to be as efficient as it would be if only a single action was sent.

Besides just performance concerns, there are two other reasons why you should not follow this pattern. First, this style of sharing logic is not very flexible. Because the shared logic is relegated to a separate action it must always be run after the initial logic. But what if instead you need to run some shared logic _before_ the core logic? This style cannot accommodate that.

Second, this style of sharing logic also muddies tests. When you send a user action you have to further assert on receiving the shared action and assert on how state changed. This bloats tests with unnecessary internal details, and the test no longer reads as a script from top-to-bottom of actions the user is taking in the feature:

let store = TestStore(initialState: Feature.State()) {
Feature()
}

store.send(.buttonTapped) {
$0.count = 1
}
store.receive(\.sharedComputation) {
// Assert on shared logic
}
store.send(.toggleChanged) {
$0.isEnabled = true
}
store.receive(\.sharedComputation) {
// Assert on shared logic
}
store.send(.textFieldChanged("Hello")) {
$0.description = "Hello"
}
store.receive(\.sharedComputation) {
// Assert on shared logic
}

So, we do not recommend sharing logic in a reducer by having dedicated actions for the logic and executing synchronous effects.

The above example can be refactored like so:

Reduce { state, action in
switch action {
case .buttonTapped:
state.count += 1
return self.sharedComputation(state: &state)

case .toggleChanged:
state.isEnabled.toggle()
return self.sharedComputation(state: &state)

case let .textFieldChanged(text):
state.description = text
return self.sharedComputation(state: &state)
}
}
}

// Some shared work to compute something.
return .run { send in
// A shared effect to compute something
}
}
}

This effectively works the same as before, but now when a user action is sent all logic is executed at once without sending an additional action. This also fixes the other problems we mentioned above.

For example, if you need to execute the shared logic _before_ the core logic, you can do so easily:

case .buttonTapped:
let sharedEffect = self.sharedComputation(state: &state)
state.count += 1
return sharedEffect

You have complete flexibility to decide how, when and where you want to execute the shared logic.

Further, tests become more streamlined since you do not have to assert on internal details of shared actions being sent around. The test reads like a user script of what the user is doing in the feature:

store.send(.buttonTapped) {
$0.count = 1
// Assert on shared logic
}
store.send(.toggleChanged) {
$0.isEnabled = true
// Assert on shared logic
}
store.send(.textFieldChanged("Hello") {
$0.description = "Hello"
// Assert on shared logic
}

##### Sharing logic in child features

There is another common scenario for sharing logic in features where the parent feature wants to invoke logic in a child feature. One can technically do this by sending actions from the parent to the child, but we do not recommend it (see above in Sharing logic with actions to learn why):

// Handling action from parent feature:
case .buttonTapped:
// Send action to child to perform logic:
return .send(.child(.refresh))

Instead, we recommend invoking the child reducer directly:

case .buttonTapped:
return reduce(into: &state, action: .child(.refresh))

### CPU intensive calculations

Reducers are run on the main thread and so they are not appropriate for performing intense CPU work. If you need to perform lots of CPU-bound work, then it is more appropriate to use an `Effect`, which will operate in the cooperative thread pool, and then send actions back into the system. You should also make sure to perform your CPU intensive work in a cooperative manner by periodically suspending with `Task.yield()` so that you do not block a thread in the cooperative pool for too long.

So, instead of performing intense work like this in your reducer:

case .buttonTapped:
var result = // ...
for value in someLargeCollection {
// Some intense computation with value
}
state.result = result

…you should return an effect to perform that work, sprinkling in some yields every once in awhile, and then delivering the result in an action:

case .buttonTapped:
return .run { send in
var result = // ...
for (index, value) in someLargeCollection.enumerated() {
// Some intense computation with value

// Yield every once in awhile to cooperate in the thread pool.
if index.isMultiple(of: 1_000) {
await Task.yield()
}
}
await send(.computationResponse(result))
}

case let .computationResponse(result):
state.result = result

This will keep CPU intense work from being performed in the reducer, and hence not on the main thread.

### High-frequency actions

Sending actions in a Composable Architecture application should not be thought as simple method calls that one does with classes, such as `ObservableObject` conformances. When an action is sent into the system there are multiple layers of features that can intercept and interpret it, and the resulting state changes can reverberate throughout the entire application.

Because of this, sending actions does come with a cost. You should aim to only send “significant” actions into the system, that is, actions that cause the execution of important logic and effects for your application. High-frequency actions, such as sending dozens of actions per second, should be avoided unless your application truly needs that volume of actions in order to implement its logic.

However, there are often times that actions are sent at a high frequency but the reducer doesn’t actually need that volume of information. For example, say you were constructing an effect that wanted to report its progress

In the 1.5.6 release of the library a change was made to `Store/scope(state:action:)-90255` that made it more sensitive to performance considerations.

The most common form of scoping, that of scoping directly along boundaries of child features, is the most performant form of scoping and is the intended use of scoping. The library is slowly evolving to a state where that is the _only_ kind of scoping one can do on a store.

The simplest example of this directly scoping to some child state and actions for handing to a child view:

ChildView(
store: store.scope(state: \.child, action: \.child)
)

Furthermore, scoping to a child domain to be used with one of the libraries navigation view modifiers, such as `SwiftUI/View/sheet(store:onDismiss:content:)`, also falls under the intended use of scope:

.sheet(store: store.scope(state: \.child, action: \.child)) { store in
ChildView(store: store)
}

All of these examples are how `Store/scope(state:action:)-90255` is intended to be used, and you can continue using it in this way with no performance concerns.

Where performance can become a concern is when using `scope` on _computed_ properties rather than simple stored fields. For example, say you had a computed property in the parent feature’s state for deriving the child state:

extension ParentFeature.State {
var computedChild: ChildFeature.State {
ChildFeature.State(
// Heavy computation here...
)
}
}

And then in the view, say you scoped along that computed property:

ChildView(
store: store.scope(state: \.computedChild, action: \.child)
)

If the computation in that property is heavy, it is going to become exacerbated by the changes made in 1.5, and the problem worsens the closer the scoping is to the root of the application.

The problem is that in version 1.5 scoped stores stopped directly holding onto their local state, and instead hold onto a reference to the store at the root of the application. And when you access state from the scoped store, it transforms the root state to the child state on the fly.

This transformation will include the heavy computed property, and potentially compute it many times if you need to access multiple pieces of state from the store. If you are noticing a performance problem while depending on 1.5+ of the library, look through your code base for any place you are using computed properties in scopes. You can even put a `print` statement in the computed property so that you can see first hand just how many times it is being invoked while running your application.

To fix the problem we recommend using `Store/scope(state:action:)-90255` only along stored properties of child features. Such key paths are simple getters, and so not have a problem with performance. If you are using a computed property in a scope, then reconsider if that could instead be done along a plain, stored property and moving the computed logic into the child view. The further you push the computation towards the leaf nodes of your application, the less performance problems you will see.

## See Also

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

- Performance
- Overview
- Sharing logic with actions
- CPU intensive calculations
- High-frequency actions
- Store scoping
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/faq

- ComposableArchitecture
- Frequently asked questions

Article

# Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

## Overview

We often see articles and discussions online concerning the Composable Architecture (TCA for short) that are outdated or slightly misinformed. Often these articles and discussions focus solely on “cons” of using TCA without giving time to what “pros” are unlocked by embracing any “cons” should they still exist in the latest version of TCA.

However, focusing only on “cons” is missing the forest from the trees. As an analogy, one could write a scathing article about the “cons” of value types in Swift, including the fact that they lack a stable identity like classes do. But that would be missing one of their greatest strengths, which is their ability to be copied and compared in a lightweight way!

App architecture is filled with trade-offs, and it is important to think deeply about what one gains and loses with each choice they make. We have collected some of the most common issues brought up here in order to dispel some myths:

- Should TCA be used for every kind of app?

- Should I adopt a 3rd party library for my app’s architecture?

- Does TCA go against the grain of SwiftUI?

- Isn’t TCA just a port of Redux? Is there a need for a library?

- Do features built in TCA have a lot of boilerplate?

- Isn’t maintaining a separate enum of “actions” unnecessary work?

- Are TCA features inefficient because all of an app’s state is held in one massive type?

- Does that cause views to over-render?

- Are large value types expensive to mutate?

- Can large value types cause stack overflows?
- Don’t TCA features have excessive “ping-ponging”?

- If features are built with value types, doesn’t that mean they cannot share state since value types are copied?

- Do I need a Point-Free subscription to learn or use TCA?

- Do I need to be familiar with “functional programming” to use TCA?

### Should TCA be used for every kind of app?

We do not recommend people use TCA when they are first learning Swift or SwiftUI. TCA is not a substitute or replacement for SwiftUI, but rather is meant to be paired with SwiftUI. You will need to be familiar with all of SwiftUI’s standard concepts to wield TCA correctly.

We also don’t think TCA really shines when building simple “reader” apps that mostly load JSON from the network and display it. Such apps don’t tend to have much in the way of nuanced logic or complex side effects, and so the benefits of TCA aren’t as clear.

In general it can be fine to start a project with vanilla SwiftUI (with a concentration on concise domain modeling), and then transition to TCA later if there is a need for any of its powers.

### Should I adopt a 3rd party library for my app’s architecture?

Adopting a 3rd party library is a big decision that should be had by you and your team after thoughtful discussion and consideration. We cannot make that decision for you. 🙂

But the “not invented here” mentality cannot be the _sole_ reason to not adopt a library. If a library’s core tenets align with your priorities for building your app, then adopting a library can be a sensible choice. It would be better to coalesce on a well-defined set of tools with a consistent history of maintenance and a strong community than to glue together many “tips and tricks” found in blog posts scattered around the internet.

Blog posts tend to be written from the perspective of something that was interesting and helpful in a particular moment, but it doesn’t necessarily stand the test of time. How many blog posts have been vetted for the many real world edge cases one actually encouters in app development? How many blog post techniques are still used by their authors 4 years later? How many blog posts have follow-up retrospectives describing how the technique worked in practice and evolved over time?

So, in comparison, we do not feel the adoption of a 3rd party library is significantly riskier than adopting ideas from blog posts, but it is up to you and your team to figure out your priorities for your application.

### Does TCA go against the grain of SwiftUI?

We actually feel that TCA complements SwiftUI quite well! The design of TCA has been heavily inspired by SwiftUI, and so you will find a lot of similarities:

- TCA features can minimally and implicitly observe minimal state changes just as in SwiftUI, but one uses the `@ObservableState` macro to do so, which is like Swift’s `@Observable`. We even back-ported Swift’s observation tools so that they could be used with iOS 16 and earlier.

- One composes TCA features together much like one composes SwiftUI features, by implementing a `body` property and using result builder syntax.

- Dependencies are declared using the `@Dependency` property wrapper, which behaves much like SwiftUI’s `@Environment` property wrapper, but it works outside of views.

- The library’s state sharing tools work a lot like SwiftUI’s `@Binding` tool, but it works outside of views and it is 100% testable.

We also feel that often TCA allows one to even more fully embrace some of the super powers of SwiftUI:

- TCA apps are allowed to use Swift’s observation tools with value types, whereas vanilla SwiftUI is limited to only reference types. The author of the observation proposal even intended for `@Observable` to work with value types but ultimately had to abandon it due to limitations of Swift. But we are able to overcome those limitations thanks to the `Store` type.

- Navigation in TCA uses all of the same tools from vanilla SwiftUI, such as `sheet(item:)`, `popover(item:)`, and even `NavigationStack`. But we also provide tools for driving navigation from more concise domains, such as enums and optionals.

- TCA allows one to “hot swap” a feature’s logic and behavior for alternate versions, with essentially no extra work. For example when showing a “placeholder” version of a UI using SwiftUI’s `redacted` API, you can swap the feature’s logic for an “inert” version that does nothing when interacted with.

- TCA features tend to be easier to view in Xcode previews because dependencies are controlled from the beginning. There are many dependencies that don’t work in previews ( _e.g._ location managers), and some that are dangerous to use in previews ( _e.g._ analytics clients), but one does not need to worry about that when controlling dependencies properly.

- TCA features can be fully tested, including how dependencies execute and feed data back into the system, all without needing to run a UI test.

And the more familiar you are with SwiftUI and its patterns, the better you will be able to leverage the Composable Architecture. We’ve never said that you must abandon SwiftUI in order to use TCA, and in fact we think the opposite is true!

### Isn’t TCA just a port of Redux? Is there a need for a library?

While TCA certainly shares some ideas and terminology with Redux, the two libraries are quite different. First, Redux is a JavaScript library, not a Swift library, and it was never meant to be an opinionated and cohesive solution to many app architecture problems. It focused on a particular problem, and stuck with it.

TCA broadened the focus to include tools for a lot of common problems one runs into with app architecture, such as:

- …tools for concise domain modeling.

- Allowing one to embrace value types fully instead of reference types.

- A full suite of tools are provided for integrating with Apple’s platforms (SwiftUI, UIKit, AppKit, _etc._), including navigation.

- A powerful dependency management system for controlling and propagating dependencies throughout your app.

- A testing tool that makes it possible to exhaustively test how your feature behaves with user actions, including how side effects execute and feed data back into the system.

- …and more!

Redux does not provide tools itself for any of the above problems.

And you can certainly opt to build your own TCA-inspired library instead of depending directly on TCA, and in fact many large companies do just that. But it is also worth considering if it is worth losing out on the continual development and improvements TCA makes over the years. With each major release of iOS we have made sure to keep TCA up-to-date, including concurrency tools, `NavigationStack`, and Swift 5.9’s observation tools (of which we even back-ported so that they could be used all the way tools, and more. And further you will be missing out on the community of thousands of developers that use TCA and frequent our GitHub discussions and Slack.

### Do features built in TCA have a lot of boilerplate?

Often people complain of boilerplate in TCA, especially with regards a legacy concept known as “view stores”. Those were objects that allowed views to observe the minimal amount of state in a view, and they were deprecated a long time ago after Swift 5.9 released with the Observation framework. Features built with modern TCA do not need to worry about view stores and instead can access state directly off of stores and the view will observe the minimal amount of state, just as in vanilla SwiftUI.

In our experience, a standard TCA feature should not require very many more lines of code than an equivalent vanilla SwiftUI feature, and if you write tests or integrate features together using the tools TCA provides, it should require much _less_ code than the equivalent vanilla code.

### Isn’t maintaining a separate enum of “actions” unnecessary work?

Modeling user actions with an enum rather than methods defined on some object is certainly a big decision to make, and some people find it off-putting, but it wasn’t made just for the fun of it. There are massive benefits one gains from having a data description of every action in your application:

- It fully decouples the logic of your feature from the view of your feature, even more than a dedicated `@Observable` model class can. You can write a reducer that wraps an existing reducer and “tweaks” the underlying reducer’s logic in anyway it sees fit.

For example, in our open source word game, isowords, we have an onboarding feature that runs the game feature inside, but with additional logic layered on. Since each action in the game has a simple enum description we are able to intercept any action and execute some additional logic. For example, when the user submits a word during onboarding we can inspect which word they submitted as well as which step of the onboarding process they are on in order to figure out if they should proceed to the next step:

case .game(.submitButtonTapped):
switch state.step {
case
.step5_SubmitGame where state.game.selectedWordString == "GAME",
.step8_FindCubes where state.game.selectedWordString == "CUBES",
.step12_CubeIsShaking where state.game.selectedWordString == "REMOVE",
.step16_FindAnyWord where dictionary.contains(state.game.selectedWordString, .en):

state.step.next()

This is quite complex logic that was easy to implement thanks to the enum description of actions. And on top of that, it was all 100% unit testable.

- Having a data type of all actions in your feature makes it possible to write powerful debugging tools. For example, the `_printChanges()` reducer operator gives you insight into every action that enters the system, and prints a nicely formatted message showing exactly how state changed when the action was processed:

received action:
AppFeature.Action.syncUpsList(.addSyncUpButtonTapped)
AppFeature.State(
_path: [:],
_syncUpsList: SyncUpsList.State(
- _destination: nil,
+ _destination: .add(
+ SyncUpForm.State(
+ …
+ )
+ ),
_syncUps: #1 […]
)
)

You can also create a tool, `signpost`, that automatically instruments every action of your feature with signposts to find any potential performance problems in your app. And 3rd parties have built their own tools for tracking and instrumenting features, all thanks to the fact that there is a data representation of every action in the app.

- Having a data type of all actions in your feature also makes it possible to write exhaustive tests on every aspect of your feature. Using something known as a `TestStore` you can emulate user flows by sending it actions and asserting how state changes each step of the way. And further, you must also assert on how effects feed their data back into the system by asserting on actions received:

store.send(.refreshButtonTapped) {
$0.isLoading = true
}
store.receive(\.userResponse) {
$0.currentUser = User(id: 42, name: "Blob")
$0.isLoading = false
}

Again this is only possible thanks to the data type of all actions in the feature. See for more information on testing in TCA.

### Are TCA features inefficient because all of an app’s state is held in one massive type?

This comes up often, but this misunderstands how real world features are actually modeled in practice. An app built with TCA does not literally hold onto the state of every possible screen of the app all at once. In reality most features of an app are not presented at once, but rather incrementally. Features are presented in sheets, drill-downs and other forms of navigation, and those forms of navigation are gated by optional state. This means if a feature is not presented, then its state is `nil`, and hence not represented in the app state.

- ##### Does that cause views to over-render?

In reality views re-compute the minimal number of times based off of what state is accessed in the view, just as it does in vanilla SwiftUI with the `@Observable` macro. But because we back-ported the observation framework to iOS 13 you can make use of the tools today, and not wait until you can drop iOS 16 support.

- ##### Are large value types expensive to mutate?

This doesn’t really seem to be the case with in-place mutation in Swift. Mutation _via_ `inout` has been quite efficient from our testing, and there’s a chance that Swift’s new borrowing and consuming tools will allow us to make it even more efficient.

- ##### Can large value types cause stack overflows?

While it is true that large value types can overflow the stack, in practice this does not really happen if you are using the navigation tools of the library. The navigation tools insert a heap allocated, copy-on-write wrapper at each presentation node of your app’s state. So if feature A can present feature B, then feature A’s state does not literally contain feature B’s state.

### Don’t TCA features have excessive “ping-ponging”?

There have been complaints of action “ping-ponging”, where one wants to perform multiple effects and so has to send multiple actions:

case .refreshButtonTapped:
return .run { send in
await send(.userResponse(apiClient.fetchCurrentUser()))
}
case let .userResponse(response):
return .run { send in
await send(.moviesResponse(apiClient.fetchMovies(userID: response.id)))
}
case let .moviesResponse(response):
// Do something with response

However, this is really only necessary if you specifically need to intermingle state mutations _and_ async operations. If you only need to execute multiple async operations with no state mutations in between, then all of that work can go into a single effect:

case .refreshButtonTapped:
return .run { send in
let userResponse = await apiClient.fetchCurrentUser()
let moviesResponse = await apiClient.fetchMovies(userID: userResponse.id)
await send(.moviesResponse(moviesResponse))
}

And if you really do need to perform state mutations between each of these asynchronous operations then you will incur a bit of ping-ponging. But, as mentioned above, there are great benefits to having a data description of actions, such as an extreme decoupling of logic from the view, powerful debugging tools, the ability to test every aspect of your feature, and more. If you were to try to reproduce those abilities in a non-TCA app you would be inevitably led to the same ping-ponging.

### If features are built with value types, doesn’t that mean they cannot share state since value types are copied?

This _used_ to be true, but in version 1.10 of the library we released all new state sharing tools that allow you to easily share state between multiple features, and even persist state to external systems, such as user defaults and the file system.

Further, one of the dangers of introducing shared state to an app, any app, is that it can make it difficult to understand since it introduces reference semantics into your domain. But we put in extra work to make sure that shared state remains 100% testable, and even _exhaustively_ testable, which makes it far easier to keep track of how shared state is mutated in your features.

### Do I need a Point-Free subscription to learn or use TCA?

While we do release a lot of material on our website that is subscriber-only, we also release a _ton_ of material completely for free. The documentation for TCA contains numerous articles and tutorials, including a massive tutorial building a complex app from scratch that demonstrates domain modeling, navigation, dependencies, testing, and more.

### Do I need to be familiar with “functional programming” to use TCA?

TCA does not describe itself as a “functional programming” library, and never has. At the end of the day Swift is not a functional language, and so there is no way to force functional patterns at compile time, such as “pure” functions. And so familiarity of “functional programming” is not necessary.

However, certain concepts of functional programming languages are quite important to us, and we have used those concepts to guide aspects of the library. For example, a core tenet of the library is to build as much of your domain using value types, which are easy to understand and behaviorless, as opposed to reference types, which allow for “action at a distance”. The library also values separating side effects from pure logic transformations. This allows for great testability, including how side effects execute and feed data back into the system.

However, one does not need to have any prior experience with these concepts. The ideas are imbued into the library and documentation, and so you will gain experience by simply following our materials and demo apps.

## See Also

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

- Frequently asked questions
- Overview
- Should TCA be used for every kind of app?
- Should I adopt a 3rd party library for my app’s architecture?
- Does TCA go against the grain of SwiftUI?
- Isn’t TCA just a port of Redux? Is there a need for a library?
- Do features built in TCA have a lot of boilerplate?
- Isn’t maintaining a separate enum of “actions” unnecessary work?
- Are TCA features inefficient because all of an app’s state is held in one massive type?
- Don’t TCA features have excessive “ping-ponging”?
- If features are built with value types, doesn’t that mean they cannot share state since value types are copied?
- Do I need a Point-Free subscription to learn or use TCA?
- Do I need to be familiar with “functional programming” to use TCA?
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer

- ComposableArchitecture
- Reducer

Protocol

# Reducer

A protocol that describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any.

## Overview

The `Reducer` protocol describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any. Types that conform to this protocol represent the domain, logic and behavior for a feature. Conformances to `Reducer` can be written by hand, but the `Reducer()` can make your reducers more concise and more powerful.

- Conforming to the Reducer protocol

- Using the @Reducer macro

- @CasePathable and @dynamicMemberLookup enums

- Automatic fulfillment of reducer requirements

- Destination and path reducers

- Navigating to non-reducer features

- Synthesizing protocol conformances on State and Action

- Nested enum reducers
- Gotchas

- Autocomplete

- #Preview and enum reducers

- CI build failures

## Conforming to the Reducer protocol

The bare minimum of conforming to the `Reducer` protocol is to provide a `State` type that represents the state your feature needs to do its job, a `Action` type that represents the actions users can perform in your feature (as well as actions that effects can feed back into the system), and a `body` property that compose your feature together with any other features that are needed (such as for navigation).

As a very simple example, a “counter” feature could model its state as a struct holding an integer:

struct CounterFeature: Reducer {
@ObservableState
struct State {
var count = 0
}
}

The actions would be just two cases for tapping an increment or decrement button:

struct CounterFeature: Reducer {
// ...
enum Action {
case decrementButtonTapped
case incrementButtonTapped
}
}

The logic of your feature is implemented by mutating the feature’s current state when an action comes into the system. This is most easily done by constructing a `Reduce` inside the `body` of your reducer:

struct CounterFeature: Reducer {
// ...

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none
case .incrementButtonTapped:
state.count += 1
return .none
}
}
}
}

The `Reduce` reducer’s first responsibility is to mutate the feature’s current state given an action. Its second responsibility is to return effects that will be executed asynchronously and feed their data back into the system. Currently `Feature` does not need to run any effects, and so `none` is returned.

If the feature does need to do effectful work, then more would need to be done. For example, suppose the feature has the ability to start and stop a timer, and with each tick of the timer the `count` will be incremented. That could be done like so:

struct CounterFeature: Reducer {
@ObservableState
struct State {
var count = 0
}
enum Action {
case decrementButtonTapped
case incrementButtonTapped
case startTimerButtonTapped
case stopTimerButtonTapped
case timerTick
}
enum CancelID { case timer }

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none

case .incrementButtonTapped:
state.count += 1
return .none

case .startTimerButtonTapped:
return .run { send in
while true {
try await Task.sleep(for: .seconds(1))
await send(.timerTick)
}
}
.cancellable(CancelID.timer)

case .stopTimerButtonTapped:
return .cancel(CancelID.timer)

case .timerTick:
state.count += 1
return .none
}
}
}
}

That is the basics of implementing a feature as a conformance to `Reducer`.

## Using the @Reducer macro

While you technically can conform to the `Reducer` protocol directly, as we did above, the `Reducer()` macro can automate many aspects of implementing features for you. At a bare minimum, all you have to do is annotate your reducer with `@Reducer` and you can even drop the `Reducer` conformance:

+@Reducer
-struct CounterFeature: Reducer {
+struct CounterFeature {
@ObservableState
struct State {
var count = 0
}
enum Action {
case decrementButtonTapped
case incrementButtonTapped
}

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none
case .incrementButtonTapped:
state.count += 1
return .none
}
}
}
}

There are a number of things the `Reducer()` macro does for you:

### @CasePathable and @dynamicMemberLookup enums

The `@Reducer` macro automatically applies the `@CasePathable` macro to your `Action` enum:

+@CasePathable
enum Action {
// ...
}

Case paths are a tool that bring the power and ergonomics of key paths to enum cases, and they are a vital tool for composing reducers together.

In particular, having this macro applied to your `Action` enum will allow you to use key path syntax for specifying enum cases in various APIs in the library, such as `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q`, `Reducer/forEach(_:action:destination:fileID:filePath:line:column:)-9svqb`, `Scope`, and more.

Further, if the `State` of your feature is an enum, which is useful for modeling a feature that can be one of multiple mutually exclusive values, the `Reducer()` will apply the `@CasePathable` macro, as well as `@dynamicMemberLookup`:

+@CasePathable
+@dynamicMemberLookup
enum State {
// ...
}

This will allow you to use key path syntax for specifying case paths to the `State`’s cases, as well as allow you to use dot-chaining syntax for optionally extracting a case from the state. This can be useful when using the operators that come with the library that allow for driving navigation from an enum of options:

.sheet(
item: $store.scope(state: \.destination?.editForm, action: \.destination.editForm)
) { store in
FormView(store: store)
}

The syntax `state: \.destination?.editForm` is only possible due to both `@dynamicMemberLookup` and `@CasePathable` being applied to the `State` enum.

### Automatic fulfillment of reducer requirements

The `Reducer()` macro will automatically fill in any `Reducer` protocol requirements that you leave off. For example, something as simple as this compiles:

@Reducer
struct Feature {}

The `@Reducer` macro will automatically insert an empty `State` struct, an empty `Action` enum, and an empty `body`. This effectively means that `Feature` is a logicless, behaviorless, inert reducer.

Having these requirements automatically fulfilled for you can be handy for slowly filling them in with their real implementations. For example, this `Feature` reducer could be integrated in a parent domain using the library’s navigation tools, all without having implemented any of the domain yet. Then, once we are ready we can start implementing the real logic and behavior of the feature.

### Destination and path reducers

There is a common pattern in the Composable Architecture of representing destinations a feature can navigate to as a reducer that operates on enum state, with a case for each feature that can be navigated to. This is explained in great detail in the Tree-based navigation and Stack-based navigation articles.

This form of domain modeling can be very powerful, but also incur a bit of boilerplate. For example, if a feature can navigate to 3 other features, then one might have a `Destination` reducer like the following:

@Reducer
struct Destination {
@ObservableState
enum State {
case add(FormFeature.State)
case detail(DetailFeature.State)
case edit(EditFeature.State)
}
enum Action {
case add(FormFeature.Action)
case detail(DetailFeature.Action)
case edit(EditFeature.Action)
}

Scope(state: \.add, action: \.add) {
FormFeature()
}
Scope(state: \.detail, action: \.detail) {
DetailFeature()
}
Scope(state: \.edit, action: \.edit) {
EditFeature()
}
}
}

It’s not the worst code in the world, but it is 24 lines with a lot of repetition, and if we need to add a new destination we must add a case to the `State` enum, a case to the `Action` enum, and a `Scope` to the `body`.

The `Reducer()` macro is now capable of generating all of this code for you from the following simple declaration

@Reducer
enum Destination {
case add(FormFeature)
case detail(DetailFeature)
case edit(EditFeature)
}

24 lines of code has become 6. The `@Reducer` macro can now be applied to an _enum_ where each case holds onto the reducer that governs the logic and behavior for that case. Further, when using the `ifLet(_:action:)` operator with this style of `Destination` enum reducer you can completely leave off the trailing closure as it can be automatically inferred:

Reduce { state, action in
// Core feature logic
}
.ifLet(\.$destination, action: \.destination)
-{
- Destination()
-}

This pattern also works for `Path` reducers, which is common when dealing with Stack-based navigation, and in that case you can leave off the trailing closure of the `forEach(_:action:)` operator:

Reduce { state, action in
// Core feature logic
}
.forEach(\.path, action: \.path)
-{
- Path()
-}

Further, for `Path` reducers in particular, the `Reducer()` macro also helps you reduce boilerplate when using the initializer `init(path:root:destination:fileID:filePath:line:column:)` that comes with the library. In the last trailing closure you can use the `case` computed property to switch on the `Path.State` enum and extract out a store for each case:

NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
// Root view
} destination: { store in
switch store.case {
case let .add(store):
AddView(store: store)
case let .detail(store):
DetailView(store: store)
case let .edit(store):
EditView(store: store)
}
}

#### Navigating to non-reducer features

There are many times that you want to present or navigate to a feature that is not modeled with a Composable Architecture reducer. This can happen with legacy features that are not built with the Composable Architecture, or with features that are very simple and do not need a fully built reducer.

In those cases you can use the `ReducerCaseIgnored()` and `ReducerCaseEphemeral()` macros to annotate cases that are not powered by reducers. See the documentation for those macros for more details.

As an example, suppose that you have a feature that can navigate to multiple features, all of which are Composable Architecture features except for one:

@Reducer
enum Destination {
case add(AddItemFeature)
case edit(EditItemFeature)
@ReducerCaseIgnored
case item(Item)
}

In this situation the `.item` case holds onto a plain item and not a full reducer, and for that reason we have to ignore it from some of `@Reducer`’s macro expansion.

Then, to present a view from this case one can do:

.sheet(item: $store.scope(state: \.destination?.item, action: \.destination.item)) { store in
ItemView(item: store.withState { $0 })
}

#### Synthesizing protocol conformances on State and Action

Since the `State` and `Action` types are generated automatically for you when using `@Reducer` on an enum, you must extend these types yourself to synthesize conformances of `Equatable`, `Hashable`, _etc._:

@Reducer
enum Destination {
// ...
}
extension Destination.State: Equatable {}

#### Nested enum reducers

There may be times when an enum reducer may want to nest another enum reducer. To do so, the parent enum reducer must specify the child’s `Body` associated value and `body` static property explicitly:

@Reducer
enum Modal { /* ... */ }

@Reducer
enum Destination {
case modal(Modal.Body = Modal.body)
}

#### Autocomplete

Applying `@Reducer` can break autocompletion in the `body` of the reducer. This is a known issue, and it can generally be worked around by providing additional type hints to the compiler:

1. Adding an explicit `Reducer` conformance in addition to the macro application can restore autocomplete throughout the `body` of the reducer:

@Reducer
-struct Feature {
+struct Feature: Reducer {

2. Adding explicit generics to instances of `Reduce` in the `body` can restore autocomplete inside the `Reduce`:

- Reduce { state, action in

#### \#Preview and enum reducers

The `#Preview` macro is not capable of seeing the expansion of any macros since it is a macro itself. This means that when using destination and path reducers (see Destination and path reducers above) you cannot construct the cases of the state enum inside `#Preview`:

#Preview {
FeatureView(
store: Store(
initialState: Feature.State(
destination: .edit(EditFeature.State()) // 🛑
)
) {
Feature()
}
)
}

The `.edit` case is not usable from within `#Preview` since it is generated by the `Reducer()` macro.

The workaround is to move the view to a helper that be compiled outside of a macro, and then use it inside the macro:

#Preview {
preview
}
private var preview: some View {
FeatureView(
store: Store(
initialState: Feature.State(
destination: .edit(EditFeature.State())
)
) {
Feature()
}
)
}

You can use a computed property, free function, or even a dedicated view if you want. You can also use the old, non-macro style of previews by using a `PreviewProvider`:

struct Feature_Previews: PreviewProvider {
static var previews: some View {
FeatureView(
store: Store(
initialState: Feature.State(
destination: .edit(EditFeature.State())
)
) {
Feature()
}
)
}
}

#### Error: External macro implementation … could not be found

When integrating with the Composable Architecture, one may encounter the following error:

This error can show up when the macro has not yet been enabled, which is a separate error that should be visible from Xcode’s Issue navigator.

Sometimes, however, this error will still emit due to an Xcode bug in which a custom build configuration name is being used in the project. In general, using a build configuration other than “Debug” or “Release” can trigger upstream build issues with Swift packages, and we recommend only using the default “Debug” and “Release” build configuration names to avoid the above issue and others.

#### CI build failures

When testing your code on an external CI server you may run into errors such as the following:

You can fix this in one of two ways. You can write a default to the CI machine that allows Xcode to skip macro validation:

defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

Or if you are invoking `xcodebuild` directly in your CI scripts, you can pass the `-skipMacroValidation` flag to `xcodebuild` when building your project:

xcodebuild -skipMacroValidation …

## Topics

### Implementing a reducer

`macro Reducer()`

Helps implement the conformance to the `Reducer` protocol for a type.

`associatedtype State`

A type that holds the current state of the reducer.

**Required**

`associatedtype Action`

A type that holds all possible actions that cause the `State` of the reducer to change and/or kick off a side `Effect` that can communicate with the outside world.

`var body: Self.Body`

The content and behavior of a reducer that is composed from other reducers.

**Required** Default implementations provided.

`struct Reduce`

A type-erased reducer that invokes the given `reduce` function.

`struct Effect`

### Composing reducers

`enum ReducerBuilder`

A result builder for combining reducers into a single reducer by running each, one after the other, and merging their effects.

`struct CombineReducers`

Combines multiple reducers into a single reducer.

### Embedding child features

`struct Scope`

Embeds a child reducer in a parent domain.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

### Supporting reducers

`struct EmptyReducer`

A reducer that does nothing.

`struct BindingReducer`

A reducer that updates bindable state when it receives binding actions.

`extension Optional`

### Reducer modifiers

Sets the dependency value of the specified key path to the given value.

Transform a reducer’s dependency value at the specified key path with the given function.

Adds a reducer to run when this reducer changes the given value in state.

Instruments a reducer with signposts.

Enhances a reducer with debug logging of received actions and state mutations for the given printer.

### Supporting types

`typealias ReducerOf`

A convenience for constraining a `Reducer` conformance.

### Deprecations

Review unsupported reducer APIs and their replacements.

### Instance Methods

Places a value in the reducer’s dependencies.

`func forEach<DestinationState, DestinationAction>(WritableKeyPath<Self.State, StackState<DestinationState>>, action: CaseKeyPath<Self.Action, StackAction<DestinationState, DestinationAction>>) -> some Reducer<Self.State, Self.Action>\\

A special overload of `Reducer/forEach(_:action:destination:fileID:filePath:line:column:)-9svqb` for enum reducers.

`func forEach<DestinationState, DestinationAction, Destination>(WritableKeyPath<Self.State, StackState<DestinationState>>, action: AnyCasePath<Self.Action, StackAction<DestinationState, DestinationAction>>, destination: () -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\
` Deprecated

`func forEach<DestinationState, DestinationAction, Destination>(WritableKeyPath<Self.State, StackState<DestinationState>>, action: CaseKeyPath<Self.Action, StackAction<DestinationState, DestinationAction>>, destination: () -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\

Embeds a child reducer in a parent domain that works on elements of a navigation stack in parent state.

`func forEach<ElementState, ElementAction, ID, Element>(WritableKeyPath<Self.State, IdentifiedArray<ID, ElementState>>, action: AnyCasePath<Self.Action, (ID, ElementAction)>, element: () -> Element, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\
` Deprecated

`func forEach<ElementState, ElementAction, ID, Element>(WritableKeyPath<Self.State, IdentifiedArray<ID, ElementState>>, action: CaseKeyPath<Self.Action, IdentifiedAction<ID, ElementAction>>, element: () -> Element, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\

Embeds a child reducer in a parent domain that works on elements of a collection in parent state.

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/ifcaselet(_:action:then:fileid:filepath:line:column:)-1oxkp) Deprecated

Embeds a child reducer in a parent domain that works on a case of parent enum state.

`func ifLet<ChildState, ChildAction>(WritableKeyPath<Self.State, PresentationState<ChildState>>, action: CaseKeyPath<Self.Action, PresentationAction<ChildAction>>) -> some Reducer<Self.State, Self.Action>\\

A special overload of `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` for enum reducers.

`func ifLet<DestinationState, DestinationAction, Destination>(WritableKeyPath<Self.State, PresentationState<DestinationState>>, action: CaseKeyPath<Self.Action, PresentationAction<DestinationAction>>, destination: () -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\

Embeds a child reducer in a parent domain that works on an optional property of parent state.

`func ifLet<DestinationState, DestinationAction, Destination>(WritableKeyPath<Self.State, PresentationState<DestinationState>>, action: AnyCasePath<Self.Action, PresentationAction<DestinationAction>>, destination: () -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\
` Deprecated

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-11rub)

A special overload of `Reducer/ifLet(_:action:then:fileID:filePath:line:column:)-2r2pn` for alerts and confirmation dialogs that does not require a child reducer.

`func ifLet<DestinationState, DestinationAction>(WritableKeyPath<Self.State, PresentationState<DestinationState>>, action: CaseKeyPath<Self.Action, PresentationAction<DestinationAction>>, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\

A special overload of `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` for alerts and confirmation dialogs that does not require a child reducer.

`func ifLet<WrappedState, WrappedAction>(WritableKeyPath<Self.State, WrappedState?>, action: AnyCasePath<Self.Action, WrappedAction>, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> _IfLetReducer<Self, EmptyReducer<WrappedState, WrappedAction>>` Deprecated

`func ifLet<DestinationState, DestinationAction>(WritableKeyPath<Self.State, PresentationState<DestinationState>>, action: AnyCasePath<Self.Action, PresentationAction<DestinationAction>>, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\
` Deprecated

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:then:fileid:filepath:line:column:)-24blc)

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:then:fileid:filepath:line:column:)-94ggc) Deprecated

## Relationships

### Inherited By

- `CaseReducer`

### Conforming Types

- `BindingReducer`
- `CombineReducers`
- `EmptyReducer`
- `Optional`
Conforms when `Wrapped` conforms to `Reducer`.

- `Reduce`
- `Scope`

## See Also

### State management

`class Store`

A store represents the runtime that powers the application. It is the object that you will pass around to views that need to interact with the application.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

- Reducer
- Overview
- Conforming to the Reducer protocol
- Using the @Reducer macro
- @CasePathable and @dynamicMemberLookup enums
- Automatic fulfillment of reducer requirements
- Destination and path reducers
- Gotchas
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect

- ComposableArchitecture
- Effect

Structure

# Effect

## Topics

### Creating an effect

An effect that does nothing and completes immediately. Useful for situations where you must return an effect, but you don’t need to do anything.

Wraps an asynchronous unit of work that can emit actions any number of times in an effect.

Initializes an effect that immediately emits the action passed in.

`typealias EffectOf`

A convenience type alias for referring to an effect of a given reducer’s domain.

`enum TaskResult`

A value that represents either a success or a failure. This type differs from Swift’s `Result` type in that it uses only one generic for the success case, leaving the failure case as an untyped `Error`.

Deprecated

### Cancellation

Turns an effect into one that is capable of being canceled.

An effect that will cancel any currently in-flight effect with the given identifier.

Execute an operation with a cancellation identifier.

`static func cancel(id: some Hashable & Sendable)`

Cancel any currently in-flight operation with the given identifier.

### Composition

Transforms all elements from the upstream effect with a provided closure.

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

`static func merge(some Sequence<Effect<Action>>) -> Effect<Action>`

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

Merges this effect and another into a single effect that runs both at the same time.

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

`static func concatenate(some Collection<Effect<Action>>) -> Effect<Action>`

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

### SwiftUI integration

Wraps the emission of each element with SwiftUI’s `withAnimation`.

Wraps the emission of each element with SwiftUI’s `withTransaction`.

### Combine integration

Creates an effect from a Combine publisher.

Turns an effect into one that can be debounced.

Throttles an effect so that it only publishes one output per given interval.

## Relationships

### Conforms To

- `Swift.Sendable`

## See Also

### State management

`protocol Reducer`

A protocol that describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any.

`class Store`

A store represents the runtime that powers the application. It is the object that you will pass around to views that need to interact with the application.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

- Effect
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/store

- ComposableArchitecture
- Store

Class

# Store

A store represents the runtime that powers the application. It is the object that you will pass around to views that need to interact with the application.

@MainActor @dynamicMemberLookup @preconcurrency

## Overview

You will typically construct a single one of these at the root of your application:

@main
struct MyApp: App {
var body: some Scene {
WindowGroup {
RootView(
store: Store(initialState: AppFeature.State()) {
AppFeature()
}
)
}
}
}

…and then use the `scope(state:action:)-90255` method to derive more focused stores that can be passed to subviews.

### Scoping

The most important operation defined on `Store` is the `scope(state:action:)-90255` method, which allows you to transform a store into one that deals with child state and actions. This is necessary for passing stores to subviews that only care about a small portion of the entire application’s domain.

For example, if an application has a tab view at its root with tabs for activity, search, and profile, then we can model the domain like this:

@Reducer
struct AppFeature {
struct State {
var activity: Activity.State
var profile: Profile.State
var search: Search.State
}

enum Action {
case activity(Activity.Action)
case profile(Profile.Action)
case search(Search.Action)
}

// ...
}

We can construct a view for each of these domains by applying `scope(state:action:)-90255` to a store that holds onto the full app domain in order to transform it into a store for each subdomain:

struct AppView: View {

TabView {
ActivityView(
store: store.scope(state: \.activity, action: \.activity)
)
.tabItem { Text("Activity") }

SearchView(
store: store.scope(state: \.search, action: \.search)
)
.tabItem { Text("Search") }

ProfileView(
store: store.scope(state: \.profile, action: \.profile)
)
.tabItem { Text("Profile") }
}
}
}

### Thread safety

The `Store` class is not thread-safe, and so all interactions with an instance of `Store` (including all of its child stores) must be done on the same thread the store was created on. Further, if the store is powering a SwiftUI or UIKit view, as is customary, then all interactions must be done on the _main_ thread.

The reason stores are not thread-safe is due to the fact that when an action is sent to a store, a reducer is run on the current state, and this process cannot be done from multiple threads. It is possible to make this process thread-safe by introducing locks or queues, but this introduces new complications:

- If done simply with `DispatchQueue.main.async` you will incur a thread hop even when you are already on the main thread. This can lead to unexpected behavior in UIKit and SwiftUI, where sometimes you are required to do work synchronously, such as in animation blocks.

- It is possible to create a scheduler that performs its work immediately when on the main thread and otherwise uses `DispatchQueue.main.async` ( _e.g._, see Combine Schedulers’ UIScheduler).

This introduces a lot more complexity, and should probably not be adopted without having a very good reason.

This is why we require all actions be sent from the same thread. This requirement is in the same spirit of how `URLSession` and other Apple APIs are designed. Those APIs tend to deliver their outputs on whatever thread is most convenient for them, and then it is your responsibility to dispatch we get to test these aspects of our effects if we so desire, or we can ignore if we prefer. We have that flexibility.

#### Thread safety checks

The store performs some basic thread safety checks in order to help catch mistakes. Stores constructed via the initializer `init(initialState:reducer:withDependencies:)` are assumed to run only on the main thread, and so a check is executed immediately to make sure that is the case. Further, all actions sent to the store and all scopes (see `scope(state:action:)-90255`) of the store are also checked to make sure that work is performed on the main thread.

### ObservableObject conformance

The store conforms to `ObservableObject` but is _not_ observable via the `@ObservedObject` property wrapper. This conformance is completely inert and its sole purpose is to allow stores to be held in SwiftUI’s `@StateObject` property wrapper.

Instead, stores should be observed through Swift’s Observation framework (or the Perception package when targeting iOS <17) by applying the `ObservableState()` macro to your feature’s state.

## Topics

### Creating a store

Initializes a store from an initial state and a reducer.

`typealias StoreOf`

A convenience type alias for referring to a store of a given reducer’s domain.

### Accessing state

`var state: State`

Direct access to state in the store when `State` conforms to `ObservableState`.

Calls the given closure with a snapshot of the current state of the store.

### Sending actions

Sends an action to the store.

Sends an action to the store with a given animation.

Sends an action to the store with a given transaction.

`struct StoreTask`

The type returned from `send(_:)` that represents the lifecycle of the effect started from sending an action.

### Scoping stores

``var `case`: State.StateReducer.CaseScope``

A destructurable view of a store on a collection of cases.

### Combine integration

`struct StorePublisher`

A publisher of store state.

### Deprecated interfaces

Review unsupported store APIs and their replacements.

### Instance Methods

Scopes the store to one that exposes child state and actions.

Scopes the store to optional child state and actions.

`func scope<ElementID, ElementState, ElementAction>(state: KeyPath<State, IdentifiedArray<ElementID, ElementState>>, action: CaseKeyPath<Action, IdentifiedAction<ElementID, ElementAction>>, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some RandomAccessCollection<Store<ElementState, ElementAction>>\\

Scopes the store of an identified collection to a collection of stores.

## Relationships

### Conforms To

- `Combine.ObservableObject`
- `Observation.Observable`
- `PerceptionCore.Perceptible`
- `Swift.Copyable`
- `Swift.CustomDebugStringConvertible`
- `Swift.Equatable`
- `Swift.Hashable`
- `Swift.Identifiable`
- `Swift.Sendable`

## See Also

### State management

`protocol Reducer`

A protocol that describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any.

`struct Effect`

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

- Store
- Overview
- Scoping
- Thread safety
- ObservableObject conformance
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/teststore

- ComposableArchitecture
- TestStore

Class

# TestStore

A testable runtime for a reducer.

@MainActor @preconcurrency

## Overview

This object aids in writing expressive and exhaustive tests for features built in the Composable Architecture. It allows you to send a sequence of actions to the store, and each step of the way you must assert exactly how state changed, and how effect emissions were fed back into the system.

See the dedicated Testing article for detailed information on testing.

## Exhaustive testing

By default, `TestStore` requires you to exhaustively prove how your feature evolves from sending use actions and receiving actions from effects. There are multiple ways the test store forces you to do this:

- After each action is sent you must describe precisely how the state changed from before the action was sent to after it was sent.

If even the smallest piece of data differs the test will fail. This guarantees that you are proving you know precisely how the state of the system changes.

- Sending an action can sometimes cause an effect to be executed, and if that effect sends an action back into the system, you **must** explicitly assert that you expect to receive that action from the effect, _and_ you must assert how state changed as a result.

If you try to send another action before you have handled all effect actions, the test will fail. This guarantees that you do not accidentally forget about an effect action, and that the sequence of steps you are describing will mimic how the application behaves in reality.

- All effects must complete by the time the test case has finished running, and all effect actions must be asserted on.

If at the end of the assertion there is still an in-flight effect running or an unreceived action, the assertion will fail. This helps exhaustively prove that you know what effects are in flight and forces you to prove that effects will not cause any future changes to your state.

For example, given a simple counter reducer:

@Reducer
struct Counter {
struct State: Equatable {
var count = 0
}

enum Action {
case decrementButtonTapped
case incrementButtonTapped
}

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none

case .incrementButtonTapped:
state.count += 1
return .none
}
}
}
}

One can assert against its behavior over time:

@MainActor
struct CounterTests {
@Test
func basics() async {
let store = TestStore(
// Given: a counter state of 0
initialState: Counter.State(count: 0),
) {
Counter()
}

// When: the increment button is tapped
await store.send(.incrementButtonTapped) {
// Then: the count should be 1
$0.count = 1
}
}
}

Note that in the trailing closure of `.send(.incrementButtonTapped)` we are given a single mutable value of the state before the action was sent, and it is our job to mutate the value to match the state after the action was sent. In this case the `count` field changes to `1`.

If the change made in the closure does not reflect reality, you will get a test failure with a nicely formatted failure message letting you know exactly what went wrong:

await store.send(.incrementButtonTapped) {
$0.count = 42
}

For a more complex example, consider the following bare-bones search feature that uses a clock and cancel token to debounce requests:

@Reducer
struct Search {
struct State: Equatable {
var query = ""
var results: [String] = []
}

enum Action {
case queryChanged(String)

}

@Dependency(\.apiClient) var apiClient
@Dependency(\.continuousClock) var clock
private enum CancelID { case search }

Reduce { state, action in
switch action {
case let .queryChanged(query):
state.query = query
return .run { send in
try await self.clock.sleep(for: 0.5)

await send(.searchResponse(Result { try await self.apiClient.search(query) }))
}
.cancellable(id: CancelID.search, cancelInFlight: true)

case let .searchResponse(.success(results)):
state.results = results
return .none

case .searchResponse(.failure):
// Do error handling here.
return .none
}
}
}
}

It can be fully tested by overriding the `apiClient` and `continuousClock` dependencies with values that are fully controlled and deterministic:

// Create a test clock to control the timing of effects
let clock = TestClock()

let store = TestStore(initialState: Search.State()) {
Search()
} withDependencies: {
// Override the clock dependency with the test clock
$0.continuousClock = clock

// Simulate a search response with one item
$0.apiClient.search = { _ in
["Composable Architecture"]
}
)

// Change the query
await store.send(.searchFieldChanged("c") {
// Assert that state updates accordingly
$0.query = "c"
}

// Advance the clock by enough to get past the debounce
await clock.advance(by: 0.5)

// Assert that the expected response is received
await store.receive(\.searchResponse.success) {
$0.results = ["Composable Architecture"]
}

This test is proving that when the search query changes some search responses are delivered and state updates accordingly.

If we did not assert that the `searchResponse` action was received, we would get the following test failure:

This helpfully lets us know that we have no asserted on everything that happened in the feature, which could be hiding a bug from us.

Or if we had sent another action before handling the effect’s action we would have also gotten a test failure:

All of these types of failures help you prove that you know exactly how your feature evolves as actions are sent into the system. If the library did not produce a test failure in these situations it could be hiding subtle bugs in your code. For example, when the user clears the search query you probably expect that the results are cleared and no search request is executed since there is no query. This can be done like so:

await store.send(.queryChanged("")) {
$0.query = ""
$0.results = []
}

// No need to perform `store.receive` since we do not expect a search
// effect to execute.

But, if in the future a bug is introduced causing a search request to be executed even when the query is empty, you will get a test failure because a new effect is being created that is not being asserted on. This is the power of exhaustive testing.

## Non-exhaustive testing

While exhaustive testing can be powerful, it can also be a nuisance, especially when testing how many features integrate together. This is why sometimes you may want to selectively test in a non-exhaustive style.

Test stores are exhaustive by default, which means you must assert on every state change, and how ever effect feeds data back into the system, and you must make sure that all effects complete before the test is finished. To turn off exhaustivity you can set `exhaustivity` to `off`. When that is done the `TestStore`’s behavior changes:

- The trailing closures of `send(_:assert:fileID:file:line:column:)-8f2pl` and `receive(_:timeout:assert:fileID:file:line:column:)-8zqxk` no longer need to assert on all state changes. They can assert on any subset of changes, and only if they make an incorrect mutation will a test failure be reported.

- The `send(_:assert:fileID:file:line:column:)-8f2pl` and `receive(_:timeout:assert:fileID:file:line:column:)-8zqxk` methods are allowed to be called even when actions have been received from effects that have not been asserted on yet. Any pending actions will be cleared.

- Tests are allowed to finish with unasserted, received actions and in-flight effects. No test failures will be reported.

Non-exhaustive stores can be configured to report skipped assertions by configuring `Exhaustivity.off(showSkippedAssertions:)`. When set to `true` the test store will have the added behavior that any unasserted change causes a grey, informational box to appear next to each assertion detailing the changes that were not asserted against. This allows you to see what information you are choosing to ignore without causing a test failure. It can be useful in tracking down bugs that happen in production but that aren’t currently detected in tests.

This style of testing is most useful for testing the integration of multiple features where you want to focus on just a certain slice of the behavior. Exhaustive testing can still be important to use for leaf node features, where you truly do want to assert on everything happening inside the feature.

For example, suppose you have a tab-based application where the 3rd tab is a login screen. The user can fill in some data on the screen, then tap the “Submit” button, and then a series of events happens to log the user in. Once the user is logged in, the 3rd tab switches from a login screen to a profile screen, _and_ the selected tab switches to the first tab, which is an activity screen.

When writing tests for the login feature we will want to do that in the exhaustive style so that we can prove exactly how the feature would behave in production. But, suppose we wanted to write an integration test that proves after the user taps the “Login” button that ultimately the selected tab switches to the first tab.

In order to test such a complex flow we must test the integration of multiple features, which means dealing with complex, nested state and effects. We can emulate this flow in a test by sending actions that mimic the user logging in, and then eventually assert that the selected tab switched to activity:

let store = TestStore(initialState: App.State()) {
App()
}

// 1️⃣ Emulate user tapping on submit button.
// (You can use case key path syntax to send actions to deeply nested features.)
await store.send(\.login.submitButtonTapped) {
// 2️⃣ Assert how all state changes in the login feature
$0.login?.isLoading = true
…
}

// 3️⃣ Login feature performs API request to login, and
// sends response back into system.
await store.receive(\.login.loginResponse.success) {
// 4️⃣ Assert how all state changes in the login feature
$0.login?.isLoading = false
…
}

// 5️⃣ Login feature sends a delegate action to let parent
// feature know it has successfully logged in.
await store.receive(\.login.delegate.didLogin) {
// 6️⃣ Assert how all of app state changes due to that action.
$0.authenticatedTab = .loggedIn(
Profile.State(...)
)
…
// 7️⃣ *Finally* assert that the selected tab switches to activity.
$0.selectedTab = .activity
}

Doing this with exhaustive testing is verbose, and there are a few problems with this:

- We need to be intimately knowledgeable in how the login feature works so that we can assert on how its state changes and how its effects feed data back into the system.

- If the login feature were to change its logic we may get test failures here even though the logic we are actually trying to test doesn’t really care about those changes.

- This test is very long, and so if there are other similar but slightly different flows we want to test we will be tempted to copy-and-paste the whole thing, leading to lots of duplicated, fragile tests.

Non-exhaustive testing allows us to test the high-level flow that we are concerned with, that of login causing the selected tab to switch to activity, without having to worry about what is happening inside the login feature. To do this, we can turn off `exhaustivity` in the test store, and then just assert on what we are interested in:

let store = TestStore(App.State()) {
App()
}
store.exhaustivity = .off // ⬅️

await store.send(\.login.submitButtonTapped)
await store.receive(\.login.delegate.didLogin) {
$0.selectedTab = .activity
}

In particular, we did not assert on how the login’s state changed or how the login’s effects fed data back into the system. We just assert that when the “Submit” button is tapped that eventually we get the `didLogin` delegate action and that causes the selected tab to flip to activity. Now the login feature is free to make any change it wants to make without affecting this integration test.

Using `off` for `exhaustivity` causes all un-asserted changes to pass without any notification. If you would like to see what test failures are being suppressed without actually causing a failure, you can use `Exhaustivity.off(showSkippedAssertions:)`:

let store = TestStore(initialState: App.State()) {
App()
}
store.exhaustivity = .off(showSkippedAssertions: true) // ⬅️

await store.send(\.login.submitButtonTapped)
await store.receive(\.login.delegate.didLogin) {
$0.selectedTab = .profile
}

When this is run you will get grey, informational boxes on each assertion where some change wasn’t fully asserted on:

The test still passes, and none of these notifications are test failures. They just let you know what things you are not explicitly asserting against, and can be useful to see when tracking down bugs that happen in production but that aren’t currently detected in tests.

## Topics

### Creating a test store

Creates a test store with an initial state and a reducer powering its runtime.

`typealias TestStoreOf`

A convenience type alias for referring to a test store of a given reducer’s domain.

### Configuring a test store

`var dependencies: DependencyValues`

The current dependencies of the test store.

`var exhaustivity: Exhaustivity`

The current exhaustivity level of the test store.

`var timeout: UInt64`

The default timeout used in all methods that take an optional timeout.

`var useMainSerialExecutor: Bool`

Serializes all async work to the main thread for the lifetime of the test store.

### Testing a reducer

Sends an action to the store and asserts when state changes.

Assert against the current state of the store.

`func finish(timeout: Duration, fileID: StaticString, file: StaticString, line: UInt, column: UInt) async`

Suspends until all in-flight effects have finished, or until it times out.

`var isDismissed: Bool`

Returns `true` if the store’s feature has been dismissed.

`struct TestStoreTask`

The type returned from `TestStore/send(_:assert:fileID:file:line:column:)-8f2pl` that represents the lifecycle of the effect started from sending an action.

### Skipping actions and effects

`func skipReceivedActions(strict: Bool, fileID: StaticString, file: StaticString, line: UInt, column: UInt) async`

Clears the queue of received actions from effects.

`func skipInFlightEffects(strict: Bool, fileID: StaticString, file: StaticString, line: UInt, column: UInt) async`

Cancels any currently in-flight effects.

### Accessing state

While the most common way of interacting with a test store’s state is via its `send(_:assert:fileID:file:line:column:)-8f2pl` and `receive(_:timeout:assert:fileID:file:line:column:)-53wic` methods, you may also access it directly throughout a test.

`var state: State`

The current state of the test store.

### Supporting types

### Deprecations

Review unsupported test store APIs and their replacements.

### Instance Methods

Returns a binding view store for this store.

Asserts an action was received matching a case path with a specific payload, and asserts how the state changes.

Asserts an action was received from an effect and asserts how the state changes.

Asserts an action was received matching a case path and asserts how the state changes.

Asserts an action was received from an effect that matches a predicate, and asserts how the state changes.

## Relationships

### Conforms To

- `Swift.Sendable`

## See Also

### Testing

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

- TestStore
- Overview
- Exhaustive testing
- Non-exhaustive testing
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftconcurrency

- ComposableArchitecture
- Adopting Swift concurrency

Article

# Adopting Swift concurrency

Learn how to write safe, concurrent effects using Swift’s structured concurrency.

## Overview

As of version 5.6, Swift can provide many warnings for situations in which you might be using types and functions that are not thread-safe in concurrent contexts. Many of these warnings can be ignored for the time being, but in Swift 6 most (if not all) of these warnings will become errors, and so you will need to know how to prove to the compiler that your types are safe to use concurrently.

There primary way to create an `Effect` in the library is via `run(priority:operation:catch:fileID:filePath:line:column:)`. It takes a `@Sendable`, asynchronous closure, which restricts the types of closures you can use for your effects. In particular, the closure can only capture `Sendable` variables that are bound with `let`. Mutable variables and non- `Sendable` types are simply not allowed to be passed to `@Sendable` closures.

There are two primary ways you will run into this restriction when building a feature in the Composable Architecture: accessing state from within an effect, and accessing a dependency from within an effect.

### Accessing state in an effect

Reducers are executed with a mutable, `inout` state variable, and such variables cannot be accessed from within `@Sendable` closures:

@Reducer
struct Feature {
@ObservableState
struct State { /* ... */ }
enum Action { /* ... */ }

Reduce { state, action in
switch action {
case .buttonTapped:
return .run { send in
try await Task.sleep(for: .seconds(1))
await send(.delayed(state.count))
// 🛑 Mutable capture of 'inout' parameter 'state' is
// not allowed in concurrently-executing code
}

// ...
}
}
}
}

To work around this you must explicitly capture the state as an immutable value for the scope of the closure:

return .run { [state] send in
try await Task.sleep(for: .seconds(1))
await send(.delayed(state.count)) // ✅
}

You can also capture just the minimal parts of the state you need for the effect by binding a new variable name for the capture:

return .run { [count = state.count] send in
try await Task.sleep(for: .seconds(1))
await send(.delayed(count)) // ✅
}

### Accessing dependencies in an effect

In the Composable Architecture, one provides dependencies to a reducer so that it can interact with the outside world in a deterministic and controlled manner. Those dependencies can be used from asynchronous and concurrent contexts, and so must be `Sendable`.

If your dependency is not sendable, you will be notified at the time of registering it with the library. In particular, when extending `DependencyValues` to provide the computed property:

extension DependencyValues {
var factClient: FactClient {
get { self[FactClient.self] }
set { self[FactClient.self] = newValue }
}
}

If `FactClient` is not `Sendable`, for whatever reason, you will get a warning in the `get` and `set` lines:

⚠️ Type 'FactClient' does not conform to the 'Sendable' protocol

To fix this you need to make each dependency `Sendable`. This usually just means making sure that the interface type only holds onto `Sendable` data, and in particular, any closure-based endpoints should be annotated as `@Sendable`:

struct FactClient {

}

This will restrict the kinds of closures that can be used when constructing `FactClient` values, thus making the entire `FactClient` sendable itself.

## See Also

### Integrations

Integrating the Composable Architecture into a SwiftUI application.

Observation backport

Learn how the Observation framework from Swift 5.9 was backported to support iOS 16 and earlier, as well as the caveats of using the backported tools.

Integrating the Composable Architecture into a UIKit application.

- Adopting Swift concurrency
- Overview
- Accessing state in an effect
- Accessing dependencies in an effect
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftuiintegration

- ComposableArchitecture
- SwiftUI Integration

API Collection

# SwiftUI Integration

Integrating the Composable Architecture into a SwiftUI application.

## Overview

The Composable Architecture can be used to power applications built in many frameworks, but it was designed with SwiftUI in mind, and comes with many powerful tools to integrate into your SwiftUI applications.

## Topics

### Alerts and dialogs

`protocol _EphemeralState`

Loosely represents features that are only briefly shown and the first time they are interacted with they are dismissed. Such features do not manage any behavior on the inside.

### Navigation stacks and links

`init<State, Action, Destination, R>(path: Binding<Store<StackState<State>, StackAction<State, Action>>>, root: () -> R, destination: (Store<State, Action>) -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt)`

Drives a navigation stack with a store.

Creates a navigation link that presents the view corresponding to an element of `StackState`.

### Bindings

Working with SwiftUI bindings

Learn how to connect features written in the Composable Architecture to SwiftUI bindings.

`protocol BindableAction`

An action type that exposes a `binding` case that holds a `BindingAction`.

`struct BindingAction`

An action that describes simple mutations to some root state at a writable key path.

`struct BindingReducer`

A reducer that updates bindable state when it receives binding actions.

### Deprecations

Review unsupported SwiftUI APIs and their replacements.

## See Also

### Integrations

Adopting Swift concurrency

Learn how to write safe, concurrent effects using Swift’s structured concurrency.

Observation backport

Learn how the Observation framework from Swift 5.9 was backported to support iOS 16 and earlier, as well as the caveats of using the backported tools.

Integrating the Composable Architecture into a UIKit application.

- SwiftUI Integration
- Overview
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/observationbackport

- ComposableArchitecture
- Observation backport

Article

# Observation backport

Learn how the Observation framework from Swift 5.9 was backported to support iOS 16 and earlier, as well as the caveats of using the backported tools.

## Overview

With version 1.7 of the Composable Architecture we have introduced support for Swift 5.9’s observation tools, _and_ we have backported those tools to work in iOS 13 and later. Using the observation tools in pre-iOS 17 does require a few additional steps and there are some gotchas to be aware of.

## The Perception framework

The Composable Architecture comes with a framework known as Perception, which is our backport of Swift 5.9’s Observation to iOS 13, macOS 12, tvOS 13 and watchOS 6. For all of the tools in the Observation framework there is a corresponding tool in Perception.

For example, instead of the `@Observable` macro, there is the `@Perceptible` macro:

@Perceptible
class CounterModel {
var count = 0
}

However, in order for a view to properly observe changes to a “perceptible” model, you must remember to wrap the contents of your view in the `WithPerceptionTracking` view:

struct CounterView: View {
let model = CounterModel()

var body: some View {
WithPerceptionTracking {
Form {
Text(self.model.count.description)
Button("Decrement") { self.model.count -= 1 }
Button("Increment") { self.model.count += 1 }
}
}
}
}

This will make sure that the view subscribes to any fields accessed in the `@Perceptible` model so that changes to those fields invalidate the view and cause it to re-render.

If a field of a `@Perceptible` model is accessed in a view while _not_ inside `WithPerceptionTracking`, then a runtime warning will be triggered:

To debug this, expand the warning in the Issue Navigator of Xcode (⌘5), and click through the stack frames displayed to find the line in your view where you are accessing state without being inside `WithPerceptionTracking`.

## Bindings

If you want to derive bindings from the store (see Working with SwiftUI bindings for more information), then you would typically use the `@Bindable` property wrapper that comes with SwiftUI:

struct MyView: View {

}

However, `@Bindable` is . So, the Perception library comes with a tool that can be used in its place until you can target iOS 17 and later. You just have to qualify `@Bindable` with the `Perception` namespace:

## Gotchas

There are a few gotchas to be aware of when using `WithPerceptionTracking`.

### Lazy view closures

There are many “lazy” closures in SwiftUI that evaluate only when something happens in the view, and not necessarily in the same stack frames as the `body` of the view. For example, the trailing closure of `ForEach` is called _after_ the `body` of the view has been computed.

This means that even if you wrap the body of the view in `WithPerceptionTracking`:

WithPerceptionTracking {
ForEach(store.scope(state: \.rows, action: \.rows), id: \.state.id) { store in
Text(store.title)
}
}

…the access to the row’s `store.title` happens _outside_ `WithPerceptionTracking`, and hence will not work and will trigger a runtime warning as described above.

The fix for this is to wrap the content of the trailing closure in another `WithPerceptionTracking`:

WithPerceptionTracking {
ForEach(store.scope(state: \.rows, action: \.rows), id: \.state.id) { store in
WithPerceptionTracking {
Text(store.title)
}
}
}

### Mixing legacy and modern features together

Some problems can arise when mixing together features built in the “legacy” style, using `ViewStore` and `WithViewStore`, and features built in the “modern” style, using the `ObservableState()` macro. The problems mostly manifest themselves as re-computing view bodies more often than necessary, but that can also put strain on SwiftUI’s ability to figure out what state changed, and can cause glitches or exacerbate navigation bugs.

See Incrementally migrating for more information about this.

## See Also

### Integrations

Adopting Swift concurrency

Learn how to write safe, concurrent effects using Swift’s structured concurrency.

Integrating the Composable Architecture into a SwiftUI application.

Integrating the Composable Architecture into a UIKit application.

- Observation backport
- Overview
- The Perception framework
- Bindings
- Gotchas
- Lazy view closures
- Mixing legacy and modern features together
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/uikit

- ComposableArchitecture
- UIKit Integration

API Collection

# UIKit Integration

Integrating the Composable Architecture into a UIKit application.

## Overview

While the Composable Architecture was designed with SwiftUI in mind, it comes with tools to integrate into application code written in UIKit.

## Topics

### Combine integration

Calls one of two closures depending on whether a store’s optional state is `nil` or not, and whenever this condition changes for as long as the cancellable lives.

Deprecated

A publisher that emits when state changes.

## See Also

### Integrations

Adopting Swift concurrency

Learn how to write safe, concurrent effects using Swift’s structured concurrency.

Integrating the Composable Architecture into a SwiftUI application.

Observation backport

Learn how the Observation framework from Swift 5.9 was backported to support iOS 16 and earlier, as well as the caveats of using the backported tools.

- UIKit Integration
- Overview
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migrationguides

- ComposableArchitecture
- Migration guides

# Migration guides

Learn how to upgrade your application to the newest version of the Composable Architecture.

## Overview

The Composable Architecture is under constant development, and we are always looking for ways to simplify the library, and make it more powerful. As such, we often need to deprecate certain APIs in favor of newer ones. We recommend people update their code as quickly as possible to the newest APIs, and these guides contain tips to do so.

## Topics

Migrating to 1.19

Store internals have been rewritten for performance and future features, and are now compatible with SwiftUI’s `@StateObject` property wrapper.

Migrating to 1.18

Stores now automatically cancel their in-flight effects when they deallocate. And another UIKit navigation helper has been introduced.

Migrating to 1.17.1

The Sharing library has graduated, with backwards-incompatible changes, to 2.0, and the Composable Architecture has been updated to extend support to this new version.

Migrating to 1.17

The `@Shared` property wrapper and related tools have been extracted to their own library so that they can be used in non-Composable Architecture applications. This a backwards compatible change, but some new deprecations have been introduced.

Migrating to 1.16

The `.appStorage` strategy used with `@Shared` now uses key-value observing instead of `NotificationCenter` when possible. Learn how this may affect your code.

Migrating to 1.15

The library has been completely updated for Swift 6 language mode, and now compiles in strict concurrency with no warnings or errors.

Migrating to 1.14

The `Store` type is now officially `@MainActor` isolated.

Migrating to 1.13

The Composable Architecture now provides first class tools for building features in UIKit, including minimal state observation, presentation and stack navigation.

Migrating to 1.12

Take advantage of custom decoding and encoding logic for the shared file storage persistence strategy, as well as beta support for Swift’s native Testing framework.

Migrating to 1.11

Update your code to use the new `withLock` method for mutating shared state from asynchronous contexts, rather than mutating the underlying wrapped value directly.

Migrating to 1.10

Update your code to make use of the new state sharing tools in the library, such as the `Shared` property wrapper, and the `appStorage` and `fileStorage` persistence strategies.

Migrating to 1.9

Update your code to make use of the new `TestStore/send(_:assert:fileID:file:line:column:)-8877x` method on `TestStore` which gives a succinct syntax for sending actions with case key paths, and the `dependency(_:)` method for overriding dependencies.

Migrating to 1.8

Update your code to make use of the new capabilities of the `Reducer()` macro, including automatic fulfillment of requirements for destination reducers and path reducers.

Migrating to 1.7

Update your code to make use of the new observation tools in the library and get rid of legacy APIs such as `WithViewStore`, `IfLetStore`, `ForEachStore`, and more.

Migrating to 1.6

Update your code to make use of the new `TestStore/receive(_:_:timeout:assert:fileID:file:line:column:)-9jd7x` method when you need to assert on the payload inside an action received.

Migrating to 1.5

Update your code to make use of the new `Store/scope(state:action:)-90255` operation on `Store` in order to improve the performance of your features and simplify the usage of navigation APIs.

Migrating to 1.4

Update your code to make use of the `Reducer()` macro, and learn how to better leverage case key paths in your features.

- Migration guides
- Overview
- Topics

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/appstoragekeypathkey

- ComposableArchitecture
- AppStorageKeyPathKey Deprecated

Structure

# AppStorageKeyPathKey

A type defining a user defaults persistence strategy via key path.

## Overview

See `appStorage(_:)` to create values of this type.

## Topics

## Relationships

### Conforms To

- `Sharing.SharedKey`
- `Sharing.SharedReaderKey`
- `Swift.Copyable`
- `Swift.Equatable`
- `Swift.Hashable`
- `Swift.Sendable`

- AppStorageKeyPathKey
- Overview
- Topics
- Relationships

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/inmemoryfilestorage()

/#app-main)

- ComposableArchitecture
- InMemoryFileStorage() Deprecated

Function

# InMemoryFileStorage()

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/livefilestorage()

/#app-main)

- ComposableArchitecture
- LiveFileStorage() Deprecated

Function

# LiveFileStorage()

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/identifiedaction

- ComposableArchitecture
- IdentifiedAction

Enumeration

# IdentifiedAction

A wrapper type for actions that can be presented in a list.

## Overview

Use this type for modeling a feature’s domain that needs to present child features using `Reducer/forEach(_:action:element:fileID:filePath:line:column:)-6zye8`.

## Topics

### Supporting types

`typealias IdentifiedActionOf`

A convenience type alias for referring to an identified action of a given reducer’s domain.

### Structures

`struct AllCasePaths`

### Enumeration Cases

`case element(id: ID, action: Action)`

An action sent to the element at a given identifier.

## Relationships

### Conforms To

- `CasePathsCore.CasePathable`
- `Swift.Copyable`
- `Swift.Decodable`
- `Swift.Encodable`
- `Swift.Equatable`
- `Swift.Hashable`
- `Swift.Sendable`

- IdentifiedAction
- Overview
- Topics
- Relationships

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/perceptioncore

- ComposableArchitecture
- PerceptionCore

Extended Module

# PerceptionCore

## Topics

### Extended Structures

`extension Bindable`

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/sharing

- ComposableArchitecture
- Sharing

Extended Module

# Sharing

## Topics

### Extended Protocols

`extension SharedReaderKey`

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftnavigation

- ComposableArchitecture
- SwiftNavigation

Extended Module

# SwiftNavigation

## Topics

### Extended Structures

`extension UIBindable`

`extension UIBinding`

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftuicore

- ComposableArchitecture
- SwiftUICore

Extended Module

# SwiftUICore

## Topics

### Extended Protocols

`extension View`

### Extended Structures

`extension Bindable`

`extension Binding`

### Extended Types

`ObservedObject`

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/gettingstarted)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/dependencymanagement)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/testingtca)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/navigation)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/sharingstate)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/performance)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/faq)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/store)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/teststore)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftconcurrency)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftuiintegration)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/observationbackport)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/uikit)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migrationguides)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/appstoragekeypathkey)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/inmemoryfilestorage())

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/livefilestorage())

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/identifiedaction)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/perceptioncore)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/sharing)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftnavigation)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftuicore)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/sharingstate/

- ComposableArchitecture
- Sharing state

Article

# Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

## Overview

Sharing state is the process of letting many features have access to the same data so that when any feature makes a change to this data it is instantly visible to every other feature. Such sharing can be really handy, but also does not play nicely with value types, which are copied rather than shared. Because the Composable Architecture highly prefers modeling domains with value types rather than reference types, sharing state can be tricky.

This is why the library comes with a few tools for sharing state with many parts of your application. The majority of these tools exist outside of the Composable Architecture, and are in a separate library called Sharing. You can refer to that library’s documentation for more information, but we have also repeated some of the most important concepts in this article.

There are two main kinds of shared state in the library: explicitly passed state and persisted state. And there are 3 persistence strategies shipped with the library: in-memory, user defaults, and file storage. You can also implement your own persistence strategy if you want to use something other than user defaults or the file system, such as SQLite.

- “Source of truth”

- Explicit shared state

- Persisted shared state

- In-memory

- User defaults

- File storage

- Custom persistence
- Observing changes to shared state

- Initialization rules

- Deriving shared state

- Concurrent mutations to shared state

- Testing shared state

- Testing when using persistence

- Testing when using custom persistence strategies

- Overriding shared state in tests

- UI Testing

- Testing tips
- Read-only shared state

- Type-safe keys

- Shared state in pre-observation apps

- Gotchas of @Shared

## “Source of truth”

First a quick discussion on defining exactly what “shared state” is. A common concept thrown around in architectural discussions is “single source of truth.” This is the idea that the complete state of an application, even its navigation, can be driven off a single piece of data. It’s a great idea, in theory, but in practice it can be quite difficult to completely embrace.

First of all, a _single_ piece of data to drive _all_ of application state is just not feasible. There is a lot of state in an application that is fine to be local to a view and does not need global representation. For example, the state of whether a button is being pressed is probably fine to reside privately inside the button.

And second, applications typically do not have a _single_ source of truth. That is far too simplistic. If your application loads data from an API, or from disk, or from user defaults, then the “truth” for that data does not lie in your application. It lies externally.

In reality, there are _two_ sources of “truth” in any application:

1. There is the state the application needs to execute its logic and behavior. This is the kind of state that determines if a button is enabled or disabled, drives navigation such as sheets and drill-downs, and handles validation of forms. Such state only makes sense for the application.

2. Then there is a second source of “truth” in an application, which is the data that lies in some external system and needs to be loaded into the application. Such state is best modeled as a dependency or using the shared state tools discussed in this article.

## Explicit shared state

This is the simplest kind of shared state to get started with. It allows you to share state amongst many features without any persistence. The data is only held in memory, and will be cleared out the next time the application is run.

To share data in this style, use the `@Shared` property wrapper with no arguments. For example, suppose you have a feature that holds a count and you want to be able to hand a shared reference to that count to other features. You can do so by holding onto a `@Shared` property in the feature’s state:

@Reducer
struct ParentFeature {
@ObservableState
struct State {
@Shared var count: Int
// Other properties
}
// ...
}

Then suppose that this feature can present a child feature that wants access to this shared `count` value. It too would hold onto a `@Shared` property to a count:

@Reducer
struct ChildFeature {
@ObservableState
struct State {
@Shared var count: Int
// Other properties
}
// ...
}

When the parent features creates the child feature’s state, it can pass a _reference_ to the shared count rather than the actual count value by using the `$count` projected value:

case .presentButtonTapped:
state.child = ChildFeature.State(count: state.$count)
// ...

Now any mutation the `ChildFeature` makes to its `count` will be instantly made to the `ParentFeature`’s count too.

## Persisted shared state

Explicitly shared state discussed above is a nice, lightweight way to share a piece of data with many parts of your application. However, sometimes you want to share state with the entire application without having to pass it around explicitly. One can do this by passing a `SharedKey` to the `@Shared` property wrapper, and the library comes with three persistence strategies, as well as the ability to create custom persistence strategies.

#### In-memory

This is the simplest persistence strategy in that it doesn’t actually persist at all. It keeps the data in memory and makes it available to every part of the application, but when the app is relaunched the data will be reset

If you would like to persist your shared value across application launches, then you can use the `appStorage` strategy with `@Shared` in order to automatically persist any changes to the value to user defaults. It works similarly to in-memory sharing discussed above. It requires a key to store the value in user defaults, as well as a default value that will be used when there is no value in the user defaults:

@Shared(.appStorage("count")) var count = 0

That small change will guarantee that all changes to `count` are persisted and will be automatically loaded the next time the application launches.

This form of persistence only works for simple data types because that is what works best with `UserDefaults`. This includes strings, booleans, integers, doubles, URLs, data, and more. If you need to store more complex data, such as custom data types serialized to JSON, then you will want to use the `.fileStorage` strategy or a custom persistence strategy.

#### File storage

If you would like to persist your shared value across application launches, and your value is complex (such as a custom data type), then you can use the `fileStorage` strategy with `@Shared`. It automatically persists any changes to the file system.

It works similarly to the in-memory sharing discussed above, but it requires a URL to store the data on disk, as well as a default value that will be used when there is no data in the file system:

@Shared(.fileStorage(URL(/* ... */)) var users: [User] = []

This strategy works by serializing your value to JSON to save to disk, and then deserializing JSON when loading from disk. For this reason the value held in `@Shared(.fileStorage(…))` must conform to `Codable`.

#### Custom persistence

It is possible to define all new persistence strategies for the times that user defaults or JSON files are not sufficient. To do so, define a type that conforms to the `SharedKey` protocol:

public final class CustomSharedKey: SharedKey {
// ...
}

And then define a static function on the `SharedKey` protocol for creating your new persistence strategy:

extension SharedReaderKey {

CustomPersistence(/* ... */)
}
}

With those steps done you can make use of the strategy in the same way one does for `appStorage` and `fileStorage`:

@Shared(.custom(/* ... */)) var myValue: Value

The `SharedKey` protocol represents loading from _and_ saving to some external storage, such as the file system or user defaults. Sometimes saving is not a valid operation for the external system, such as if your server holds onto a remote configuration file that your app uses to customize its appearance or behavior. In those situations you can conform to the `SharedReaderKey` protocol. See Read-only shared state for more information.

## Observing changes to shared state

The `@Shared` property wrapper exposes a `publisher` property so that you can observe changes to the reference from any part of your application. For example, if some feature in your app wants to listen for changes to some shared `count` value, then it can introduce an `onAppear` action that kicks off a long-living effect that subscribes to changes of `count`:

case .onAppear:
return .publisher {
state.$count.publisher
.map(Action.countUpdated)
}

case .countUpdated(let count):
// Do something with count
return .none

Note that you will have to be careful for features that both hold onto shared state and subscribe to changes to that state. It is possible to introduce an infinite loop if you do something like this:

case .countUpdated(let count):
state.count = count + 1
return .none

If `count` changes, then `$count.publisher` emits, causing the `countUpdated` action to be sent, causing the shared `count` to be mutated, causing `$count.publisher` to emit, and so on.

## Initialization rules

Because the state sharing tools use property wrappers there are special rules that must be followed when writing custom initializers for your types. These rules apply to _any_ kind of property wrapper, including those that ship with vanilla SwiftUI (e.g. `@State`, `@StateObject`, etc.), but the rules can be quite confusing and so below we describe the various ways to initialize shared state.

It is common to need to provide a custom initializer to your feature’s `State` type, especially when modularizing. When using `@Shared` in your `State` that can become complicated. Depending on your exact situation you can do one of the following:

- You are using non-persisted shared state (i.e. no argument is passed to `@Shared`), and the “source of truth” of the state lives with the parent feature. Then the initializer should take a `Shared` value and you can assign through the underscored property:

public struct State {
@Shared public var count: Int
// other fields

self._count = count
// other assignments
}
}

- You are using non-persisted shared state ( _i.e._ no argument is passed to `@Shared`), and the “source of truth” of the state lives within the feature you are initializing. Then the initializer should take a plain, non- `Shared` value and you construct the `Shared` value in the initializer:

public init(count: Int, /* other fields */) {
self._count = Shared(count)
// other assignments
}
}

- You are using a persistence strategy with shared state ( _e.g._ `appStorage`, `fileStorage`, _etc._), then the initializer should take a plain, non- `Shared` value and you construct the `Shared` value in the initializer using the initializer which takes a `SharedKey` as the second argument:

public init(count: Int, /* other fields */) {
self._count = Shared(wrappedValue: count, .appStorage("count"))
// other assignments
}
}

The declaration of `count` can use `@Shared` without an argument because the persistence strategy is specified in the initializer.

## Deriving shared state

@Reducer
struct PhoneNumberFeature {
struct State {
@Shared var phoneNumber: String
}
// ...
}

case .nextButtonTapped:
state.path.append(
PhoneNumberFeature.State(phoneNumber: state.$signUpData.phoneNumber)
)

It can be instructive to think of `@Shared` as the Composable Architecture analogue of `@Bindable` in vanilla SwiftUI. You use it to express that the actual “source of truth” of the value lies elsewhere, but you want to be able to read its most current value and write to it.

This also works for persistence strategies. If a parent feature holds onto a `@Shared` piece of state with a persistence strategy:

@Reducer
struct ParentFeature {
struct State {
@Shared(.fileStorage(.currentUser)) var currentUser
}
// ...
}

…and a child feature wants access to just a shared _piece_ of `currentUser`, such as their name, then they can do so by holding onto a simple, unadorned `@Shared`:

@Reducer
struct ChildFeature {
struct State {
@Shared var currentUserName: String
}
// ...
}

And then the parent can pass along `$currentUser.name` to the child feature when constructing its state:

case .editNameButtonTapped:
state.destination = .editName(
EditNameFeature(name: state.$currentUser.name)
)

Any changes the child feature makes to its shared `name` will be automatically made to the parent’s shared `currentUser`, and further those changes will be automatically persisted thanks to the `.fileStorage` persistence strategy used. This means the child feature gets to describe that it needs access to shared state without describing the persistence strategy, and the parent can be responsible for persisting and deriving shared state to pass to the child.

If your shared state is a collection, and in particular an `IdentifiedArray`, then we have another tool for deriving shared state to a particular element of the array. You can subscript into a `Shared` collection with the `[id:]` subscript, and that will give a piece of shared optional state, which you can then unwrap to turn into honest shared state using a special `Shared` initializer:

guard let todo = Shared($todos[id: todoID])
else { return }

## Concurrent mutations to shared state

While the `@Shared` property wrapper makes it possible to treat shared state _mostly_ like regular state, you do have to perform some extra steps to mutate shared state. This is because shared state is technically a reference deep down, even though we take extra steps to make it appear value-like. And this means it’s possible to mutate the same piece of shared state from multiple threads, and hence race conditions are possible. See Mutating Shared State for a more in-depth explanation.

To mutate a piece of shared state in an isolated fashion, use the `withLock` method defined on the `@Shared` projected value:

state.$count.withLock { $0 += 1 }

That locks the entire unit of work of reading the current count, incrementing it, and storing it back in the reference.

Technically it is still possible to write code that has race conditions, such as this silly example:

let currentCount = state.count
state.$count.withLock { $0 = currentCount + 1 }

But there is no way to 100% prevent race conditions in code. Even actors are susceptible to problems due to re-entrancy. To avoid problems like the above we recommend wrapping as many mutations of the shared state as possible in a single `withLock`. That will make sure that the full unit of work is guarded by a lock.

## Testing shared state

Shared state behaves quite a bit different from the regular state held in Composable Architecture features. It is capable of being changed by any part of the application, not just when an action is sent to the store, and it has reference semantics rather than value semantics. Typically references cause serious problems with testing, especially exhaustive testing that the library prefers (see Testing), because references cannot be copied and so one cannot inspect the changes before and after an action is sent.

For this reason, the `@Shared` property wrapper does extra work during testing to preserve a previous snapshot of the state so that one can still exhaustively assert on shared state, even though it is a reference.

For the most part, shared state can be tested just like any regular state held in your features. For example, consider the following simple counter feature that uses in-memory shared state for the count:

@Reducer
struct Feature {
struct State: Equatable {
@Shared var count: Int
}
enum Action {
case incrementButtonTapped
}

Reduce { state, action in
switch action {
case .incrementButtonTapped:
state.$count.withLock { $0 += 1 }
return .none
}
}
}
}

This feature can be tested in a similar same way as when you are using non-shared state:

@Test
func increment() async {
let store = TestStore(initialState: Feature.State(count: Shared(0))) {
Feature()
}

await store.send(.incrementButtonTapped) {
$0.$count.withLock { $0 = 1 }
}
}

This test passes because we have described how the state changes. But even better, if we mutate the `count` incorrectly:

await store.send(.incrementButtonTapped) {
$0.$count.withLock { $0 = 2 }
}
}

…we immediately get a test failure letting us know exactly what went wrong:

❌ State was not expected to change, but a change occurred: …

− Feature.State(_count: 2)
+ Feature.State(_count: 1)

(Expected: −, Actual: +)

This works even though the `@Shared` count is a reference type. The `TestStore` and `@Shared` type work in unison to snapshot the state before and after the action is sent, allowing us to still assert in an exhaustive manner.

However, exhaustively testing shared state is more complicated than testing non-shared state in features. Shared state can be captured in effects and mutated directly, without ever sending an action into system. This is in stark contrast to regular state, which can only ever be mutated when sending an action.

For example, it is possible to alter the `incrementButtonTapped` action so that it captures the shared state in an effect, and then increments from the effect:

case .incrementButtonTapped:
return .run { [sharedCount = state.$count] _ in
await sharedCount.withLock { $0 += 1 }
}

The only reason this is possible is because `@Shared` state is reference-like, and hence can technically be mutated from anywhere.

However, how does this affect testing? Since the `count` is no longer incremented directly in the reducer we can drop the trailing closure from the test store assertion:

@Test
func increment() async {
let store = TestStore(initialState: SimpleFeature.State(count: Shared(0))) {
SimpleFeature()
}
await store.send(.incrementButtonTapped)
}

This is technically correct, but we aren’t testing the behavior of the effect at all.

Luckily the `TestStore` has our back. If you run this test you will immediately get a failure letting you know that the shared count was mutated but we did not assert on the changes:

− 0
+ 1

(Before: −, After: +)

In order to get this test passing we have to explicitly assert on the shared counter state at the end of the test, which we can do using the `assert(_:fileID:file:line:column:)` method:

@Test
func increment() async {
let store = TestStore(initialState: SimpleFeature.State(count: Shared(0))) {
SimpleFeature()
}
await store.send(.incrementButtonTapped)
store.assert {
$0.$count.withLock { $0 = 1 }
}
}

Now the test passes.

So, even though the `@Shared` type opens our application up to a little bit more uncertainty due to its reference semantics, it is still possible to get exhaustive test coverage on its changes.

#### Testing when using persistence

It is also possible to test when using one of the persistence strategies provided by the library, which are `appStorage` and `fileStorage`. Typically persistence is difficult to test because the persisted data bleeds over from test to test, making it difficult to exhaustively prove how each test behaves in isolation.

But the `.appStorage` and `.fileStorage` strategies do extra work to make sure that happens. By default the `.appStorage` strategy uses a non-persisting user defaults so that changes are not actually persisted across test runs. And the `.fileStorage` strategy uses a mock file system so that changes to state are not actually persisted to the file system.

This means that if we altered the `SimpleFeature` of the Testing shared state section above to use app storage:

struct State: Equatable {
@Shared(.appStorage("count")) var count: Int
}

…then the test for this feature can be written in the same way as before and will still pass.

#### Testing when using custom persistence strategies

When creating your own custom persistence strategies you must careful to do so in a style that is amenable to testing. For example, the `appStorage` persistence strategy that comes with the library injects a `defaultAppStorage` dependency so that one can inject a custom `UserDefaults` in order to execute in a controlled environment. By default `defaultAppStorage` uses a non-persisting user defaults, but you can also customize it to use any kind of defaults.

Similarly the `fileStorage` persistence strategy uses an internal dependency for changing how files are written to the disk and loaded from disk. In tests the dependency will forgo any interaction with the file system and instead write data to a `[URL: Data]` dictionary, and load data from that dictionary. That emulates how the file system works, but without persisting any data to the global file system, which can bleed over into other tests.

#### Overriding shared state in tests

When testing features that use `@Shared` with a persistence strategy you may want to set the initial value of that state for the test. Typically this can be done by declaring the shared state at the beginning of the test so that its default value can be specified:

@Test
func basics() {
@Shared(.appStorage("count")) var count = 42

// Shared state will be 42 for all features using it.
let store = TestStore(…)
}

However, if your test suite is a part of an app target, then the entry point of the app will execute and potentially cause an early access of `@Shared`, thus capturing a different default value than what is specified above. This quirk of tests in app targets is documented in Testing gotchas of the Testing article, and a similar quirk exists for Xcode previews and is discussed below in Gotchas of @Shared.

The most robust workaround to this issue is to simply not execute your app’s entry point when tests are running, which we detail in Testing host application. This makes it so that you are not accidentally execute network requests, tracking analytics, etc. while running tests.

You can also work around this issue by simply setting the shared state again after initializing it:

@Test
func basics() {
@Shared(.appStorage("count")) var count = 42
count = 42 // NB: Set again to override any value set by the app target.

#### UI Testing

When UI testing your app you must take extra care so that shared state is not persisted across app runs because that can cause one test to bleed over into another test, making it difficult to write deterministic tests that always pass. To fix this, you can set an environment value from your UI test target, and then if that value is present in the app target you can override the `defaultAppStorage` and `defaultFileStorage` dependencies so that they use in-memory storage, i.e. they do not persist ever:

@main
struct EntryPoint: App {
let store = Store(initialState: AppFeature.State()) {
AppFeature()
} withDependencies: {
if ProcessInfo.processInfo.environment["UITesting"] == "true" {
$0.defaultAppStorage = UserDefaults(
suiteName:"\(NSTemporaryDirectory())\(UUID().uuidString)"
)!
$0.defaultFileStorage = .inMemory
}
}
}

#### Testing tips

There is something you can do to make testing features with shared state more robust and catch more potential future problems when you refactor your code. Right now suppose you have two features using `@Shared(.appStorage("count"))`:

@Reducer
struct Feature1 {
struct State {
@Shared(.appStorage("count")) var count = 0
}
// ...
}

@Reducer
struct Feature2 {
struct State {
@Shared(.appStorage("count")) var count = 0
}
// ...
}

And suppose you wrote a test that proves one of these counts is incremented when a button is tapped:

await store.send(.feature1(.buttonTapped)) {
$0.feature1.count = 1
}

Because both features are using `@Shared` you can be sure that both counts are kept in sync, and so you do not need to assert on `feature2.count`.

However, if someday during a long, complex refactor you accidentally removed `@Shared` from the second feature:

@Reducer
struct Feature2 {
struct State {
var count = 0
}
// ...
}

…then all of your code would continue compiling, and the test would still pass, but you may have introduced a bug by not having these two pieces of state in sync anymore.

You could also fix this by forcing yourself to assert on all shared state in your features, even though technically it’s not necessary:

await store.send(.feature1(.buttonTapped)) {
$0.feature1.count = 1
$0.feature2.count = 1
}

If you are worried about these kinds of bugs you can make your tests more robust by not asserting on the shared state in the argument handed to the trailing closure of `TestStore`’s `send`, and instead capture a reference to the shared state in the test and mutate it in the trailing closure:

@Test
func increment() async {
@Shared(.appStorage("count")) var count = 0
let store = TestStore(initialState: ParentFeature.State()) {
ParentFeature()
}

await store.send(.feature1(.buttonTapped)) {
// Mutate $0 to expected value.
count = 1
}
}

This will fail if you accidentally remove a `@Shared` from one of your features.

Further, you can enforce this pattern in your codebase by making all `@Shared` properties `fileprivate` so that they can never be mutated outside their file scope:

struct State {
@Shared(.appStorage("count")) fileprivate var count = 0
}

## Read-only shared state

The `@Shared` property wrapper described above gives you access to a piece of shared state that is both readable and writable. That is by far the most common use case when it comes to shared state, but there are times when one wants to express access to shared state for which you are not allowed to write to it, or possibly it doesn’t even make sense to write to it.

For those times there is the `@SharedReader` property wrapper. It represents a reference to some piece of state shared with multiple parts of the application, but you are not allowed to write to it. Every persistence strategy discussed above works with `SharedReader`, however if you try to mutate the state you will get a compiler error:

@SharedReader(.appStorage("isOn")) var isOn = false
isOn = true // 🛑

It is also possible to make custom persistence strategies that only have the notion of loading and subscribing, but cannot write. To do this you will conform only to the `SharedReaderKey` protocol instead of the full `SharedKey` protocol.

For example, you could create a `.remoteConfig` strategy that loads (and subscribes to) a remote configuration file held on your server so that it is kept automatically in sync:

@SharedReader(.remoteConfig) var remoteConfig

## Type-safe keys

Due to the nature of persisting data to external systems, you lose some type safety when shuffling data from your app to the persistence storage and back. For example, if you are using the `fileStorage` strategy to save an array of users to disk you might do so like this:

extension URL {
static let users = URL(/* ... */))
}

@Shared(.fileStorage(.users)) var users: [User] = []

And say you have used this file storage users in multiple places throughout your application.

But then, someday in the future you may decide to refactor this data to be an identified array instead of a plain array:

// Somewhere else in the application

But if you forget to convert _all_ shared user arrays to the new identified array your application will still compile, but it will be broken. The two types of storage will not share state.

To add some type-safety and reusability to this process you can extend the `SharedReaderKey` protocol to add a static variable for describing the details of your persistence:

extension SharedReaderKey where Self == FileStorageKey<IdentifiedArrayOf<User>> {
static var users: Self {
fileStorage(.users)
}
}

Then when using `@Shared` you can specify this key directly without `.fileStorage`:

And now that the type is baked into the key you cannot accidentally use the wrong type because you will get an immediate compiler error:

@Shared(.users) var users = User

This technique works for all types of persistence strategies. For example, a type-safe `.inMemory` key can be constructed like so:

extension SharedReaderKey where Self == InMemoryKey<IdentifiedArrayOf<User>> {
static var users: Self {
inMemory("users")
}
}

And a type-safe `.appStorage` key can be constructed like so:

static var count: Self {
appStorage("count")
}
}

And this technique also works on custom persistence strategies.

Further, you can also bake in the default of the shared value into your key by doing the following:

extension SharedReaderKey where Self == FileStorageKey<IdentifiedArrayOf<User>>.Default {
static var users: Self {
Self[.fileStorage(.users), default: []]
}
}

And now anytime you reference the shared users state you can leave off the default value, and you can even leave off the type annotation:

@Shared(.users) var users

## Shared state in pre-observation apps

It is possible to use `@Shared` in features that have not yet been updated with the observation tools released in 1.7, such as the `ObservableState()` macro. In the reducer you can use `@Shared` regardless of your use of the observation tools.

However, if you are deploying to iOS 16 or earlier, then you must use `WithPerceptionTracking` in your views if you are accessing shared state. For example, the following view:

struct FeatureView: View {

Form {
Text(store.sharedCount.description)
}
}
}

…will not update properly when `sharedCount` changes. This view will even generate a runtime warning letting you know something is wrong:

The fix is to wrap the body of the view in `WithPerceptionTracking`:

WithPerceptionTracking {
Form {
Text(store.sharedCount.description)
}
}
}
}

## Gotchas of @Shared

There are a few gotchas to be aware of when using shared state in the Composable Architecture.

#### Hashability

Because the `@Shared` type is equatable based on its wrapped value, and because the value is held in a reference and can change over time, it cannot be hashable. This also means that types containing `@Shared` properties should not compute their hashes from shared values.

#### Codability

The `@Shared` type is not conditionally encodable or decodable because the source of truth of the wrapped value is rarely local: it might be derived from some other shared value, or it might rely on loading the value from a backing persistence strategy.

When introducing shared state to a data type that is encodable or decodable, you must provide your own implementations of `encode(to:)` and `init(from:)` that do the appropriate thing.

For example, if the data type is sharing state with a persistence strategy, you can decode by delegating to the memberwise initializer that implicitly loads the shared value from the property wrapper’s persistence strategy, or you can explicitly initialize a shared value. And for encoding you can often skip encoding the shared value:

struct AppState {
@Shared(.appStorage("launchCount")) var launchCount = 0
var todos: [String] = []
}

extension AppState: Codable {
enum CodingKeys: String, CodingKey { case todos }

init(from decoder: any Decoder) throws {
let container = try decoder.container(keyedBy: CodingKeys.self)

// Use the property wrapper default via the memberwise initializer:
try self.init(
todos: container.decode([String].self, forKey: .todos)
)

// Or initialize the shared storage manually:
self._launchCount = Shared(wrappedValue: 0, .appStorage("launchCount"))
self.todos = try container.decode([String].self, forKey: .todos)
}

func encode(to encoder: any Encoder) throws {
var container = encoder.container(keyedBy: CodingKeys.self)
try container.encode(self.todos, forKey: .todos)
// Skip encoding the launch count.
}
}

#### Tests

While shared properties are compatible with the Composable Architecture’s testing tools, assertions may not correspond directly to a particular action when several actions are received by effects.

Take this simple example, in which a `tap` action kicks off an effect that returns a `response`, which finally mutates some shared state:

@Reducer
struct Feature {
struct State: Equatable {
@Shared(value: false) var bool
}
enum Action {
case tap
case response
}

Reduce { state, action in
switch action {
case .tap:
return .run { send in
await send(.response)
}
case .response:
state.$bool.withLock { $0.toggle() }
return .none
}
}
}
}

We would expect to assert against this mutation when the test store receives the `response` action, but this will fail:

// ❌ State was not expected to change, but a change occurred: …
//
// Feature.State(
// - _shared: #1 false
// + _shared: #1 true
//   )
//
// (Expected: −, Actual: +)
await store.send(.tap)

// ❌ Expected state to change, but no change occurred.
await store.receive(.response) {
$0.$shared.withLock { $0 = true }
}

This is due to an implementation detail of the `TestStore` that predates `@Shared`, in which the test store eagerly processes all actions received _before_ you have asserted on them. As such, you must always assert against shared state mutations in the first action:

await store.send(.tap) { // ✅
$0.$shared.withLock { $0 = true }
}

// ❌ Expected state to change, but no change occurred.
await store.receive(.response) // ✅

In a future major version of the Composable Architecture, we will be able to introduce a breaking change that allows you to assert against shared state mutations in the action that performed the mutation.

## See Also

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

- Sharing state
- Overview
- “Source of truth”
- Explicit shared state
- Persisted shared state
- Observing changes to shared state
- Initialization rules
- Deriving shared state
- Concurrent mutations to shared state
- Testing shared state
- Read-only shared state
- Type-safe keys
- Shared state in pre-observation apps
- Gotchas of @Shared
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/state

- ComposableArchitecture
- Reducer
- State

Associated Type

# State

A type that holds the current state of the reducer.

associatedtype State

**Required**

## Topics

### Observing state

`macro ObservableState()`

Defines and implements conformance of the Observable protocol.

## See Also

### Implementing a reducer

`macro Reducer()`

Helps implement the conformance to the `Reducer` protocol for a type.

`associatedtype Action`

A type that holds all possible actions that cause the `State` of the reducer to change and/or kick off a side `Effect` that can communicate with the outside world.

`var body: Self.Body`

The content and behavior of a reducer that is composed from other reducers.

**Required** Default implementations provided.

`struct Reduce`

A type-erased reducer that invokes the given `reduce` function.

`struct Effect`

- State
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/teststore/assert(_:fileid:file:line:column:)

/#app-main)

- ComposableArchitecture
- TestStore
- assert(\_:fileID:file:line:column:)

Instance Method

# assert(\_:fileID:file:line:column:)

Assert against the current state of the store.

@MainActor
func assert(

fileID: StaticString = #fileID,
file filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column
)

Available when `State` conforms to `Equatable`.

## Parameters

`updateStateToExpectedResult`

A closure that asserts against the current state of the test store.

`fileID`

The fileID.

`filePath`

The filePath.

`line`

The line.

`column`

The column.

## Discussion

The trailing closure provided is given a mutable argument that represents the current state, and you can provide any mutations you want to the state. If your mutations cause the argument to differ from the current state of the test store, a test failure will be triggered.

This tool is most useful in non-exhaustive test stores (see Non-exhaustive testing), which allow you to assert on a subset of the things happening inside your features. For example, you can send an action in a child feature without asserting on how many changes in the system, and then tell the test store to `finish(timeout:fileID:file:line:column:)` by executing all of its effects, and finally to `skipReceivedActions(strict:fileID:file:line:column:)` to receive all actions. After that is done you can assert on the final state of the store:

store.exhaustivity = .off
await store.send(\.child.closeButtonTapped)
await store.finish()
await store.skipReceivedActions()
store.assert {
$0.child = nil
}

## See Also

### Testing a reducer

Sends an action to the store and asserts when state changes.

`func finish(timeout: Duration, fileID: StaticString, file: StaticString, line: UInt, column: UInt) async`

Suspends until all in-flight effects have finished, or until it times out.

`var isDismissed: Bool`

Returns `true` if the store’s feature has been dismissed.

`struct TestStoreTask`

The type returned from `TestStore/send(_:assert:fileID:file:line:column:)-8f2pl` that represents the lifecycle of the effect started from sending an action.

- assert(\_:fileID:file:line:column:)
- Parameters
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/User

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/observablestate()

/#app-main)

- ComposableArchitecture
- Reducer
- State
- ObservableState()

Macro

# ObservableState()

Defines and implements conformance of the Observable protocol.

@attached(extension, conformances: Observable, ObservableState) @attached(member, names: named(_$id), named(_$observationRegistrar), named(_$willModify)) @attached(memberAttribute)
macro ObservableState()

## Topics

### Conformance

`protocol ObservableState`

### Change tracking

`struct ObservableStateID`

A unique identifier for a observed value.

`struct ObservationStateRegistrar`

Provides storage for tracking and access to data changes.

### Supporting macros

`macro ObservationStateTracked()`

`macro ObservationStateIgnored()`

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/state)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/testingtca)),

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/teststore/assert(_:fileid:file:line:column:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/teststore)%E2%80%99s

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/observablestate())

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/dependencymanagement/

- ComposableArchitecture
- Dependencies

Article

# Dependencies

Learn how to register dependencies with the library so that they can be immediately accessible from any reducer.

## Overview

Dependencies in an application are the types and functions that need to interact with outside systems that you do not control. Classic examples of this are API clients that make network requests to servers, but also seemingly innocuous things such as `UUID` and `Date` initializers, and even clocks, can be thought of as dependencies.

By controlling the dependencies our features need to do their job we gain the ability to completely alter the execution context a feature runs in. This means in tests and Xcode previews you can provide a mock version of an API client that immediately returns some stubbed data rather than making a live network request to a server.

## Overriding dependencies

It is possible to change the dependencies for just one particular reducer inside a larger composed reducer. This can be handy when running a feature in a more controlled environment where it may not be appropriate to communicate with the outside world.

For example, suppose you want to teach users how to use your feature through an onboarding experience. In such an experience it may not be appropriate for the user’s actions to cause data to be written to disk, or user defaults to be written, or any number of things. It would be better to use mock versions of those dependencies so that the user can interact with your feature in a fully controlled environment.

To do this you can use the `dependency(_:_:)` method to override a reducer’s dependency with another value:

@Reducer
struct Onboarding {

Reduce { state, action in
// Additional onboarding logic
}
Feature()
.dependency(\.userDefaults, .mock)
.dependency(\.database, .mock)
}
}

This will cause the `Feature` reducer to use a mock user defaults and database dependency, as well as any reducer `Feature` uses under the hood, _and_ any effects produced by `Feature`.

## See Also

### Essentials

Getting started

Learn how to integrate the Composable Architecture into your project and write your first application.

Testing

Learn how to write comprehensive and exhaustive tests for your features built in the Composable Architecture.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

Performance

Learn how to improve the performance of features built in the Composable Architecture.

Frequently asked questions

A collection of some of the most common questions and comments people have concerning the library.

- Dependencies
- Overview
- Overriding dependencies
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/dependency(_:_:)

/#app-main)

- ComposableArchitecture
- Reducer
- dependency(\_:\_:)

Instance Method

# dependency(\_:\_:)

Sets the dependency value of the specified key path to the given value.

@warn_unqualified_access

_ value: Value

## Parameters

`keyPath`

A key path that indicates the property of the `DependencyValues` structure to update.

`value`

The new value to set for the item specified by `keyPath`.

## Return Value

A reducer that has the given value set in its dependencies.

## Discussion

This overrides the dependency specified by `keyPath` for the execution of the receiving reducer _and_ all of its effects. It can be useful for altering the dependencies for just one portion of your application, while letting the rest of the application continue using the default live dependencies.

For example, suppose you are creating an onboarding experience to teach people how to use one of your features. This can be done by constructing a new reducer that embeds the core feature’s domain and layers on additional logic:

@Reducer
struct Onboarding {
struct State {
var feature: Feature.State
// Additional onboarding state
}
enum Action {
case feature(Feature.Action)
// Additional onboarding actions
}

Scope(state: \.feature, action: \.feature) {
Feature()
}

Reduce { state, action in
// Additional onboarding logic
}
}
}

This can work just fine, but the `Feature` reducer will have access to all of the live dependencies by default, and that might not be ideal. For example, the `Feature` reducer may need to make API requests and read/write from user defaults. It may be preferable to run the `Feature` reducer in an alternative environment for onboarding purposes, such as an API client that returns some mock data or an in-memory user defaults so that the onboarding experience doesn’t accidentally trample on shared data.

This can be by using the `dependency(_:_:)` method to override those dependencies just for the `Feature` reducer and its effects:

Scope(state: \.feature, action: \.feature) {
Feature()
.dependency(\.apiClient, .mock)
.dependency(\.userDefaults, .mock)
}

Reduce { state, action in
// Additional onboarding logic
}
}

See `transformDependency(_:transform:)` for a similar method that can inspect and modify the current dependency when overriding.

## See Also

### Reducer modifiers

Transform a reducer’s dependency value at the specified key path with the given function.

Adds a reducer to run when this reducer changes the given value in state.

Instruments a reducer with signposts.

Enhances a reducer with debug logging of received actions and state mutations for the given printer.

- dependency(\_:\_:)
- Parameters
- Return Value
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/dependency(_:_:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/

- ComposableArchitecture
- Reducer

Protocol

# Reducer

A protocol that describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any.

## Overview

The `Reducer` protocol describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any. Types that conform to this protocol represent the domain, logic and behavior for a feature. Conformances to `Reducer` can be written by hand, but the `Reducer()` can make your reducers more concise and more powerful.

- Conforming to the Reducer protocol

- Using the @Reducer macro

- @CasePathable and @dynamicMemberLookup enums

- Automatic fulfillment of reducer requirements

- Destination and path reducers

- Navigating to non-reducer features

- Synthesizing protocol conformances on State and Action

- Nested enum reducers
- Gotchas

- Autocomplete

- #Preview and enum reducers

- CI build failures

## Conforming to the Reducer protocol

The bare minimum of conforming to the `Reducer` protocol is to provide a `State` type that represents the state your feature needs to do its job, a `Action` type that represents the actions users can perform in your feature (as well as actions that effects can feed back into the system), and a `body` property that compose your feature together with any other features that are needed (such as for navigation).

As a very simple example, a “counter” feature could model its state as a struct holding an integer:

struct CounterFeature: Reducer {
@ObservableState
struct State {
var count = 0
}
}

The actions would be just two cases for tapping an increment or decrement button:

struct CounterFeature: Reducer {
// ...
enum Action {
case decrementButtonTapped
case incrementButtonTapped
}
}

The logic of your feature is implemented by mutating the feature’s current state when an action comes into the system. This is most easily done by constructing a `Reduce` inside the `body` of your reducer:

struct CounterFeature: Reducer {
// ...

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none
case .incrementButtonTapped:
state.count += 1
return .none
}
}
}
}

The `Reduce` reducer’s first responsibility is to mutate the feature’s current state given an action. Its second responsibility is to return effects that will be executed asynchronously and feed their data back into the system. Currently `Feature` does not need to run any effects, and so `none` is returned.

If the feature does need to do effectful work, then more would need to be done. For example, suppose the feature has the ability to start and stop a timer, and with each tick of the timer the `count` will be incremented. That could be done like so:

struct CounterFeature: Reducer {
@ObservableState
struct State {
var count = 0
}
enum Action {
case decrementButtonTapped
case incrementButtonTapped
case startTimerButtonTapped
case stopTimerButtonTapped
case timerTick
}
enum CancelID { case timer }

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none

case .incrementButtonTapped:
state.count += 1
return .none

case .startTimerButtonTapped:
return .run { send in
while true {
try await Task.sleep(for: .seconds(1))
await send(.timerTick)
}
}
.cancellable(CancelID.timer)

case .stopTimerButtonTapped:
return .cancel(CancelID.timer)

case .timerTick:
state.count += 1
return .none
}
}
}
}

That is the basics of implementing a feature as a conformance to `Reducer`.

## Using the @Reducer macro

While you technically can conform to the `Reducer` protocol directly, as we did above, the `Reducer()` macro can automate many aspects of implementing features for you. At a bare minimum, all you have to do is annotate your reducer with `@Reducer` and you can even drop the `Reducer` conformance:

+@Reducer
-struct CounterFeature: Reducer {
+struct CounterFeature {
@ObservableState
struct State {
var count = 0
}
enum Action {
case decrementButtonTapped
case incrementButtonTapped
}

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none
case .incrementButtonTapped:
state.count += 1
return .none
}
}
}
}

There are a number of things the `Reducer()` macro does for you:

### @CasePathable and @dynamicMemberLookup enums

The `@Reducer` macro automatically applies the `@CasePathable` macro to your `Action` enum:

+@CasePathable
enum Action {
// ...
}

Case paths are a tool that bring the power and ergonomics of key paths to enum cases, and they are a vital tool for composing reducers together.

In particular, having this macro applied to your `Action` enum will allow you to use key path syntax for specifying enum cases in various APIs in the library, such as `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q`, `Reducer/forEach(_:action:destination:fileID:filePath:line:column:)-9svqb`, `Scope`, and more.

Further, if the `State` of your feature is an enum, which is useful for modeling a feature that can be one of multiple mutually exclusive values, the `Reducer()` will apply the `@CasePathable` macro, as well as `@dynamicMemberLookup`:

+@CasePathable
+@dynamicMemberLookup
enum State {
// ...
}

This will allow you to use key path syntax for specifying case paths to the `State`’s cases, as well as allow you to use dot-chaining syntax for optionally extracting a case from the state. This can be useful when using the operators that come with the library that allow for driving navigation from an enum of options:

.sheet(
item: $store.scope(state: \.destination?.editForm, action: \.destination.editForm)
) { store in
FormView(store: store)
}

The syntax `state: \.destination?.editForm` is only possible due to both `@dynamicMemberLookup` and `@CasePathable` being applied to the `State` enum.

### Automatic fulfillment of reducer requirements

The `Reducer()` macro will automatically fill in any `Reducer` protocol requirements that you leave off. For example, something as simple as this compiles:

@Reducer
struct Feature {}

The `@Reducer` macro will automatically insert an empty `State` struct, an empty `Action` enum, and an empty `body`. This effectively means that `Feature` is a logicless, behaviorless, inert reducer.

Having these requirements automatically fulfilled for you can be handy for slowly filling them in with their real implementations. For example, this `Feature` reducer could be integrated in a parent domain using the library’s navigation tools, all without having implemented any of the domain yet. Then, once we are ready we can start implementing the real logic and behavior of the feature.

### Destination and path reducers

There is a common pattern in the Composable Architecture of representing destinations a feature can navigate to as a reducer that operates on enum state, with a case for each feature that can be navigated to. This is explained in great detail in the Tree-based navigation and Stack-based navigation articles.

This form of domain modeling can be very powerful, but also incur a bit of boilerplate. For example, if a feature can navigate to 3 other features, then one might have a `Destination` reducer like the following:

@Reducer
struct Destination {
@ObservableState
enum State {
case add(FormFeature.State)
case detail(DetailFeature.State)
case edit(EditFeature.State)
}
enum Action {
case add(FormFeature.Action)
case detail(DetailFeature.Action)
case edit(EditFeature.Action)
}

Scope(state: \.add, action: \.add) {
FormFeature()
}
Scope(state: \.detail, action: \.detail) {
DetailFeature()
}
Scope(state: \.edit, action: \.edit) {
EditFeature()
}
}
}

It’s not the worst code in the world, but it is 24 lines with a lot of repetition, and if we need to add a new destination we must add a case to the `State` enum, a case to the `Action` enum, and a `Scope` to the `body`.

The `Reducer()` macro is now capable of generating all of this code for you from the following simple declaration

@Reducer
enum Destination {
case add(FormFeature)
case detail(DetailFeature)
case edit(EditFeature)
}

24 lines of code has become 6. The `@Reducer` macro can now be applied to an _enum_ where each case holds onto the reducer that governs the logic and behavior for that case. Further, when using the `ifLet(_:action:)` operator with this style of `Destination` enum reducer you can completely leave off the trailing closure as it can be automatically inferred:

Reduce { state, action in
// Core feature logic
}
.ifLet(\.$destination, action: \.destination)
-{
- Destination()
-}

This pattern also works for `Path` reducers, which is common when dealing with Stack-based navigation, and in that case you can leave off the trailing closure of the `forEach(_:action:)` operator:

Reduce { state, action in
// Core feature logic
}
.forEach(\.path, action: \.path)
-{
- Path()
-}

Further, for `Path` reducers in particular, the `Reducer()` macro also helps you reduce boilerplate when using the initializer `init(path:root:destination:fileID:filePath:line:column:)` that comes with the library. In the last trailing closure you can use the `case` computed property to switch on the `Path.State` enum and extract out a store for each case:

NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
// Root view
} destination: { store in
switch store.case {
case let .add(store):
AddView(store: store)
case let .detail(store):
DetailView(store: store)
case let .edit(store):
EditView(store: store)
}
}

#### Navigating to non-reducer features

There are many times that you want to present or navigate to a feature that is not modeled with a Composable Architecture reducer. This can happen with legacy features that are not built with the Composable Architecture, or with features that are very simple and do not need a fully built reducer.

In those cases you can use the `ReducerCaseIgnored()` and `ReducerCaseEphemeral()` macros to annotate cases that are not powered by reducers. See the documentation for those macros for more details.

As an example, suppose that you have a feature that can navigate to multiple features, all of which are Composable Architecture features except for one:

@Reducer
enum Destination {
case add(AddItemFeature)
case edit(EditItemFeature)
@ReducerCaseIgnored
case item(Item)
}

In this situation the `.item` case holds onto a plain item and not a full reducer, and for that reason we have to ignore it from some of `@Reducer`’s macro expansion.

Then, to present a view from this case one can do:

.sheet(item: $store.scope(state: \.destination?.item, action: \.destination.item)) { store in
ItemView(item: store.withState { $0 })
}

#### Synthesizing protocol conformances on State and Action

Since the `State` and `Action` types are generated automatically for you when using `@Reducer` on an enum, you must extend these types yourself to synthesize conformances of `Equatable`, `Hashable`, _etc._:

@Reducer
enum Destination {
// ...
}
extension Destination.State: Equatable {}

#### Nested enum reducers

There may be times when an enum reducer may want to nest another enum reducer. To do so, the parent enum reducer must specify the child’s `Body` associated value and `body` static property explicitly:

@Reducer
enum Modal { /* ... */ }

@Reducer
enum Destination {
case modal(Modal.Body = Modal.body)
}

#### Autocomplete

Applying `@Reducer` can break autocompletion in the `body` of the reducer. This is a known issue, and it can generally be worked around by providing additional type hints to the compiler:

1. Adding an explicit `Reducer` conformance in addition to the macro application can restore autocomplete throughout the `body` of the reducer:

@Reducer
-struct Feature {
+struct Feature: Reducer {

2. Adding explicit generics to instances of `Reduce` in the `body` can restore autocomplete inside the `Reduce`:

- Reduce { state, action in

#### \#Preview and enum reducers

The `#Preview` macro is not capable of seeing the expansion of any macros since it is a macro itself. This means that when using destination and path reducers (see Destination and path reducers above) you cannot construct the cases of the state enum inside `#Preview`:

#Preview {
FeatureView(
store: Store(
initialState: Feature.State(
destination: .edit(EditFeature.State()) // 🛑
)
) {
Feature()
}
)
}

The `.edit` case is not usable from within `#Preview` since it is generated by the `Reducer()` macro.

The workaround is to move the view to a helper that be compiled outside of a macro, and then use it inside the macro:

#Preview {
preview
}
private var preview: some View {
FeatureView(
store: Store(
initialState: Feature.State(
destination: .edit(EditFeature.State())
)
) {
Feature()
}
)
}

You can use a computed property, free function, or even a dedicated view if you want. You can also use the old, non-macro style of previews by using a `PreviewProvider`:

struct Feature_Previews: PreviewProvider {
static var previews: some View {
FeatureView(
store: Store(
initialState: Feature.State(
destination: .edit(EditFeature.State())
)
) {
Feature()
}
)
}
}

#### Error: External macro implementation … could not be found

When integrating with the Composable Architecture, one may encounter the following error:

This error can show up when the macro has not yet been enabled, which is a separate error that should be visible from Xcode’s Issue navigator.

Sometimes, however, this error will still emit due to an Xcode bug in which a custom build configuration name is being used in the project. In general, using a build configuration other than “Debug” or “Release” can trigger upstream build issues with Swift packages, and we recommend only using the default “Debug” and “Release” build configuration names to avoid the above issue and others.

#### CI build failures

When testing your code on an external CI server you may run into errors such as the following:

You can fix this in one of two ways. You can write a default to the CI machine that allows Xcode to skip macro validation:

defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

Or if you are invoking `xcodebuild` directly in your CI scripts, you can pass the `-skipMacroValidation` flag to `xcodebuild` when building your project:

xcodebuild -skipMacroValidation …

## Topics

### Implementing a reducer

`macro Reducer()`

Helps implement the conformance to the `Reducer` protocol for a type.

`associatedtype State`

A type that holds the current state of the reducer.

**Required**

`associatedtype Action`

A type that holds all possible actions that cause the `State` of the reducer to change and/or kick off a side `Effect` that can communicate with the outside world.

`var body: Self.Body`

The content and behavior of a reducer that is composed from other reducers.

**Required** Default implementations provided.

`struct Reduce`

A type-erased reducer that invokes the given `reduce` function.

`struct Effect`

### Composing reducers

`enum ReducerBuilder`

A result builder for combining reducers into a single reducer by running each, one after the other, and merging their effects.

`struct CombineReducers`

Combines multiple reducers into a single reducer.

### Embedding child features

`struct Scope`

Embeds a child reducer in a parent domain.

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

### Supporting reducers

`struct EmptyReducer`

A reducer that does nothing.

`struct BindingReducer`

A reducer that updates bindable state when it receives binding actions.

`extension Optional`

### Reducer modifiers

Sets the dependency value of the specified key path to the given value.

Transform a reducer’s dependency value at the specified key path with the given function.

Adds a reducer to run when this reducer changes the given value in state.

Instruments a reducer with signposts.

Enhances a reducer with debug logging of received actions and state mutations for the given printer.

### Supporting types

`typealias ReducerOf`

A convenience for constraining a `Reducer` conformance.

### Deprecations

Review unsupported reducer APIs and their replacements.

### Instance Methods

Places a value in the reducer’s dependencies.

`func forEach<DestinationState, DestinationAction>(WritableKeyPath<Self.State, StackState<DestinationState>>, action: CaseKeyPath<Self.Action, StackAction<DestinationState, DestinationAction>>) -> some Reducer<Self.State, Self.Action>\\

A special overload of `Reducer/forEach(_:action:destination:fileID:filePath:line:column:)-9svqb` for enum reducers.

`func forEach<DestinationState, DestinationAction, Destination>(WritableKeyPath<Self.State, StackState<DestinationState>>, action: AnyCasePath<Self.Action, StackAction<DestinationState, DestinationAction>>, destination: () -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\
` Deprecated

`func forEach<DestinationState, DestinationAction, Destination>(WritableKeyPath<Self.State, StackState<DestinationState>>, action: CaseKeyPath<Self.Action, StackAction<DestinationState, DestinationAction>>, destination: () -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\

Embeds a child reducer in a parent domain that works on elements of a navigation stack in parent state.

`func forEach<ElementState, ElementAction, ID, Element>(WritableKeyPath<Self.State, IdentifiedArray<ID, ElementState>>, action: AnyCasePath<Self.Action, (ID, ElementAction)>, element: () -> Element, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\
` Deprecated

`func forEach<ElementState, ElementAction, ID, Element>(WritableKeyPath<Self.State, IdentifiedArray<ID, ElementState>>, action: CaseKeyPath<Self.Action, IdentifiedAction<ID, ElementAction>>, element: () -> Element, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\

Embeds a child reducer in a parent domain that works on elements of a collection in parent state.

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/ifcaselet(_:action:then:fileid:filepath:line:column:)-1oxkp) Deprecated

Embeds a child reducer in a parent domain that works on a case of parent enum state.

`func ifLet<ChildState, ChildAction>(WritableKeyPath<Self.State, PresentationState<ChildState>>, action: CaseKeyPath<Self.Action, PresentationAction<ChildAction>>) -> some Reducer<Self.State, Self.Action>\\

A special overload of `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` for enum reducers.

`func ifLet<DestinationState, DestinationAction, Destination>(WritableKeyPath<Self.State, PresentationState<DestinationState>>, action: CaseKeyPath<Self.Action, PresentationAction<DestinationAction>>, destination: () -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\

Embeds a child reducer in a parent domain that works on an optional property of parent state.

`func ifLet<DestinationState, DestinationAction, Destination>(WritableKeyPath<Self.State, PresentationState<DestinationState>>, action: AnyCasePath<Self.Action, PresentationAction<DestinationAction>>, destination: () -> Destination, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\
` Deprecated

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-11rub)

A special overload of `Reducer/ifLet(_:action:then:fileID:filePath:line:column:)-2r2pn` for alerts and confirmation dialogs that does not require a child reducer.

`func ifLet<DestinationState, DestinationAction>(WritableKeyPath<Self.State, PresentationState<DestinationState>>, action: CaseKeyPath<Self.Action, PresentationAction<DestinationAction>>, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\

A special overload of `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` for alerts and confirmation dialogs that does not require a child reducer.

`func ifLet<WrappedState, WrappedAction>(WritableKeyPath<Self.State, WrappedState?>, action: AnyCasePath<Self.Action, WrappedAction>, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> _IfLetReducer<Self, EmptyReducer<WrappedState, WrappedAction>>` Deprecated

`func ifLet<DestinationState, DestinationAction>(WritableKeyPath<Self.State, PresentationState<DestinationState>>, action: AnyCasePath<Self.Action, PresentationAction<DestinationAction>>, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) -> some Reducer<Self.State, Self.Action>\\
` Deprecated

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:then:fileid:filepath:line:column:)-24blc)

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:then:fileid:filepath:line:column:)-94ggc) Deprecated

## Relationships

### Inherited By

- `CaseReducer`

### Conforming Types

- `BindingReducer`
- `CombineReducers`
- `EmptyReducer`
- `Optional`
Conforms when `Wrapped` conforms to `Reducer`.

- `Reduce`
- `Scope`

## See Also

### State management

`class Store`

A store represents the runtime that powers the application. It is the object that you will pass around to views that need to interact with the application.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

- Reducer
- Overview
- Conforming to the Reducer protocol
- Using the @Reducer macro
- @CasePathable and @dynamicMemberLookup enums
- Automatic fulfillment of reducer requirements
- Destination and path reducers
- Gotchas
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer()

/#app-main)

- ComposableArchitecture
- Reducer
- Reducer()

Macro

# Reducer()

Helps implement the conformance to the `Reducer` protocol for a type.

@attached(member, names: named(State), named(Action), named(init), named(body), named(CaseScope), named(scope)) @attached(memberAttribute) @attached(extension, conformances: Reducer, CaseReducer) macro Reducer()

## Overview

See the article `Reducer` for more information about the macro and `Reducer` protocol.

## Topics

### Enum reducers

`macro Reducer(state: _SynthesizedConformance..., action: _SynthesizedConformance...)`

An overload of `Reducer()` that takes a description of protocol conformances to synthesize on the State and Action types

Deprecated

`macro ReducerCaseEphemeral()`

Marks the case of an enum reducer as holding onto “ephemeral” state.

`macro ReducerCaseIgnored()`

Marks the case of an enum reducer as “ignored”, and as such will not compose the case’s domain into the rest of the reducer besides state.

`protocol CaseReducer`

A reducer represented by multiple enum cases.

`protocol CaseReducerState`

A state type that is associated with a `CaseReducer`.

## See Also

### Implementing a reducer

`associatedtype State`

A type that holds the current state of the reducer.

**Required**

`associatedtype Action`

A type that holds all possible actions that cause the `State` of the reducer to change and/or kick off a side `Effect` that can communicate with the outside world.

`var body: Self.Body`

The content and behavior of a reducer that is composed from other reducers.

**Required** Default implementations provided.

`struct Reduce`

A type-erased reducer that invokes the given `reduce` function.

`struct Effect`

- Reducer()
- Overview
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/action

- ComposableArchitecture
- Reducer
- Action

Associated Type

# Action

A type that holds all possible actions that cause the `State` of the reducer to change and/or kick off a side `Effect` that can communicate with the outside world.

associatedtype Action

**Required**

## Topics

### View actions

`protocol ViewAction`

Defines the actions that can be sent from a view.

Provides a view with access to a feature’s `ViewAction` s.

`protocol ViewActionSending`

A type that represents a view with a `Store` that can send `ViewAction` s.

## See Also

### Implementing a reducer

`macro Reducer()`

Helps implement the conformance to the `Reducer` protocol for a type.

`associatedtype State`

A type that holds the current state of the reducer.

`var body: Self.Body`

The content and behavior of a reducer that is composed from other reducers.

**Required** Default implementations provided.

`struct Reduce`

A type-erased reducer that invokes the given `reduce` function.

`struct Effect`

- Action
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/body-20w8t

- ComposableArchitecture
- Reducer
- body

Instance Property

# body

The content and behavior of a reducer that is composed from other reducers.

**Required** Default implementations provided.

## Discussion

In the body of a reducer one can compose many reducers together, which will be run in order, from top to bottom, and usually involves some reducer operations for integrating, such as `ifLet`, `forEach`, `_printChanges`, etc.:

Reduce { state, action in
…
}
.ifLet(\.child, action: \.child) {
ChildFeature()
}
._printChanges()

Analytics()
}

Do not invoke this property directly.

## Topics

### Associated type

`associatedtype Body`

A type representing the body of this reducer.

**Required**

## Default Implementations

### CaseReducer Implementations

`var body: Self.Body`

### Reducer Implementations

`var body: Never`

A non-existent body.

## See Also

### Implementing a reducer

`macro Reducer()`

Helps implement the conformance to the `Reducer` protocol for a type.

`associatedtype State`

A type that holds the current state of the reducer.

`associatedtype Action`

A type that holds all possible actions that cause the `State` of the reducer to change and/or kick off a side `Effect` that can communicate with the outside world.

`struct Reduce`

A type-erased reducer that invokes the given `reduce` function.

`struct Effect`

- body
- Discussion
- Topics
- Default Implementations
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reduce

- ComposableArchitecture
- Reducer
- Reduce

Structure

# Reduce

A type-erased reducer that invokes the given `reduce` function.

## Overview

`Reduce` is useful for injecting logic into a reducer tree without the overhead of introducing a new type that conforms to `Reducer`.

## Topics

### Creating a reducer

Initializes a reducer with a `reduce` function.

### Type erased reducers

Type-erases a reducer.

### Reduce conformance

`var body: Self.Body`

The content and behavior of a reducer that is composed from other reducers.

**Required** Default implementations provided.

Evolves the current state of the reducer to the next state.

**Required** Default implementation provided.

## Relationships

### Conforms To

- `Reducer`

## See Also

### Implementing a reducer

`macro Reducer()`

Helps implement the conformance to the `Reducer` protocol for a type.

`associatedtype State`

A type that holds the current state of the reducer.

**Required**

`associatedtype Action`

A type that holds all possible actions that cause the `State` of the reducer to change and/or kick off a side `Effect` that can communicate with the outside world.

`struct Effect`

- Reduce
- Overview
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/none

- ComposableArchitecture
- Effect
- none

Type Property

# none

An effect that does nothing and completes immediately. Useful for situations where you must return an effect, but you don’t need to do anything.

## See Also

### Creating an effect

Wraps an asynchronous unit of work that can emit actions any number of times in an effect.

Initializes an effect that immediately emits the action passed in.

`typealias EffectOf`

A convenience type alias for referring to an effect of a given reducer’s domain.

`enum TaskResult`

A value that represents either a success or a failure. This type differs from Swift’s `Result` type in that it uses only one generic for the success case, leaving the failure case as an untyped `Error`.

Deprecated

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/scope

- ComposableArchitecture
- Reducer
- Scope

Structure

# Scope

Embeds a child reducer in a parent domain.

## Overview

`Scope` allows you to transform a parent domain into a child domain, and then run a child reduce on that subset domain. This is an important tool for breaking down large features into smaller units and then piecing them together. The smaller units can be easier to understand and test, and can even be packaged into their own isolated modules.

You hand `Scope` 3 pieces of data for it to do its job:

- A writable key path that identifies the child state inside the parent state.

- A case path that identifies the child actions inside the parent actions.

- A @ `ReducerBuilder` closure that describes the reducer you want to run on the child domain.

When run, it will intercept all child actions sent and feed them to the child reducer so that it can update the parent state and execute effects.

For example, given the basic scaffolding of child reducer:

@Reducer
struct Child {
struct State {
// ...
}
enum Action {
// ...
}
// ...
}

A parent reducer with a domain that holds onto the child domain can use `init(state:action:child:)-88vdx` to embed the child reducer in its `body`:

@Reducer
struct Parent {
struct State {
var child: Child.State
// ...
}

enum Action {
case child(Child.Action)
// ...
}

Scope(state: \.child, action: \.child) {
Child()
}
Reduce { state, action in
// Additional parent logic and behavior
}
}
}

## Enum state

The `Scope` reducer also works when state is modeled as an enum, not just a struct. In that case you can use `init(state:action:child:fileID:filePath:line:column:)-9g44g` to specify a case path that identifies the case of state you want to scope to.

For example, if your state was modeled as an enum for unloaded/loading/loaded, you could scope to the loaded case to run a reduce on only that case:

@Reducer
struct Feature {
enum State {
case unloaded
case loading
case loaded(Child.State)
}
enum Action {
case child(Child.Action)
// ...
}

Scope(state: \.loaded, action: \.child) {
Child()
}
Reduce { state, action in
// Additional feature logic and behavior
}
}
}

It is important to note that the order of combine `Scope` and your additional feature logic matters. It must be combined before the additional logic. In the other order it would be possible for the feature to intercept a child action, switch the state to another case, and then the scoped child reducer would not be able to react to that action. That can cause subtle bugs, and so we show a runtime warning in that case, and cause test failures.

For an alternative to using `Scope` with state case paths that enforces the order, check out the `ifCaseLet(_:action:then:fileID:filePath:line:column:)-rdrb` operator.

## Topics

### Deprecations

Review unsupported reducer APIs and their replacements.

### Initializers

Initializes a reducer that runs the given child reducer against a slice of parent state and actions.

## Relationships

### Conforms To

- `Reducer`

## See Also

### Embedding child features

Learn how to use the navigation tools in the library, including how to best model your domains, how to integrate features in the reducer and view layers, and how to write tests.

- Scope
- Overview
- Enum state
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/treebasednavigation

- ComposableArchitecture
- Navigation
- Tree-based navigation

Article

# Tree-based navigation

Learn about tree-based navigation, that is navigation modeled with optionals and enums, including how to model your domains, how to integrate features, how to test your features, and more.

## Overview

Tree-based navigation is the process of modeling navigation using optional and enum state. This style of navigation allows you to deep-link into any state of your application by simply constructing a deeply nested piece of state, handing it off to SwiftUI, and letting it take care of the rest.

- Basics

- Enum state

- Integration

- Dismissal

- Testing

## Basics

The tools for this style of navigation include the `Presents()` macro, `PresentationAction`, the `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` operator, and that is all. Once your feature is properly integrated with those tools you can use all of SwiftUI’s normal navigation view modifiers, such as `sheet(item:)`, `popover(item:)`, etc.

The process of integrating two features together for navigation largely consists of 2 steps: integrating the features’ domains together and integrating the features’ views together. One typically starts by integrating the features’ domains together. This consists of adding the child’s state and actions to the parent, and then utilizing a reducer operator to compose the child reducer into the parent.

For example, suppose you have a list of items and you want to be able to show a sheet to display a form for adding a new item. We can integrate state and actions together by utilizing the `Presents()` macro and `PresentationAction` type:

@Reducer
struct InventoryFeature {
@ObservableState
struct State: Equatable {
@Presents var addItem: ItemFormFeature.State?

// ...
}

enum Action {

// ...
}

Next you can integrate the reducers of the parent and child features by using the `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` reducer operator, as well as having an action in the parent domain for populating the child’s state to drive navigation:

@Reducer
struct InventoryFeature {
@ObservableState
struct State: Equatable { /* ... */ }
enum Action { /* ... */ }

Reduce { state, action in
switch action {
case .addButtonTapped:
// Populating this state performs the navigation
state.addItem = ItemFormFeature.State()
return .none

// ...
}
}
.ifLet(\.$addItem, action: \.addItem) {
ItemFormFeature()
}
}
}

That’s all that it takes to integrate the domains and logic of the parent and child features. Next we need to integrate the features’ views. This is done by passing a binding of a store to one of SwiftUI’s view modifiers.

For example, to show a sheet from the `addItem` state in the `InventoryFeature`, we can hand the `sheet(item:)` modifier a binding of a `Store` as an argument that is focused on presentation state and actions:

struct InventoryView: View {

List {
// ...
}
.sheet(
item: $store.scope(state: \.addItem, action: \.addItem)
) { store in
ItemFormView(store: store)
}
}
}

With those few steps completed the domains and views of the parent and child features are now integrated together, and when the `addItem` state flips to a non- `nil` value the sheet will be presented, and when it is `nil`’d out it will be dismissed.

In this example we are using the `.sheet` view modifier, but every view modifier SwiftUI ships can be handed a store in this fashion, including `popover(item:)`, `fullScreenCover(item:), ` navigationDestination(item:)\`, and more. This should make it possible to use optional state to drive any kind of navigation in a SwiftUI application.

## Enum state

While driving navigation with optional state can be powerful, it can also lead to less-than-ideal modeled domains. In particular, if a feature can navigate to multiple screens then you may be tempted to model that with multiple optional values:

@ObservableState
struct State {
@Presents var detailItem: DetailFeature.State?
@Presents var editItem: EditFeature.State?
@Presents var addItem: AddFeature.State?
// ...
}

However, this can lead to invalid states, such as 2 or more states being non-nil at the same time, and that can cause a lot of problems. First of all, SwiftUI does not support presenting multiple views at the same time from a single view, and so by allowing this in our state we run the risk of putting our application into an inconsistent state with respect to SwiftUI.

Second, it becomes more difficult for us to determine what feature is actually being presented. We must check multiple optionals to figure out which one is non- `nil`, and then we must figure out how to interpret when multiple pieces of state are non- `nil` at the same time.

And the number of invalid states increases exponentially with respect to the number of features that can be navigated to. For example, 3 optionals leads to 4 invalid states, 4 optionals leads to 11 invalid states, and 5 optionals leads to 26 invalid states.

For these reasons, and more, it can be better to model multiple destinations in a feature as a single enum rather than multiple optionals. So the example of above, with 3 optionals, can be refactored as an enum:

enum State {
case addItem(AddFeature.State)
case detailItem(DetailFeature.State)
case editItem(EditFeature.State)
// ...
}

This gives us compile-time proof that only one single destination can be active at a time.

In order to utilize this style of domain modeling you must take a few extra steps. First you model a “destination” reducer that encapsulates the domains and behavior of all of the features that you can navigate to. Typically it’s best to nest this reducer inside the feature that can perform the navigation, and the `Reducer()` macro can do most of the heavy lifting for us by implementing the entire reducer from a simple description of the features that can be navigated to:

@Reducer
struct InventoryFeature {
// ...

@Reducer
enum Destination {
case addItem(AddFeature)
case detailItem(DetailFeature)
case editItem(EditFeature)
}
}

With that done we can now hold onto a _single_ piece of optional state in our feature, using the `Presents()` macro, and we hold onto the destination actions using the `PresentationAction` type:

@Reducer
struct InventoryFeature {
@ObservableState
struct State {
@Presents var destination: Destination.State?
// ...
}
enum Action {

And then we must make use of the `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` operator to integrate the domain of the destination with the domain of the parent feature:

Reduce { state, action in
// ...
}
.ifLet(\.$destination, action: \.destination)
}
}

That completes the steps for integrating the child and parent features together.

Now when we want to present a particular feature we can simply populate the `destination` state with a case of the enum:

case addButtonTapped:
state.destination = .addItem(AddFeature.State())
return .none

And at any time we can figure out exactly what feature is being presented by switching or otherwise destructuring the single piece of `destination` state rather than checking multiple optional values.

The final step is to make use of the library’s scoping powers to focus in on the `Destination` domain and further isolate a particular case of the state and action enums via dot-chaining.

For example, suppose the “add” screen is presented as a sheet, the “edit” screen is presented by a popover, and the “detail” screen is presented in a drill-down. Then we can use the `.sheet(item:)`, `.popover(item:)`, and `.navigationDestination(item:)` view modifiers that come from SwiftUI to have each of those styles of presentation powered by the respective case of the destination enum.

To do this you must first hold onto the store in a bindable manner by using the `@Bindable` property wrapper:

}

And then in the `body` of the view you can use the `SwiftUI/Binding/scope(state:action:fileID:filePath:line:column:)` operator to derive bindings from `$store`:

var body: some View {
List {
// ...
}
.sheet(
item: $store.scope(
state: \.destination?.addItem,
action: \.destination.addItem
)
) { store in
AddFeatureView(store: store)
}
.popover(
item: $store.scope(
state: \.destination?.editItem,
action: \.destination.editItem
)
) { store in
EditFeatureView(store: store)
}
.navigationDestination(
item: $store.scope(
state: \.destination?.detailItem,
action: \.destination.detailItem
)
) { store in
DetailFeatureView(store: store)
}
}

With those steps completed you can be sure that your domains are modeled as concisely as possible. If the “add” item sheet was presented, and you decided to mutate the `destination` state to point to the `.detailItem` case, then you can be certain that the sheet will be dismissed and the drill-down will occur immediately.

### API Unification

One of the best features of tree-based navigation is that it unifies all forms of navigation with a single style of API. First of all, regardless of the type of navigation you plan on performing, integrating the parent and child features together can be done with the single `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` operator. This one single API services all forms of optional-driven navigation.

And then in the view, whether you are wanting to perform a drill-down, show a sheet, display an alert, or even show a custom navigation component, all you need to do is invoke an API that is provided a store focused on some `PresentationState` and `PresentationAction`. If you do that, then the API can handle the rest, making sure to present the child view when the state becomes non- `nil` and dismissing when it goes

Depending on your deployment target, certain APIs may be unavailable. For example, if you target

platforms earlier than iOS 16, macOS 13, tvOS 16 and watchOS 9, then you cannot use `navigationDestination`. Instead you can use `NavigationLink`, but you must define helper for driving navigation off of a binding of data rather than just a simple boolean. Just paste the following into your project:

@available(iOS, introduced: 13, deprecated: 16)
@available(macOS, introduced: 10.15, deprecated: 13)
@available(tvOS, introduced: 13, deprecated: 16)
@available(watchOS, introduced: 6, deprecated: 9)
extension NavigationLink {

) where Destination == C? {
self.init(
destination: item.wrappedValue.map(destination),
isActive: Binding(
get: { item.wrappedValue != nil },
set: { isActive, transaction in
onNavigate(isActive)
if !isActive {
item.transaction(transaction).wrappedValue = nil
}
}
),
label: label
)
}
}

That gives you the ability to drive a `NavigationLink` from state. When the link is tapped the `onNavigate` closure will be invoked, giving you the ability to populate state. And when the feature is dismissed, the state will be `nil`’d out.

## Integration

Once your features are integrated together using the steps above, your parent feature gets instant access to everything happening inside the child feature. You can use this as a means to integrate the logic of child and parent features. For example, if you want to detect when the “Save” button inside the edit feature is tapped, you can simply destructure on that action. This consists of pattern matching on the `PresentationAction`, then the `PresentationAction.presented(_:)` case, then the feature you are interested in, and finally the action you are interested in:

case .destination(.presented(.editItem(.saveButtonTapped))):
// ...

Once inside that case you can then try extracting out the feature state so that you can perform additional logic, such as closing the “edit” feature and saving the edited item to the database:

case .destination(.presented(.editItem(.saveButtonTapped))):
guard case let .editItem(editItemState) = state.destination
else { return .none }

state.destination = nil
return .run { _ in
self.database.save(editItemState.item)
}

## Dismissal

Dismissing a presented feature is as simple as `nil`-ing out the state that represents the presented feature:

case .closeButtonTapped:
state.destination = nil
return .none

In order to `nil` out the presenting state you must have access to that state, and usually only the parent has access, but often we would like to encapsulate the logic of dismissing a feature to be inside the child feature without needing explicit communication with the parent.

SwiftUI provides a wonderful tool for allowing child _views_ to dismiss themselves from the parent, all without any explicit communication with the parent. It’s an environment value called `dismiss`, and it can be used like so:

struct ChildView: View {
@Environment(\.dismiss) var dismiss
var body: some View {
Button("Close") { self.dismiss() }
}
}

When `self.dismiss()` is invoked, SwiftUI finds the closest parent view with a presentation, and causes it to dismiss by writing `false` or `nil` to the binding that drives the presentation. This can be incredibly useful, but it is also relegated to the view layer. It is not possible to use `dismiss` elsewhere, like in an observable object, which would allow you to have nuanced logic for dismissal such as validation or async work.

The Composable Architecture has a similar tool, except it is appropriate to use from a reducer, where the rest of your feature’s logic and behavior resides. It is accessed via the library’s dependency management system (see Dependencies) using `DismissEffect`:

@Reducer
struct Feature {
@ObservableState
struct State { /* ... */ }
enum Action {
case closeButtonTapped
// ...
}
@Dependency(\.dismiss) var dismiss

Reduce { state, action in
switch action {
case .closeButtonTapped:
return .run { _ in await self.dismiss() }
}
}
}
}

When `self.dismiss()` is invoked it will `nil` out the state responsible for presenting the feature by sending a `PresentationAction.dismiss` action back into the system, causing the feature to be dismissed. This allows you to encapsulate the logic for dismissing a child feature entirely inside the child domain without explicitly communicating with the parent.

## Testing

A huge benefit of properly modeling your domains for navigation is that testing becomes quite easy. Further, using “non-exhaustive testing” (see Non-exhaustive testing) can be very useful for testing navigation since you often only want to assert on a few high level details and not all state mutations and effects.

As an example, consider the following simple counter feature that wants to dismiss itself if its count is greater than or equal to 5:

@Reducer
struct CounterFeature {
@ObservableState
struct State: Equatable {
var count = 0
}
enum Action {
case decrementButtonTapped
case incrementButtonTapped
}

@Dependency(\.dismiss) var dismiss

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none

case .incrementButtonTapped:
state.count += 1

? .run { _ in await self.dismiss() }
: .none
}
}
}
}

And then let’s embed that feature into a parent feature using the `Presents()` macro, `PresentationAction` type and `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` operator:

@Reducer
struct Feature {
@ObservableState
struct State: Equatable {
@Presents var counter: CounterFeature.State?
}
enum Action {

Reduce { state, action in
// Logic and behavior for core feature.
}
.ifLet(\.$counter, action: \.counter) {
CounterFeature()
}
}
}

Now let’s try to write a test on the `Feature` reducer that proves that when the child counter feature’s count is incremented above 5 it will dismiss itself. To do this we will construct a `TestStore` for `Feature` that starts in a state with the count already set to 3:

@Test
func dismissal() {
let store = TestStore(
initialState: Feature.State(
counter: CounterFeature.State(count: 3)
)
) {
CounterFeature()
}
}

Then we can send the `.incrementButtonTapped` action in the counter child feature to confirm that the count goes up by one:

await store.send(\.counter.incrementButtonTapped) {
$0.counter?.count = 4
}

And then we can send it one more time to see that the count goes up to 5:

await store.send(\.counter.incrementButtonTapped) {
$0.counter?.count = 5
}

And then we finally expect that the child dismisses itself, which manifests itself as the `PresentationAction.dismiss` action being sent to `nil` out the `counter` state, which we can assert using the `TestStore/receive(_:timeout:assert:fileID:file:line:column:)-53wic` method on `TestStore`:

await store.receive(\.counter.dismiss) {
$0.counter = nil
}

This shows how we can write very nuanced tests on how parent and child features interact with each other.

However, the more complex the features become, the more cumbersome testing their integration can be. By default, `TestStore` requires us to be exhaustive in our assertions. We must assert on how every piece of state changes, how every effect feeds data back into the system, and we must make sure that all effects finish by the end of the test (see Testing for more info).

But `TestStore` also supports a form of testing known as “non-exhaustive testing” that allows you to assert on only the parts of the features that you actually care about (see Non-exhaustive testing for more info).

For example, if we turn off exhaustivity on the test store (see `exhaustivity`) then we can assert at a high level that when the increment button is tapped twice that eventually we receive a dismiss action:

@Test
func dismissal() {
let store = TestStore(
initialState: Feature.State(
counter: CounterFeature.State(count: 3)
)
) {
CounterFeature()
}
store.exhaustivity = .off

await store.send(\.counter.incrementButtonTapped)
await store.send(\.counter.incrementButtonTapped)
await store.receive(\.counter.dismiss)
}

This essentially proves the same thing that the previous test proves, but it does so in much fewer lines and is more resilient to future changes in the features that we don’t necessarily care about.

That is the basics of testing, but things get a little more complicated when you leverage the concepts outlined in Enum state in which you model multiple destinations as an enum instead of multiple optionals. In order to assert on state changes when using enum state you must chain into the particular case to make a mutation:

await store.send(\.destination.counter.incrementButtonTapped) {
$0.destination?.counter?.count = 4
}

## See Also

### Tree-based navigation

`macro Presents()`

Wraps a property with `PresentationState` and observes it.

`enum PresentationAction`

A wrapper type for actions that can be presented.

- Tree-based navigation
- Overview
- Basics
- Enum state
- API Unification
- Integration
- Dismissal
- Testing
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/stackbasednavigation

- ComposableArchitecture
- Navigation
- Stack-based navigation

Article

# Stack-based navigation

Learn about stack-based navigation, that is navigation modeled with collections, including how to model your domains, how to integrate features, how to test your features, and more.

## Overview

Stack-based navigation is the process of modeling navigation using collections of state. This style of navigation allows you to deep-link into any state of your application by simply constructing a flat collection of data, handing it off to SwiftUI, and letting it take care of the rest. It also allows for complex and recursive navigation paths in your application.

- Basics

- Pushing features onto the stack

- Integration

- Dismissal

- Testing

- StackState vs NavigationPath

- UIKit

## Basics

The tools for this style of navigation include `StackState`, `StackAction` and the `Reducer/forEach(_:action:destination:fileID:filePath:line:column:)-9svqb` operator, as well as a new initializer `init(path:root:destination:fileID:filePath:line:column:)` on `NavigationStack` that behaves like the normal initializer, but is tuned specifically for the Composable Architecture.

The process of integrating features into a navigation stack largely consists of 2 steps: integrating the features’ domains together, and constructing a `NavigationStack` for a store describing all the views in the stack. One typically starts by integrating the features’ domains together. This consists of defining a new reducer, typically called `Path`, that holds the domains of all the features that can be pushed onto the stack:

@Reducer
struct RootFeature {
// ...

@Reducer
enum Path {
case addItem(AddFeature)
case detailItem(DetailFeature)
case editItem(EditFeature)
}
}

Once the `Path` reducer is defined we can then hold onto `StackState` and `StackAction` in the feature that manages the navigation stack:

@Reducer
struct RootFeature {
@ObservableState
struct State {

// ...
}
enum Action {

// ...
}
}

And then we must make use of the `forEach(_:action:)` method to integrate the domains of all the features that can be navigated to with the domain of the parent feature:

Reduce { state, action in
// Core logic for root feature
}
.forEach(\.path, action: \.path)
}
}

That completes the steps to integrate the child and parent features together for a navigation stack.

Next we must integrate the child and parent views together. This is done by a `NavigationStack` using a special initializer that comes with this library, called `init(path:root:destination:fileID:filePath:line:column:)`. This initializer takes 3 arguments: a binding of a store focused in on `StackState` and `StackAction` in your domain, a trailing view builder for the root view of the stack, and another trailing view builder for all of the views that can be pushed onto the stack:

NavigationStack(
path: // Store focused on StackState and StackAction
) {
// Root view of the navigation stack
} destination: { store in
// A view for each case of the Path.State enum
}

To fill in the first argument you only need to scope a binding of your store to the `path` state and `path` action you already hold in the root feature:

struct RootView: View {

NavigationStack(
path: $store.scope(state: \.path, action: \.path)
) {
// Root view of the navigation stack
} destination: { store in
// A view for each case of the Path.State enum
}
}
}

The root view can be anything you want, and would typically have some `NavigationLink` s or other buttons that push new data onto the `StackState` held in your domain.

And the last trailing closure is provided a store of `Path` domain, and you can use the `case` computed property to destructure each case of the `Path` to obtain a store focused on just that case:

} destination: { store in
switch store.case {
case .addItem(let store):
case .detailItem(let store):
case .editItem(let store):
}
}

This will give you compile-time guarantees that you have handled each case of the `Path.State` enum, which can be nice for when you add new types of destinations to the stack.

In each of these cases you can return any kind of view that you want, but ultimately you want to scope the store down to a specific case of the `Path.State` enum:

} destination: { store in
switch store.case {
case .addItem(let store):
AddView(store: store)
case .detailItem(let store):
DetailView(store: store)
case .editItem(let store):
EditView(store: store)
}
}

And that is all it takes to integrate multiple child features together into a navigation stack, and done so with concisely modeled domains. Once those steps are taken you can easily add additional features to the stack by adding a new case to the `Path` reducer state and action enums, and you get complete introspection into what is happening in each child feature from the parent. Continue reading into Integration for more information on that.

## Pushing features onto the stack

There are two primary ways to push features onto the stack once you have their domains integrated and `NavigationStack` in the view, as described above. The simplest way is to use the `init(state:label:fileID:filePath:line:column:)` initializer on `NavigationLink`, which requires you to specify the state of the feature you want to push onto the stack. You must specify the full state, going all the way ) action will be sent, causing the `path` collection to be mutated and appending the `.detail` state to the stack.

This is by far the simplest way to navigate to a screen, but it also has its drawbacks. In particular, it makes modularity difficult since the view that holds onto the `NavigationLink` must have access to the `Path.State` type, which means it needs to build all of the `Path` reducer, including _every_ feature that can be navigated to.

This hurts modularity because it is no longer possible to build each feature that can be presented in the stack individually, in full isolation. You must build them all together. Technically you can move all features’ `State` types (and only the `State` types) to a separate module, and then features can depend on only that module without needing to build every feature’s reducer.

Another alternative is to forgo `NavigationLink` entirely and just use `Button` that sends an action in the child feature’s domain:

Form {
Button("Detail") {
store.send(.detailButtonTapped)
}
}

Then the root feature can listen for that action and append to the `path` with new state in order to drive navigation:

case .path(.element(id: _, action: .list(.detailButtonTapped))):
state.path.append(.detail(DetailFeature.State()))
return .none

## Integration

Once your features are integrated together using the steps above, your parent feature gets instant access to everything happening inside the navigation stack. You can use this as a means to integrate the logic of the stack element features with the parent feature. For example, if you want to detect when the “Save” button inside the edit feature is tapped, you can simply destructure on that action. This consists of pattern matching on the `StackAction`, then the `StackAction.element(id:action:)` action, then the feature you are interested in, and finally the action you are interested in:

case let .path(.element(id: id, action: .editItem(.saveButtonTapped))):
// ...

Once inside that case you can then try extracting out the feature state so that you can perform additional logic, such as popping the “edit” feature and saving the edited item to the database:

case let .path(.element(id: id, action: .editItem(.saveButtonTapped))):
guard let editItemState = state.path[id: id]?.editItem
else { return .none }

state.path.pop(from: id)
return .run { _ in
await self.database.save(editItemState.item)
}

Note that when destructuring the `StackAction.element(id:action:)` action we get access to not only the action that happened in the child domain, but also the ID of the element in the stack. `StackState` automatically manages IDs for every feature added to the stack, which can be used to look up specific elements in the stack using `subscript(id:fileID:filePath:line:column:)` and pop elements from the stack using `pop(from:)`.

## Dismissal

Dismissing a feature in a stack is as simple as mutating the `StackState` using one of its methods, such as `popLast()`, `pop(from:)` and more:

case .closeButtonTapped:
state.popLast()
return .none

However, in order to do this you must have access to that stack state, and usually only the parent has access. But often we would like to encapsulate the logic of dismissing a feature to be inside the child feature without needing explicit communication with the parent.

SwiftUI provides a wonderful tool for allowing child _views_ to dismiss themselves from the parent, all without any explicit communication with the parent. It’s an environment value called `dismiss`, and it can be used like so:

struct ChildView: View {
@Environment(\.dismiss) var dismiss
var body: some View {
Button("Close") { self.dismiss() }
}
}

When `self.dismiss()` is invoked, SwiftUI finds the closest parent view that is presented in the navigation stack, and removes that state from the collection powering the stack. This can be incredibly useful, but it is also relegated to the view layer. It is not possible to use `dismiss` elsewhere, like in an observable object, which would allow you to have nuanced logic for dismissal such as validation or async work.

The Composable Architecture has a similar tool, except it is appropriate to use from a reducer, where the rest of your feature’s logic and behavior resides. It is accessed via the library’s dependency management system (see Dependencies) using `DismissEffect`:

@Reducer
struct Feature {
@ObservableState
struct State { /* ... */ }
enum Action {
case closeButtonTapped
// ...
}
@Dependency(\.dismiss) var dismiss

Reduce { state, action in
switch action {
case .closeButtonTapped:
return .run { _ in await self.dismiss() }
// ...
}
}
}
}

When `self.dismiss()` is invoked it will remove the corresponding value from the `StackState` powering the navigation stack. It does this by sending a `StackAction.popFrom(id:)` action back into the system, causing the feature state to be removed. This allows you to encapsulate the logic for dismissing a child feature entirely inside the child domain without explicitly communicating with the parent.

## Testing

A huge benefit of using the tools of this library to model navigation stacks is that testing becomes quite easy. Further, using “non-exhaustive testing” (see Non-exhaustive testing) can be very useful for testing navigation since you often only want to assert on a few high level details and not all state mutations and effects.

As an example, consider the following simple counter feature that wants to dismiss itself if its count is greater than or equal to 5:

@Reducer
struct CounterFeature {
@ObservableState
struct State: Equatable {
var count = 0
}
enum Action {
case decrementButtonTapped
case incrementButtonTapped
}

@Dependency(\.dismiss) var dismiss

Reduce { state, action in
switch action {
case .decrementButtonTapped:
state.count -= 1
return .none

case .incrementButtonTapped:
state.count += 1

? .run { _ in await self.dismiss() }
: .none
}
}
}
}

And then let’s embed that feature into a parent feature:

@Reducer
struct Feature {
@ObservableState
struct State: Equatable {

}
enum Action {

}

@Reducer
struct Path {
enum State: Equatable { case counter(CounterFeature.State) }
enum Action { case counter(CounterFeature.Action) }

Scope(state: \.counter, action: \.counter) { CounterFeature() }
}
}

Reduce { state, action in
// Logic and behavior for core feature.
}
.forEach(\.path, action: \.path) { Path() }
}
}

Now let’s try to write a test on the `Feature` reducer that proves that when the child counter feature’s count is incremented above 5 it will dismiss itself. To do this we will construct a `TestStore` for `Feature` that starts in a state with a single counter already on the stack:

@Test
func dismissal() {
let store = TestStore(
initialState: Feature.State(
path: StackState([\
CounterFeature.State(count: 3)\
])
)
) {
CounterFeature()
}
}

Then we can send the `.incrementButtonTapped` action in the counter child feature inside the stack in order to confirm that the count goes up by one, but in order to do so we need to provide an ID:

await store.send(\.path[id: ???].counter.incrementButtonTapped) {
// ...
}

As mentioned in Integration, `StackState` automatically manages IDs for each feature and those IDs are mostly opaque to the outside. However, specifically in tests those IDs are integers and generational, which means the ID starts at 0 and then for each feature pushed onto the stack the global ID increments by one.

This means that when the `TestStore` were constructed with a single element already in the stack that it was given an ID of 0, and so that is the ID we can use when sending an action:

await store.send(\.path[id: 0].counter.incrementButtonTapped) {
// ...
}

Next we want to assert how the counter feature in the stack changes when the action is sent. To do this we must go through multiple layers: first subscript through the ID, then unwrap the optional value returned from that subscript, then pattern match on the case of the `Path.State` enum, and then perform the mutation.

The library provides two different tools to perform all of these steps in a single step. You can use the `XCTModify` helper:

await store.send(\.path[id: 0].counter.incrementButtonTapped) {
XCTModify(&$0.path[id: 0], case: \.counter) {
$0.count = 4
}
}

The `XCTModify` function takes an `inout` piece of enum state as its first argument and a case path for its second argument, and then uses the case path to extract the payload in that case, allow you to perform a mutation to it, and embed the data back into the enum. So, in the code above we are subscripting into ID 0, isolating the `.counter` case of the `Path.State` enum, and mutating the `count` to be 4 since it incremented by one. Further, if the case of `$0.path[id: 0]` didn’t match the case path, then a test failure would be emitted.

Another option is to use `StackState/subscript(id:case:)-7gczr` to simultaneously subscript into an ID on the stack _and_ a case of the path enum:

await store.send(\.path[id: 0].counter.incrementButtonTapped) {
$0.path[id: 0, case: \.counter]?.count = 4
}

The `XCTModify` style is best when you have many things you need to modify on the state, and the `StackState/subscript(id:case:)-7gczr` style is best when you have simple mutations.

Continuing with the test, we can send it one more time to see that the count goes up to 5:

await store.send(\.path[id: 0].counter.incrementButtonTapped) {
XCTModify(&$0.path[id: 0], case: \.counter) {
$0.count = 5
}
}

And then we finally expect that the child dismisses itself, which manifests itself as the `StackAction.popFrom(id:)` action being sent to pop the counter feature off the stack, which we can assert using the `TestStore/receive(_:timeout:assert:fileID:file:line:column:)-53wic` method on `TestStore`:

await store.receive(\.path.popFrom) {
$0.path[id: 0] = nil
}

If you need to assert that a specific child action is received, you can construct a case key path for a specific child element action by subscripting on the `\.path` case with the element ID.

For example, if the child feature performed an effect that sent an `.response` action, you can test that it is received:

await store.receive(\.path[id: 0].counter.response) {
// ...
}

This shows how we can write very nuanced tests on how parent and child features interact with each other in a navigation stack.

However, the more complex the features become, the more cumbersome testing their integration can be. By default, `TestStore` requires us to be exhaustive in our assertions. We must assert on how every piece of state changes, how every effect feeds data back into the system, and we must make sure that all effects finish by the end of the test (see Testing for more info).

But `TestStore` also supports a form of testing known as “non-exhaustive testing” that allows you to assert on only the parts of the features that you actually care about (see Non-exhaustive testing for more info).

For example, if we turn off exhaustivity on the test store (see `exhaustivity`) then we can assert at a high level that when the increment button is tapped twice that eventually we receive a `StackAction.popFrom(id:)` action:

@Test
func dismissal() {
let store = TestStore(
initialState: Feature.State(
path: StackState([\
CounterFeature.State(count: 3)\
])
)
) {
CounterFeature()
}
store.exhaustivity = .off

await store.send(\.path[id: 0].counter.incrementButtonTapped)
await store.send(\.path[id: 0].counter.incrementButtonTapped)
await store.receive(\.path.popFrom)
}

This essentially proves the same thing that the previous test proves, but it does so in much fewer lines and is more resilient to future changes in the features that we don’t necessarily care about.

## StackState vs NavigationPath

SwiftUI comes with a powerful type for modeling data in navigation stacks called `NavigationPath`, and so you might wonder why we created our own data type, `StackState`, instead of leveraging `NavigationPath`.

The `NavigationPath` data type is a type-erased list of data that is tuned specifically for `NavigationStack` s. It allows you to maximally decouple features in the stack since you can add any kind of data to a path, as long as it is `Hashable`:

var path = NavigationPath()
path.append(1)
path.append("Hello")
path.append(false)

And SwiftUI interprets that data by describing what view should be pushed onto the stack corresponding to a type of data:

struct RootView: View {
@State var path = NavigationPath()

var body: some View {
NavigationStack(path: self.$path) {
Form {
// ...
}
.navigationDestination(for: Int.self) { integer in
// ...
}
.navigationDestination(for: String.self) { string in
// ...
}
.navigationDestination(for: Bool.self) { bool in
// ...
}
}
}
}

This can be powerful, but it does come with some downsides. Because the underlying data is type-erased, SwiftUI has decided to not expose much API on the data type. For example, the only things you can do with a path are append data to the end of it, as seen above, or remove data from the end of it:

path.removeLast()

Or count the elements in the path:

path.count

And that is all. You can’t insert or remove elements from anywhere but the end, and you can’t even iterate over the path:

let path: NavigationPath = …
for element in path { // 🛑
}

This can make it very difficult to analyze what is on the stack and aggregate data across the entire stack.

The Composable Architecture’s `StackState` serves a similar purpose as `NavigationPath`, but with different trade offs:

- `StackState` is fully statically typed, and so you cannot add just _any_ kind of data to it.

- But, `StackState` conforms to the `Collection` protocol (as well as `RandomAccessCollection` and `RangeReplaceableCollection`), which gives you access to a lot of methods for manipulating the collection and introspecting what is inside the stack.

- Your feature’s data does not need to be `Hashable` to put it in a `StackState`. The data type manages stable identifiers for your features under the hood, and automatically derives a hash value from those identifiers.

We feel that `StackState` offers a nice balance between full runtime flexibility and static, compile-time guarantees, and that it is the perfect tool for modeling navigation stacks in the Composable Architecture.

## UIKit

The library also comes with a tool that allows you to use UIKit’s `UINavigationController` in a state-driven manner. If you model your domains using `StackState` as described above, then you can use the special `NavigationStackController` type to implement a view controller for your stack:

class AppController: NavigationStackController {

@UIBindable var store = store

self.init(path: $store.scope(state: \.path, action: \.path)) {
RootViewController(store: store)
} destination: { store in
switch store.case {
case .addItem(let store):
AddViewController(store: store)
case .detailItem(let store):
DetailViewController(store: store)
case .editItem(let store):
EditViewController(store: store)
}
}

self.store = store
}
}

## See Also

### Stack-based navigation

`struct StackState`

A list of data representing the content of a navigation stack.

`enum StackAction`

A wrapper type for actions that can be presented in a navigation stack.

`typealias StackActionOf`

A convenience type alias for referring to a stack action of a given reducer’s domain.

`struct StackElementID`

An opaque type that identifies an element of `StackState`.

- Stack-based navigation
- Overview
- Basics
- Pushing features onto the stack
- Integration
- Dismissal
- Testing
- StackState vs NavigationPath
- UIKit
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:)

/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:)

Instance Method

# ifLet(\_:action:)

A special overload of `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` for enum reducers.

_ state: WritableKeyPath<Self.State, PresentationState<ChildState>>,
action: CaseKeyPath<Self.Action, PresentationAction<ChildAction>>

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:)

/#app-main)

- ComposableArchitecture
- Reducer
- forEach(\_:action:)

Instance Method

# forEach(\_:action:)

A special overload of `Reducer/forEach(_:action:destination:fileID:filePath:line:column:)-9svqb` for enum reducers.

_ state: WritableKeyPath<Self.State, StackState<DestinationState>>,
action: CaseKeyPath<Self.Action, StackAction<DestinationState, DestinationAction>>

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftui/navigationstack/init(path:root:destination:fileid:filepath:line:column:)

/#app-main)

- ComposableArchitecture
- SwiftUI Integration
- init(path:root:destination:fileID:filePath:line:column:)

Initializer

# init(path:root:destination:fileID:filePath:line:column:)

Drives a navigation stack with a store.

ComposableArchitectureSwiftUI

@MainActor

path: Binding<Store<StackState<State>, StackAction<State, Action>>>,

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column
) where Data == StackState<State>.PathView, Root == ModifiedContent<R, _NavigationDestinationViewModifier<State, Action, Destination>>, State : ObservableState, Destination : View, R : View

Available when `Root` conforms to `View`.

## Discussion

See the dedicated article on Navigation for more information on the library’s navigation tools, and in particular see Stack-based navigation for information on using this view.

## See Also

### Navigation stacks and links

Creates a navigation link that presents the view corresponding to an element of `StackState`.

- init(path:root:destination:fileID:filePath:line:column:)
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/store/case

- ComposableArchitecture
- Store
- case

Instance Property

# case

A destructurable view of a store on a collection of cases.

@MainActor
var `case`: State.StateReducer.CaseScope { get }

Available when `State` conforms to `CaseReducerState` and `Action` is `State.StateReducer.Action`.

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducercaseignored()

/#app-main)

- ComposableArchitecture
- Reducer
- Reducer()
- ReducerCaseIgnored()

Macro

# ReducerCaseIgnored()

Marks the case of an enum reducer as “ignored”, and as such will not compose the case’s domain into the rest of the reducer besides state.

@attached(peer, names: named(`_`))
macro ReducerCaseIgnored()

## Overview

Apply this macro to cases that do not hold onto reducer features, and instead hold onto plain data that needs to be passed to a child view.

@Reducer
enum Destination {
@ReducerCaseIgnored
case meeting(id: Meeting.ID)
// ...
}

## See Also

### Enum reducers

`macro Reducer(state: _SynthesizedConformance..., action: _SynthesizedConformance...)`

An overload of `Reducer()` that takes a description of protocol conformances to synthesize on the State and Action types

Deprecated

`macro ReducerCaseEphemeral()`

Marks the case of an enum reducer as holding onto “ephemeral” state.

`protocol CaseReducer`

A reducer represented by multiple enum cases.

`protocol CaseReducerState`

A state type that is associated with a `CaseReducer`.

- ReducerCaseIgnored()
- Overview
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducercaseephemeral()

/#app-main)

- ComposableArchitecture
- Reducer
- Reducer()
- ReducerCaseEphemeral()

Macro

# ReducerCaseEphemeral()

Marks the case of an enum reducer as holding onto “ephemeral” state.

@attached(peer, names: named(`_`))
macro ReducerCaseEphemeral()

## Overview

Apply this reducer to any cases of an enum reducer that holds onto state conforming to the `_EphemeralState` protocol, such as `AlertState` and `ConfirmationDialogState`:

@Reducer
enum Destination {
@ReducerCaseEphemeral

// ...

enum Alert {
case saveButtonTapped
case discardButtonTapped
}
}

## See Also

### Enum reducers

`macro Reducer(state: _SynthesizedConformance..., action: _SynthesizedConformance...)`

An overload of `Reducer()` that takes a description of protocol conformances to synthesize on the State and Action types

Deprecated

`macro ReducerCaseIgnored()`

Marks the case of an enum reducer as “ignored”, and as such will not compose the case’s domain into the rest of the reducer besides state.

`protocol CaseReducer`

A reducer represented by multiple enum cases.

`protocol CaseReducerState`

A state type that is associated with a `CaseReducer`.

- ReducerCaseEphemeral()
- Overview
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducerbuilder

- ComposableArchitecture
- Reducer
- ReducerBuilder

Enumeration

# ReducerBuilder

A result builder for combining reducers into a single reducer by running each, one after the other, and merging their effects.

@resultBuilder

## Overview

It is most common to encounter a reducer builder context when conforming a type to `Reducer` and implementing its `body` property.

See `CombineReducers` for an entry point into a reducer builder context.

## Topics

### Building reducers

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducerbuilder/buildblock())

`](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducerbuilder/buildarray(_:))

## See Also

### Composing reducers

`struct CombineReducers`

Combines multiple reducers into a single reducer.

- ReducerBuilder
- Overview
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/combinereducers

- ComposableArchitecture
- Reducer
- CombineReducers

Structure

# CombineReducers

Combines multiple reducers into a single reducer.

## Overview

`CombineReducers` takes a block that can combine a number of reducers using a `ReducerBuilder`.

Useful for grouping reducers together and applying reducer modifiers to the result.

CombineReducers {
ReducerA()
ReducerB()
ReducerC()
}
._printChanges()
}

## Topics

### Initializers

Initializes a reducer that combines all of the reducers in the given build block.

## Relationships

### Conforms To

- `Reducer`

## See Also

### Composing reducers

`enum ReducerBuilder`

A result builder for combining reducers into a single reducer by running each, one after the other, and merging their effects.

- CombineReducers
- Overview
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/emptyreducer

- ComposableArchitecture
- Reducer
- EmptyReducer

Structure

# EmptyReducer

A reducer that does nothing.

## Overview

While not very useful on its own, `EmptyReducer` can be used as a placeholder in APIs that hold reducers.

## Topics

### Initializers

`init()`

Initializes a reducer that does nothing.

## Relationships

### Conforms To

- `Reducer`

## See Also

### Supporting reducers

`struct BindingReducer`

A reducer that updates bindable state when it receives binding actions.

`extension Optional`

- EmptyReducer
- Overview
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/bindingreducer

- ComposableArchitecture
- Reducer
- BindingReducer

Structure

# BindingReducer

A reducer that updates bindable state when it receives binding actions.

## Overview

This reducer should typically be composed into the `body` of your feature’s reducer:

@Reducer
struct Feature {
struct State {
@BindingState var isOn = false
// More properties...
}
enum Action: BindableAction {

// More actions
}

BindingReducer()
Reduce { state, action in
// Your feature's logic...
}
}
}

This makes it so that the binding’s logic is run before the feature’s logic, _i.e._ you will only see the state after the binding was written. If you want to react to the state _before_ the binding was written, you can flip the order of the composition:

Reduce { state, action in
// Your feature's logic...
}
BindingReducer()
}

If you forget to compose the `BindingReducer` into your feature’s reducer, then when a binding is written to it will cause a runtime purple Xcode warning letting you know what needs to be fixed.

## Topics

### Initializers

`init()`

Initializes a reducer that updates bindable state when it receives binding actions.

## Relationships

### Conforms To

- `Reducer`

## See Also

### Supporting reducers

`struct EmptyReducer`

A reducer that does nothing.

`extension Optional`

- BindingReducer
- Overview
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swift/optional

- ComposableArchitecture
- Reducer
- Optional

Extended Enumeration

# Optional

ComposableArchitectureSwift

extension Optional

## Topics

## Relationships

### Conforms To

- `Reducer`
Conforms when `Wrapped` conforms to `Reducer`.

- `Swift.Copyable`

## See Also

### Supporting reducers

`struct EmptyReducer`

A reducer that does nothing.

`struct BindingReducer`

A reducer that updates bindable state when it receives binding actions.

- Optional
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/transformdependency(_:transform:)

/#app-main)

- ComposableArchitecture
- Reducer
- transformDependency(\_:transform:)

Instance Method

# transformDependency(\_:transform:)

Transform a reducer’s dependency value at the specified key path with the given function.

@warn_unqualified_access

## Parameters

`keyPath`

A key path that indicates the property of the `DependencyValues` structure to transform.

`transform`

A closure that is handed a mutable instance of the value specified by the key path.

## Discussion

This is similar to `dependency(_:_:)`, except it allows you to mutate a dependency value directly. This can be handy when you want to alter a dependency but still use its current value.

For example, suppose you want to see when a particular endpoint of a dependency gets called in your application. You can override that endpoint to insert a breakpoint or print statement, but still call out to the original endpoint:

Feature()
.transformDependency(\.speechClient) { speechClient in
speechClient.requestAuthorization = {
print("requestAuthorization")
try await speechClient.requestAuthorization()
}
}

You can also transform _all_ dependency values at once by using the `\.self` key path:

Feature()
.transformDependency(\.self) { dependencyValues in
// Access to all dependencies in here
}

## See Also

### Reducer modifiers

Sets the dependency value of the specified key path to the given value.

Adds a reducer to run when this reducer changes the given value in state.

Instruments a reducer with signposts.

Enhances a reducer with debug logging of received actions and state mutations for the given printer.

- transformDependency(\_:transform:)
- Parameters
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/onchange(of:_:)

/#app-main)

- ComposableArchitecture
- Reducer
- onChange(of:\_:)

Instance Method

# onChange(of:\_:)

Adds a reducer to run when this reducer changes the given value in state.

## Parameters

`toValue`

A closure that returns a value from the given state.

`reducer`

A reducer builder closure to run when the value changes.

- `oldValue`: The old value that failed the comparison check.

- `newValue`: The new value that failed the comparison check.

## Return Value

A reducer that performs the logic when the state changes.

## Discussion

Use this operator to trigger additional logic when a value changes, like when a `BindingReducer` makes a deeper change to a struct held in `BindingState`.

@Reducer
struct Settings {
struct State {
@BindingState var userSettings: UserSettings
// ...
}

enum Action: BindableAction {

// ...
}

BindingReducer()
.onChange(of: \.userSettings.isHapticFeedbackEnabled) { oldValue, newValue in
Reduce { state, action in
.run { send in
// Persist new value...
}
}
}
}
}

When the value changes, the new version of the closure will be called, so any captured values will have their values from the time that the observed value has its new value. The system passes the old and new observed values into the closure.

## See Also

### Reducer modifiers

Sets the dependency value of the specified key path to the given value.

Transform a reducer’s dependency value at the specified key path with the given function.

Instruments a reducer with signposts.

Enhances a reducer with debug logging of received actions and state mutations for the given printer.

- onChange(of:\_:)
- Parameters
- Return Value
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/signpost(_:log:)

/#app-main)

- ComposableArchitecture
- Reducer
- signpost(\_:log:)

Instance Method

# signpost(\_:log:)

Instruments a reducer with signposts.

@warn_unqualified_access
func signpost(
_ prefix: String = "",
log: OSLog = OSLog(
subsystem: "co.pointfree.ComposableArchitecture",
category: "Reducer Instrumentation"
)

## Parameters

`prefix`

A string to print at the beginning of the formatted message for the signpost.

`log`

An `OSLog` to use for signposts.

## Return Value

A reducer that has been enhanced with instrumentation.

## Discussion

Each invocation of the reducer will be measured by an interval, and the lifecycle of its effects will be measured with interval and event signposts.

To use, build your app for profiling, create a blank instrument, and add the signpost instrument. Start recording your app you will see timing information for every action sent to the store, as well as every effect executed.

Effect instrumentation can be particularly useful for inspecting the lifecycle of long-living effects. For example, if you start an effect ( _e.g._, a location manager) in `onAppear` and forget to tear down the effect in `onDisappear`, the instrument will show that the effect never completed.

## See Also

### Reducer modifiers

Sets the dependency value of the specified key path to the given value.

Transform a reducer’s dependency value at the specified key path with the given function.

Adds a reducer to run when this reducer changes the given value in state.

Enhances a reducer with debug logging of received actions and state mutations for the given printer.

- signpost(\_:log:)
- Parameters
- Return Value
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/_printchanges(_:)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducerof

- ComposableArchitecture
- Reducer
- ReducerOf

Type Alias

# ReducerOf

A convenience for constraining a `Reducer` conformance.

## Discussion

This allows you to specify the `body` of a `Reducer` conformance like so:

// ...
}

…instead of the more verbose:

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducerdeprecations

- ComposableArchitecture
- Reducer
- Deprecations

API Collection

# Deprecations

Review unsupported reducer APIs and their replacements.

## Overview

Avoid using deprecated APIs in your app. Select a method to see the replacement that you should use instead.

## Topics

### Deprecated methods

Adds a reducer to run when this reducer changes the given value in state.

Deprecated

### Enum reducers

`struct _SynthesizedConformance`

A description of a protocol conformance to synthesize on the State and Action types generated by the `Reducer()` macro.

- Deprecations
- Overview
- Topics

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/dependency(_:)

/#app-main)

- ComposableArchitecture
- Reducer
- dependency(\_:)

Instance Method

# dependency(\_:)

Places a value in the reducer’s dependencies.

@warn_unqualified_access

## Parameters

`value`

The value to set for this value’s type in the dependencies.

## Return Value

A reducer that has the given value set in its dependencies.

- dependency(\_:)
- Parameters
- Return Value

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:destination:fileid:filepath:line:column:)-2frtf

-2frtf/#app-main)

- ComposableArchitecture
- Reducer
- forEach(\_:action:destination:fileID:filePath:line:column:) Deprecated

Instance Method

# forEach(\_:action:destination:fileID:filePath:line:column:)

@warn_unqualified_access

_ toStackState: WritableKeyPath<Self.State, StackState<DestinationState>>,
action toStackAction: AnyCasePath<Self.Action, StackAction<DestinationState, DestinationAction>>,

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:destination:fileid:filepath:line:column:)-7fv3l

-7fv3l/#app-main)

- ComposableArchitecture
- Reducer
- forEach(\_:action:destination:fileID:filePath:line:column:)

Instance Method

# forEach(\_:action:destination:fileID:filePath:line:column:)

Embeds a child reducer in a parent domain that works on elements of a navigation stack in parent state.

@warn_unqualified_access

_ toStackState: WritableKeyPath<Self.State, StackState<DestinationState>>,
action toStackAction: CaseKeyPath<Self.Action, StackAction<DestinationState, DestinationAction>>,

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

## Parameters

`toStackState`

A writable key path from parent state to a stack of destination state.

`toStackAction`

A case path from parent action to a stack action.

`destination`

A reducer that will be invoked with destination actions against elements of destination state.

`fileID`

The fileID.

`filePath`

The filePath.

`line`

The line.

`column`

The column.

## Return Value

A reducer that combines the destination reducer with the parent reducer.

## Discussion

This version of `forEach` works when the parent domain holds onto the child domain using `StackState` and `StackAction`.

For example, if a parent feature models a navigation stack of child features using the `StackState` and `StackAction` types, then it can perform its core logic _and_ the logic of each child feature using the `forEach` operator:

@Reducer
struct ParentFeature {
struct State {

// ...
}
enum Action {

// ...
}

Reduce { state, action in
// Core parent logic
}
.forEach(\.path, action: \.path) {
Path()
}
}
}

The `forEach` operator does a number of things to make integrating parent and child features ergonomic and enforce correctness:

- It forces a specific order of operations for the child and parent features:

- When a `StackAction.element(id:action:)` action is sent it runs the child first, and then the parent. If the order was reversed, then it would be possible for the parent feature to `nil` out the child state, in which case the child feature would not be able to react to that action. That can cause subtle bugs.

- When a `StackAction.popFrom(id:)` action is sent it runs the parent feature before the child state is popped off the stack. This gives the parent feature an opportunity to inspect the child state one last time before the state is removed.

- When a `StackAction.push(id:state:)` action is sent it runs the parent feature after the child state is appended to the stack. This gives the parent feature an opportunity to make extra mutations to the state after it has been added.
- It automatically cancels all child effects when it detects the child’s state is removed from the stack

- It gives the child feature access to the `DismissEffect` dependency, which allows the child feature to dismiss itself without communicating with the parent.

- forEach(\_:action:destination:fileID:filePath:line:column:)
- Parameters
- Return Value
- Discussion

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:element:fileid:filepath:line:column:)-9fscv

-9fscv/#app-main)

- ComposableArchitecture
- Reducer
- forEach(\_:action:element:fileID:filePath:line:column:) Deprecated

Instance Method

# forEach(\_:action:element:fileID:filePath:line:column:)

@warn_unqualified_access

_ toElementsState: WritableKeyPath<Self.State, IdentifiedArray<ID, ElementState>>,

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:element:fileid:filepath:line:column:)-exyt

-exyt/#app-main)

- ComposableArchitecture
- Reducer
- forEach(\_:action:element:fileID:filePath:line:column:)

Instance Method

# forEach(\_:action:element:fileID:filePath:line:column:)

Embeds a child reducer in a parent domain that works on elements of a collection in parent state.

@warn_unqualified_access

_ toElementsState: WritableKeyPath<Self.State, IdentifiedArray<ID, ElementState>>,
action toElementAction: CaseKeyPath<Self.Action, IdentifiedAction<ID, ElementAction>>,

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

## Parameters

`toElementsState`

A writable key path from parent state to an `IdentifiedArray` of child state.

`toElementAction`

A case path from parent action to an `IdentifiedAction` of child actions.

`element`

A reducer that will be invoked with child actions against elements of child state.

`fileID`

The fileID.

`filePath`

The filePath.

`line`

The line.

`column`

The column.

## Return Value

A reducer that combines the child reducer with the parent reducer.

## Discussion

For example, if a parent feature holds onto an array of child states, then it can perform its core logic _and_ the child’s logic by using the `forEach` operator:

@Reducer
struct Parent {
struct State {

}
enum Action {

// ...
}

Reduce { state, action in
// Core logic for parent feature
}
.forEach(\.rows, action: \.rows) {
Row()
}
}
}

The `forEach` forces a specific order of operations for the child and parent features. It runs the child first, and then the parent. If the order was reversed, then it would be possible for the parent feature to remove the child state from the array, in which case the child feature would not be able to react to that action. That can cause subtle bugs.

It is still possible for a parent feature higher up in the application to remove the child state from the array before the child has a chance to react to the action. In such cases a runtime warning is shown in Xcode to let you know that there’s a potential problem.

- forEach(\_:action:element:fileID:filePath:line:column:)
- Parameters
- Return Value
- Discussion

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/ifcaselet(_:action:then:fileid:filepath:line:column:)-1oxkp

-1oxkp/#app-main)

- ComposableArchitecture
- Reducer
- ifCaseLet(\_:action:then:fileID:filePath:line:column:) Deprecated

Instance Method

# ifCaseLet(\_:action:then:fileID:filePath:line:column:)

@warn_unqualified_access

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/ifcaselet(_:action:then:fileid:filepath:line:column:)-3myuz

-3myuz/#app-main)

- ComposableArchitecture
- Reducer
- ifCaseLet(\_:action:then:fileID:filePath:line:column:)

Instance Method

# ifCaseLet(\_:action:then:fileID:filePath:line:column:)

Embeds a child reducer in a parent domain that works on a case of parent enum state.

@warn_unqualified_access

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

## Parameters

`toCaseState`

A case path from parent state to a case containing child state.

`toCaseAction`

A case path from parent action to a case containing child actions.

`case`

A reducer that will be invoked with child actions against child state when it is present

`fileID`

The fileID.

`filePath`

The filePath.

`line`

The line.

`column`

The column.

## Return Value

A reducer that combines the child reducer with the parent reducer.

## Discussion

For example, if a parent feature’s state is expressed as an enum of multiple children states, then `ifCaseLet` can run a child reducer on a particular case of the enum:

@Reducer
struct Parent {
enum State {
case loggedIn(Authenticated.State)
case loggedOut(Unauthenticated.State)
}
enum Action {
case loggedIn(Authenticated.Action)
case loggedOut(Unauthenticated.Action)
// ...
}

Reduce { state, action in
// Core logic for parent feature
}
.ifCaseLet(\.loggedIn, action: \.loggedIn) {
Authenticated()
}
.ifCaseLet(\.loggedOut, action: \.loggedOut) {
Unauthenticated()
}
}
}

The `ifCaseLet` operator does a number of things to try to enforce correctness:

- It forces a specific order of operations for the child and parent features. It runs the child first, and then the parent. If the order was reversed, then it would be possible for the parent feature to change the case of the child enum, in which case the child feature would not be able to react to that action. That can cause subtle bugs.

- It automatically cancels all child effects when it detects the child enum case changes.

It is still possible for a parent feature higher up in the application to change the case of the enum before the child has a chance to react to the action. In such cases a runtime warning is shown in Xcode to let you know that there’s a potential problem.

- ifCaseLet(\_:action:then:fileID:filePath:line:column:)
- Parameters
- Return Value
- Discussion

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:destination:fileid:filepath:line:column:)-1dc5e

-1dc5e/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:destination:fileID:filePath:line:column:)

Instance Method

# ifLet(\_:action:destination:fileID:filePath:line:column:)

Embeds a child reducer in a parent domain that works on an optional property of parent state.

@warn_unqualified_access

_ toPresentationState: WritableKeyPath<Self.State, PresentationState<DestinationState>>,
action toPresentationAction: CaseKeyPath<Self.Action, PresentationAction<DestinationAction>>,

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

## Parameters

`toPresentationState`

A writable key path from parent state to a property containing child presentation state.

`toPresentationAction`

A case path from parent action to a case containing child actions.

`destination`

A reducer that will be invoked with child actions against presented child state.

`fileID`

The fileID.

`filePath`

The filePath.

`line`

The line.

`column`

The column.

## Return Value

A reducer that combines the child reducer with the parent reducer.

## Discussion

This version of `ifLet` requires the usage of the `Presents()` macro and `PresentationAction` type in your feature’s domain.

For example, if a parent feature holds onto a piece of optional child state, then it can perform its core logic _and_ the child’s logic by using the `ifLet` operator:

@Reducer
struct Parent {
@ObservableState
struct State {
@Presents var child: Child.State?
// ...
}
enum Action {

// ...
}

Reduce { state, action in
// Core logic for parent feature
}
.ifLet(\.$child, action: \.child) {
Child()
}
}
}

The `ifLet` operator does a number of things to make integrating parent and child features ergonomic and enforce correctness:

- It forces a specific order of operations for the child and parent features:

- When a `PresentationAction.dismiss` action is sent, it runs the parent feature before the child state is `nil`’d out. This gives the parent feature an opportunity to inspect the child state one last time before the state is cleared.

- When a `PresentationAction.presented(_:)` action is sent it runs the child first, and then the parent. If the order was reversed, then it would be possible for the parent feature to `nil` out the child state, in which case the child feature would not be able to react to that action. That can cause subtle bugs.
- It automatically cancels all child effects when it detects the child’s state is `nil`’d out.

- Automatically `nil` s out child state when an action is sent for alerts and confirmation dialogs.

- It gives the child feature access to the `DismissEffect` dependency, which allows the child feature to dismiss itself without communicating with the parent.

- ifLet(\_:action:destination:fileID:filePath:line:column:)
- Parameters
- Return Value
- Discussion

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:destination:fileid:filepath:line:column:)-9flmq

-9flmq/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:destination:fileID:filePath:line:column:) Deprecated

Instance Method

# ifLet(\_:action:destination:fileID:filePath:line:column:)

@warn_unqualified_access

_ toPresentationState: WritableKeyPath<Self.State, PresentationState<DestinationState>>,
action toPresentationAction: AnyCasePath<Self.Action, PresentationAction<DestinationAction>>,

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-11rub

-11rub/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:fileID:filePath:line:column:)

Instance Method

# ifLet(\_:action:fileID:filePath:line:column:)

A special overload of `Reducer/ifLet(_:action:then:fileID:filePath:line:column:)-2r2pn` for alerts and confirmation dialogs that does not require a child reducer.

@warn_unqualified_access

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-1nb9r

-1nb9r/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:fileID:filePath:line:column:)

Instance Method

# ifLet(\_:action:fileID:filePath:line:column:)

A special overload of `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` for alerts and confirmation dialogs that does not require a child reducer.

@warn_unqualified_access

_ toPresentationState: WritableKeyPath<Self.State, PresentationState<DestinationState>>,
action toPresentationAction: CaseKeyPath<Self.Action, PresentationAction<DestinationAction>>,
fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-4pj5v

-4pj5v/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:fileID:filePath:line:column:) Deprecated

Instance Method

# ifLet(\_:action:fileID:filePath:line:column:)

@warn_unqualified_access

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column
) -> _IfLetReducer<Self, EmptyReducer<WrappedState, WrappedAction>> where WrappedState : _EphemeralState

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-5daay

-5daay/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:fileID:filePath:line:column:) Deprecated

Instance Method

# ifLet(\_:action:fileID:filePath:line:column:)

@warn_unqualified_access

_ toPresentationState: WritableKeyPath<Self.State, PresentationState<DestinationState>>,
action toPresentationAction: AnyCasePath<Self.Action, PresentationAction<DestinationAction>>,
fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:then:fileid:filepath:line:column:)-24blc

-24blc/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:then:fileID:filePath:line:column:)

Instance Method

# ifLet(\_:action:then:fileID:filePath:line:column:)

Embeds a child reducer in a parent domain that works on an optional property of parent state.

@warn_unqualified_access

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

## Parameters

`toWrappedState`

A writable key path from parent state to a property containing optional child state.

`toWrappedAction`

A case path from parent action to a case containing child actions.

`wrapped`

A reducer that will be invoked with child actions against non-optional child state.

`fileID`

The fileID.

`filePath`

The filePath.

`line`

The line.

`column`

The column.

## Return Value

A reducer that combines the child reducer with the parent reducer.

## Discussion

For example, if a parent feature holds onto a piece of optional child state, then it can perform its core logic _and_ the child’s logic by using the `ifLet` operator:

@Reducer
struct Parent {
struct State {
var child: Child.State?
// ...
}
enum Action {
case child(Child.Action)
// ...
}

Reduce { state, action in
// Core logic for parent feature
}
.ifLet(\.child, action: \.child) {
Child()
}
}
}

The `ifLet` operator does a number of things to try to enforce correctness:

- It forces a specific order of operations for the child and parent features. It runs the child first, and then the parent. If the order was reversed, then it would be possible for the parent feature to `nil` out the child state, in which case the child feature would not be able to react to that action. That can cause subtle bugs.

- It automatically cancels all child effects when it detects the child’s state is `nil`’d out.

- Automatically `nil` s out child state when an action is sent for alerts and confirmation dialogs.

See `Reducer/ifLet(_:action:destination:fileID:filePath:line:column:)-4ub6q` for a more advanced operator suited to navigation.

- ifLet(\_:action:then:fileID:filePath:line:column:)
- Parameters
- Return Value
- Discussion

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:then:fileid:filepath:line:column:)-94ggc

-94ggc/#app-main)

- ComposableArchitecture
- Reducer
- ifLet(\_:action:then:fileID:filePath:line:column:) Deprecated

Instance Method

# ifLet(\_:action:then:fileID:filePath:line:column:)

@warn_unqualified_access

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/casereducer

- ComposableArchitecture
- Reducer
- Reducer()
- CaseReducer

Protocol

# CaseReducer

A reducer represented by multiple enum cases.

## Overview

You should not conform to this protocol directly. Instead, the `Reducer()` macro will add a conformance to enums.

## Topics

### Associated Types

`associatedtype Action = Self.Action`

**Required**

`associatedtype Body = Self.Body`

`associatedtype CaseScope`

`associatedtype State = Self.State`

### Type Properties

`static var body: Self.Body`

**Required** Default implementation provided.

### Type Methods

## Relationships

### Inherits From

- `Reducer`

## See Also

### Enum reducers

`macro Reducer(state: _SynthesizedConformance..., action: _SynthesizedConformance...)`

An overload of `Reducer()` that takes a description of protocol conformances to synthesize on the State and Action types

Deprecated

`macro ReducerCaseEphemeral()`

Marks the case of an enum reducer as holding onto “ephemeral” state.

`macro ReducerCaseIgnored()`

Marks the case of an enum reducer as “ignored”, and as such will not compose the case’s domain into the rest of the reducer besides state.

`protocol CaseReducerState`

A state type that is associated with a `CaseReducer`.

- CaseReducer
- Overview
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer())

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/action)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/body-20w8t)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reduce)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/none)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer).

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/scope),

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/body-20w8t).

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/treebasednavigation)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/stackbasednavigation)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/scope)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/stackbasednavigation),

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftui/navigationstack/init(path:root:destination:fileid:filepath:line:column:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/store/case)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducercaseignored())

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducercaseephemeral())

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducerbuilder)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/combinereducers)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/emptyreducer)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/bindingreducer)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swift/optional)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/transformdependency(_:transform:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/onchange(of:_:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/signpost(_:log:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/_printchanges(_:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducerof)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducerdeprecations)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/dependency(_:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:destination:fileid:filepath:line:column:)-2frtf)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:destination:fileid:filepath:line:column:)-7fv3l)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:element:fileid:filepath:line:column:)-9fscv)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/foreach(_:action:element:fileid:filepath:line:column:)-exyt)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/ifcaselet(_:action:then:fileid:filepath:line:column:)-1oxkp)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/ifcaselet(_:action:then:fileid:filepath:line:column:)-3myuz)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:destination:fileid:filepath:line:column:)-1dc5e)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:destination:fileid:filepath:line:column:)-9flmq)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-11rub)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-1nb9r)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-4pj5v)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:fileid:filepath:line:column:)-5daay)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:then:fileid:filepath:line:column:)-24blc)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/reducer/iflet(_:action:then:fileid:filepath:line:column:)-94ggc)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/casereducer)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/

- ComposableArchitecture
- Effect

Structure

# Effect

## Topics

### Creating an effect

An effect that does nothing and completes immediately. Useful for situations where you must return an effect, but you don’t need to do anything.

Wraps an asynchronous unit of work that can emit actions any number of times in an effect.

Initializes an effect that immediately emits the action passed in.

`typealias EffectOf`

A convenience type alias for referring to an effect of a given reducer’s domain.

`enum TaskResult`

A value that represents either a success or a failure. This type differs from Swift’s `Result` type in that it uses only one generic for the success case, leaving the failure case as an untyped `Error`.

Deprecated

### Cancellation

Turns an effect into one that is capable of being canceled.

An effect that will cancel any currently in-flight effect with the given identifier.

Execute an operation with a cancellation identifier.

`static func cancel(id: some Hashable & Sendable)`

Cancel any currently in-flight operation with the given identifier.

### Composition

Transforms all elements from the upstream effect with a provided closure.

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

`static func merge(some Sequence<Effect<Action>>) -> Effect<Action>`

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

Merges this effect and another into a single effect that runs both at the same time.

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

`static func concatenate(some Collection<Effect<Action>>) -> Effect<Action>`

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

### SwiftUI integration

Wraps the emission of each element with SwiftUI’s `withAnimation`.

Wraps the emission of each element with SwiftUI’s `withTransaction`.

### Combine integration

Creates an effect from a Combine publisher.

Turns an effect into one that can be debounced.

Throttles an effect so that it only publishes one output per given interval.

## Relationships

### Conforms To

- `Swift.Sendable`

## See Also

### State management

`protocol Reducer`

A protocol that describes how to evolve the current state of an application to the next state, given an action, and describes what `Effect` s should be executed later by the store, if any.

`class Store`

A store represents the runtime that powers the application. It is the object that you will pass around to views that need to interact with the application.

Sharing state

Learn techniques for sharing state throughout many parts of your application, and how to persist data to user defaults, the file system, and other external mediums.

- Effect
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/run(priority:operation:catch:fileid:filepath:line:column:)

/#app-main)

- ComposableArchitecture
- Effect
- run(priority:operation:catch:fileID:filePath:line:column:)

Type Method

# run(priority:operation:catch:fileID:filePath:line:column:)

Wraps an asynchronous unit of work that can emit actions any number of times in an effect.

static func run(
priority: TaskPriority? = nil,

fileID: StaticString = #fileID,
filePath: StaticString = #filePath,
line: UInt = #line,
column: UInt = #column

## Parameters

`priority`

Priority of the underlying task. If `nil`, the priority will come from `Task.currentPriority`.

`operation`

The operation to execute.

`handler`

An error handler, invoked if the operation throws an error other than `CancellationError`.

`fileID`

The fileID.

`filePath`

The filePath.

`line`

The line.

`column`

The column.

## Return Value

An effect wrapping the given asynchronous work.

## Discussion

For example, if you had an async sequence in a dependency client:

struct EventsClient {

Then you could attach to it in a `run` effect by using `for await` and sending each action of the stream back into the system:

case .startButtonTapped:
return .run { send in
for await event in self.events() {
send(.event(event))
}
}

See `Send` for more information on how to use the `send` argument passed to `run`’s closure.

The closure provided to `run(priority:operation:catch:fileID:filePath:line:column:)` is allowed to throw, but any non-cancellation errors thrown will cause a runtime warning when run in the simulator or on a device, and will cause a test failure in tests. To catch non-cancellation errors use the `catch` trailing closure.

## Topics

### Sending actions

`struct Send`

A type that can send actions back into the system when used from `run(priority:operation:catch:fileID:filePath:line:column:)`.

## See Also

### Creating an effect

An effect that does nothing and completes immediately. Useful for situations where you must return an effect, but you don’t need to do anything.

Initializes an effect that immediately emits the action passed in.

`typealias EffectOf`

A convenience type alias for referring to an effect of a given reducer’s domain.

`enum TaskResult`

A value that represents either a success or a failure. This type differs from Swift’s `Result` type in that it uses only one generic for the success case, leaving the failure case as an untyped `Error`.

Deprecated

- run(priority:operation:catch:fileID:filePath:line:column:)
- Parameters
- Return Value
- Discussion
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/send(_:)

/#app-main)

- ComposableArchitecture
- Effect
- send(\_:)

Type Method

# send(\_:)

Initializes an effect that immediately emits the action passed in.

## Parameters

`action`

The action that is immediately emitted by the effect.

## Discussion

## Topics

### Animating actions

## See Also

### Creating an effect

An effect that does nothing and completes immediately. Useful for situations where you must return an effect, but you don’t need to do anything.

Wraps an asynchronous unit of work that can emit actions any number of times in an effect.

`typealias EffectOf`

A convenience type alias for referring to an effect of a given reducer’s domain.

`enum TaskResult`

A value that represents either a success or a failure. This type differs from Swift’s `Result` type in that it uses only one generic for the success case, leaving the failure case as an untyped `Error`.

Deprecated

- send(\_:)
- Parameters
- Discussion
- Topics
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effectof

- ComposableArchitecture
- Effect
- EffectOf

Type Alias

# EffectOf

A convenience type alias for referring to an effect of a given reducer’s domain.

## Discussion

Instead of specifying the action:

You can specify the reducer:

## See Also

### Creating an effect

An effect that does nothing and completes immediately. Useful for situations where you must return an effect, but you don’t need to do anything.

Wraps an asynchronous unit of work that can emit actions any number of times in an effect.

Initializes an effect that immediately emits the action passed in.

`enum TaskResult`

A value that represents either a success or a failure. This type differs from Swift’s `Result` type in that it uses only one generic for the success case, leaving the failure case as an untyped `Error`.

Deprecated

- EffectOf
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/taskresult

- ComposableArchitecture
- Effect
- TaskResult Deprecated

Enumeration

# TaskResult

A value that represents either a success or a failure. This type differs from Swift’s `Result` type in that it uses only one generic for the success case, leaving the failure case as an untyped `Error`.

## Overview

If someday Swift gets typed `throws`, then we can eliminate this type and rely solely on `Result`.

You typically use this type as the payload of an action which receives a response from an effect:

enum Action: Equatable {
case factButtonTapped

}

Then you can model your dependency as using simple `async` and `throws` functionality:

struct NumberFactClient {

And finally you can use `run(priority:operation:catch:fileID:filePath:line:column:)` to construct an effect in the reducer that invokes the `numberFact` endpoint and wraps its response in a `TaskResult` by using its catching initializer, `init(catching:)`:

case .factButtonTapped:
return .run { send in
await send(
.factResponse(
TaskResult { try await self.numberFact.fetch(state.number) }
)
)
}

case let .factResponse(.success(fact)):
// do something with fact

case .factResponse(.failure):
// handle error

// ...
}

## Equality

The biggest downside to using an untyped `Error` in a result type is that the result will not be equatable even if the success type is. This negatively affects your ability to test features that use `TaskResult` in their actions with the `TestStore`.

`TaskResult` does extra work to try to maintain equatability when possible. If the underlying type masked by the `Error` is `Equatable`, then it will use that `Equatable` conformance on two failures. Luckily, most errors thrown by Apple’s frameworks are already equatable, and because errors are typically simple value types, it is usually possible to have the compiler synthesize a conformance for you.

If you are testing the unhappy path of a feature that feeds a `TaskResult` back into the system, be sure to conform the error to equatable, or the test will fail:

// Set up a failing dependency
struct RefreshFailure: Error {}
store.dependencies.apiClient.fetchFeed = { throw RefreshFailure() }

// Simulate pull-to-refresh
store.send(.refresh) { $0.isLoading = true }

// Assert against failure
await store.receive(.refreshResponse(.failure(RefreshFailure())) { // 🛑
$0.errorLabelText = "An error occurred."
$0.isLoading = false
}
// 🛑 'RefreshFailure' is not equatable

To get a passing test, explicitly conform your custom error to the `Equatable` protocol:

// Set up a failing dependency
struct RefreshFailure: Error, Equatable {} // 👈
store.dependencies.apiClient.fetchFeed = { throw RefreshFailure() }

// Assert against failure
await store.receive(.refreshResponse(.failure(RefreshFailure())) { // ✅
$0.errorLabelText = "An error occurred."
$0.isLoading = false
}

## Topics

### Representing a task result

`case success(Success)`

A success, storing a `Success` value.

`case failure(any Error)`

A failure, storing an error.

### Converting a throwing expression

Creates a new task result by evaluating an async throwing closure, capturing the returned value as a success, or any thrown error as a failure.

### Accessing a result’s value

`var value: Success`

Returns the success value as a throwing property.

### Transforming results

Returns a new task result, mapping any success value using the given transformation.

Returns a new task result, mapping any success value using the given transformation and unwrapping the produced result.

Transforms a `Result` into a `TaskResult`, erasing its `Failure` to `Error`.

Transforms a `TaskResult` into a `Result`.

## Relationships

### Conforms To

- `CasePathsCore.CasePathable`
- `Swift.Copyable`
- `Swift.Equatable`
- `Swift.Hashable`
- `Swift.Sendable`

## See Also

### Creating an effect

An effect that does nothing and completes immediately. Useful for situations where you must return an effect, but you don’t need to do anything.

Wraps an asynchronous unit of work that can emit actions any number of times in an effect.

Initializes an effect that immediately emits the action passed in.

`typealias EffectOf`

A convenience type alias for referring to an effect of a given reducer’s domain.

- TaskResult
- Overview
- Equality
- Topics
- Relationships
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/cancellable(id:cancelinflight:)

/#app-main)

- ComposableArchitecture
- Effect
- cancellable(id:cancelInFlight:)

Instance Method

# cancellable(id:cancelInFlight:)

Turns an effect into one that is capable of being canceled.

func cancellable(
id: some Hashable & Sendable,
cancelInFlight: Bool = false

## Parameters

`id`

The effect’s identifier.

`cancelInFlight`

Determines if any in-flight effect with the same identifier should be canceled before starting this new one.

## Return Value

A new effect that is capable of being canceled by an identifier.

## Discussion

To turn an effect into a cancellable one you must provide an identifier, which is used in `cancel(id:)` to identify which in-flight effect should be canceled. Any hashable value can be used for the identifier, such as a string, but you can add a bit of protection against typos by defining a new type for the identifier:

enum CancelID { case loadUser }

case .reloadButtonTapped:
// Start a new effect to load the user
return .run { send in
await send(
.userResponse(
TaskResult { try await self.apiClient.loadUser() }
)
)
}
.cancellable(id: CancelID.loadUser, cancelInFlight: true)

case .cancelButtonTapped:
// Cancel any in-flight requests to load the user
return .cancel(id: CancelID.loadUser)

## See Also

### Cancellation

An effect that will cancel any currently in-flight effect with the given identifier.

Execute an operation with a cancellation identifier.

`static func cancel(id: some Hashable & Sendable)`

Cancel any currently in-flight operation with the given identifier.

- cancellable(id:cancelInFlight:)
- Parameters
- Return Value
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/cancel(id:)

/#app-main)

- ComposableArchitecture
- Effect
- cancel(id:)

Type Method

# cancel(id:)

An effect that will cancel any currently in-flight effect with the given identifier.

## Parameters

`id`

An effect identifier.

## Return Value

A new effect that will cancel any currently in-flight effect with the given identifier.

## See Also

### Cancellation

Turns an effect into one that is capable of being canceled.

Execute an operation with a cancellation identifier.

`static func cancel(id: some Hashable & Sendable)`

Cancel any currently in-flight operation with the given identifier.

- cancel(id:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/withtaskcancellation(id:cancelinflight:isolation:operation:)

/#app-main)

- ComposableArchitecture
- Effect
- withTaskCancellation(id:cancelInFlight:isolation:operation:)

Function

# withTaskCancellation(id:cancelInFlight:isolation:operation:)

Execute an operation with a cancellation identifier.

id: some Hashable & Sendable,
cancelInFlight: Bool = false,
isolation: isolated (any Actor)? = #isolation,

## Parameters

`id`

A unique identifier for the operation.

`cancelInFlight`

Determines if any in-flight operation with the same identifier should be canceled before starting this new one.

`isolation`

The isolation of the operation.

`operation`

An async operation.

## Return Value

A value produced by operation.

## Discussion

If the operation is in-flight when `Task.cancel(id:)` is called with the same identifier, the operation will be cancelled.

enum CancelID { case timer }

await withTaskCancellation(id: CancelID.timer) {
// Start cancellable timer...
}

### Debouncing tasks

When paired with a clock, this function can be used to debounce a unit of async work by specifying the `cancelInFlight`, which will automatically cancel any in-flight work with the same identifier:

@Dependency(\.continuousClock) var clock
enum CancelID { case response }

// ...

return .run { send in
try await withTaskCancellation(id: CancelID.response, cancelInFlight: true) {
try await self.clock.sleep(for: .seconds(0.3))
await send(
.debouncedResponse(TaskResult { try await environment.request() })
)
}
}

## See Also

### Cancellation

Turns an effect into one that is capable of being canceled.

An effect that will cancel any currently in-flight effect with the given identifier.

`static func cancel(id: some Hashable & Sendable)`

Cancel any currently in-flight operation with the given identifier.

- withTaskCancellation(id:cancelInFlight:isolation:operation:)
- Parameters
- Return Value
- Discussion
- Debouncing tasks
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/_concurrency/task/cancel(id:)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/map(_:)

/#app-main)

- ComposableArchitecture
- Effect
- map(\_:)

Instance Method

# map(\_:)

Transforms all elements from the upstream effect with a provided closure.

## Parameters

`transform`

A closure that transforms the upstream effect’s action to a new action.

## Return Value

A publisher that uses the provided closure to map elements from the upstream effect to new elements that it then publishes.

## See Also

### Composition

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

`static func merge(some Sequence<Effect<Action>>) -> Effect<Action>`

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

Merges this effect and another into a single effect that runs both at the same time.

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

`static func concatenate(some Collection<Effect<Action>>) -> Effect<Action>`

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

- map(\_:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/merge(_:)-5ai73

-5ai73/#app-main)

- ComposableArchitecture
- Effect
- merge(\_:)

Type Method

# merge(\_:)

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

## Parameters

`effects`

A variadic list of effects.

## Return Value

A new effect

## See Also

### Composition

Transforms all elements from the upstream effect with a provided closure.

`static func merge(some Sequence<Effect<Action>>) -> Effect<Action>`

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

Merges this effect and another into a single effect that runs both at the same time.

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

`static func concatenate(some Collection<Effect<Action>>) -> Effect<Action>`

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

- merge(\_:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/merge(_:)-8ckqn

-8ckqn/#app-main)

- ComposableArchitecture
- Effect
- merge(\_:)

Type Method

# merge(\_:)

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

static func merge(_ effects: some Sequence<Effect<Action>>) -> Effect<Action>

## Parameters

`effects`

A sequence of effects.

## Return Value

A new effect

## See Also

### Composition

Transforms all elements from the upstream effect with a provided closure.

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

Merges this effect and another into a single effect that runs both at the same time.

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

`static func concatenate(some Collection<Effect<Action>>) -> Effect<Action>`

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

- merge(\_:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/merge(with:)

/#app-main)

- ComposableArchitecture
- Effect
- merge(with:)

Instance Method

# merge(with:)

Merges this effect and another into a single effect that runs both at the same time.

## Parameters

`other`

Another effect.

## Return Value

An effect that runs this effect and the other at the same time.

## See Also

### Composition

Transforms all elements from the upstream effect with a provided closure.

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

`static func merge(some Sequence<Effect<Action>>) -> Effect<Action>`

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

`static func concatenate(some Collection<Effect<Action>>) -> Effect<Action>`

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

- merge(with:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/concatenate(_:)-3iza9

-3iza9/#app-main)

- ComposableArchitecture
- Effect
- concatenate(\_:)

Type Method

# concatenate(\_:)

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

## Parameters

`effects`

A variadic list of effects.

## Return Value

A new effect

## See Also

### Composition

Transforms all elements from the upstream effect with a provided closure.

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

`static func merge(some Sequence<Effect<Action>>) -> Effect<Action>`

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

Merges this effect and another into a single effect that runs both at the same time.

`static func concatenate(some Collection<Effect<Action>>) -> Effect<Action>`

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

- concatenate(\_:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/concatenate(_:)-4gba2

-4gba2/#app-main)

- ComposableArchitecture
- Effect
- concatenate(\_:)

Type Method

# concatenate(\_:)

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

static func concatenate(_ effects: some Collection<Effect<Action>>) -> Effect<Action>

## Parameters

`effects`

A collection of effects.

## Return Value

A new effect

## See Also

### Composition

Transforms all elements from the upstream effect with a provided closure.

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

`static func merge(some Sequence<Effect<Action>>) -> Effect<Action>`

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

Merges this effect and another into a single effect that runs both at the same time.

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

- concatenate(\_:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/concatenate(with:)

/#app-main)

- ComposableArchitecture
- Effect
- concatenate(with:)

Instance Method

# concatenate(with:)

Concatenates this effect and another into a single effect that first runs this effect, and after it completes or is cancelled, runs the other.

## Parameters

`other`

Another effect.

## Return Value

An effect that runs this effect, and after it completes or is cancelled, runs the other.

## See Also

### Composition

Transforms all elements from the upstream effect with a provided closure.

Merges a variadic list of effects together into a single effect, which runs the effects at the same time.

`static func merge(some Sequence<Effect<Action>>) -> Effect<Action>`

Merges a sequence of effects together into a single effect, which runs the effects at the same time.

Merges this effect and another into a single effect that runs both at the same time.

Concatenates a variadic list of effects together into a single effect, which runs the effects one after the other.

`static func concatenate(some Collection<Effect<Action>>) -> Effect<Action>`

Concatenates a collection of effects together into a single effect, which runs the effects one after the other.

- concatenate(with:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/animation(_:)

/#app-main)

- ComposableArchitecture
- Effect
- animation(\_:)

Instance Method

# animation(\_:)

Wraps the emission of each element with SwiftUI’s `withAnimation`.

## Parameters

`animation`

An animation.

## Return Value

A publisher.

## Discussion

case .buttonTapped:
return .run { send in
await send(.activityResponse(self.apiClient.fetchActivity()))
}
.animation()

## See Also

### SwiftUI integration

Wraps the emission of each element with SwiftUI’s `withTransaction`.

- animation(\_:)
- Parameters
- Return Value
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/transaction(_:)

/#app-main)

- ComposableArchitecture
- Effect
- transaction(\_:)

Instance Method

# transaction(\_:)

Wraps the emission of each element with SwiftUI’s `withTransaction`.

## Parameters

`transaction`

A transaction.

## Return Value

A publisher.

## Discussion

case .buttonTapped:
var transaction = Transaction(animation: .default)
transaction.disablesAnimations = true
return .run { send in
await send(.activityResponse(self.apiClient.fetchActivity()))
}
.transaction(transaction)

## See Also

### SwiftUI integration

Wraps the emission of each element with SwiftUI’s `withAnimation`.

- transaction(\_:)
- Parameters
- Return Value
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/publisher(_:)

/#app-main)

- ComposableArchitecture
- Effect
- publisher(\_:)

Type Method

# publisher(\_:)

Creates an effect from a Combine publisher.

## Parameters

`createPublisher`

The closure to execute when the effect is performed.

## Return Value

An effect wrapping a Combine publisher.

## See Also

### Combine integration

Turns an effect into one that can be debounced.

Throttles an effect so that it only publishes one output per given interval.

- publisher(\_:)
- Parameters
- Return Value
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/debounce(id:for:scheduler:options:)

/#app-main)

- ComposableArchitecture
- Effect
- debounce(id:for:scheduler:options:)

Instance Method

# debounce(id:for:scheduler:options:)

Turns an effect into one that can be debounced.

id: some Hashable & Sendable,
for dueTime: S.SchedulerTimeType.Stride,
scheduler: S,
options: S.SchedulerOptions? = nil

## Parameters

`id`

The effect’s identifier.

`dueTime`

The duration you want to debounce for.

`scheduler`

The scheduler you want to deliver the debounced output to.

`options`

Scheduler options that customize the effect’s delivery of elements.

## Return Value

An effect that publishes events only after a specified time elapses.

## Discussion

To turn an effect into a debounce-able one you must provide an identifier, which is used to determine which in-flight effect should be canceled in order to start a new effect. Any hashable value can be used for the identifier, such as a string, but you can add a bit of protection against typos by defining a new type that conforms to `Hashable`, such as an enum:

case let .textChanged(text):
enum CancelID { case search }

return .run { send in
await send(
.searchResponse(
TaskResult { await self.apiClient.search(text) }
)
)
}
.debounce(id: CancelID.search, for: 0.5, scheduler: self.mainQueue)

## See Also

### Combine integration

Creates an effect from a Combine publisher.

Throttles an effect so that it only publishes one output per given interval.

- debounce(id:for:scheduler:options:)
- Parameters
- Return Value
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/throttle(id:for:scheduler:latest:)

/#app-main)

- ComposableArchitecture
- Effect
- throttle(id:for:scheduler:latest:)

Instance Method

# throttle(id:for:scheduler:latest:)

Throttles an effect so that it only publishes one output per given interval.

id: some Hashable & Sendable,
for interval: S.SchedulerTimeType.Stride,
scheduler: S,
latest: Bool

Available when `Action` conforms to `Sendable`.

## Parameters

`id`

The effect’s identifier.

`interval`

The interval at which to find and emit the most recent element, expressed in the time system of the scheduler.

`scheduler`

The scheduler you want to deliver the throttled output to.

`latest`

A boolean value that indicates whether to publish the most recent element. If `false`, the publisher emits the first element received during the interval.

## Return Value

An effect that emits either the most-recent or first element received during the specified interval.

## Discussion

The throttling of an effect is with respect to actions being sent into the store. So, if you return a throttled effect from an action that is sent with high frequency, the effect will be executed at most once per interval specified.

## See Also

### Combine integration

Creates an effect from a Combine publisher.

Turns an effect into one that can be debounced.

- throttle(id:for:scheduler:latest:)
- Parameters
- Return Value
- Discussion
- See Also

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/run(priority:operation:catch:fileid:filepath:line:column:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/send(_:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effectof)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/taskresult)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/cancellable(id:cancelinflight:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/cancel(id:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/withtaskcancellation(id:cancelinflight:isolation:operation:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/_concurrency/task/cancel(id:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/map(_:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/merge(_:)-5ai73)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/merge(_:)-8ckqn)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/merge(with:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/concatenate(_:)-3iza9)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/concatenate(_:)-4gba2)

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

# https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/effect/concatenate(with:))

# 404

**File not found**

The site configured at this address does not
contain the requested file.

If this is your site, make sure that the filename case matches the URL
as well as any file permissions.

For root URLs (like `http://example.com/`) you must provide an
`index.html` file.

Read the full documentation
for more information about using **GitHub Pages**.

GitHub Status —
@githubstatus

---

