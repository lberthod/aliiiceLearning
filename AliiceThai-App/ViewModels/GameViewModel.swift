import Foundation
import Combine

class GameViewModel: ObservableObject {
    static let shared = GameViewModel()

    @Published var allWords: [Word] = []
    @Published var wrappedWords: [WrappedWord] = []
    @Published var categories: [String] = []
    @Published var currentWord: Word?
    @Published var remainingWords: [Word] = []
    @Published var quizOptions: [Word] = []
    @Published var selectedCategory: String = "animals" {
        didSet {
            loadWordsForCategory()
        }
    }

    // MARK: - Spaced Repetition & Word Stats
    @Published var wordStats: [String: WordStat] = [:]

    init() {
        loadAllWords()
        loadWrappedWords()
        extractCategories()
        loadWordsForCategory()
        loadSpacedRepStats()
    }

    private func loadAllWords() {
        allWords = ALL_WORDS
    }

    private func loadWrappedWords() {
        if let words = JSONWordParser.shared.loadWordsFromJSON() {
            wrappedWords = words
        }
    }

    private func extractCategories() {
        let unique = Set(allWords.map { $0.category })
        categories = Array(unique).sorted()
    }

    private func loadSpacedRepStats() {
        wordStats = SpacedRepetitionScheduler.shared.getAllStats()
    }

    func loadWordsForCategory() {
        let categoryWords = allWords.filter { $0.category == selectedCategory }
        remainingWords = categoryWords.shuffled()
        currentWord = remainingWords.first
    }

    func nextWord() {
        if !remainingWords.isEmpty {
            remainingWords.removeFirst()
        }
        currentWord = remainingWords.first

        if remainingWords.isEmpty {
            loadWordsForCategory()
        }
    }

    func generateQuizOptions() -> [Word] {
        guard let current = currentWord else { return [] }

        var options: [Word] = [current]

        // Try to get 3 other words from same category
        let otherWordsInCategory = allWords.filter { $0.id != current.id && $0.category == selectedCategory }
        let shuffledInCategory = otherWordsInCategory.shuffled()

        let fromCategory = min(3, shuffledInCategory.count)
        for i in 0..<fromCategory {
            options.append(shuffledInCategory[i])
        }

        // If we need more options, get from other categories
        if options.count < 4 {
            let otherCategoryWords = allWords.filter { $0.category != selectedCategory }
            let shuffledOthers = otherCategoryWords.shuffled()

            var neededCount = 4 - options.count
            for word in shuffledOthers {
                if neededCount == 0 { break }
                if !options.contains(where: { $0.id == word.id }) {
                    options.append(word)
                    neededCount -= 1
                }
            }
        }

        quizOptions = options.shuffled()
        return quizOptions
    }

    func isCorrectAnswer(_ word: Word) -> Bool {
        return word.id == currentWord?.id
    }

    func getLocalizedTranslation(for word: Word, language: String) -> String {
        return language == "fr" ? word.french : word.english
    }

    func getTodaysLessonWords(count: Int = 8) -> [Word] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: today) ?? 1

        let unseenWords = allWords.filter { word in
            !word.category.isEmpty
        }

        guard !unseenWords.isEmpty else { return [] }

        var shuffled = unseenWords.shuffled()
        let seed = dayOfYear % unseenWords.count
        let rotated = Array(shuffled.dropFirst(seed)) + Array(shuffled.prefix(seed))

        return Array(rotated.prefix(count))
    }

    // MARK: - Spaced Repetition Methods

    func recordQuizAnswer(wordId: String, isCorrect: Bool, toneCorrect: Bool? = nil) {
        SpacedRepetitionScheduler.shared.recordAttempt(
            wordId: wordId,
            isCorrect: isCorrect,
            toneCorrect: toneCorrect
        )
        loadSpacedRepStats()
    }

    func getTodaysDueWords() -> [WrappedWord] {
        let dueWords = SpacedRepetitionScheduler.shared.getDueWords(from: wrappedWords)
        return dueWords
    }

    func getWordAccuracy(_ wordId: String) -> Int? {
        return wordStats[wordId]?.accuracyPercentage
    }

    func getWordLeitnerBox(_ wordId: String) -> LeitnerBox? {
        return wordStats[wordId]?.leitnerBox
    }

    // MARK: - Classifier Methods

    func getClassifierForWord(_ wordId: String) -> String? {
        return ClassifiersData.shared.getClassifier(forWordId: wordId)
    }

    func recordClassifierAttempt(classifierId: String, isCorrect: Bool) {
        let gameState = GameState.shared
        gameState.recordClassifierAttempt(classifierId: classifierId, isCorrect: isCorrect)
    }
}
