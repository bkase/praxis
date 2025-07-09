import SwiftUI
import ComposableArchitecture

struct ActiveSessionView: View {
    let store: StoreOf<AppFeature>
    let goal: String
    let startTime: Date
    let expectedMinutes: UInt64
    
    @State private var currentTime = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var elapsedTime: TimeInterval {
        currentTime.timeIntervalSince(startTime)
    }
    
    var elapsedMinutes: Int {
        Int(elapsedTime / 60)
    }
    
    var elapsedFormatted: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Active Session")
                        .font(.headline)
                    
                    Text(goal)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Text(elapsedFormatted)
                    .font(.system(size: 48, weight: .light, design: .monospaced))
                    .onReceive(timer) { _ in
                        currentTime = Date()
                    }
                
                HStack(spacing: 12) {
                    Label("\(elapsedMinutes) min", systemImage: "clock")
                    Divider()
                        .frame(height: 16)
                    Label("Expected: \(expectedMinutes) min", systemImage: "target")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                Button("Stop Session") {
                    viewStore.send(.stopButtonTapped)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(viewStore.isLoading)
            }
            .padding(.vertical)
        }
    }
}