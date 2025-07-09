# Xcode Setup Instructions

Since Swift Package Manager macros require manual trust in Xcode, here are the steps to build and run the app:

## 1. Open the Project
The workspace is already open in Xcode from our earlier command:
```
open Momentum.xcworkspace
```

## 2. Trust Macros
When Xcode opens, you'll see warnings about macros from these packages:
- ComposableArchitectureMacros
- CasePathsMacros
- DependenciesMacrosPlugin
- PerceptionMacros

For each one:
1. Click on the warning in the Issue Navigator
2. Click "Trust & Enable" for each macro

## 3. Build the App
1. Select the "MomentumApp" scheme from the scheme selector
2. Select "My Mac" as the destination
3. Press ⌘B to build

## 4. Run the App
1. Press ⌘R to run the app
2. The app will appear in your menu bar with a timer icon
3. Click the icon to open the popover interface

## 5. Test the Features
- Start a session by entering a goal and time
- Stop the session to create a reflection
- Open and edit the reflection file
- Analyze the reflection (currently returns mock data)

## Known Issues
- The Rust binary build script runs on every build (expected)
- Entitlements warning is normal and doesn't affect functionality
- Analysis currently returns mock data (Claude API integration not implemented)

## Next Steps
To complete the Claude API integration:
1. Implement the actual API call in `src/environment.rs`
2. Add your Anthropic API key to your environment
3. Test with real AI analysis