import SwiftUI
import ComposableArchitecture

struct AwaitingAnalysisView: View {
    @Bindable var store: StoreOf<AppFeature>
    let reflectionPath: String
    
    var body: some View {
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
                .keyboardShortcut("o", modifiers: .command)
                
                Button("Analyze with AI") {
                    store.send(.analyzeButtonTapped)
                }
                .buttonStyle(.borderedProminent)
                .disabled(store.isLoading)
                .keyboardShortcut(.return, modifiers: .command)
            }
            
            Button("Start New Session") {
                store.send(.resetToIdle)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .keyboardShortcut("n", modifiers: .command)
        }
        .padding(.vertical)
    }
}