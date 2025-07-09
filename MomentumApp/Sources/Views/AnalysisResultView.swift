import SwiftUI
import ComposableArchitecture

struct AnalysisResultView: View {
    let store: StoreOf<AppFeature>
    let analysis: AnalysisResult
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(.accentColor)
                        Text("AI Analysis")
                            .font(.headline)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Group {
                            Text("Summary")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(analysis.summary)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        Group {
                            Text("Suggestion")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(analysis.suggestion)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        Group {
                            Text("Reasoning")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(analysis.reasoning)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button("Start New Session") {
                        viewStore.send(.resetToIdle)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                }
                .padding(.vertical)
            }
        }
    }
}