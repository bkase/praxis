import ComposableArchitecture
import Foundation
import Sharing

@Reducer
struct PreparationFeature {
    struct ChecklistSlot: Equatable, Identifiable, Codable {
        let id: Int // Position 0-3
        var item: ChecklistItem?
        var isTransitioning: Bool = false
        var isFadingIn: Bool = false
        
        private enum CodingKeys: String, CodingKey {
            case id, item
            // Don't persist animation states
        }
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
        @Shared(.preparationState) var persistentState = PreparationPersistentState.initial
        var activeTransitions: [Int: ItemTransition] = [:] // Key is slot ID
        
        // Computed properties for accessing persistent state
        var checklistSlots: [ChecklistSlot] {
            get { persistentState.checklistSlots }
            set { $persistentState.withLock { $0.checklistSlots = newValue } }
        }
        
        var totalItemsCompleted: Int {
            get { persistentState.totalItemsCompleted }
            set { $persistentState.withLock { $0.totalItemsCompleted = newValue } }
        }
        
        var nextItemIndex: Int {
            get { persistentState.nextItemIndex }
            set { $persistentState.withLock { $0.nextItemIndex = newValue } }
        }
        
        var isStartButtonEnabled: Bool {
            !goal.isEmpty &&
            Int(timeInput).map { $0 > 0 } == true &&
            totalItemsCompleted == 10
        }
        
        init(
            goal: String = "",
            timeInput: String = ""
        ) {
            self.goal = goal
            self.timeInput = timeInput
            // Check if we need to initialize the persistent state
            if self.checklistSlots.isEmpty {
                self.checklistSlots = Self.createInitialSlots()
            }
        }
        
        init(preparationState: PreparationState) {
            self.goal = preparationState.goal
            self.timeInput = preparationState.timeInput
            // Convert old checklist to slots
            var slots = Self.createInitialSlots()
            let items = preparationState.checklist.prefix(4)
            for (index, item) in items.enumerated() {
                slots[index].item = item
            }
            self.checklistSlots = slots
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
                // Only initialize if we haven't already (persistent state is empty)
                if state.checklistSlots.isEmpty || state.checklistSlots.allSatisfy({ $0.item == nil }) {
                    // Initialize slots with first 4 items from the pool
                    state.checklistSlots = State.createInitialSlots()
                    let initialItems = ChecklistItemPool.allItems.prefix(4).enumerated().map { index, text in
                        ChecklistItem(id: "\(index)", text: text, isCompleted: false)
                    }
                    var slots = state.checklistSlots
                    for (index, item) in initialItems.enumerated() {
                        slots[index].item = item
                    }
                    state.checklistSlots = slots
                    state.nextItemIndex = 4
                    state.totalItemsCompleted = 0
                }
                return .none
                
            case let .checklistSlotToggled(slotId):
                guard slotId < state.checklistSlots.count,
                      let item = state.checklistSlots[slotId].item else { return .none }
                
                if !item.isCompleted {
                    // Mark item as completed
                    var slots = state.checklistSlots
                    slots[slotId].item?.isCompleted = true
                    state.checklistSlots = slots
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
                    var slots = state.checklistSlots
                    slots[slotId].item?.isCompleted = false
                    state.checklistSlots = slots
                    state.totalItemsCompleted -= 1
                }
                return .none
                
            case let .beginSlotTransition(slotId, replacementText):
                // Mark slot as transitioning
                var slots = state.checklistSlots
                slots[slotId].isTransitioning = true
                state.checklistSlots = slots
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
                var slots = state.checklistSlots
                slots[slotId].item = nil
                slots[slotId].isTransitioning = false
                slots[slotId].isFadingIn = false
                state.checklistSlots = slots
                
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
                var slots = state.checklistSlots
                slots[slotId].item = newItem
                slots[slotId].isFadingIn = true
                state.checklistSlots = slots
                
                // Reset the fade-in flag after animation duration
                return .run { send in
                    try await clock.sleep(for: .milliseconds(350)) // Slightly longer than animation
                    await send(.resetFadeInFlag(slotId: slotId))
                }
                
            case let .resetFadeInFlag(slotId):
                // Reset the fade-in flag so the item becomes fully interactive
                var slots = state.checklistSlots
                slots[slotId].isFadingIn = false
                state.checklistSlots = slots
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