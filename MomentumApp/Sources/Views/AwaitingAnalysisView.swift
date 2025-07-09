import SwiftUI
import ComposableArchitecture

struct AwaitingAnalysisView: View {
    let store: StoreOf<AppFeature>
    let reflectionPath: String
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Image(systemName: "doc.text")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                
                Text("Reflection Created")
                    .font(.headline)
                
                Text("Your reflection has been saved. Review it and then analyze it for insights.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 12) {
                    Button("Open Reflection") {
                        NSWorkspace.shared.open(URL(fileURLWithPath: reflectionPath))
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Analyze with AI") {
                        viewStore.send(.analyzeButtonTapped)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewStore.isLoading)
                }
                
                Button("Start New Session") {
                    viewStore.send(.resetToIdle)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.vertical)
        }
    }
}