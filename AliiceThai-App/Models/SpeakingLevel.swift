import Foundation

struct SpeakingLevel {
    let score: Int  // 0-100
    let level: String  // A1, A1.2, A1.3, A2
    let progressToNext: Int  // 0-100% to next level
    let masteryScore: Int
    let toneScore: Int
    let outputScore: Int

    static func calculate(
        wordStats: [String: WordStat],
        toneAccuracyByWord: [String: Int],
        outputPracticedWords: Set<String>,
        learnedPhrases: Set<String>
    ) -> SpeakingLevel {
        let totalWords = wordStats.count
        guard totalWords > 0 else {
            return SpeakingLevel(score: 0, level: "A1", progressToNext: 0, masteryScore: 0, toneScore: 0, outputScore: 0)
        }

        // Calculate mastery score (word progression through Leitner boxes)
        let expertWords = wordStats.filter { $0.value.leitnerBox == .expert }.count
        let masteryWords = wordStats.filter { $0.value.leitnerBox == .mastery }.count
        let masteryScore = Int(Double(expertWords * 1 + masteryWords * 5) / Double(totalWords * 10) * 100)

        // Calculate tone accuracy score
        let toneAccuracies = toneAccuracyByWord.values
        let toneScore = toneAccuracies.isEmpty ? 0 : Int(Double(toneAccuracies.reduce(0, +)) / Double(toneAccuracies.count))

        // Calculate output coverage score
        let outputScore = Int(Double(outputPracticedWords.count) / Double(totalWords) * 100)

        // Weighted formula: mastery (50%) + tone (30%) + output (20%)
        let overallScore = (masteryScore * 5 + toneScore * 3 + outputScore * 2) / 10

        // Map to CEFR level
        let level: String
        switch overallScore {
        case 0...25:
            level = "A1"
        case 25...50:
            level = "A1.2"
        case 50...75:
            level = "A1.3"
        default:
            level = "A2"
        }

        // Calculate progress to next level
        let levelRanges: [String: (min: Int, max: Int)] = [
            "A1": (0, 25),
            "A1.2": (25, 50),
            "A1.3": (50, 75),
            "A2": (75, 100)
        ]

        let (minRange, maxRange) = levelRanges[level] ?? (0, 100)
        let progressToNext = overallScore >= 100 ? 100 : Int(Double(overallScore - minRange) / Double(maxRange - minRange) * 100)

        return SpeakingLevel(
            score: min(overallScore, 100),
            level: level,
            progressToNext: min(progressToNext, 100),
            masteryScore: masteryScore,
            toneScore: toneScore,
            outputScore: outputScore
        )
    }

    var description: String {
        "Your Speaking Level: \(level) (Score: \(score)/100)"
    }

    var nextLevel: String {
        switch level {
        case "A1":
            return "A1.2"
        case "A1.2":
            return "A1.3"
        case "A1.3":
            return "A2"
        default:
            return "Advanced"
        }
    }
}
