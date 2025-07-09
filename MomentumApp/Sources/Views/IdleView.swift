import SwiftUI
import ComposableArchitecture

struct IdleView: View {
    @Bindable var store: StoreOf<AppFeature>
    @State private var goal = ""
    @State private var minutes = "30"
    @FocusState private var isGoalFieldFocused: Bool
    
    private var isValidInput: Bool {
        Goal(goal) != nil && Minutes(string: minutes) != nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Start a Focus Session")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("What's your goal?", systemImage: "target")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleOnly)
                    
                    TextField("e.g., Complete project proposal", text: $goal)
                        .textFieldStyle(.roundedBorder)
                        .focused($isGoalFieldFocused)
                        .onSubmit {
                            if isValidInput {
                                startSession()
                            }
                        }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Expected time (minutes)", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleOnly)
                    
                    TextField("30", text: $minutes)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            if isValidInput {
                                startSession()
                            }
                        }
                }
            }
            
            Button(action: startSession) {
                Label("Start Session", systemImage: "play.fill")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!isValidInput || store.isLoading)
            .frame(maxWidth: .infinity)
            .keyboardShortcut(.return, modifiers: .command)
        }
        .onAppear {
            isGoalFieldFocused = true
        }
    }
    
    private func startSession() {
        if let goalValue = Goal(goal), 
           let minutesValue = Minutes(string: minutes) {
            store.send(.startButtonTapped(goal: goalValue, minutes: minutesValue))
        }
    }
}