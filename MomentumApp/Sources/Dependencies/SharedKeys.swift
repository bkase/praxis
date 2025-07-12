import ComposableArchitecture
import Foundation

// MARK: - Shared Keys for Persistence

extension SharedKey where Self == FileStorageKey<SessionData?>.Default {
    static var sessionData: Self {
        Self[.fileStorage(sessionFileURL), default: nil]
    }
    
    private static var sessionFileURL: URL {
        documentsDirectory.appendingPathComponent("session.json")
    }
    
    private static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension SharedKey where Self == AppStorageKey<String>.Default {
    static var lastGoal: Self {
        Self[.appStorage("momentum.lastGoal"), default: ""]
    }
}

extension SharedKey where Self == AppStorageKey<String>.Default {
    static var lastTimeMinutes: Self {
        Self[.appStorage("momentum.lastTimeMinutes"), default: "30"]
    }
}

extension SharedKey where Self == InMemoryKey<[AnalysisResult]>.Default {
    static var analysisHistory: Self {
        Self[.inMemory("analysisHistory"), default: []]
    }
}