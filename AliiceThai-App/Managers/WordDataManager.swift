import Foundation
import Combine

class WordDataManager: ObservableObject {
    static let shared = WordDataManager()

    @Published var allWords: [WrappedWord] = []
    @Published var isLoading = false
    @Published var error: String?

    // Caches for performance
    private var wordsByLevel: [String: [WrappedWord]] = [:]
    private var wordsByClassifier: [String: [WrappedWord]] = [:]
    private var searchIndex: [String: [WrappedWord]] = [:]
    private let searchQueue = DispatchQueue(label: "com.alicethai.search", qos: .userInitiated)

    init() {
        loadWords()
    }

    func loadWords() {
        isLoading = true

        // Load in background
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = Bundle.main.url(forResource: "worddata", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let words = try decoder.decode([WrappedWord].self, from: data)

                    DispatchQueue.main.async {
                        self.allWords = words
                        self.buildCaches(words)
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.error = "Failed to load words: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.error = "worddata.json not found"
                    self.isLoading = false
                }
            }
        }
    }

    // Build caches for fast lookup
    private func buildCaches(_ words: [WrappedWord]) {
        // Cache by level
        for word in words {
            let level = word.learning.level
            wordsByLevel[level, default: []].append(word)
        }

        // Cache by classifier
        for word in words {
            if let clf = word.linguistic.classifier {
                wordsByClassifier[clf, default: []].append(word)
            }
        }

        // Build search index (optimized for partial matching)
        for word in words {
            let thaiIndex = word.core.thai.lowercased()
            let romanIndex = word.core.romanization.with_tone.lowercased()
            let frIndex = (word.core.translation.fr as? String)?.lowercased() ?? ""

            for key in [thaiIndex, romanIndex, frIndex] where !key.isEmpty {
                searchIndex[key, default: []].append(word)
            }
        }
    }

    func getWordsByLevel(_ level: String) -> [WrappedWord] {
        return wordsByLevel[level] ?? []
    }

    func getWordsByClassifier(_ classifier: String) -> [WrappedWord] {
        return wordsByClassifier[classifier] ?? []
    }

    func searchWords(query: String) -> [WrappedWord] {
        guard !query.isEmpty else { return allWords }

        let lowercased = query.lowercased()
        var results: Set<String> = []
        var foundWords: [WrappedWord] = []

        // Quick search in index
        for (key, words) in searchIndex {
            if key.contains(lowercased) {
                for word in words {
                    if results.insert(word.id).inserted {
                        foundWords.append(word)
                    }
                }
            }
        }

        return foundWords.isEmpty ? allWords.filter { word in
            word.core.thai.contains(lowercased) ||
            word.core.romanization.with_tone.localizedCaseInsensitiveContains(lowercased) ||
            (word.core.translation.fr as? String)?.localizedCaseInsensitiveContains(lowercased) ?? false
        } : foundWords
    }

    func getStats() -> (totalWords: Int, levels: [String], classifiers: [String]) {
        let levels = Set(allWords.map { $0.learning.level }).sorted()
        let classifiers = Set(allWords.compactMap { $0.linguistic.classifier }).sorted()
        return (allWords.count, levels, classifiers)
    }
}
