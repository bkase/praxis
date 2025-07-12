import ComposableArchitecture
import Foundation

@Reducer
struct PreparationFeature {
    @ObservableState
    struct State: Equatable {
        var preparationState: PreparationState
        
        init(preparationState: PreparationState = PreparationState()) {
            self.preparationState = preparationState
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case checklistItemsLoaded(TaskResult<[ChecklistItem]>)
        case checklistItemToggled(ChecklistItem.ID)
        case goalChanged(String)
        case timeInputChanged(String)
    }
    
    @Dependency(\.checklistClient) var checklistClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return .run { send in
                    await send(
                        .checklistItemsLoaded(
                            await TaskResult {
                                try await checklistClient.load()
                            }
                        )
                    )
                }
                
            case let .checklistItemsLoaded(.success(items)):
                state.preparationState.checklist = IdentifiedArray(uniqueElements: items)
                return .none
                
            case .checklistItemsLoaded(.failure):
                // Error handling is done at parent level
                return .none
                
            case let .checklistItemToggled(id):
                state.preparationState.checklist[id: id]?.isCompleted.toggle()
                return .none
                
            case let .goalChanged(newGoal):
                state.preparationState.goal = newGoal
                return .none
                
            case let .timeInputChanged(newTimeInput):
                state.preparationState.timeInput = newTimeInput
                return .none
            }
        }
    }
}