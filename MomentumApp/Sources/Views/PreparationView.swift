import SwiftUI
import ComposableArchitecture

struct PreparationView: View {
    @Bindable var store: StoreOf<PreparationFeature>
    @FocusState private var isGoalFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Compose Your Intention")
                .font(.momentumTitle)
                .foregroundStyle(Color.textPrimary)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("GROUNDING RITUAL")
                        .font(.sectionLabel)
                        .foregroundStyle(Color.textSecondary)
                        .tracking(0.5)
                    
                    TextField("Write a report", text: Binding(
                        get: { store.goal },
                        set: { store.send(.goalChanged($0)) }
                    ))
                    .textFieldStyle(.intention)
                    .focused($isGoalFieldFocused)
                    .onSubmit {
                        if store.isStartButtonEnabled {
                            startSession()
                        }
                    }
                    
                    DurationPicker(
                        timeInput: Binding(
                            get: { store.timeInput },
                            set: { store.send(.timeInputChanged($0)) }
                        ),
                        onChange: { newValue in
                            store.send(.timeInputChanged(newValue))
                        }
                    )
                }
                
                if !store.checklist.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Pre-session checklist")
                                .font(.sectionLabel)
                                .foregroundStyle(Color.textSecondary)
                                .tracking(0.5)
                            
                            Spacer()
                            
                            ProgressIndicatorView(
                                completed: store.completedChecklistItemCount,
                                total: store.totalChecklistItemCount
                            )
                        }
                        
                        VStack(spacing: 8) {
                            ForEach(store.checklist) { item in
                                ChecklistRowView(
                                    item: item,
                                    onToggle: {
                                        store.send(.checklistItemToggled(item.id))
                                    }
                                )
                            }
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                Button("Enter the Sanctuary") {
                    startSession()
                }
                .buttonStyle(.sanctuary)
                .disabled(!store.isStartButtonEnabled)
                .keyboardShortcut(.return, modifiers: .command)
                Spacer()
            }
            .padding(.top, 12)
        }
        .padding(24)
        .background(Color.canvasBackground)
        .onAppear {
            isGoalFieldFocused = true
            store.send(.onAppear)
        }
    }
    
    private func startSession() {
        store.send(.startButtonTapped)
    }
}