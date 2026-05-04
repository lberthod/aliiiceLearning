import Foundation

struct WordStat: Identifiable, Codable {
    let id: String // Word ID
    var attemptedCount: Int = 0
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var lastSeenDate: Date?
    var nextReviewDate: Date?
    var leitnerBox: LeitnerBox = .learning
    var confidence: Int = 0 // 1-10 self-reported
    var toneAccuracy: Int? // 0-100%

    // SM-2 Algorithm fields
    var easeFactor: Double = 2.5 // Starts at 2.5, adjusted based on performance
    var intervalDays: Int = 1 // Days until next review
    var repetitionCount: Int = 0 // Number of successful reviews

    // Computed properties
    var accuracy: Double {
        guard attemptedCount > 0 else { return 0 }
        return Double(correctCount) / Double(attemptedCount)
    }

    var accuracyPercentage: Int {
        return Int(accuracy * 100)
    }

    var isLearning: Bool {
        return leitnerBox == .learning
    }

    var isMastered: Bool {
        return leitnerBox == .expert
    }
}

enum LeitnerBox: String, Codable {
    case learning = "1-day-review"    // Review again in 1 day
    case review = "3-day-review"      // Review in 3 days
    case mastery = "7-day-review"     // Review in 7 days
    case expert = "30-day-review"     // Review in 30 days

    var reviewIntervalDays: Int {
        switch self {
        case .learning: return 1
        case .review: return 3
        case .mastery: return 7
        case .expert: return 30
        }
    }

    var displayName: String {
        switch self {
        case .learning: return "Learning"
        case .review: return "Review"
        case .mastery: return "Mastery"
        case .expert: return "Expert"
        }
    }

    var displayNameFr: String {
        switch self {
        case .learning: return "Apprentissage"
        case .review: return "Révision"
        case .mastery: return "Maîtrise"
        case .expert: return "Expert"
        }
    }

    var emoji: String {
        switch self {
        case .learning: return "📦"
        case .review: return "📦📦"
        case .mastery: return "📦📦📦"
        case .expert: return "⭐"
        }
    }
}
