import Foundation
import Combine

class SpacedRepetitionScheduler: ObservableObject {
    static let shared = SpacedRepetitionScheduler()

    @Published private(set) var wordStats: [String: WordStat] = [:]

    private let userDefaultsKey = "wordStats"

    init() {
        loadFromUserDefaults()
    }

    // MARK: - Core Algorithm

    func recordAttempt(wordId: String, isCorrect: Bool, toneCorrect: Bool? = nil) {
        var stat = wordStats[wordId] ?? WordStat(id: wordId)

        stat.attemptedCount += 1
        if isCorrect {
            stat.correctCount += 1
        } else {
            stat.incorrectCount += 1
        }
        stat.lastSeenDate = Date()

        if let toneCorrect = toneCorrect {
            let currentTone = stat.toneAccuracy ?? 0
            stat.toneAccuracy = Int((Double(currentTone) + (toneCorrect ? 100 : 0)) / 2)
        }

        // Apply SM-2 algorithm for adaptive spacing
        applySM2Algorithm(&stat, isCorrect: isCorrect)

        // Promotion/demotion logic (keep for compatibility)
        stat.leitnerBox = calculateNextBox(
            currentBox: stat.leitnerBox,
            accuracy: stat.accuracy,
            attemptCount: stat.attemptedCount
        )

        stat.nextReviewDate = calculateNextReview(box: stat.leitnerBox)
        wordStats[wordId] = stat

        saveToUserDefaults()
    }

    private func calculateNextBox(
        currentBox: LeitnerBox,
        accuracy: Double,
        attemptCount: Int
    ) -> LeitnerBox {
        // Promotion: 90%+ accuracy + 3+ attempts → promote
        if accuracy >= 0.90 && attemptCount >= 3 {
            switch currentBox {
            case .learning:
                return .review
            case .review:
                return .mastery
            case .mastery:
                return .expert
            case .expert:
                return .expert
            }
        }

        // Demotion: <60% accuracy → demote
        if accuracy < 0.60 && attemptCount >= 2 {
            switch currentBox {
            case .learning:
                return .learning
            case .review:
                return .learning
            case .mastery:
                return .review
            case .expert:
                return .mastery
            }
        }

        return currentBox
    }

    private func calculateNextReview(box: LeitnerBox) -> Date {
        return Calendar.current.date(
            byAdding: .day,
            value: box.reviewIntervalDays,
            to: Date()
        ) ?? Date()
    }

    // MARK: - SM-2 Algorithm Implementation
    // Based on Supermemo-2 (https://www.supermemo.com/english/ol/sm2.htm)

    private func applySM2Algorithm(_ stat: inout WordStat, isCorrect: Bool) {
        // Determine quality of response (0-5 scale)
        // 0 = complete blackout
        // 1 = incorrect, but correct answer is easy to recall
        // 2 = incorrect, but correct answer is somewhat easy to recall
        // 3 = correct answer with serious difficulty
        // 4 = correct answer after some hesitation
        // 5 = perfect response
        let qualityOfResponse = calculateQualityOfResponse(stat: stat, isCorrect: isCorrect)

        if isCorrect && qualityOfResponse >= 3 {
            // User got it right with acceptable quality - increase interval
            stat.repetitionCount += 1

            // Calculate new interval
            if stat.repetitionCount == 1 {
                stat.intervalDays = 1
            } else if stat.repetitionCount == 2 {
                stat.intervalDays = 3
            } else {
                stat.intervalDays = Int(Double(stat.intervalDays) * stat.easeFactor)
            }
        } else {
            // User got it wrong or had difficulty - reset repetition count
            stat.repetitionCount = 0
            stat.intervalDays = 1
        }

        // Update ease factor based on SM-2 formula
        let newEF = stat.easeFactor + (0.1 - (5 - Double(qualityOfResponse)) * (0.08 + (5 - Double(qualityOfResponse)) * 0.02))
        stat.easeFactor = max(1.3, newEF) // Minimum ease factor is 1.3

        // Update next review date based on SM-2 interval
        if let nextDate = Calendar.current.date(byAdding: .day, value: stat.intervalDays, to: Date()) {
            stat.nextReviewDate = nextDate
        }
    }

    private func calculateQualityOfResponse(stat: WordStat, isCorrect: Bool) -> Int {
        guard isCorrect else { return 0 } // Wrong answer = quality 0

        // Quality based on accuracy and tone accuracy if available
        if let toneAccuracy = stat.toneAccuracy {
            if toneAccuracy >= 90 {
                return 5 // Perfect response
            } else if toneAccuracy >= 70 {
                return 4 // Correct with minor issues
            } else if toneAccuracy >= 50 {
                return 3 // Correct with difficulty
            } else {
                return 2 // Technically correct but with issues
            }
        } else {
            // No tone data, base on overall accuracy
            let accuracy = stat.accuracy
            if accuracy >= 0.95 {
                return 5
            } else if accuracy >= 0.80 {
                return 4
            } else if accuracy >= 0.60 {
                return 3
            } else {
                return 2
            }
        }
    }

    // MARK: - Query Methods

    /// Get words due for review today
    func getDueWords(from allWords: [WrappedWord]) -> [WrappedWord] {
        let now = Date()
        return allWords.filter { word in
            guard let stat = wordStats[word.id] else { return true } // Unseen = due
            return stat.nextReviewDate ?? Date.distantPast <= now
        }
    }

    /// Get all word stats
    func getAllStats() -> [String: WordStat] {
        return wordStats
    }

    /// Get stat for word
    func getStat(wordId: String) -> WordStat? {
        return wordStats[wordId]
    }

    /// Get words in specific Leitner box
    func getWordsByBox(_ box: LeitnerBox, from allWords: [WrappedWord]) -> [WrappedWord] {
        return allWords.filter { word in
            let stat = wordStats[word.id]
            return stat?.leitnerBox == box
        }
    }

    /// Get distribution of words across Leitner boxes
    func getBoxDistribution(from allWords: [WrappedWord]) -> [LeitnerBox: Int] {
        var distribution = [LeitnerBox: Int]()

        for box in [LeitnerBox.learning, .review, .mastery, .expert] {
            let count = getWordsByBox(box, from: allWords).count
            distribution[box] = count
        }

        return distribution
    }

    /// Get average accuracy across all attempted words
    func getAverageAccuracy() -> Double {
        let attempted = wordStats.filter { $0.value.attemptedCount > 0 }
        guard !attempted.isEmpty else { return 0 }

        let total = attempted.reduce(0.0) { $0 + $1.value.accuracy }
        return total / Double(attempted.count)
    }

    /// Get retention rate (words in mastery/expert boxes)
    func getRetentionRate(from allWords: [WrappedWord]) -> Double {
        let mastered = getWordsByBox(.mastery, from: allWords).count +
                       getWordsByBox(.expert, from: allWords).count
        guard !allWords.isEmpty else { return 0 }
        return Double(mastered) / Double(allWords.count)
    }

    // MARK: - Persistence

    func saveToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(wordStats)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("❌ Failed to save word stats: \(error)")
        }
    }

    func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            wordStats = [:]
            return
        }

        do {
            let decoder = JSONDecoder()
            wordStats = try decoder.decode([String: WordStat].self, from: data)
            print("✅ Loaded \(wordStats.count) word stats")
        } catch {
            print("❌ Failed to load word stats: \(error)")
            wordStats = [:]
        }
    }

    func resetAllStats() {
        wordStats = [:]
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        print("🔄 Word stats reset")
    }
}
