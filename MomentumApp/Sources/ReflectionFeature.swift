import ComposableArchitecture
import Foundation

@Reducer
struct ReflectionFeature {
    @ObservableState
    struct State: Equatable {
        let reflectionPath: String
    }
    
    enum Action: Equatable {
        case analyzeButtonTapped
        case cancelButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .analyzeButtonTapped:
                return .none
            case .cancelButtonTapped:
                return .none
            }
        }
    }
}