import Foundation

struct MissionAction: Codable {
    let step: Int
    let title: String
    let description: String
    let exerciseType: String // "vocabulary", "tone", "output", "listening"
    let targetCount: Int
}

struct Mission: Codable, Identifiable {
    let id: String
    let week: Int
    let title: String
    let description: String
    let longDescription: String // Detailed explanation
    let category: String // "greeting", "food", "family", "navigation", etc.
    let type: String // "vocabulary", "scenario", "speaking", "listening"
    let targetCount: Int // words to master for this mission
    let rewardXP: Int
    let estimatedHours: Int
    let unlockAtWeek: Int
    let vocabulary: [String] // List of word IDs for this mission
    let actions: [MissionAction] // Step-by-step actions

    var displayName: String {
        "Week \(week): \(title)"
    }

    // Mission definitions for curriculum progression
    static let allMissions: [Mission] = [
        // WEEK 1
        Mission(
            id: "w1_greetings",
            week: 1,
            title: "Airport Greetings",
            description: "Master essential greeting phrases for arrival in Thailand",
            longDescription: "Learn how to greet people politely when you arrive in Thailand. Master the essential phrases you'll need at the airport and your first interactions with Thai people.",
            category: "greeting",
            type: "vocabulary",
            targetCount: 10,
            rewardXP: 50,
            estimatedHours: 2,
            unlockAtWeek: 1,
            vocabulary: ["hello", "goodbye", "thank_you", "please", "how_are_you", "name", "nice_meet", "welcome", "sorry", "yes"],
            actions: [
                MissionAction(step: 1, title: "Learn Greetings", description: "Study 5 essential greeting words with tone and pronunciation", exerciseType: "vocabulary", targetCount: 5),
                MissionAction(step: 2, title: "Master Tones", description: "Perfect your tone pronunciation for each greeting", exerciseType: "tone", targetCount: 5),
                MissionAction(step: 3, title: "Practice Speaking", description: "Record yourself greeting people naturally", exerciseType: "output", targetCount: 3),
                MissionAction(step: 4, title: "Quiz Challenge", description: "Test your knowledge with quiz questions", exerciseType: "vocabulary", targetCount: 10)
            ]
        ),

        Mission(
            id: "w1_basics",
            week: 1,
            title: "Basic Survival Phrases",
            description: "Learn phrases to navigate your first day in Bangkok",
            longDescription: "Master essential survival phrases for your first day in Bangkok. Learn how to ask for water, food, bathroom, hotel directions and get help when needed.",
            category: "greeting",
            type: "speaking",
            targetCount: 8,
            rewardXP: 50,
            estimatedHours: 2,
            unlockAtWeek: 1,
            vocabulary: ["water", "food", "bathroom", "hotel", "help", "money", "language", "english"],
            actions: [
                MissionAction(step: 1, title: "Learn Survival Words", description: "Master 8 essential survival words for daily needs", exerciseType: "vocabulary", targetCount: 8),
                MissionAction(step: 2, title: "Output Practice", description: "Practice saying these phrases in context", exerciseType: "output", targetCount: 4),
                MissionAction(step: 3, title: "Listen & Repeat", description: "Hear native speakers and repeat the phrases", exerciseType: "listening", targetCount: 3)
            ]
        ),

        // WEEK 2
        Mission(
            id: "w2_food",
            week: 2,
            title: "Market Foods",
            description: "Explore the floating markets and learn food vocabulary",
            longDescription: "Discover the vibrant floating markets of Thailand and master food vocabulary. Learn how to identify and name different foods and flavors you'll encounter.",
            category: "food",
            type: "vocabulary",
            targetCount: 12,
            rewardXP: 60,
            estimatedHours: 2,
            unlockAtWeek: 2,
            vocabulary: ["rice", "chicken", "fish", "vegetables", "fruit", "mango", "sticky_rice", "spicy", "sweet", "salty", "bitter", "delicious"],
            actions: [
                MissionAction(step: 1, title: "Learn Food Vocabulary", description: "Study 12 food and flavor words", exerciseType: "vocabulary", targetCount: 12),
                MissionAction(step: 2, title: "Tone Training", description: "Master pronunciation of food words", exerciseType: "tone", targetCount: 6),
                MissionAction(step: 3, title: "Listen in Markets", description: "Hear real market vendors selling food", exerciseType: "listening", targetCount: 4)
            ]
        ),

        Mission(
            id: "w2_ordering",
            week: 2,
            title: "Ordering at Restaurants",
            description: "Master the art of ordering food in Thai restaurants",
            longDescription: "Learn how to order food confidently in Thai restaurants. Master phrases for ordering, requesting flavors, and paying the bill.",
            category: "food",
            type: "speaking",
            targetCount: 10,
            rewardXP: 60,
            estimatedHours: 2,
            unlockAtWeek: 2,
            vocabulary: ["order", "menu", "eat", "drink", "hot", "cold", "bill", "pay", "delicious", "not_spicy"],
            actions: [
                MissionAction(step: 1, title: "Learn Ordering Phrases", description: "Master 10 essential ordering phrases", exerciseType: "vocabulary", targetCount: 10),
                MissionAction(step: 2, title: "Speaking Practice", description: "Practice ordering in simulated restaurants", exerciseType: "output", targetCount: 5),
                MissionAction(step: 3, title: "Dialogue Quiz", description: "Complete ordering dialogues", exerciseType: "vocabulary", targetCount: 5)
            ]
        ),

        // WEEK 3
        Mission(
            id: "w3_directions",
            week: 3,
            title: "Navigation Quest",
            description: "Learn to ask for and understand directions around Bangkok",
            longDescription: "Master directional vocabulary and learn how to ask for and understand directions in Bangkok. Essential for getting around the city.",
            category: "navigation",
            type: "vocabulary",
            targetCount: 12,
            rewardXP: 70,
            estimatedHours: 2,
            unlockAtWeek: 3,
            vocabulary: ["left", "right", "straight", "turn", "street", "road", "near", "far", "here", "there", "map", "temple"],
            actions: [
                MissionAction(step: 1, title: "Learn Directions", description: "Master 12 directional words", exerciseType: "vocabulary", targetCount: 12),
                MissionAction(step: 2, title: "Map Skills", description: "Practice understanding directions with maps", exerciseType: "listening", targetCount: 4),
                MissionAction(step: 3, title: "Ask Directions", description: "Practice asking for directions naturally", exerciseType: "output", targetCount: 3)
            ]
        ),

        Mission(
            id: "w3_travel",
            week: 3,
            title: "Travel & Transport",
            description: "Get around Thailand using different transportation methods",
            longDescription: "Learn how to use different transportation methods in Thailand. Master taxi, bus, train and boat vocabulary to explore the country.",
            category: "navigation",
            type: "vocabulary",
            targetCount: 11,
            rewardXP: 70,
            estimatedHours: 2,
            unlockAtWeek: 3,
            vocabulary: ["taxi", "bus", "train", "boat", "car", "motorcycle", "station", "airport", "ticket", "driver", "passenger"],
            actions: [
                MissionAction(step: 1, title: "Transport Vocabulary", description: "Learn 11 transportation words", exerciseType: "vocabulary", targetCount: 11),
                MissionAction(step: 2, title: "Booking Phrases", description: "Practice booking transportation", exerciseType: "output", targetCount: 4),
                MissionAction(step: 3, title: "Travel Dialogues", description: "Complete realistic travel scenarios", exerciseType: "listening", targetCount: 3)
            ]
        ),

        // WEEK 4
        Mission(
            id: "w4_conversation",
            week: 4,
            title: "Local Conversations",
            description: "Have meaningful conversations with Thai locals",
            longDescription: "Congratulations! Now learn how to have natural conversations with Thai people. Master personal questions and responses.",
            category: "greeting",
            type: "speaking",
            targetCount: 15,
            rewardXP: 100,
            estimatedHours: 3,
            unlockAtWeek: 4,
            vocabulary: ["where_from", "occupation", "family", "age", "like", "dont_like", "interesting", "funny", "beautiful", "busy", "relax", "weekend", "travel", "country", "question"],
            actions: [
                MissionAction(step: 1, title: "Conversation Vocabulary", description: "Learn 15 conversational words and phrases", exerciseType: "vocabulary", targetCount: 15),
                MissionAction(step: 2, title: "Answer Questions", description: "Practice answering personal questions", exerciseType: "output", targetCount: 5),
                MissionAction(step: 3, title: "Role Play Conversations", description: "Have full conversations with natives", exerciseType: "output", targetCount: 5)
            ]
        ),

        Mission(
            id: "w4_review",
            week: 4,
            title: "Master A1 Complete",
            description: "Comprehensive review of all A1 level vocabulary",
            longDescription: "Final challenge! Review all A1 level vocabulary from weeks 1-4. You've come a long way - now prove you're ready for A1.2!",
            category: "greeting",
            type: "vocabulary",
            targetCount: 20,
            rewardXP: 150,
            estimatedHours: 4,
            unlockAtWeek: 4,
            vocabulary: ["hello", "thank_you", "goodbye", "please", "yes", "no", "food", "water", "help", "money", "taxi", "hotel", "temple", "left", "right", "straight", "nice", "beautiful", "family", "friend"],
            actions: [
                MissionAction(step: 1, title: "Full Vocabulary Review", description: "Review all 20 A1 words", exerciseType: "vocabulary", targetCount: 20),
                MissionAction(step: 2, title: "Pronunciation Mastery", description: "Perfect all tones and pronunciation", exerciseType: "tone", targetCount: 10),
                MissionAction(step: 3, title: "Final Quiz", description: "Take comprehensive final quiz", exerciseType: "vocabulary", targetCount: 20)
            ]
        )
    ]

    static func getMissionForWeek(_ week: Int) -> [Mission] {
        return allMissions.filter { $0.unlockAtWeek <= week }
    }

    static func getNextMissionAfter(_ completed: Set<String>) -> Mission? {
        return allMissions.first { !completed.contains($0.id) }
    }
}
