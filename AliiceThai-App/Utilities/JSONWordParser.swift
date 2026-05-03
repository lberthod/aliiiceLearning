import Foundation

// MARK: - Decodable Structures for wrapped JSON

struct WrappedWord: Codable {
    let id: String
    let version: String
    let status: String
    let core: CoreData
    let linguistic: LinguisticData
    let audio: AudioData
    let learning: LearningData
    let usage: UsageData
    let memory: MemoryData
    let relations: RelationsData
    let quiz: QuizData
    let user_progress_template: UserProgressTemplate
    let metadata: MetadataData
}

struct CoreData: Codable {
    let emoji: String
    let thai: String
    let romanization: RomanizationData
    let translation: TranslationData
}

struct RomanizationData: Codable {
    let simple: String
    let rtgs: String
    let with_tone: String
}

struct TranslationData: Codable {
    let fr: String
    let en: String
}

struct LinguisticData: Codable {
    let word_type: String
    let classifier: String?
    let syllables: [SyllableData]
    let register: String
    let politeness: String
}

struct SyllableData: Codable {
    let thai: String
    let romanization: String
    let tone: String
}

struct AudioData: Codable {
    let tts_provider: String
    let voice: String
    let audio_key: String
    let variants: AudioVariants
}

struct AudioVariants: Codable {
    let slow: String
    let normal: String
    let fast: String
}

struct LearningData: Codable {
    let level: String
    let priority: Int
    let frequency: String
    let difficulty_score: Int
    let recommended_order: Int
    let skills: [String]
}

struct UsageData: Codable {
    let contexts: [String]
    let example_sentences: [ExampleSentence]
    let common_phrases: [CommonPhrase]
}

struct ExampleSentence: Codable {
    let id: String
    let thai: String
    let romanization: String
    let fr: String
    let en: String
    let audio_key: String
}

struct CommonPhrase: Codable {
    let thai: String
    let romanization: String
    let fr: String
    let en: String
}

struct MemoryData: Codable {
    let mnemonic_fr: String
    let visual_strength: Int
    let emotional_tag: String
    let image_prompt: String
}

struct RelationsData: Codable {
    let same_category: [String]
    let related_words: [String]
    let confusable_with: [ConfusableWord]
}

struct ConfusableWord: Codable {
    let id: String
    let reason: String
}

struct QuizData: Codable {
    let enabled: Bool?
    let question_types: [String]
    let distractors: [String]
}

struct UserProgressTemplate: Codable {
    let seen_count: Int
    let correct_count: Int
    let wrong_count: Int
    let mastery_score: Int
    let last_seen_at: String?
    let next_review_at: String?
    let ease_factor: Double
    let interval_days: Int
    let is_mastered: Bool
}

struct MetadataData: Codable {
    let created_at: String
    let updated_at: String
    let source: String
    let notes: String
}

// MARK: - JSON Word Parser

class JSONWordParser {
    static let shared = JSONWordParser()

    private var wrappedWords: [WrappedWord] = []
    private var wordsByID: [String: WrappedWord] = [:]

    /// Load JSON from bundle
    func loadWordsFromJSON(filename: String = "worddata") -> [WrappedWord]? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("❌ Failed to find \(filename).json")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let words = try decoder.decode([WrappedWord].self, from: data)
            self.wrappedWords = words
            self.buildIndex()
            print("✅ Loaded \(words.count) words from JSON")
            return words
        } catch {
            print("❌ Failed to decode JSON: \(error)")
            return nil
        }
    }

    /// Build index for quick lookup
    private func buildIndex() {
        wordsByID = [:]
        for word in wrappedWords {
            wordsByID[word.id] = word
        }
    }

    /// Get all words
    func getAllWords() -> [WrappedWord] {
        return wrappedWords
    }

    /// Get word by ID
    func getWord(id: String) -> WrappedWord? {
        return wordsByID[id]
    }

    /// Get all unique classifiers
    func getAllClassifiers() -> Set<String> {
        var classifiers = Set<String>()
        for word in wrappedWords {
            if let classifier = word.linguistic.classifier {
                classifiers.insert(classifier)
            }
        }
        return classifiers
    }

    /// Get words by classifier
    func getWords(byClassifier classifier: String) -> [WrappedWord] {
        return wrappedWords.filter { $0.linguistic.classifier == classifier }
    }

    /// Get words by context/category
    func getWords(byContext context: String) -> [WrappedWord] {
        return wrappedWords.filter { $0.usage.contexts.contains(context) }
    }

    /// Get words by level
    func getWords(byLevel level: String) -> [WrappedWord] {
        return wrappedWords.filter { $0.learning.level == level }
    }

    /// Get tone name from syllable (normalize tone naming)
    func getToneName(_ toneName: String) -> String {
        let normalized = toneName.lowercased()
        switch normalized {
        case "mid": return "mid"
        case "low": return "low"
        case "falling": return "falling"
        case "rising": return "rising"
        case "high": return "high"
        default: return "mid"
        }
    }

    /// Get tone number (1-5) from tone name
    func getToneNumber(toneName: String) -> Int {
        let normalized = getToneName(toneName)
        switch normalized {
        case "mid": return 1
        case "low": return 2
        case "falling": return 3
        case "rising": return 4
        case "high": return 5
        default: return 1
        }
    }
}
