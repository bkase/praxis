# TODO: Match PreparationView to HTML Prototype

## Priority: HIGH
## Created: 2025-07-13

### Summary
Update the PreparationView implementation to exactly match the provided HTML prototype, including the dynamic checklist behavior, visual design, and interaction patterns.

### Key Changes Required

#### 1. Dynamic Checklist Behavior (Most Complex)
The HTML prototype has a sophisticated checklist system:
- **Pool of 10 items total**: "Rested", "Not hungry", "Bathroom break", "Phone on silent", "Desk cleared", "Water bottle filled", "Distractions closed", "Notes prepared", "Environment comfortable", "Mind centered"
- **Shows only 4 items at a time** in a fixed-height container (156px = ~4 items)
- **Item replacement animation**: When an item is checked:
  1. Item stays visible for 600ms
  2. Fades out over 300ms (opacity 0, translateX -10px)
  3. Is replaced by the next item from the pool (if any remain)
  4. New item fades in (from opacity 0, translateX 10px)
- **Progress tracking**: Shows "X of 10 completed" (total items ever completed, not current visible)
- **Button state**: Only enabled when all 10 items have been completed

#### 2. Visual Design Updates
##### Colors (already updated in Color+Extensions.swift):
- Background: #F9F7F4
- Gold accent: #C79A2A
- Border neutral: #E3DDD1
- Hover fill: #FDF9F1
- Text primary: #111111
- Text secondary: #6D4F1C

##### Typography (already updated in Font+Extensions.swift):
- Title: New York/Georgia serif, 28px, regular weight, -0.5px letter spacing
- Button: New York/Georgia serif, 18px, italic, 0.5px letter spacing
- Section label: 11px, semibold, 2px letter spacing, uppercase
- Intention field: 16px regular
- Duration: 14px for label, 15px medium for input

##### Layout & Spacing:
- Container: 320px max width, 24px top/20px side padding
- Title: Center aligned, 24px bottom margin
- Intention input: No label, just placeholder "What will you accomplish?"
- Duration: Single row with label, input (60px wide), and "min" unit
- Checklist: Fixed height container for 4 items
- Items: 10px vertical/14px horizontal padding, 4px bottom margin
- Button: 14px padding, 2px border
- Progress: 8px top margin, center aligned

#### 3. State Management Updates

##### PreparationFeature.State needs:
```swift
struct State {
    // Existing
    var goal: String = ""
    var timeInput: String = ""
    
    // New/Modified
    var visibleChecklist: IdentifiedArrayOf<ChecklistItem> = [] // Currently visible 4 items
    var totalItemsCompleted: Int = 0 // Total items completed (up to 10)
    var nextItemIndex: Int = 4 // Next item to show from the pool
    var itemTransitions: [String: ItemTransition] = [:] // Track fade animations
    
    // Computed
    var isStartButtonEnabled: Bool {
        !goal.isEmpty && 
        Int(timeInput).map { $0 > 0 } == true &&
        totalItemsCompleted == 10 // All 10 items completed
    }
}

struct ItemTransition: Equatable {
    let itemId: String
    let replacementText: String?
    let startTime: Date
}
```

##### New Actions:
```swift
enum Action {
    // Existing actions...
    
    // New checklist actions
    case checklistItemToggled(ChecklistItem.ID)
    case beginItemTransition(ChecklistItem.ID, replacementText: String?)
    case completeItemTransition(ChecklistItem.ID)
    case fadeInNewItem(ChecklistItem.ID, text: String)
}
```

#### 4. Animation Implementation

##### ChecklistRowView needs:
- Opacity and transform modifiers based on transition state
- withAnimation for smooth transitions
- onAppear/onDisappear for managing animation lifecycle

##### Timing:
- 600ms delay after check before starting fade
- 300ms fade out duration
- 50ms delay before fade in
- 300ms fade in duration

#### 5. Component Updates

##### IntentionTextFieldStyle:
- Remove border radius to 3px (not rounded)
- Placeholder: "What will you accomplish?"
- Focus state: background #FDF9F1, 2px shadow with 15% opacity

##### DurationPicker:
- Redesign as single row
- Input: 60px wide, centered text, background #FDF9F1
- Min/max: 5-180

##### ChecklistRowView:
- 2px border radius (not 3px)
- Checkbox: 16x16, 2px border
- Hover state: background #FDF9F1, border #C79A2A
- Completed: immediate visual change, then animation after delay

##### SanctuaryButtonStyle:
- Text: "Enter Sanctuary" 
- 3px border radius
- Hover: background #C79A2A, white text, translateY(-1px), shadow
- Active: translateY(0), reduced shadow
- Disabled: opacity 0.3, no hover effects

#### 6. Test Updates
- Update ChecklistTests to handle new 10-item pool behavior
- Test item transitions and animations
- Test progress tracking (0 of 10, not 0 of 4)
- Test button enabled only at 10 completed

### Implementation Order
1. Update PreparationFeature.State with new properties
2. Create animation/transition logic in reducer
3. Update ChecklistRowView with animation states
4. Update PreparationView layout to match HTML exactly
5. Update component styles (button, input, etc.)
6. Update tests
7. Verify animations work smoothly

### Files to Modify
- PreparationFeature.swift (state & reducer logic)
- PreparationView.swift (layout updates)
- ChecklistRowView.swift (animation implementation)
- All style files (match exact values from HTML)
- ChecklistTests.swift (new behavior)
- ChecklistModels.swift (already created with item pool)

### Success Criteria
- Checklist shows exactly 4 items at a time
- Items animate out and are replaced from pool
- Progress shows "X of 10 completed"
- Button only enables at 10/10
- Visual design matches HTML exactly
- All animations are smooth and match timing