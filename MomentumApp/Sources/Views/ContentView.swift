import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            Divider()
            
            sessionContentView
                .padding()
                .frame(maxHeight: .infinity)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 12) {
                        if store.error != nil {
                            errorView
                        }
                        
                        if store.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(0.7)
                        }
                    }
                }
        }
        .frame(width: 320, height: 400)
        .background(Color(NSColor.windowBackgroundColor))
        .onKeyPress(.escape) {
            if store.isLoading {
                store.send(.cancelCurrentOperation)
                return .handled
            } else if store.error != nil {
                store.send(.clearError)
                return .handled
            }
            return .ignored
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Text("Momentum")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button {
                NSApp.terminate(nil)
            } label: {
                Image(systemName: "xmark.circle")
                    .foregroundStyle(.secondary)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
            .help("Quit Momentum")
        }
        .padding()
    }
    
    @ViewBuilder
    private var sessionContentView: some View {
        switch store.session {
        case .preparing:
            PreparationView(store: store)
                .transition(.opacity)
            
        case let .active(goal, startTime, expectedMinutes):
            ActiveSessionView(
                store: store,
                goal: goal,
                startTime: startTime,
                expectedMinutes: expectedMinutes
            )
            .transition(.opacity)
            
        case let .awaitingAnalysis(reflectionPath):
            AwaitingAnalysisView(
                store: store,
                reflectionPath: reflectionPath
            )
            .transition(.opacity)
            
        case let .analyzed(analysis):
            AnalysisResultView(
                store: store,
                analysis: analysis
            )
            .transition(.opacity)
        }
    }
    
    @ViewBuilder
    private var errorView: some View {
        VStack(spacing: 8) {
            if let errorMessage = store.errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .labelStyle(.titleAndIcon)
            }
            
            if let recovery = store.errorRecovery {
                Text(recovery)
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                    .multilineTextAlignment(.center)
            }
            
            Button("Dismiss") {
                store.send(.clearError)
            }
            .font(.caption)
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}