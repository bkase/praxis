import ComposableArchitecture
import Foundation

struct ChecklistItem: Identifiable, Equatable, Codable {
    let id: String
    let text: String
    var isCompleted: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, text
    }
}

struct ChecklistItemPool {
    static let allItems = [
        "Rested",
        "Not hungry",
        "Bathroom break",
        "Phone on silent",
        "Desk cleared",
        "Water bottle filled",
        "Distractions closed",
        "Notes prepared",
        "Environment comfortable",
        "Mind centered"
    ]
    
    static func createInitialItems() -> IdentifiedArrayOf<ChecklistItem> {
        IdentifiedArray(uniqueElements: allItems.prefix(4).enumerated().map { index, text in
            ChecklistItem(id: "\(index)", text: text, isCompleted: false)
        })
    }
}

@DependencyClient
struct ChecklistClient {
    var load: @Sendable () async throws -> [ChecklistItem]
}

extension DependencyValues {
    var checklistClient: ChecklistClient {
        get { self[ChecklistClient.self] }
        set { self[ChecklistClient.self] = newValue }
    }
}

extension ChecklistClient: DependencyKey {
    static let liveValue = ChecklistClient(
        load: {
            let appSupportURL = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first!.appendingPathComponent("com.momentum.app")
            
            try? FileManager.default.createDirectory(
                at: appSupportURL,
                withIntermediateDirectories: true
            )
            
            let checklistURL = appSupportURL.appendingPathComponent("checklist.json")
            
            if !FileManager.default.fileExists(atPath: checklistURL.path) {
                if let bundleURL = Bundle.main.url(forResource: "checklist", withExtension: "json") {
                    try FileManager.default.copyItem(at: bundleURL, to: checklistURL)
                } else {
                    throw AppError.other("Default checklist.json not found in bundle")
                }
            }
            
            let data = try Data(contentsOf: checklistURL)
            let items = try JSONDecoder().decode([ChecklistItem].self, from: data)
            return items
        }
    )
    
    static let testValue = ChecklistClient(
        load: {
            [
                ChecklistItem(id: "test-1", text: "Test item 1"),
                ChecklistItem(id: "test-2", text: "Test item 2"),
                ChecklistItem(id: "test-3", text: "Test item 3")
            ]
        }
    )
}