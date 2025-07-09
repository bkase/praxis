import SwiftUI
import ComposableArchitecture

struct AnalysisResultView: View {
    @Bindable var store: StoreOf<AppFeature>
    let analysis: AnalysisResult
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.accentColor)
                    Text("AI Analysis")
                        .font(.headline)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Summary")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(analysis.summary)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Suggestion")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(analysis.suggestion)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Reasoning")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(analysis.reasoning)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Button("Start New Session") {
                    store.send(.resetToIdle)
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .keyboardShortcut("n", modifiers: .command)
            }
            .padding(.vertical)
        }
    }
}