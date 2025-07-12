import ComposableArchitecture
import Foundation

@Reducer
struct ActiveSessionFeature {
    @ObservableState
    struct State: Equatable {
        let goal: String
        let startTime: Date
        let expectedMinutes: UInt64
    }
    
    enum Action: Equatable {
        case stopButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .stopButtonTapped:
                return .none
            }
        }
    }
}