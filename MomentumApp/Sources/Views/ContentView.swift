import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Momentum")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: { NSApp.terminate(nil) }) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                
                // Main content based on session state
                Group {
                    switch viewStore.session {
                    case .idle:
                        IdleView(store: store)
                        
                    case let .active(goal, startTime, expectedMinutes):
                        ActiveSessionView(
                            store: store,
                            goal: goal,
                            startTime: startTime,
                            expectedMinutes: expectedMinutes
                        )
                        
                    case let .awaitingAnalysis(reflectionPath):
                        AwaitingAnalysisView(
                            store: store,
                            reflectionPath: reflectionPath
                        )
                        
                    case let .analyzed(analysis):
                        AnalysisResultView(
                            store: store,
                            analysis: analysis
                        )
                    }
                }
                .padding(.horizontal)
                
                // Error message
                if let errorMessage = viewStore.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        
                        Button("Dismiss") {
                            viewStore.send(.clearError)
                        }
                        .font(.caption)
                    }
                    .padding(.horizontal)
                }
                
                // Loading indicator
                if viewStore.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.7)
                }
                
                Spacer()
            }
            .frame(width: 320, height: 400)
            .background(Color(NSColor.windowBackgroundColor))
        }
    }
}