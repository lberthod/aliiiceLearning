import Foundation
import Combine

struct CurriculumWeek {
    let weekNumber: Int
    let goal: String
    let goalFrench: String
    let description: String
    let descriptionFrench: String
    let targetWordCount: Int
    let listeningExercises: Int
    let outputTasks: Int
    let missionTitle: String
    let missionTitleFrench: String
    let missionDescription: String
    let missionDescriptionFrench: String
    let skillFocus: [String]
    let skillFocusFrench: [String]
}

struct ScheduledWord {
    let word: WrappedWord
    let scheduledDate: Date
    let weekNumber: Int
    let dayOfWeek: Int
    let priority: String
    let repetitionNumber: Int
}

class CurriculumPath: ObservableObject {
    static let shared = CurriculumPath()

    @Published var currentWeek: Int = 1

    let pathWeeks: [CurriculumWeek] = [
        CurriculumWeek(
            weekNumber: 1,
            goal: "I can greet and introduce myself",
            goalFrench: "Je peux saluer et me présenter",
            description: "Learn basic greetings, polite phrases, and how to introduce yourself in Thai",
            descriptionFrench: "Apprenez les salutations de base, les formules de politesse et comment vous présenter en thaï",
            targetWordCount: 15,
            listeningExercises: 5,
            outputTasks: 8,
            missionTitle: "Meet Alice at the Airport",
            missionTitleFrench: "Rencontrer Alice à l'aéroport",
            missionDescription: "Greet Alice politely and introduce yourself with your name and basic information",
            missionDescriptionFrench: "Saluez Alice poliment et présentez-vous avec votre nom et vos informations de base",
            skillFocus: ["Greetings", "Pronouns", "Polite particles"],
            skillFocusFrench: ["Salutations", "Pronoms", "Particules de politesse"]
        ),

        CurriculumWeek(
            weekNumber: 2,
            goal: "I can talk about family and daily life",
            goalFrench: "Je peux parler de ma famille et de la vie quotidienne",
            description: "Talk about family members, possessions, and describe daily routines",
            descriptionFrench: "Parlez de la famille, des possessions et décrivez les routines quotidiennes",
            targetWordCount: 15,
            listeningExercises: 5,
            outputTasks: 8,
            missionTitle: "Family Conversation Over Tea",
            missionTitleFrench: "Conversation familiale autour du thé",
            missionDescription: "Describe your family and ask Alice about her family while sharing tea",
            missionDescriptionFrench: "Décrivez votre famille et demandez à Alice la sienne autour d'une tasse de thé",
            skillFocus: ["Family vocabulary", "Possessives", "Present tense"],
            skillFocusFrench: ["Vocabulaire familial", "Possessifs", "Présent simple"]
        ),

        CurriculumWeek(
            weekNumber: 3,
            goal: "I can order food and express preferences",
            goalFrench: "Je peux commander à manger et exprimer mes préférences",
            description: "Learn food vocabulary, how to order, express likes/dislikes, and discuss flavors",
            descriptionFrench: "Apprenez le vocabulaire culinaire, comment commander, exprimer vos goûts et les saveurs",
            targetWordCount: 15,
            listeningExercises: 5,
            outputTasks: 8,
            missionTitle: "Restaurant Ordering Challenge",
            missionTitleFrench: "Défi de commande au restaurant",
            missionDescription: "Order a complete meal at a Thai restaurant, specify preferences, and ask about dishes",
            missionDescriptionFrench: "Commandez un repas complet au restaurant thaï, spécifiez vos préférences et posez des questions",
            skillFocus: ["Food vocabulary", "Classifiers", "Preference verbs"],
            skillFocusFrench: ["Vocabulaire culinaire", "Classificateurs", "Verbes de préférence"]
        ),

        CurriculumWeek(
            weekNumber: 4,
            goal: "I can navigate and ask for directions",
            goalFrench: "Je peux naviguer et demander des directions",
            description: "Learn location words, directions, prepositions, and how to ask and give directions",
            descriptionFrench: "Apprenez les mots de localisation, les directions, les prépositions et comment demander/donner des directions",
            targetWordCount: 15,
            listeningExercises: 5,
            outputTasks: 8,
            missionTitle: "Navigate Bangkok with Alice",
            missionTitleFrench: "Naviguer à Bangkok avec Alice",
            missionDescription: "Help Alice navigate around Bangkok, asking for and giving directions using landmarks",
            missionDescriptionFrench: "Aidez Alice à naviguer à Bangkok en demandant et donnant des directions avec des repères",
            skillFocus: ["Location vocabulary", "Prepositions", "Direction verbs"],
            skillFocusFrench: ["Vocabulaire de localisation", "Prépositions", "Verbes de direction"]
        )
    ]

    func getWeekSchedule(weekNumber: Int) -> CurriculumWeek? {
        return pathWeeks.first { $0.weekNumber == weekNumber }
    }

    func generateLearningSchedule(
        allWords: [WrappedWord],
        weekNumber: Int,
        scheduler: SpacedRepetitionScheduler
    ) -> [ScheduledWord] {
        guard let week = getWeekSchedule(weekNumber: weekNumber) else {
            return []
        }

        // Filter words by level and priority for the given week
        let weekWords = filterWordsByWeek(allWords, weekNumber: weekNumber)
            .sorted { $0.learning.priority < $1.learning.priority }
            .prefix(week.targetWordCount)

        var scheduled: [ScheduledWord] = []

        // Distribute words across 7 days with spacing
        for (index, word) in weekWords.enumerated() {
            let dayOfWeek = index % 7  // Spread across week (0-6)
            let startDate = getWeekStartDate(weekNumber: weekNumber)
            let scheduledDate = Calendar.current.date(byAdding: .day, value: dayOfWeek, to: startDate) ?? Date()

            // First 5 words per day are high priority, rest are medium
            let priority = index < (week.targetWordCount / 2) ? "high" : "medium"

            scheduled.append(ScheduledWord(
                word: word,
                scheduledDate: scheduledDate,
                weekNumber: weekNumber,
                dayOfWeek: dayOfWeek,
                priority: priority,
                repetitionNumber: 1
            ))
        }

        return scheduled
    }

    private func filterWordsByWeek(_ words: [WrappedWord], weekNumber: Int) -> [WrappedWord] {
        // Filter by level: Week 1-2 = A1.1-A1.2, Week 3-4 = A1.3-A2.1
        let minLevel = weekNumber <= 2 ? "A1.1" : "A1.3"
        let maxLevel = weekNumber <= 2 ? "A1.2" : "A2.1"

        return words.filter { word in
            let level = word.learning.level
            return level >= minLevel && level <= maxLevel
        }
    }

    private func getWeekStartDate(weekNumber: Int) -> Date {
        // Calculate the start date of the given week
        let daysToAdd = (weekNumber - 1) * 7
        return Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date()) ?? Date()
    }

    func getWeekProgress(
        weekNumber: Int,
        gameState: GameState
    ) -> (completed: Int, total: Int, percentage: Int) {
        guard let week = getWeekSchedule(weekNumber: weekNumber) else {
            return (0, 0, 0)
        }

        let targetTotal = week.targetWordCount
        // Get count of words learned this week
        let completedCount = 0  // Would be calculated from gameState.learnedPhrases
        let percentage = targetTotal > 0 ? (completedCount * 100) / targetTotal : 0

        return (completedCount, targetTotal, percentage)
    }

    func getMissionBriefing(weekNumber: Int, language: String = "en") -> (title: String, description: String) {
        guard let week = getWeekSchedule(weekNumber: weekNumber) else {
            return ("", "")
        }

        if language == "fr" {
            return (week.missionTitleFrench, week.missionDescriptionFrench)
        } else {
            return (week.missionTitle, week.missionDescription)
        }
    }
}
