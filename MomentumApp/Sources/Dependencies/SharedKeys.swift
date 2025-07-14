import ComposableArchitecture
import Foundation

// MARK: - Persistent Preparation State

struct PreparationPersistentState: Codable, Equatable {
    var checklistSlots: [PreparationFeature.ChecklistSlot]
    var totalItemsCompleted: Int
    var nextItemIndex: Int
    
    static let initial = PreparationPersistentState(
        checklistSlots: [],
        totalItemsCompleted: 0,
        nextItemIndex: 4
    )
}

// MARK: - Shared Keys for Persistence

// Helper to get app support directory
private extension URL {
    static var appSupportDirectory: URL {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportURL = urls[0].appendingPathComponent("com.momentum.app")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
        
        return appSupportURL
    }
}

extension SharedKey where Self == FileStorageKey<SessionData?>.Default {
    static var sessionData: Self {
        Self[.fileStorage(sessionFileURL), default: nil]
    }
    
    private static var sessionFileURL: URL {
        URL.appSupportDirectory.appendingPathComponent("session.json")
    }
}

extension SharedKey where Self == AppStorageKey<String>.Default {
    static var lastGoal: Self {
        Self[.appStorage("momentumLastGoal"), default: ""]
    }
}

extension SharedKey where Self == AppStorageKey<String>.Default {
    static var lastTimeMinutes: Self {
        Self[.appStorage("momentumLastTimeMinutes"), default: "30"]
    }
}

extension SharedKey where Self == InMemoryKey<[AnalysisResult]>.Default {
    static var analysisHistory: Self {
        Self[.inMemory("analysisHistory"), default: []]
    }
}

extension SharedKey where Self == FileStorageKey<PreparationPersistentState>.Default {
    static var preparationState: Self {
        Self[.fileStorage(preparationFileURL), default: .initial]
    }
    
    private static var preparationFileURL: URL {
        URL.appSupportDirectory.appendingPathComponent("preparation.json")
    }
}