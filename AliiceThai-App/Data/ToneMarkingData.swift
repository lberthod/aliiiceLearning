import Foundation

struct ToneMarking: Identifiable, Codable {
    let wordId: String // Link to Word.id / JSON id
    let thai: String // "แมว"
    let romanizationRTGS: String // "maew" (Royal Thai General System)
    let romanizationTone: String // "maew" + marks (from JSON: with_tone field)
    let toneNumber: Int // 1-5 per Thai tone system
    let toneName: String // "mid", "low", "falling", "rising", "high"
    let syllables: [ToneSyllable]

    var id: String { wordId }

    var toneVisual: String {
        switch toneName {
        case "mid":
            return "━━━" // flat line
        case "low":
            return "╲╲╲" // falling
        case "falling":
            return "╲" // downward
        case "rising":
            return "╱" // upward
        case "high":
            return "━" // high flat
        default:
            return ""
        }
    }

    var toneEmoji: String {
        switch toneName {
        case "mid":
            return "➡️" // straight
        case "low":
            return "⬇️" // down
        case "falling":
            return "⬇️" // down
        case "rising":
            return "⬆️" // up
        case "high":
            return "⬆️" // up
        default:
            return "❓"
        }
    }
}

struct ToneSyllable: Codable {
    let thai: String // syllable in Thai script
    let romanization: String // romanization
    let tone: String // "mid", "low", "falling", "rising", "high"
    let ipa: String? // International Phonetic Alphabet (if available)
    let consonantClass: String? // "high", "middle", "low" (if available)
    let vowel: String? // a, e, i, o, u + length markers
    let toneNumber: Int? // 1-5

    var toneNumberComputed: Int {
        return JSONWordParser.shared.getToneNumber(toneName: tone)
    }

    var toneVisual: String {
        let normalized = JSONWordParser.shared.getToneName(tone)
        switch normalized {
        case "mid":
            return "━"
        case "low":
            return "╲"
        case "falling":
            return "╲"
        case "rising":
            return "╱"
        case "high":
            return "━"
        default:
            return ""
        }
    }
}

// MARK: - ToneMarkingData Factory

class ToneMarkingData {
    static let shared = ToneMarkingData()

    private var toneMarkings: [String: ToneMarking] = [:]

    /// Build tone markings from wrapped words
    func buildFromWrappedWords(_ words: [WrappedWord]) {
        toneMarkings = [:]

        for word in words {
            let syllables = word.linguistic.syllables.map { syllableData in
                ToneSyllable(
                    thai: syllableData.thai,
                    romanization: syllableData.romanization,
                    tone: syllableData.tone,
                    ipa: nil, // Could be extracted from JSON if available
                    consonantClass: nil, // Could be derived if needed
                    vowel: nil, // Could be extracted if needed
                    toneNumber: JSONWordParser.shared.getToneNumber(toneName: syllableData.tone)
                )
            }

            // Use first syllable's tone for word tone (or average for multi-syllables)
            let primaryTone = word.linguistic.syllables.first?.tone ?? "mid"
            let primaryToneNumber = JSONWordParser.shared.getToneNumber(toneName: primaryTone)

            let toneMarking = ToneMarking(
                wordId: word.id,
                thai: word.core.thai,
                romanizationRTGS: word.core.romanization.rtgs,
                romanizationTone: word.core.romanization.with_tone,
                toneNumber: primaryToneNumber,
                toneName: JSONWordParser.shared.getToneName(primaryTone),
                syllables: syllables
            )

            toneMarkings[word.id] = toneMarking
        }

        print("✅ Built tone markings for \(toneMarkings.count) words")
    }

    /// Get tone marking for word
    func getToneMarking(wordId: String) -> ToneMarking? {
        return toneMarkings[wordId]
    }

    /// Get all tone markings
    func getAllToneMarkings() -> [ToneMarking] {
        return Array(toneMarkings.values)
    }

    /// Get words by tone number
    func getWords(byToneNumber toneNumber: Int) -> [ToneMarking] {
        return toneMarkings.values.filter { $0.toneNumber == toneNumber }
    }

    /// Get words by tone name
    func getWords(byToneName toneName: String) -> [ToneMarking] {
        let normalized = JSONWordParser.shared.getToneName(toneName)
        return toneMarkings.values.filter { JSONWordParser.shared.getToneName($0.toneName) == normalized }
    }

    /// Get single vs multi-syllable words for difficulty progression
    func getSingleSyllableWords() -> [ToneMarking] {
        return toneMarkings.values.filter { $0.syllables.count == 1 }
    }

    func getMultiSyllableWords() -> [ToneMarking] {
        return toneMarkings.values.filter { $0.syllables.count > 1 }
    }
}
