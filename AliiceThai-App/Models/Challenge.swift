import Foundation

struct Challenge: Codable, Identifiable {
    let id: String
    let type: String // "daily" | "weekly"
    let title: String
    let description: String
    let targetCount: Int
    var progressCount: Int = 0
    var isCompleted: Bool = false
    var createdDate: Date = Date()

    static func generateDailyChallenge() -> Challenge {
        let challenges: [(title: String, description: String, targetCount: Int)] = [
            (
                title: "Tone Master",
                description: "Complete 3 tone accuracy drills",
                targetCount: 3
            ),
            (
                title: "Word Master",
                description: "Get 10 quiz answers correct",
                targetCount: 10
            ),
            (
                title: "Output Warrior",
                description: "Complete 5 speaking tasks",
                targetCount: 5
            ),
            (
                title: "Listening Expert",
                description: "Complete 2 listening sessions",
                targetCount: 2
            ),
            (
                title: "Perfect Streak",
                description: "Get 5 consecutive answers right",
                targetCount: 5
            )
        ]

        let random = challenges.randomElement() ?? challenges[0]
        return Challenge(
            id: UUID().uuidString,
            type: "daily",
            title: random.title,
            description: random.description,
            targetCount: random.targetCount,
            progressCount: 0,
            isCompleted: false,
            createdDate: Date()
        )
    }

    var progressPercentage: Int {
        guard targetCount > 0 else { return 0 }
        return min(Int(Double(progressCount) / Double(targetCount) * 100), 100)
    }

    var isProgressComplete: Bool {
        return progressCount >= targetCount
    }

    mutating func incrementProgress() {
        progressCount += 1
        if progressCount >= targetCount {
            isCompleted = true
        }
    }
}
