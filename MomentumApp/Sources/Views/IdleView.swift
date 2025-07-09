import SwiftUI
import ComposableArchitecture

struct IdleView: View {
    let store: StoreOf<AppFeature>
    @State private var goal = ""
    @State private var minutes = "30"
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 20) {
                Text("Start a Focus Session")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's your goal?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("e.g., Complete project proposal", text: $goal)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Expected time (minutes)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("30", text: $minutes)
                        .textFieldStyle(.roundedBorder)
                }
                
                Button("Start Session") {
                    if let minutesInt = Int(minutes), !goal.isEmpty {
                        viewStore.send(.startButtonTapped(goal: goal, minutes: minutesInt))
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(goal.isEmpty || Int(minutes) == nil || viewStore.isLoading)
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical)
        }
    }
}