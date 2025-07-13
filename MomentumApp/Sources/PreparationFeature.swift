import ComposableArchitecture
import Foundation

@Reducer
struct PreparationFeature {
    @ObservableState
    struct State: Equatable {
        var goal: String = ""
        var timeInput: String = ""
        var checklist: IdentifiedArrayOf<ChecklistItem> = []
        var completedChecklistItemCount: Int = 0
        var totalChecklistItemCount: Int = 0
        
        var isStartButtonEnabled: Bool {
            !goal.isEmpty &&
            Int(timeInput).map { $0 > 0 } == true &&
            checklist.allSatisfy { $0.isCompleted }
        }
        
        init(
            goal: String = "",
            timeInput: String = "",
            checklist: IdentifiedArrayOf<ChecklistItem> = [],
            completedChecklistItemCount: Int? = nil,
            totalChecklistItemCount: Int? = nil
        ) {
            self.goal = goal
            self.timeInput = timeInput
            self.checklist = checklist
            self.completedChecklistItemCount = completedChecklistItemCount ?? checklist.filter { $0.isCompleted }.count
            self.totalChecklistItemCount = totalChecklistItemCount ?? checklist.count
        }
        
        init(preparationState: PreparationState) {
            self.goal = preparationState.goal
            self.timeInput = preparationState.timeInput
            self.checklist = preparationState.checklist
            self.completedChecklistItemCount = preparationState.checklist.filter { $0.isCompleted }.count
            self.totalChecklistItemCount = preparationState.checklist.count
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
                state.totalChecklistItemCount = items.count
                state.completedChecklistItemCount = items.filter { $0.isCompleted }.count
                return .none
                
            case .checklistItemsLoaded(.failure):
                // Error handling is done at parent level
                return .none
                
            case let .checklistItemToggled(id):
                state.checklist[id: id]?.isCompleted.toggle()
                if let item = state.checklist[id: id] {
                    if item.isCompleted {
                        state.completedChecklistItemCount += 1
                    } else {
                        state.completedChecklistItemCount -= 1
                    }
                }
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