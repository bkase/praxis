import ComposableArchitecture
import Foundation

@Reducer
struct PreparationFeature {
    struct ItemTransition: Equatable {
        let itemId: String
        let replacementText: String?
        let startTime: Date
    }
    
    @ObservableState
    struct State: Equatable {
        var goal: String = ""
        var timeInput: String = ""
        var visibleChecklist: IdentifiedArrayOf<ChecklistItem> = []
        var totalItemsCompleted: Int = 0
        var nextItemIndex: Int = 4
        var itemTransitions: [String: ItemTransition] = [:]
        
        var isStartButtonEnabled: Bool {
            !goal.isEmpty &&
            Int(timeInput).map { $0 > 0 } == true &&
            totalItemsCompleted == 10
        }
        
        init(
            goal: String = "",
            timeInput: String = "",
            visibleChecklist: IdentifiedArrayOf<ChecklistItem> = [],
            totalItemsCompleted: Int = 0,
            nextItemIndex: Int = 4
        ) {
            self.goal = goal
            self.timeInput = timeInput
            self.visibleChecklist = visibleChecklist
            self.totalItemsCompleted = totalItemsCompleted
            self.nextItemIndex = nextItemIndex
        }
        
        init(preparationState: PreparationState) {
            self.goal = preparationState.goal
            self.timeInput = preparationState.timeInput
            // Convert old checklist to visible checklist, showing first 4 items
            self.visibleChecklist = IdentifiedArray(uniqueElements: preparationState.checklist.prefix(4))
            self.totalItemsCompleted = preparationState.checklist.filter { $0.isCompleted }.count
            self.nextItemIndex = min(4, preparationState.checklist.count)
        }
        
        var preparationState: PreparationState {
            PreparationState(
                goal: goal,
                timeInput: timeInput,
                checklist: visibleChecklist // For now, save visible items
            )
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case checklistItemsLoaded(TaskResult<[ChecklistItem]>)
        case checklistItemToggled(ChecklistItem.ID)
        case beginItemTransition(ChecklistItem.ID, replacementText: String?)
        case completeItemTransition(ChecklistItem.ID)
        case fadeInNewItem(ChecklistItem.ID, text: String)
        case goalChanged(String)
        case timeInputChanged(String)
        case startButtonTapped
    }
    
    @Dependency(\.checklistClient) var checklistClient
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                // Load only the first 4 items from the pool
                let initialItems = ChecklistItemPool.allItems.prefix(4).enumerated().map { index, text in
                    ChecklistItem(id: "\(index)", text: text, isCompleted: false)
                }
                state.visibleChecklist = IdentifiedArray(uniqueElements: initialItems)
                return .none
                
            case let .checklistItemsLoaded(.success(items)):
                // Not used in new implementation, but keeping for compatibility
                return .none
                
            case .checklistItemsLoaded(.failure):
                // Error handling is done at parent level
                return .none
                
            case let .checklistItemToggled(id):
                guard let item = state.visibleChecklist[id: id] else { return .none }
                
                if !item.isCompleted {
                    // Mark item as completed
                    state.visibleChecklist[id: id]?.isCompleted = true
                    state.totalItemsCompleted += 1
                    
                    // Check if we have more items to show
                    let replacementText: String?
                    if state.nextItemIndex < ChecklistItemPool.allItems.count {
                        replacementText = ChecklistItemPool.allItems[state.nextItemIndex]
                        state.nextItemIndex += 1
                    } else {
                        replacementText = nil
                    }
                    
                    // Start fade-out transition after 600ms delay
                    return .run { send in
                        try await clock.sleep(for: .milliseconds(600))
                        await send(.beginItemTransition(id, replacementText: replacementText))
                    }
                } else {
                    // Unchecking an item (not in spec, but handling for completeness)
                    state.visibleChecklist[id: id]?.isCompleted = false
                    state.totalItemsCompleted -= 1
                }
                return .none
                
            case let .beginItemTransition(id, replacementText):
                // Store transition info
                state.itemTransitions[id] = ItemTransition(
                    itemId: id,
                    replacementText: replacementText,
                    startTime: Date()
                )
                
                // Complete transition after fade-out duration (300ms)
                return .run { send in
                    try await clock.sleep(for: .milliseconds(300))
                    await send(.completeItemTransition(id))
                }
                
            case let .completeItemTransition(id):
                guard let transition = state.itemTransitions[id] else { return .none }
                
                // Remove the old item
                state.visibleChecklist.remove(id: id)
                state.itemTransitions.removeValue(forKey: id)
                
                // Add replacement item if available
                if let replacementText = transition.replacementText {
                    let newId = UUID().uuidString
                    let newItem = ChecklistItem(id: newId, text: replacementText, isCompleted: false)
                    state.visibleChecklist.append(newItem)
                    
                    // Trigger fade-in animation
                    return .run { send in
                        try await clock.sleep(for: .milliseconds(50))
                        await send(.fadeInNewItem(newId, text: replacementText))
                    }
                }
                return .none
                
            case .fadeInNewItem:
                // This action is primarily for triggering SwiftUI animations
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