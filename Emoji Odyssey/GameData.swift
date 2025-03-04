import SwiftUI

class GameData: ObservableObject {
    @Published var completedLevels: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(completedLevels), forKey: "CompletedLevels")
        }
    }

    init() {
        self.completedLevels = Set(UserDefaults.standard.stringArray(forKey: "CompletedLevels") ?? [])
    }

    func markLevelCompleted(genre: String, level: Int) {
        completedLevels.insert("\(genre)_\(level)")
    }

    func isLevelCompleted(genre: String, level: Int) -> Bool {
        return completedLevels.contains("\(genre)_\(level)")
    }
}
