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

    // MARK: - Confusable Pairs Tracking (Phase 4)
    @Published var studiedConfusablePairs: Set<String> = [] {
        didSet {
            saveState()
        }
    }
    @Published var wrongAnswersOnConfusablePairs: [String: Int] = [:] {
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
    private let studiedConfusablePairsKey = "studiedConfusablePairs"
    private let wrongAnswersOnConfusablePairsKey = "wrongAnswersOnConfusablePairs"

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
        UserDefaults.standard.set(Array(studiedConfusablePairs), forKey: studiedConfusablePairsKey)
        UserDefaults.standard.set(wrongAnswersOnConfusablePairs, forKey: wrongAnswersOnConfusablePairsKey)
        UserDefaults.standard.set(Array(completedMissions), forKey: completedMissionsKey)
        UserDefaults.standard.set(missionProgress, forKey: missionProgressKey)
        UserDefaults.standard.set(totalXP, forKey: totalXPKey)

        // Save challenge data
        if let challengeData = try? JSONEncoder().encode(currentChallenge) {
            UserDefaults.standard.set(challengeData, forKey: currentChallengeKey)
        }
        UserDefaults.standard.set(streakDays, forKey: streakDaysKey)
        UserDefaults.standard.set(lastActivityDate, forKey: lastActivityDateKey)
        UserDefaults.standard.set(completedChallenges, forKey: completedChallengesKey)
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
        if let savedConfusablePairs = UserDefaults.standard.array(forKey: studiedConfusablePairsKey) as? [String] {
            studiedConfusablePairs = Set(savedConfusablePairs)
        }
        if let savedConfusableMistakes = UserDefaults.standard.dictionary(forKey: wrongAnswersOnConfusablePairsKey) as? [String: Int] {
            wrongAnswersOnConfusablePairs = savedConfusableMistakes
        }
        if let savedMissions = UserDefaults.standard.array(forKey: completedMissionsKey) as? [String] {
            completedMissions = Set(savedMissions)
        }
        if let savedProgress = UserDefaults.standard.dictionary(forKey: missionProgressKey) as? [String: Int] {
            missionProgress = savedProgress
        }
        totalXP = UserDefaults.standard.integer(forKey: totalXPKey)

        // Auto-select first uncompleted mission if none selected
        if currentMission == nil {
            selectNextMission()
        }

        // Load challenge data
        if let challengeData = UserDefaults.standard.data(forKey: currentChallengeKey),
           let challenge = try? JSONDecoder().decode(Challenge.self, from: challengeData) {
            currentChallenge = challenge
        }
        streakDays = UserDefaults.standard.integer(forKey: streakDaysKey)
        lastActivityDate = UserDefaults.standard.object(forKey: lastActivityDateKey) as? Date
        if let saved = UserDefaults.standard.array(forKey: completedChallengesKey) as? [String] {
            completedChallenges = saved
        }

        // Initialize daily challenge if needed
        checkAndResetDailyChallenge()
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

    // MARK: - Confusable Pairs Tracking Methods

    func recordConfusablePairStudy(pairId: String) {
        studiedConfusablePairs.insert(pairId)
        saveState()
    }

    func recordConfusablePairMistake(pairId: String) {
        let currentCount = wrongAnswersOnConfusablePairs[pairId] ?? 0
        wrongAnswersOnConfusablePairs[pairId] = currentCount + 1
        saveState()
    }

    func isConfusablePairStudied(_ pairId: String) -> Bool {
        return studiedConfusablePairs.contains(pairId)
    }

    func getConfusablePairMistakeCount(_ pairId: String) -> Int {
        return wrongAnswersOnConfusablePairs[pairId] ?? 0
    }

    func getTotalConfusablePairMistakes() -> Int {
        return wrongAnswersOnConfusablePairs.values.reduce(0, +)
    }

    // MARK: - Mission Tracking (Phase 4 Gamification)

    @Published var currentMission: Mission?
    @Published var completedMissions: Set<String> = [] {
        didSet {
            saveState()
        }
    }
    @Published var missionProgress: [String: Int] = [:] {
        didSet {
            saveState()
        }
    }
    @Published var totalXP: Int = 0 {
        didSet {
            saveState()
        }
    }

    // MARK: - Challenge Tracking (Phase 4 Gamification)

    @Published var currentChallenge: Challenge?
    @Published var streakDays: Int = 0 {
        didSet {
            saveState()
        }
    }
    @Published var lastActivityDate: Date?
    @Published var completedChallenges: [String] = [] {
        didSet {
            saveState()
        }
    }

    private let currentMissionKey = "currentMission"
    private let completedMissionsKey = "completedMissions"
    private let missionProgressKey = "missionProgress"
    private let totalXPKey = "totalXP"
    private let currentChallengeKey = "currentChallenge"
    private let streakDaysKey = "streakDays"
    private let lastActivityDateKey = "lastActivityDate"
    private let completedChallengesKey = "completedChallenges"

    func recordMissionProgress(missionId: String) {
        let current = missionProgress[missionId] ?? 0
        missionProgress[missionId] = current + 1

        // Check if mission is complete
        if let mission = Mission.allMissions.first(where: { $0.id == missionId }) {
            if (missionProgress[missionId] ?? 0) >= mission.targetCount {
                completeMission(missionId)
            } else {
                // Save even if not complete
                saveState()
            }
        }
    }

    func completeMission(_ missionId: String) {
        guard !completedMissions.contains(missionId) else { return }

        completedMissions.insert(missionId)

        if let mission = Mission.allMissions.first(where: { $0.id == missionId }) {
            totalXP += mission.rewardXP
        }

        // Auto-select next mission
        selectNextMission()
        saveState()

        // Log completion for analytics
        let completionDate = Date()
        print("✅ Mission completed: \(missionId) at \(completionDate)")
    }

    func selectNextMission() {
        currentMission = Mission.getNextMissionAfter(completedMissions)
    }

    func getMissionProgress(_ missionId: String) -> Int {
        return missionProgress[missionId] ?? 0
    }

    func isMissionCompleted(_ missionId: String) -> Bool {
        return completedMissions.contains(missionId)
    }

    func getAvailableMissions(for week: Int) -> [Mission] {
        return Mission.getMissionForWeek(week)
    }

    // MARK: - Challenge Management Methods

    func checkAndResetDailyChallenge() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = lastActivityDate {
            let lastDateStart = calendar.startOfDay(for: lastDate)

            if lastDateStart < today {
                // New day detected
                if currentChallenge?.isCompleted == true {
                    // Challenge was completed yesterday, extend streak
                    streakDays += 1
                } else if lastDateStart < calendar.date(byAdding: .day, value: -1, to: today) ?? today {
                    // Missed a day, reset streak
                    streakDays = 0
                }

                // Generate new daily challenge
                currentChallenge = Challenge.generateDailyChallenge()
            }
        } else {
            // First time, generate initial challenge
            currentChallenge = Challenge.generateDailyChallenge()
            streakDays = 1
        }

        lastActivityDate = Date()
        saveState()
    }

    func recordChallengeProgress() {
        guard var challenge = currentChallenge else { return }
        challenge.incrementProgress()
        currentChallenge = challenge

        if challenge.isCompleted {
            completedChallenges.append(challenge.id)
        }

        saveState()
    }

    func isChallengeCompleted() -> Bool {
        return currentChallenge?.isCompleted ?? false
    }

    func getChallengeProgress() -> (current: Int, target: Int) {
        guard let challenge = currentChallenge else { return (0, 0) }
        return (challenge.progressCount, challenge.targetCount)
    }
}

