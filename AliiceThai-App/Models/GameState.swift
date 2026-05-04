import Foundation
import Combine

class GameState: ObservableObject {
    static let shared = GameState()

    @Published var selectedCategory: String = "animals"
    @Published var currentStars: Int = 0
    @Published var bestStarsByCategory: [String: Int] = [:]
    @Published var selectedLanguage: String = "en" {
        didSet {
            saveState()
            LocalizationManager.shared.currentLanguage = selectedLanguage
        }
    }
    @Published var hasCompletedOnboarding: Bool = false
    @Published var learnedPhrases: Set<String> = [] {
        didSet {
            saveState()
        }
    }

    // MARK: - Tone Tracking (Phase 1)
    @Published var toneAccuracyByWord: [String: Int] = [:] {
        didSet {
            saveState()
        }
    }
    @Published var toneAttempts: [String: Int] = [:] {
        didSet {
            saveState()
        }
    }
    @Published var weakToneWords: Set<String> = [] {
        didSet {
            saveState()
        }
    }

    // MARK: - Classifier Tracking (Phase 1)
    @Published var classifiersLearned: Set<String> = [] {
        didSet {
            saveState()
        }
    }
    @Published var classifierQuizScores: [String: Int] = [:] {
        didSet {
            saveState()
        }
    }
    @Published var classifierAttempts: [String: Int] = [:] {
        didSet {
            saveState()
        }
    }

    // MARK: - Output Practice Tracking (Phase 2)
    @Published var outputPracticedWords: Set<String> = [] {
        didSet {
            saveState()
        }
    }
    @Published var outputTasksCompleted: [String: Int] = [:] {
        didSet {
            saveState()
        }
    }

    private let categoryStarsKey = "categoryStars"
    private let onboardingKey = "hasCompletedOnboarding"
    private let languageKey = "selectedLanguage"
    private let learnedPhrasesKey = "learnedPhrases"
    private let toneAccuracyKey = "toneAccuracyByWord"
    private let toneAttemptsKey = "toneAttempts"
    private let weakToneWordsKey = "weakToneWords"
    private let classifiersLearnedKey = "classifiersLearned"
    private let classifierScoresKey = "classifierQuizScores"
    private let classifierAttemptsKey = "classifierAttempts"
    private let outputPracticedWordsKey = "outputPracticedWords"
    private let outputTasksCompletedKey = "outputTasksCompleted"

    init() {
        loadState()
    }

    func saveState() {
        UserDefaults.standard.set(bestStarsByCategory, forKey: categoryStarsKey)
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: onboardingKey)
        UserDefaults.standard.set(selectedLanguage, forKey: languageKey)
        UserDefaults.standard.set(Array(learnedPhrases), forKey: learnedPhrasesKey)
        UserDefaults.standard.set(toneAccuracyByWord, forKey: toneAccuracyKey)
        UserDefaults.standard.set(toneAttempts, forKey: toneAttemptsKey)
        UserDefaults.standard.set(Array(weakToneWords), forKey: weakToneWordsKey)
        UserDefaults.standard.set(Array(classifiersLearned), forKey: classifiersLearnedKey)
        UserDefaults.standard.set(Array(outputPracticedWords), forKey: outputPracticedWordsKey)
        UserDefaults.standard.set(outputTasksCompleted, forKey: outputTasksCompletedKey)
        UserDefaults.standard.set(classifierQuizScores, forKey: classifierScoresKey)
        UserDefaults.standard.set(classifierAttempts, forKey: classifierAttemptsKey)
    }

    func loadState() {
        if let saved = UserDefaults.standard.dictionary(forKey: categoryStarsKey) as? [String: Int] {
            bestStarsByCategory = saved
        }
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
        selectedLanguage = UserDefaults.standard.string(forKey: languageKey) ?? "en"
        if let savedPhrases = UserDefaults.standard.array(forKey: learnedPhrasesKey) as? [String] {
            learnedPhrases = Set(savedPhrases)
        }
        if let savedToneAccuracy = UserDefaults.standard.dictionary(forKey: toneAccuracyKey) as? [String: Int] {
            toneAccuracyByWord = savedToneAccuracy
        }
        if let savedToneAttempts = UserDefaults.standard.dictionary(forKey: toneAttemptsKey) as? [String: Int] {
            toneAttempts = savedToneAttempts
        }
        if let savedWeakTones = UserDefaults.standard.array(forKey: weakToneWordsKey) as? [String] {
            weakToneWords = Set(savedWeakTones)
        }
        if let savedClassifiers = UserDefaults.standard.array(forKey: classifiersLearnedKey) as? [String] {
            classifiersLearned = Set(savedClassifiers)
        }
        if let savedScores = UserDefaults.standard.dictionary(forKey: classifierScoresKey) as? [String: Int] {
            classifierQuizScores = savedScores
        }
        if let savedAttempts = UserDefaults.standard.dictionary(forKey: classifierAttemptsKey) as? [String: Int] {
            classifierAttempts = savedAttempts
        }
        if let savedOutputWords = UserDefaults.standard.array(forKey: outputPracticedWordsKey) as? [String] {
            outputPracticedWords = Set(savedOutputWords)
        }
        if let savedOutputTasks = UserDefaults.standard.dictionary(forKey: outputTasksCompletedKey) as? [String: Int] {
            outputTasksCompleted = savedOutputTasks
        }
    }

    func addStar() {
        currentStars += 1
        updateBestStarsForCategory()
    }

    func resetCurrentStars() {
        currentStars = 0
    }

    private func updateBestStarsForCategory() {
        let current = bestStarsByCategory[selectedCategory] ?? 0
        if currentStars > current {
            bestStarsByCategory[selectedCategory] = currentStars
            saveState()
        }
    }

    func getBestStars(for category: String) -> Int {
        return bestStarsByCategory[category] ?? 0
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveState()
    }

    func setLanguage(_ language: String) {
        selectedLanguage = language
        saveState()
    }

    func getLocalizedString(_ english: String, _ french: String) -> String {
        return selectedLanguage == "fr" ? french : english
    }

    // MARK: - Learning Progress Tracking

    /// Mark a phrase as learned (unique ID based on Thai text)
    func markPhraseLearned(_ thaiText: String) {
        learnedPhrases.insert(thaiText)
    }

    /// Check if a phrase has been learned
    func isPhraseLearned(_ thaiText: String) -> Bool {
        return learnedPhrases.contains(thaiText)
    }

    /// Get count of learned phrases in a category
    func getLearnedPhraseCount(in category: [String]) -> Int {
        return category.filter { learnedPhrases.contains($0) }.count
    }

    /// Get progress percentage for a category (0-100)
    func getProgressPercentage(in category: [String]) -> Int {
        guard category.count > 0 else { return 0 }
        let learned = getLearnedPhraseCount(in: category)
        return (learned * 100) / category.count
    }

    // MARK: - Tone Tracking Methods

    func recordToneAttempt(wordId: String, isCorrect: Bool) {
        let currentAttempts = toneAttempts[wordId] ?? 0
        toneAttempts[wordId] = currentAttempts + 1

        let currentAccuracy = toneAccuracyByWord[wordId] ?? 0
        let newAccuracy = isCorrect ? 100 : 0
        toneAccuracyByWord[wordId] = (currentAccuracy + newAccuracy) / 2

        if !isCorrect {
            weakToneWords.insert(wordId)
        } else if toneAccuracyByWord[wordId]! >= 80 {
            weakToneWords.remove(wordId)
        }

        saveState()
    }

    func getToneAccuracy(wordId: String) -> Int {
        return toneAccuracyByWord[wordId] ?? 0
    }

    func getWeakTones() -> Set<String> {
        return weakToneWords.filter { toneAccuracyByWord[$0] ?? 0 < 70 }
    }

    func getToneAttempts(wordId: String) -> Int {
        return toneAttempts[wordId] ?? 0
    }

    // MARK: - Classifier Tracking Methods

    func recordClassifierAttempt(classifierId: String, isCorrect: Bool) {
        let currentAttempts = classifierAttempts[classifierId] ?? 0
        classifierAttempts[classifierId] = currentAttempts + 1

        if isCorrect {
            let currentScore = classifierQuizScores[classifierId] ?? 0
            classifierQuizScores[classifierId] = min(currentScore + 1, 100)
            classifiersLearned.insert(classifierId)
        }
        saveState()
    }

    func getClassifierMastery(_ classifierId: String) -> Int {
        return classifierQuizScores[classifierId] ?? 0
    }

    func getClassifierAttempts(_ classifierId: String) -> Int {
        return classifierAttempts[classifierId] ?? 0
    }

    func isClassifierLearned(_ classifierId: String) -> Bool {
        return classifiersLearned.contains(classifierId)
    }

    func resetAllClassifierProgress() {
        classifiersLearned.removeAll()
        classifierQuizScores.removeAll()
        classifierAttempts.removeAll()
        saveState()
    }

    // MARK: - Output Practice Tracking Methods

    func recordOutputPractice(wordId: String) {
        outputPracticedWords.insert(wordId)
        let currentCount = outputTasksCompleted[wordId] ?? 0
        outputTasksCompleted[wordId] = currentCount + 1
        saveState()
    }

    func isWordOutputPracticed(_ wordId: String) -> Bool {
        return outputPracticedWords.contains(wordId)
    }

    func getOutputTaskCompletions(_ wordId: String) -> Int {
        return outputTasksCompleted[wordId] ?? 0
    }

    func getOutputPracticedCount() -> Int {
        return outputPracticedWords.count
    }
}

