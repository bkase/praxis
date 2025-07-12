import SwiftUI
import ComposableArchitecture

struct PreparationView: View {
    @Bindable var store: StoreOf<PreparationFeature>
    @FocusState private var isGoalFieldFocused: Bool
    
    private var isTimeInputValid: Bool {
        Int(store.timeInput).map { $0 > 0 } == true
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
                    
                    TextField("e.g., Complete project proposal", text: Binding(
                        get: { store.goal },
                        set: { store.send(.goalChanged($0)) }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .focused($isGoalFieldFocused)
                    .onSubmit {
                        if store.isStartButtonEnabled {
                            startSession()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Expected time (minutes)", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleOnly)
                    
                    TextField("30", text: Binding(
                        get: { store.timeInput },
                        set: { store.send(.timeInputChanged($0)) }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(!store.timeInput.isEmpty && !isTimeInputValid ? Color.red : Color.clear, lineWidth: 1)
                    )
                    .onSubmit {
                        if store.isStartButtonEnabled {
                            startSession()
                        }
                    }
                }
                
                if !store.checklist.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Pre-session checklist", systemImage: "checklist")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .labelStyle(.titleOnly)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(store.checklist) { item in
                                HStack {
                                    Toggle(
                                        item.text,
                                        isOn: .init(
                                            get: { item.isCompleted },
                                            set: { _ in store.send(.checklistItemToggled(item.id)) }
                                        )
                                    )
                                    .font(.callout)
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
            .disabled(!store.isStartButtonEnabled)
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