import SwiftUI
import ComposableArchitecture

struct PreparationView: View {
    @Bindable var store: StoreOf<AppFeature>
    @FocusState private var isGoalFieldFocused: Bool
    
    private var preparationState: Binding<PreparationState> {
        Binding(
            get: {
                guard case let .preparing(state) = store.session else {
                    return PreparationState()
                }
                return state
            },
            set: { newState in
                store.session = .preparing(newState)
            }
        )
    }
    
    private var isTimeInputValid: Bool {
        Int(preparationState.wrappedValue.timeInput).map { $0 > 0 } == true
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Prepare Your Focus Session")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("What's your goal?", systemImage: "target")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleOnly)
                    
                    TextField("e.g., Complete project proposal", text: preparationState.goal)
                        .textFieldStyle(.roundedBorder)
                        .focused($isGoalFieldFocused)
                        .onSubmit {
                            if preparationState.wrappedValue.isStartButtonEnabled {
                                startSession()
                            }
                        }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Expected time (minutes)", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleOnly)
                    
                    TextField("30", text: preparationState.timeInput)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(!preparationState.wrappedValue.timeInput.isEmpty && !isTimeInputValid ? Color.red : Color.clear, lineWidth: 1)
                        )
                        .onSubmit {
                            if preparationState.wrappedValue.isStartButtonEnabled {
                                startSession()
                            }
                        }
                }
                
                if !preparationState.wrappedValue.checklist.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Pre-session checklist", systemImage: "checklist")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .labelStyle(.titleOnly)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(preparationState.wrappedValue.checklist) { item in
                                HStack {
                                    Toggle(isOn: Binding(
                                        get: { item.isCompleted },
                                        set: { _ in
                                            store.send(.preparation(.checklistItemToggled(item.id)))
                                        }
                                    )) {
                                        Text(item.text)
                                            .font(.callout)
                                    }
                                    .toggleStyle(.checkbox)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }
                }
            }
            
            Button(action: startSession) {
                Label("Start Focus", systemImage: "play.fill")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!preparationState.wrappedValue.isStartButtonEnabled || store.isLoading)
            .frame(maxWidth: .infinity)
            .keyboardShortcut(.return, modifiers: .command)
        }
        .onAppear {
            isGoalFieldFocused = true
            store.send(.onAppear)
        }
    }
    
    private func startSession() {
        store.send(.startButtonTapped)
    }
}