import SwiftUI
import ComposableArchitecture

struct PreparationView: View {
    @Bindable var store: StoreOf<PreparationFeature>
    @FocusState private var isGoalFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            titleSection
            
            VStack(alignment: .leading, spacing: 24) {
                intentionInput
                durationPicker
                checklistSection
            }
            
            buttonAndProgress
        }
        .frame(width: 320)
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .background(Color.canvasBackground)
        .onAppear {
            isGoalFieldFocused = true
            store.send(.onAppear)
        }
    }
    
    private var titleSection: some View {
        Text("Compose Your Intention")
            .font(.momentumTitle)
            .foregroundStyle(Color.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 24)
    }
    
    private var intentionInput: some View {
        TextField("What will you accomplish?", text: Binding(
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
    }
    
    private var durationPicker: some View {
        HStack(spacing: 8) {
            Text("Estimated duration")
                .font(.system(size: 14))
                .foregroundStyle(Color.textPrimary)
            
            TextField("30", text: Binding(
                get: { store.timeInput },
                set: { store.send(.timeInputChanged($0)) }
            ))
            .frame(width: 60)
            .multilineTextAlignment(.center)
            .font(.system(size: 15, weight: .medium))
            .textFieldStyle(DurationTextFieldStyle())
            .onSubmit {
                if store.isStartButtonEnabled {
                    startSession()
                }
            }
            
            Text("min")
                .font(.system(size: 14))
                .foregroundStyle(Color.textPrimary)
        }
    }
    
    @ViewBuilder
    private var checklistSection: some View {
        if !store.visibleChecklist.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("GROUNDING RITUAL")
                    .font(.sectionLabel)
                    .foregroundStyle(Color.textSecondary)
                    .tracking(2)
                
                // Fixed height container for 4 items
                VStack(spacing: 4) {
                    ForEach(store.visibleChecklist) { item in
                        checklistRow(for: item)
                    }
                }
                .frame(height: 156) // Fixed height for 4 items
            }
        }
    }
    
    private func checklistRow(for item: ChecklistItem) -> some View {
        let isTransitioning = store.itemTransitions[item.id] != nil
        let isFadingIn = store.itemTransitions.values.contains { transition in
            transition.replacementText == item.text
        }
        
        return ChecklistRowView(
            item: item,
            isTransitioning: isTransitioning,
            isFadingIn: isFadingIn,
            onToggle: {
                store.send(.checklistItemToggled(item.id))
            }
        )
    }
    
    private var buttonAndProgress: some View {
        VStack(spacing: 8) {
            Button("Enter Sanctuary") {
                startSession()
            }
            .buttonStyle(SanctuaryButtonStyle())
            .disabled(!store.isStartButtonEnabled)
            .keyboardShortcut(.return, modifiers: .command)
            
            // Progress indicator
            Text("\(store.totalItemsCompleted) of 10 completed")
                .font(.system(size: 12))
                .foregroundStyle(Color.textSecondary)
                .opacity(store.totalItemsCompleted > 0 ? 1 : 0)
        }
        .padding(.top, 24)
    }
    
    private func startSession() {
        store.send(.startButtonTapped)
    }
}

// Duration text field style
struct DurationTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(hex: "FDF9F1"))
            .cornerRadius(3)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.borderNeutral, lineWidth: 1)
            )
    }
}