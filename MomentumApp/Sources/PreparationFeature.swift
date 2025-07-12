import ComposableArchitecture
import Foundation

@Reducer
struct PreparationFeature {
    @ObservableState
    struct State: Equatable {
        var goal: String = ""
        var timeInput: String = ""
        var checklist: IdentifiedArrayOf<ChecklistItem> = []
        
        var isStartButtonEnabled: Bool {
            !goal.isEmpty &&
            Int(timeInput).map { $0 > 0 } == true &&
            checklist.allSatisfy { $0.isCompleted }
        }
        
        init(
            goal: String = "",
            timeInput: String = "",
            checklist: IdentifiedArrayOf<ChecklistItem> = []
        ) {
            self.goal = goal
            self.timeInput = timeInput
            self.checklist = checklist
        }
        
        init(preparationState: PreparationState) {
            self.goal = preparationState.goal
            self.timeInput = preparationState.timeInput
            self.checklist = preparationState.checklist
        }
        
        var preparationState: PreparationState {
            PreparationState(
                goal: goal,
                timeInput: timeInput,
                checklist: checklist
            )
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case checklistItemsLoaded(TaskResult<[ChecklistItem]>)
        case checklistItemToggled(ChecklistItem.ID)
        case goalChanged(String)
        case timeInputChanged(String)
        case startButtonTapped
    }
    
    @Dependency(\.checklistClient) var checklistClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
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
                state.checklist = IdentifiedArray(uniqueElements: items)
                return .none
                
            case .checklistItemsLoaded(.failure):
                // Error handling is done at parent level
                return .none
                
            case let .checklistItemToggled(id):
                state.checklist[id: id]?.isCompleted.toggle()
                return .none
                
            case let .goalChanged(newGoal):
                state.goal = newGoal
                return .none
                
            case let .timeInputChanged(newTime):
                state.timeInput = newTime
                return .none
                
            case .startButtonTapped:
                // This will be handled by parent
                return .none
            }
        }
    }
}