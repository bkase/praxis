import ComposableArchitecture
import Foundation

@Reducer
struct PreparationFeature {
    struct ChecklistSlot: Equatable, Identifiable {
        let id: Int // Position 0-3
        var item: ChecklistItem?
        var isTransitioning: Bool = false
        var isFadingIn: Bool = false
    }
    
    struct ItemTransition: Equatable {
        let slotId: Int
        let replacementText: String?
        let startTime: Date
    }
    
    @ObservableState
    struct State: Equatable {
        var goal: String = ""
        var timeInput: String = ""
        var checklistSlots: [ChecklistSlot] = []
        var totalItemsCompleted: Int = 0
        var nextItemIndex: Int = 4
        var activeTransitions: [Int: ItemTransition] = [:] // Key is slot ID
        
        var isStartButtonEnabled: Bool {
            !goal.isEmpty &&
            Int(timeInput).map { $0 > 0 } == true &&
            totalItemsCompleted == 10
        }
        
        init(
            goal: String = "",
            timeInput: String = "",
            checklistSlots: [ChecklistSlot] = [],
            totalItemsCompleted: Int = 0,
            nextItemIndex: Int = 4
        ) {
            self.goal = goal
            self.timeInput = timeInput
            self.checklistSlots = checklistSlots.isEmpty ? Self.createInitialSlots() : checklistSlots
            self.totalItemsCompleted = totalItemsCompleted
            self.nextItemIndex = nextItemIndex
        }
        
        init(preparationState: PreparationState) {
            self.goal = preparationState.goal
            self.timeInput = preparationState.timeInput
            // Convert old checklist to slots
            self.checklistSlots = Self.createInitialSlots()
            let items = preparationState.checklist.prefix(4)
            for (index, item) in items.enumerated() {
                self.checklistSlots[index].item = item
            }
            self.totalItemsCompleted = preparationState.checklist.filter { $0.isCompleted }.count
            self.nextItemIndex = min(4, preparationState.checklist.count)
        }
        
        var preparationState: PreparationState {
            PreparationState(
                goal: goal,
                timeInput: timeInput,
                checklist: IdentifiedArray(uniqueElements: checklistSlots.compactMap { $0.item })
            )
        }
        
        static func createInitialSlots() -> [ChecklistSlot] {
            (0..<4).map { ChecklistSlot(id: $0) }
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case checklistSlotToggled(slotId: Int)
        case beginSlotTransition(slotId: Int, replacementText: String?)
        case completeSlotTransition(slotId: Int)
        case fadeInNewItem(slotId: Int, text: String)
        case resetFadeInFlag(slotId: Int)
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
                // Initialize slots with first 4 items from the pool
                state.checklistSlots = State.createInitialSlots()
                let initialItems = ChecklistItemPool.allItems.prefix(4).enumerated().map { index, text in
                    ChecklistItem(id: "\(index)", text: text, isCompleted: false)
                }
                for (index, item) in initialItems.enumerated() {
                    state.checklistSlots[index].item = item
                }
                return .none
                
            case let .checklistSlotToggled(slotId):
                guard slotId < state.checklistSlots.count,
                      let item = state.checklistSlots[slotId].item else { return .none }
                
                if !item.isCompleted {
                    // Mark item as completed
                    state.checklistSlots[slotId].item?.isCompleted = true
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
                        await send(.beginSlotTransition(slotId: slotId, replacementText: replacementText))
                    }
                } else {
                    // Unchecking an item (not in spec, but handling for completeness)
                    state.checklistSlots[slotId].item?.isCompleted = false
                    state.totalItemsCompleted -= 1
                }
                return .none
                
            case let .beginSlotTransition(slotId, replacementText):
                // Mark slot as transitioning
                state.checklistSlots[slotId].isTransitioning = true
                state.activeTransitions[slotId] = ItemTransition(
                    slotId: slotId,
                    replacementText: replacementText,
                    startTime: Date()
                )
                
                // Complete transition after fade-out duration (300ms)
                return .run { send in
                    try await clock.sleep(for: .milliseconds(300))
                    await send(.completeSlotTransition(slotId: slotId))
                }
                
            case let .completeSlotTransition(slotId):
                guard let transition = state.activeTransitions[slotId] else { return .none }
                
                // First, clear the slot completely to prevent overlap
                state.checklistSlots[slotId].item = nil
                state.checklistSlots[slotId].isTransitioning = false
                state.checklistSlots[slotId].isFadingIn = false
                
                state.activeTransitions.removeValue(forKey: slotId)
                
                // If there's a replacement, add it after a small gap
                if let replacementText = transition.replacementText {
                    return .run { send in
                        // Small delay to ensure clean visual gap
                        try await clock.sleep(for: .milliseconds(100))
                        await send(.fadeInNewItem(slotId: slotId, text: replacementText))
                    }
                }
                return .none
                
            case let .fadeInNewItem(slotId, text):
                // Add the new item to the slot with fade-in animation
                let newId = UUID().uuidString
                let newItem = ChecklistItem(id: newId, text: text, isCompleted: false)
                state.checklistSlots[slotId].item = newItem
                state.checklistSlots[slotId].isFadingIn = true
                
                // Reset the fade-in flag after animation duration
                return .run { send in
                    try await clock.sleep(for: .milliseconds(350)) // Slightly longer than animation
                    await send(.resetFadeInFlag(slotId: slotId))
                }
                
            case let .resetFadeInFlag(slotId):
                // Reset the fade-in flag so the item becomes fully interactive
                state.checklistSlots[slotId].isFadingIn = false
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