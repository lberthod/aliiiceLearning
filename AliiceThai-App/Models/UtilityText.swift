import Foundation

struct UtilityScenario {
    let id: String
    let title: String
    let titleFrench: String
    let description: String
    let descriptionFrench: String
    let example: String
    let exampleFrench: String
    let context: String
    let contextFrench: String
    let difficulty: String
}

class UtilityTextManager {
    static let shared = UtilityTextManager()

    private let utilityDatabase: [String: [UtilityScenario]] = [
        // Greeting words
        "สวัสดี": [
            UtilityScenario(
                id: "greeting_1",
                title: "Greeting a shopkeeper in the morning",
                titleFrench: "Saluer un commerçant le matin",
                description: "Use this when entering a shop early in the day to establish a friendly rapport",
                descriptionFrench: "Utilisez ceci en entrant dans un magasin tôt dans la journée pour établir une relation amicale",
                example: "สวัสดีครับ ขอดูสินค้านี้ได้ไหม",
                exampleFrench: "Sawadee khrap. Kho du sinkhaa ni dai mai.",
                context: "Morning shopping at a local market or shop",
                contextFrench: "Faire ses courses le matin au marché ou au magasin local",
                difficulty: "A1"
            ),
            UtilityScenario(
                id: "greeting_2",
                title: "Meeting a friend at a café",
                titleFrench: "Rencontrer un ami au café",
                description: "A casual greeting when meeting someone you know for coffee or a meal",
                descriptionFrench: "Une salutation décontractée en rencontrant quelqu'un pour un café ou un repas",
                example: "สวัสดี! ยินดีที่ได้พบเธอ",
                exampleFrench: "Sawadee! Yin di thi dai phop tho.",
                context: "Casual social meeting at a café",
                contextFrench: "Rencontre sociale décontractée au café",
                difficulty: "A1"
            )
        ],

        // Food words
        "ข้าว": [
            UtilityScenario(
                id: "food_1",
                title: "Ordering rice at a restaurant",
                titleFrench: "Commander du riz au restaurant",
                description: "Essential word for ordering rice dishes, which are the staple of Thai meals",
                descriptionFrench: "Mot essentiel pour commander des plats de riz, qui sont l'aliment de base des repas thaïs",
                example: "ให้ข้าวสวยน้อยหน่อยครับ",
                exampleFrench: "Hai khao suay noi noi khrap.",
                context: "At a Thai restaurant ordering your main meal",
                contextFrench: "Au restaurant thaï en commandant votre repas principal",
                difficulty: "A1"
            )
        ],

        // Direction words
        "ไป": [
            UtilityScenario(
                id: "direction_1",
                title: "Asking directions to a destination",
                titleFrench: "Demander les directions vers une destination",
                description: "Use 'ไป' when asking how to get somewhere or instructing someone to go somewhere",
                descriptionFrench: "Utilisez 'ไป' pour demander comment se rendre quelque part ou instruire quelqu'un d'aller quelque part",
                example: "ไปตลาดได้ไหม",
                exampleFrench: "Pai talat dai mai?",
                context: "Lost on the street asking a local for directions",
                contextFrench: "Perdu dans la rue en demandant à un habitant les directions",
                difficulty: "A1"
            )
        ],

        // Family words
        "แม่": [
            UtilityScenario(
                id: "family_1",
                title: "Introducing your mother",
                titleFrench: "Présenter votre mère",
                description: "Essential for family introductions and conversations about family relationships",
                descriptionFrench: "Essentiel pour les présentations familiales et les conversations sur les relations familiales",
                example: "นี่คือแม่ของฉัน เธอทำงานที่โรงแรม",
                exampleFrench: "Ni khue maa khong chun. Tho tham ngan thi roong raem.",
                context: "Introducing family members to Alice",
                contextFrench: "Présenter les membres de la famille à Alice",
                difficulty: "A1"
            )
        ]
    ]

    func getUtilityScenarios(forWordId wordId: String) -> [UtilityScenario] {
        // In a real app, this would match by word ID
        // For now, we return empty as a placeholder
        return []
    }

    func getUtilityScenarios(forThaiWord word: String) -> [UtilityScenario] {
        return utilityDatabase[word] ?? []
    }

    func addUtilityScenario(_ scenario: UtilityScenario, toWord word: String) {
        var scenarios = utilityDatabase[word] ?? []
        scenarios.append(scenario)
        // In production, this would be persisted
    }

    func getRandomUtilityTip() -> UtilityScenario? {
        let allScenarios = utilityDatabase.values.flatMap { $0 }
        return allScenarios.randomElement()
    }

    func getUtilityTipsForCategory(_ category: String) -> [UtilityScenario] {
        // Group utility scenarios by category (greetings, food, directions, family, etc.)
        let allScenarios = utilityDatabase.values.flatMap { $0 }
        return allScenarios.filter { scenario in
            scenario.context.lowercased().contains(category.lowercased())
        }
    }
}
