import Foundation
import Combine

struct NarrativeScene {
    let id: String
    let weekNumber: Int
    let title: String
    let titleFrench: String
    let setting: String
    let settingFrench: String
    let narrative: String
    let narrativeFrench: String
    let characters: [String]
    let vocabularyThemes: [String]
    let sceneImageName: String?
    let sceneOrderInWeek: Int
}

struct NarrativeContext {
    let sceneId: String
    let characterName: String
    let contextText: String
    let contextTextFrench: String
    let emotionalTone: String
    let culturalNotes: String
    let culturalNotesFrench: String
}

class NarrativeFrame: ObservableObject {
    static let shared = NarrativeFrame()

    @Published var currentScene: NarrativeScene?
    @Published var completedSceneIds: Set<String> = []

    let storyTitle = "Alice's Thailand Journey"
    let storyTitleFrench = "Le voyage de Alice en Thaïlande"

    let overallNarrative = """
    Alice has arrived in Thailand for a 4-week adventure. You are her local guide and friend,
    helping her navigate her first month in Bangkok and beyond. Through greetings, family conversations,
    meals, and explorations, you'll learn Thai together as Alice discovers the magic of Thailand.
    """

    let overallNarrativeFrench = """
    Alice vient d'arriver en Thaïlande pour une aventure de 4 semaines. Vous êtes son guide et ami local,
    l'aidant à naviguer son premier mois à Bangkok et ailleurs. Par des salutations, des conversations
    familiales, des repas et des explorations, vous apprendrez le thaï ensemble tandis qu'Alice découvre
    la magie de la Thaïlande.
    """

    let scenes: [NarrativeScene] = [
        // Week 1 Scenes
        NarrativeScene(
            id: "scene_1_1_airport",
            weekNumber: 1,
            title: "First Meeting at Suvarnabhumi Airport",
            titleFrench: "Première rencontre à l'aéroport de Suvarnabhumi",
            setting: "Suvarnabhumi International Airport, Bangkok, Thailand",
            settingFrench: "Aéroport international de Suvarnabhumi, Bangkok, Thaïlande",
            narrative: """
            You meet Alice at the airport baggage claim. She looks excited but a bit overwhelmed by the crowds
            and unfamiliar sounds. She smiles when she sees you and waves. This is your first conversation in Thai!
            """,
            narrativeFrench: """
            Vous rencontrez Alice au retrait des bagages de l'aéroport. Elle semble excitée mais un peu submergée
            par la foule et les sons inconnus. Elle sourit en vous voyant et vous fait signe. C'est votre première
            conversation en thaï !
            """,
            characters: ["Alice", "You", "Taxi Driver"],
            vocabularyThemes: ["Greetings", "Polite particles", "Names", "Gratitude"],
            sceneImageName: "scene_airport",
            sceneOrderInWeek: 1
        ),

        NarrativeScene(
            id: "scene_1_2_hotel",
            weekNumber: 1,
            title: "Checking into the Hotel",
            titleFrench: "L'enregistrement à l'hôtel",
            setting: "A 3-star boutique hotel in central Bangkok",
            settingFrench: "Un hôtel-boutique 3 étoiles dans le centre de Bangkok",
            narrative: """
            Alice arrives at her hotel and you help her check in. The receptionist asks her name and
            where she's from. This is a good practice for introducing yourself in Thai!
            """,
            narrativeFrench: """
            Alice arrive à son hôtel et vous l'aidez à s'enregistrer. La réceptionniste lui demande son nom
            et d'où elle vient. C'est une bonne pratique pour se présenter en thaï !
            """,
            characters: ["Alice", "You", "Hotel Receptionist"],
            vocabularyThemes: ["Introductions", "Nationalities", "Politeness"],
            sceneImageName: "scene_hotel",
            sceneOrderInWeek: 2
        ),

        NarrativeScene(
            id: "scene_1_3_evening",
            weekNumber: 1,
            title: "Evening Stroll and First Dinner",
            titleFrench: "Promenade du soir et premier dîner",
            setting: "Charoen Krung Road, Silom district",
            settingFrench: "Route Charoen Krung, district de Silom",
            narrative: """
            You take Alice for an evening walk and dinner. She's fascinated by the street food, the decorations,
            and the friendly vendors. You teach her how to greet the shopkeepers and express gratitude for their help.
            """,
            narrativeFrench: """
            Vous amenez Alice faire une promenade du soir et dîner. Elle est fascinée par la nourriture de rue,
            les décorations et les vendeurs sympathiques. Vous lui apprenez à saluer les commerçants et à exprimer
            votre gratitude pour leur aide.
            """,
            characters: ["Alice", "You", "Food Vendor", "Local Shopkeeper"],
            vocabularyThemes: ["Greetings", "Gratitude", "Politeness", "Social courtesy"],
            sceneImageName: "scene_evening",
            sceneOrderInWeek: 3
        ),

        // Week 2 Scenes
        NarrativeScene(
            id: "scene_2_1_visit",
            weekNumber: 2,
            title: "Visiting Your Family Home",
            titleFrench: "Visite de votre maison familiale",
            setting: "Your family home in a residential Bangkok neighborhood",
            settingFrench: "Votre maison familiale dans un quartier résidentiel de Bangkok",
            narrative: """
            You invite Alice to meet your family. Your mother prepares traditional Thai food and everyone gathers
            around the table. This is the perfect opportunity to teach Alice about family vocabulary and to understand
            how Thai families interact.
            """,
            narrativeFrench: """
            Vous invitez Alice à rencontrer votre famille. Votre mère prépare de la nourriture thaïlandaise traditionnelle
            et tout le monde se rassemble autour de la table. C'est l'occasion parfaite d'enseigner à Alice le vocabulaire
            familial et de comprendre comment les familles thaïes interagissent.
            """,
            characters: ["Alice", "You", "Mother", "Father", "Siblings"],
            vocabularyThemes: ["Family", "Possessives", "Relationships", "Daily activities"],
            sceneImageName: "scene_family",
            sceneOrderInWeek: 1
        ),

        NarrativeScene(
            id: "scene_2_2_market",
            weekNumber: 2,
            title: "Shopping at the Local Market",
            titleFrench: "Shopping au marché local",
            setting: "Chatuchak Weekend Market, Bangkok",
            settingFrench: "Marché du week-end de Chatuchak, Bangkok",
            narrative: """
            You and Alice explore Chatuchak Market. She's amazed by the variety of goods and the crowds.
            You help her navigate the market, find useful items, and chat with the vendors about what they sell.
            """,
            narrativeFrench: """
            Vous et Alice explorez le marché de Chatuchak. Elle est amazée par la variété des biens et la foule.
            Vous l'aidez à naviguer le marché, à trouver des articles utiles et à discuter avec les vendeurs de ce
            qu'ils vendent.
            """,
            characters: ["Alice", "You", "Market Vendors", "Other Shoppers"],
            vocabularyThemes: ["Shopping", "Objects", "Possessives", "Preference verbs"],
            sceneImageName: "scene_market",
            sceneOrderInWeek: 2
        ),

        // Week 3 Scenes
        NarrativeScene(
            id: "scene_3_1_restaurant",
            weekNumber: 3,
            title: "Dining at a Traditional Thai Restaurant",
            titleFrench: "Repas dans un restaurant thaï traditionnel",
            setting: "A renowned khao soi restaurant in Chiang Mai (day trip)",
            settingFrench: "Un restaurant khao soi renommé à Chiang Mai (excursion d'une journée)",
            narrative: """
            You take Alice on a day trip to Chiang Mai to experience authentic Northern Thai cuisine.
            She's excited to try new dishes and learn the names of different foods. The chef is happy to explain
            the ingredients and cooking techniques.
            """,
            narrativeFrench: """
            Vous amenez Alice en excursion d'une journée à Chiang Mai pour découvrir la cuisine du nord thaïlandais.
            Elle est excitée de essayer de nouveaux plats et d'apprendre les noms de différentes alimentations.
            Le chef est heureux d'expliquer les ingrédients et les techniques de cuisson.
            """,
            characters: ["Alice", "You", "Chef", "Restaurant Staff"],
            vocabularyThemes: ["Food", "Flavors", "Preferences", "Cooking methods"],
            sceneImageName: "scene_restaurant",
            sceneOrderInWeek: 1
        ),

        NarrativeScene(
            id: "scene_3_2_market_food",
            weekNumber: 3,
            title: "Food Market Exploration",
            titleFrench: "Exploration du marché alimentaire",
            setting: "Local morning market near your home",
            settingFrench: "Marché du matin local près de votre maison",
            narrative: """
            You show Alice the morning market where locals shop for fresh produce and prepared foods.
            She asks questions about the unfamiliar vegetables and fruits. You help her understand
            Thai preferences for freshness and simplicity in cooking.
            """,
            narrativeFrench: """
            Vous montrez à Alice le marché du matin où les habitants achètent des produits frais et des aliments préparés.
            Elle pose des questions sur les légumes et fruits inconnus. Vous l'aidez à comprendre les préférences thaïes
            pour la fraîcheur et la simplicité dans la cuisine.
            """,
            characters: ["Alice", "You", "Market Vendors", "Local Shoppers"],
            vocabularyThemes: ["Food", "Vegetables", "Fruits", "Quantities"],
            sceneImageName: "scene_food_market",
            sceneOrderInWeek: 2
        ),

        // Week 4 Scenes
        NarrativeScene(
            id: "scene_4_1_directions",
            weekNumber: 4,
            title: "Getting Lost and Finding Your Way",
            titleFrench: "Se perdre et trouver son chemin",
            setting: "Old City, Bangkok",
            settingFrench: "Vieille Ville, Bangkok",
            narrative: """
            Alice wants to explore the Old City on her own. She gets a bit lost and tries to ask for directions
            from a local. This is the perfect real-world scenario to practice asking for and giving directions,
            describing locations, and understanding prepositions.
            """,
            narrativeFrench: """
            Alice veut explorer la Vieille Ville seule. Elle se perd un peu et essaie de demander des directions
            à un habitant. C'est le scénario idéal du monde réel pour pratiquer demander et donner des directions,
            décrire les emplacements et comprendre les prépositions.
            """,
            characters: ["Alice", "Local Resident", "Tuk-tuk Driver"],
            vocabularyThemes: ["Locations", "Directions", "Prepositions", "Landmarks"],
            sceneImageName: "scene_directions",
            sceneOrderInWeek: 1
        ),

        NarrativeScene(
            id: "scene_4_2_departure",
            weekNumber: 4,
            title: "Farewell and Reflection",
            titleFrench: "Adieu et réflexion",
            setting: "Airport departure lounge",
            settingFrench: "Salle de départ de l'aéroport",
            narrative: """
            After four weeks, Alice's time in Thailand is coming to an end. You reflect on the journey together,
            the places you visited, the Thai culture you experienced, and the language you learned.
            She's grateful for your guidance and excited about returning next year.
            """,
            narrativeFrench: """
            Après quatre semaines, le séjour de Alice en Thaïlande touche à sa fin. Vous réfléchissez au voyage
            ensemble, aux endroits visités, à la culture thaïe expérimentée et à la langue apprise.
            Elle est reconnaissante pour votre guidance et excitée de revenir l'année prochaine.
            """,
            characters: ["Alice", "You"],
            vocabularyThemes: ["Gratitude", "Reflection", "Locations visited", "Goodbye"],
            sceneImageName: "scene_departure",
            sceneOrderInWeek: 3
        )
    ]

    func getScenesByWeek(_ weekNumber: Int) -> [NarrativeScene] {
        return scenes.filter { $0.weekNumber == weekNumber }.sorted { $0.sceneOrderInWeek < $1.sceneOrderInWeek }
    }

    func getScene(id: String) -> NarrativeScene? {
        return scenes.first { $0.id == id }
    }

    func markSceneCompleted(id: String) {
        completedSceneIds.insert(id)
    }

    func getSceneProgress(weekNumber: Int) -> (completed: Int, total: Int, percentage: Int) {
        let weekScenes = getScenesByWeek(weekNumber)
        let completedCount = weekScenes.filter { completedSceneIds.contains($0.id) }.count
        let total = weekScenes.count
        let percentage = total > 0 ? (completedCount * 100) / total : 0

        return (completedCount, total, percentage)
    }

    func getStoryOverview(language: String = "en") -> (title: String, narrative: String) {
        if language == "fr" {
            return (storyTitleFrench, overallNarrativeFrench)
        } else {
            return (storyTitle, overallNarrative)
        }
    }
}
