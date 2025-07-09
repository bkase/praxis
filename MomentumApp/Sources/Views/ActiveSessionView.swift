import SwiftUI
import ComposableArchitecture

struct ActiveSessionView: View {
    @Bindable var store: StoreOf<AppFeature>
    let goal: String
    let startTime: Date
    let expectedMinutes: UInt64
    
    @State private var currentTime = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var elapsedTime: TimeInterval {
        currentTime.timeIntervalSince(startTime)
    }
    
    private var elapsedMinutes: Int {
        Int(elapsedTime / 60)
    }
    
    private var progress: Double {
        min(elapsedTime / (Double(expectedMinutes) * 60), 1.0)
    }
    
    private var elapsedFormatted: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    private var isOvertime: Bool {
        elapsedMinutes > Int(expectedMinutes)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image(systemName: "timer")
                    .font(.largeTitle)
                    .foregroundStyle(.tint)
                    .symbolEffect(.pulse, value: currentTime)
                
                Text("Active Session")
                    .font(.headline)
                
                Text(goal)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            ZStack {
                Circle()
                    .stroke(.quaternary, lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        isOvertime ? Color.orange : Color.accentColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)
                
                Text(elapsedFormatted)
                    .font(.system(size: 36, weight: .light, design: .monospaced))
                    .contentTransition(.numericText())
            }
            .frame(width: 180, height: 180)
            .onReceive(timer) { _ in
                withAnimation(.linear(duration: 0.5)) {
                    currentTime = Date()
                }
            }
            
            HStack(spacing: 20) {
                Label("\(elapsedMinutes) min", systemImage: "clock.fill")
                    .foregroundStyle(isOvertime ? .orange : .secondary)
                
                Divider()
                    .frame(height: 16)
                
                Label("Goal: \(expectedMinutes) min", systemImage: "target")
                    .foregroundStyle(.secondary)
            }
            .font(.caption)
            
            Button(action: { store.send(.stopButtonTapped) }) {
                Label("Stop Session", systemImage: "stop.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(store.isLoading)
            .keyboardShortcut("s", modifiers: .command)
        }
    }
}