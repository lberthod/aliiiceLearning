import Foundation
import Combine

enum ClassifierLevel: String, Codable {
    case essential = "Essential"
    case important = "Important"
    case advanced = "Advanced"
}

struct ClassifierLesson: Identifiable, Codable {
    let id: String // normalized Thai classifier like "ตัว"
    let thai: String // "ตัว"
    let romanization: String // "tua"
    let englishName: String
    let frenchName: String
    let explanation: String
    let frenchExplanation: String
    let whyMatters: String
    let whyMattersFrench: String
    let uses: [String]
    let examples: [ClassifierExampleWord] // Real words from dataset
    let commonMistakes: [String]
    let commonMistakesFrench: [String]
    let level: ClassifierLevel
}

struct ClassifierExampleWord: Identifiable, Codable {
    let id: String
    let thai: String
    let romanization: String
    let english: String
    let french: String

    init(id: String, thai: String, romanization: String, english: String, french: String) {
        self.id = id
        self.thai = thai
        self.romanization = romanization
        self.english = english
        self.french = french
    }

    init(word: WrappedWord) {
        self.id = word.id
        self.thai = word.core.thai
        self.romanization = word.core.romanization.rtgs
        self.english = word.core.translation.en
        self.french = word.core.translation.fr
    }
}

struct ClassifierQuestion {
    let id: UUID
    let numberThai: String
    let numberEnglish: String
    let nounThai: String
    let nounEnglish: String
    let nounFrench: String
    let correctClassifier: String
    let correctClassifierId: String
    let correctClassifierThai: String
    let options: [String]
    let optionsThai: [String]
    let explanation: String
}

// MARK: - ClassifiersData Manager (Improved)

class ClassifiersData: ObservableObject {
    static let shared = ClassifiersData()

    @Published private(set) var classifiers: [ClassifierLesson] = []
    private var classifiersByID: [String: ClassifierLesson] = [:]
    private var wordToClassifier: [String: String] = [:]

    /// Build classifiers from wrapped words - intelligent normalization
    func buildFromWrappedWords(_ words: [WrappedWord]) {
        var classifierGroups: [String: [WrappedWord]] = [:]

        // Group words by NORMALIZED classifier (just Thai characters)
        for word in words {
            if let classifier = word.linguistic.classifier {
                let normalized = extractThaiClassifier(classifier)
                if !normalized.isEmpty {
                    if classifierGroups[normalized] == nil {
                        classifierGroups[normalized] = []
                    }
                    classifierGroups[normalized]?.append(word)
                }
            }
        }

        // Build classifier lessons from groups
        var lessons: [ClassifierLesson] = []

        for (normalizedClassifier, wordsWithClassifier) in classifierGroups.sorted(by: { $0.key < $1.key }) {
            let exampleWords = Array(wordsWithClassifier.prefix(5)).map { ClassifierExampleWord(word: $0) }

            let lesson = createClassifierLesson(
                id: normalizedClassifier,
                thai: normalizedClassifier,
                wordsWithClassifier: wordsWithClassifier,
                exampleWords: exampleWords
            )

            lessons.append(lesson)
        }

        classifiers = lessons
        rebuildIndex()

        // Build word-to-classifier mapping (using normalized classifier)
        for word in words {
            if let classifier = word.linguistic.classifier {
                let normalized = extractThaiClassifier(classifier)
                if !normalized.isEmpty {
                    wordToClassifier[word.id] = normalized
                }
            }
        }

        print("✅ Built \(classifiers.count) unique classifiers from \(classifierGroups.count) groups")
    }

    /// Extract JUST the Thai characters from classifier string
    /// Input: "ตัว (tua)" or "คน" or "ตัว"
    /// Output: "ตัว" or "คน"
    private func extractThaiClassifier(_ classifier: String) -> String {
        // Take everything before the first parenthesis/space/special char
        let thaiOnly = classifier.filter { $0.isLetter }
        // More robust: extract just Thai script characters
        var result = ""
        for char in classifier {
            if isThaiCharacter(char) {
                result.append(char)
            } else if !result.isEmpty {
                break // Stop at first non-Thai
            }
        }
        return result.isEmpty ? classifier : result
    }

    private func isThaiCharacter(_ char: Character) -> Bool {
        let thai = CharacterSet(charactersIn: "ะาิึืเแโไๅๆ็่้๊๋์ํ๎๏ก-์")
        return char.unicodeScalars.allSatisfy { thai.contains($0) }
    }

    private func rebuildIndex() {
        classifiersByID = [:]
        for classifier in classifiers {
            classifiersByID[classifier.id] = classifier
        }
    }

    func getClassifier(_ id: String) -> ClassifierLesson? {
        return classifiersByID[id]
    }

    func getAllClassifiers() -> [ClassifierLesson] {
        return classifiers
    }

    func getClassifier(forWordId wordId: String) -> String? {
        return wordToClassifier[wordId]
    }

    /// Generate classifier quiz questions
    func generateQuestions(count: Int = 10, from words: [WrappedWord]) -> [ClassifierQuestion] {
        var questions: [ClassifierQuestion] = []

        let wordsWithClassifiers = words.filter { $0.linguistic.classifier != nil }
        let shuffled = wordsWithClassifiers.shuffled()

        let classifierIDs = classifiers.map { $0.id }

        for i in 0..<min(count, shuffled.count) {
            let word = shuffled[i]
            guard let classifier = word.linguistic.classifier else { continue }
            let normalizedClassifier = extractThaiClassifier(classifier)

            let numbers = ["หนึ่ง", "สอง", "สาม", "สี่", "ห้า"]
            let numbersEn = ["1", "2", "3", "4", "5"]

            let randomNumberIndex = Int.random(in: 0..<numbers.count)
            let numberThai = numbers[randomNumberIndex]
            let numberEn = numbersEn[randomNumberIndex]

            // Create 3 distractors
            let distractors = classifierIDs
                .filter { $0 != normalizedClassifier }
                .shuffled()
                .prefix(3)
            var options = [normalizedClassifier] + Array(distractors)
            options.shuffle()

            if let lesson = getClassifier(normalizedClassifier) {
                let question = ClassifierQuestion(
                    id: UUID(),
                    numberThai: numberThai,
                    numberEnglish: numberEn,
                    nounThai: word.core.thai,
                    nounEnglish: word.core.translation.en,
                    nounFrench: word.core.translation.fr,
                    correctClassifier: normalizedClassifier,
                    correctClassifierId: normalizedClassifier,
                    correctClassifierThai: normalizedClassifier,
                    options: options,
                    optionsThai: options,
                    explanation: lesson.whyMatters
                )
                questions.append(question)
            }
        }

        return questions
    }

    private func createClassifierLesson(
        id: String,
        thai: String,
        wordsWithClassifier: [WrappedWord],
        exampleWords: [ClassifierExampleWord]
    ) -> ClassifierLesson {
        let explanations = getClassifierExplanations()

        let englishName = explanations[thai]?.englishName ?? "Classifier for objects"
        let frenchName = explanations[thai]?.frenchName ?? "Classificateur pour objets"
        let explanation = explanations[thai]?.explanation ?? "Used for grouping nouns"
        let frenchExplanation = explanations[thai]?.frenchExplanation ?? "Utilisé pour grouper les noms"
        let whyMatters = explanations[thai]?.whyMatters ?? "Essential for counting"
        let whyMattersFrench = explanations[thai]?.whyMattersFrench ?? "Essentiel pour compter"

        // Extract unique usage contexts
        let uses = Set(wordsWithClassifier.flatMap { $0.usage.contexts }).sorted()

        let commonMistakes = getCommonMistakes(forClassifier: thai, explanation: explanation)
        let commonMistakesFrench = getCommonMistakesFrench(forClassifier: thai, explanation: frenchExplanation)

        let level = getClassifierLevel(thai)
        let romanization = getRomanization(thai)

        return ClassifierLesson(
            id: thai,
            thai: thai,
            romanization: romanization,
            englishName: englishName,
            frenchName: frenchName,
            explanation: explanation,
            frenchExplanation: frenchExplanation,
            whyMatters: whyMatters,
            whyMattersFrench: whyMattersFrench,
            uses: uses,
            examples: exampleWords,
            commonMistakes: commonMistakes,
            commonMistakesFrench: commonMistakesFrench,
            level: level
        )
    }

    private func getRomanization(_ classifier: String) -> String {
        let romanizations: [String: String] = [
            "กรอบ": "krob", "กระป๋อง": "krapong", "กลีบ": "klip", "กล่อง": "klong",
            "กอง": "kong", "กีฬา": "kila", "ก้อน": "gon", "ขบวน": "khabuan",
            "ขวด": "khuat", "ข้อ": "kho", "ข้าง": "khang", "คน": "khon",
            "คัน": "khan", "คำ": "kham", "คู่": "khu", "งาน": "ngan",
            "จาน": "chan", "ชนิด": "chanit", "ชาม": "cham", "ชิ้น": "chin",
            "ช่อ": "cho", "ซอง": "song", "ซี่": "si", "ดวง": "duang",
            "ดอก": "dok", "ด้าม": "dam", "ตน": "ton", "ตัน": "tan",
            "ตัว": "tua", "ตู้": "tu", "ต้น": "ton", "ถุง": "thung",
            "ถ้วย": "thuay", "ทาง": "thang", "ที่": "thi", "ท่อน": "thon",
            "บาง": "bang", "บาน": "ban", "ปาก": "pak", "ผล": "phon",
            "ผืน": "phuen", "ฝัก": "fak", "พระองค์": "phra ong", "ฟอง": "fong",
            "ฟ้า": "fa", "รอย": "roi", "ระดับ": "radup", "รัง": "rang",
            "รูป": "rup", "ลำ": "lam", "ลิ้น": "lin", "ลูก": "luk",
            "วง": "wong", "วัด": "wat", "สะพาน": "saphan", "สาย": "sai",
            "สี": "si", "หน้า": "na", "หม้อ": "mho", "หยด": "yot",
            "หลง": "long", "หลอด": "lot", "หลัง": "lang", "หวี": "hui",
            "หัว": "hua", "หาด": "hat", "หู": "hu", "องค์": "ong",
            "อัน": "an", "อ่าง": "ang", "เกม": "kem", "เครื่อง": "khruang",
            "เตียง": "tiang", "เปลือก": "pluak", "เมล็ด": "met", "เมือง": "muang",
            "เม็ด": "met", "เรือน": "ruean", "เรื่อง": "ruang", "เลา": "lao",
            "เล่ม": "lem", "เส้น": "sen", "แก้ว": "kaew", "แท่ง": "thang",
            "แผ่น": "phen", "แห่ง": "hang", "โต๊ะ": "to", "ใบ": "bai"
        ]
        return romanizations[classifier] ?? classifier
    }

    private func getClassifierLevel(_ classifier: String) -> ClassifierLevel {
        let essential = ["ตัว", "คน", "เล่ม", "ใบ", "คัน", "ลูก", "ก้อน", "แผ่น", "เส้น", "จาน", "ขวด", "หลัง", "เครื่อง", "แก้ว", "เรือน"]

        if essential.contains(classifier) {
            return .essential
        }

        let important = ["ปาก", "หน้า", "ผล", "ผืน", "ฝัก", "ท่อน", "บาง", "บาน", "ชิ้น", "ช่อ", "ซอง", "ซี่", "ดวง", "ดอก", "ด้าม", "ตน", "ตัน", "ตู้", "ต้น", "ถุง", "ถ้วย", "ทาง", "ที่", "สี", "หม้อ", "หยด", "หลง", "หลอด", "หวี", "หัว", "หาด", "หู", "องค์", "อัน", "อ่าง", "เกม", "เตียง", "เปลือก", "เมล็ด", "เมือง", "เม็ด", "เรื่อง", "แท่ง", "แห่ง", "โต๊ะ"]

        if important.contains(classifier) {
            return .important
        }

        return .advanced
    }

    private func getClassifierExplanations() -> [String: (englishName: String, frenchName: String, explanation: String, frenchExplanation: String, whyMatters: String, whyMattersFrench: String)] {
        return [
            "กรอบ": (
                englishName: "Classifier (for frames and framed objects)",
                frenchName: "Cadres et objets encadrés",
                explanation: "Used for picture frames and framed objects of rectangular shape",
                frenchExplanation: "Utilisé pour les cadres de tableaux et les objets encadrés de forme rectangulaire",
                whyMatters: "Important for decoration and photography vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de décoration et photographie."
            ),
            "กระป๋อง": (
                englishName: "Cans and bottled containers",
                frenchName: "Récipients et conserves",
                explanation: "Used for beverage cans and food cans in everyday shopping",
                frenchExplanation: "Utilisé pour les boîtes de boisson et les boîtes de nourriture en conserve lors des achats quotidiens",
                whyMatters: "Important for shopping and grocery vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des achats et de l'épicerie."
            ),
            "กลีบ": (
                englishName: "Classifier (for cuisine, ingrédients, marché)",
                frenchName: "Gousses et segments alimentaires",
                explanation: "Used for garlic cloves and food segments",
                frenchExplanation: "Utilisé pour les gousses d'ail et les segments alimentaires",
                whyMatters: "Important for cuisine and market shopping vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la cuisine et des achats au marché."
            ),
            "กล่อง": (
                englishName: "Boxes and containers",
                frenchName: "Boîtes et récipients",
                explanation: "Used for lunch boxes and juice boxes",
                frenchExplanation: "Utilisé pour les boîtes repas et les boîtes de jus",
                whyMatters: "Important for shopping and food containers vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des achats et des récipients alimentaires."
            ),
            "กอง": (
                englishName: "Fires and flames",
                frenchName: "Feux et flammes",
                explanation: "Used for fires and dangerous flames",
                frenchExplanation: "Utilisé pour les feux et les flammes dangereuses",
                whyMatters: "Important for emergency situations and describing natural phenomena.",
                whyMattersFrench: "Important pour les situations d'urgence et la description des phénomènes naturels."
            ),
            "กีฬา": (
                englishName: "Sports and athletic activities",
                frenchName: "Sports et activités sportives",
                explanation: "Used for sports equipment and athletic activities",
                frenchExplanation: "Utilisé pour l'équipement sportif et les activités sportives",
                whyMatters: "Important for sports, competition, and athletic conversations.",
                whyMattersFrench: "Important pour le vocabulaire du sport, de la compétition et des conversations sportives."
            ),
            "ก้อน": (
                englishName: "Chunks/Lumps/Chunks of matter",
                frenchName: "Morceaux/Blocs/Amas",
                explanation: "Used for solid chunks, lumps, or consolidated masses like ice cubes, sugar lumps, clouds, or clay blocks.",
                frenchExplanation: "Utilisé pour les morceaux solides, les blocs ou les amas consolidés comme les glaçons, les morceaux de sucre, les nuages ou les briques d'argile.",
                whyMatters: "Useful for describing food portions, weather phenomena, and various solid objects.",
                whyMattersFrench: "Utile pour décrire les portions alimentaires, les phénomènes météorologiques et divers objets solides."
            ),
            "ขบวน": (
                englishName: "Trains and convoys",
                frenchName: "Trains et convois",
                explanation: "Used for high-speed trains and train formations",
                frenchExplanation: "Utilisé pour les trains à grande vitesse et les formations de trains",
                whyMatters: "Important for transportation and travel vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des transports et des voyages."
            ),
            "ขวด": (
                englishName: "Bottles and bottled items",
                frenchName: "Bouteilles et articles en bouteille",
                explanation: "Used for bottles and bottled containers such as oil bottles, honey jars, perfume bottles, and similar liquid or paste containers.",
                frenchExplanation: "Utilisé pour les bouteilles et les récipients en bouteille comme les bouteilles d'huile, les pots de miel, les flacons de parfum et les récipients similaires.",
                whyMatters: "Essential when shopping for beverages, cooking oils, cosmetics, and household products.",
                whyMattersFrench: "Essentiel quand on achète des boissons, des huiles de cuisine, des cosmétiques et des produits ménagers."
            ),
            "ข้อ": (
                englishName: "Pieces of advice and ideas",
                frenchName: "Conseils et idées",
                explanation: "Used for pieces of advice and ideas in discussions",
                frenchExplanation: "Utilisé pour les conseils et les idées dans les discussions",
                whyMatters: "Important for creative and problem-solving conversations.",
                whyMattersFrench: "Important pour les conversations créatives et la résolution de problèmes."
            ),
            "ข้าง": (
                englishName: "Body parts and organs",
                frenchName: "Parties du corps et organes",
                explanation: "Used for body parts like eyes and ears",
                frenchExplanation: "Utilisé pour les parties du corps comme les yeux et les oreilles",
                whyMatters: "Important for anatomy and body-related vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire d'anatomie et des parties du corps."
            ),
            "คน": (
                englishName: "Person/People",
                frenchName: "Personne/Gens",
                explanation: "Used exclusively for human beings. The classifier for people is one of the most important in Thai.",
                frenchExplanation: "Utilisé exclusivement pour les êtres humains. C'est le classificateur pour les personnes et c'est l'un des plus importants en thaï.",
                whyMatters: "You must use this whenever counting people. It is one of the most frequently used classifiers in everyday conversation.",
                whyMattersFrench: "Vous devez l'utiliser chaque fois que vous comptez des personnes. C'est un des classificateurs les plus fréquemment utilisés dans la conversation quotidienne."
            ),
            "คัน": (
                englishName: "Vehicles and long objects",
                frenchName: "Véhicules et objets longs",
                explanation: "Used for vehicles and elongated objects such as cars, motorcycles, trains, bicycles, and similar items with a long shape.",
                frenchExplanation: "Utilisé pour les véhicules et les objets allongés comme les voitures, les motos, les trains, les vélos et les articles similaires de forme allongée.",
                whyMatters: "You will use this constantly when discussing transportation, directions, and travel.",
                whyMattersFrench: "Vous l'utiliserez constamment en discutant des transports, des directions et des voyages."
            ),
            "คำ": (
                englishName: "Sushi and special dishes",
                frenchName: "Sushis et plats spécialisés",
                explanation: "Used for sushi and other special Asian dishes",
                frenchExplanation: "Utilisé pour les sushis et les autres plats asiatiques spécialisés",
                whyMatters: "Important for ordering and Asian cuisine vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la commande de mets asiatiques spécialisés."
            ),
            "คู่": (
                englishName: "Pairs and matched objects",
                frenchName: "Paires et objets assortis",
                explanation: "Used for pairs of objects like socks and shoes",
                frenchExplanation: "Utilisé pour les paires d'objets comme les chaussettes et les souliers",
                whyMatters: "Important for fashion, beauty, and paired item vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la mode, de la beauté et des objets appariés."
            ),
            "งาน": (
                englishName: "Celebrations and events",
                frenchName: "Fêtes et événements",
                explanation: "Used for celebrations and special events",
                frenchExplanation: "Utilisé pour les fêtes et les événements spéciaux",
                whyMatters: "Important for celebrations, parties, and cultural events vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des fêtes, des célébrations et des événements culturels."
            ),
            "จาน": (
                englishName: "Dishes and servings (of food)",
                frenchName: "Plats et portions",
                explanation: "Used for dishes and servings of food such as curries, soups, fried rice, and other meal portions served on plates.",
                frenchExplanation: "Utilisé pour les plats et les portions d'aliments comme les currys, les soupes, le riz frit et autres portions de repas servies dans des assiettes.",
                whyMatters: "Extremely common when eating, ordering food, or cooking.",
                whyMattersFrench: "Extrêmement courant quand on mange, qu'on passe une commande de mets ou qu'on prépare des repas."
            ),
            "ชนิด": (
                englishName: "Types and disciplines",
                frenchName: "Types et disciplines",
                explanation: "Used for types and athletic disciplines",
                frenchExplanation: "Utilisé pour les types et les disciplines sportives",
                whyMatters: "Important for competition and athletic vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la compétition et des sports."
            ),
            "ชาม": (
                englishName: "Bowls for noodles",
                frenchName: "Bols et nouilles",
                explanation: "Used for noodles and ramen bowls",
                frenchExplanation: "Utilisé pour les nouilles et les bols de ramen",
                whyMatters: "Important for Asian cuisine and cooking vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la cuisine asiatique et de la préparation des repas."
            ),
            "ชิ้น": (
                englishName: "Slices and pieces",
                frenchName: "Tranches et morceaux",
                explanation: "Used for slices of fruit and food pieces",
                frenchExplanation: "Utilisé pour les tranches de fruits et les morceaux d'aliments",
                whyMatters: "Important for food and cooking vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la cuisine et de la nourriture."
            ),
            "ช่อ": (
                englishName: "Bouquets and clusters",
                frenchName: "Bouquets et grappes",
                explanation: "Used for flower bouquets and flower clusters",
                frenchExplanation: "Utilisé pour les bouquets de fleurs et les grappes florales",
                whyMatters: "Important for flowers, gifts, and decoration vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des fleurs, des cadeaux et de la décoration."
            ),
            "ซอง": (
                englishName: "Envelopes and packets",
                frenchName: "Enveloppes et paquets",
                explanation: "Used for envelopes and gift packets",
                frenchExplanation: "Utilisé pour les enveloppes et les paquets cadeaux",
                whyMatters: "Important for gifts, money, and celebrations vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des cadeaux, de l'argent et des célébrations."
            ),
            "ซี่": (
                englishName: "Teeth and dental items",
                frenchName: "Dents et articles dentaires",
                explanation: "Used for teeth and baby teeth",
                frenchExplanation: "Utilisé pour les dents et les dents de lait",
                whyMatters: "Important for body and dental vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire du corps et de la dentition."
            ),
            "ดวง": (
                englishName: "Celestial bodies and luminous objects",
                frenchName: "Corps célestes et objets lumineux",
                explanation: "Used for the sun, moon, light bulbs, and celestial objects",
                frenchExplanation: "Utilisé pour le soleil, la lune, les ampoules et les objets célestes",
                whyMatters: "Important for astronomy and describing luminous objects.",
                whyMattersFrench: "Important pour l'astronomie et la description des objets lumineux."
            ),
            "ดอก": (
                englishName: "Flowers and mushrooms",
                frenchName: "Fleurs et champignons",
                explanation: "Used for flowers and mushrooms",
                frenchExplanation: "Utilisé pour les fleurs et les champignons",
                whyMatters: "Important for botany and food vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la botanique et de l'alimentation."
            ),
            "ด้าม": (
                englishName: "Writing and painting implements",
                frenchName: "Instruments d'écriture et de peinture",
                explanation: "Used for pens, brushes, and artistic implements",
                frenchExplanation: "Utilisé pour les stylos, les pinceaux et les instruments artistiques",
                whyMatters: "Important for art, writing, and craft vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'art, de l'écriture et de l'artisanat."
            ),
            "ตน": (
                englishName: "Supernatural and imaginary beings",
                frenchName: "Êtres surnaturels et imaginaires",
                explanation: "Used for ghosts, fairies, and magical creatures",
                frenchExplanation: "Utilisé pour les fantômes, les fées et les créatures magiques",
                whyMatters: "Important for folklore and storytelling vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire du folklore et de la narration."
            ),
            "ตัน": (
                englishName: "Trees and plants",
                frenchName: "Arbres et plantes",
                explanation: "Used for trees and woody plants",
                frenchExplanation: "Utilisé pour les arbres et les plantes ligneuses",
                whyMatters: "Important for agriculture and nature vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'agriculture et de la nature."
            ),
            "ตัว": (
                englishName: "Body/Individual (animals, people, dolls)",
                frenchName: "Corps/Individu (animaux, personnes, poupées)",
                explanation: "Used for countable living things or objects with a physical body: animals, people, dolls, puppets. The word means 'body' in Thai, making this classifier very intuitive.",
                frenchExplanation: "Utilisé pour les créatures vivantes ou les objets ayant un corps physique comme les animaux, les personnes, les poupées et les marionnettes. Le mot signifie littéralement 'corps' en thaï, ce qui rend ce classificateur très facile à comprendre.",
                whyMatters: "Essential for counting living beings. You will use this daily when talking about animals, people, or any character.",
                whyMattersFrench: "Essentiel pour compter les êtres vivants. Vous l'utiliserez quotidiennement quand vous parlez des animaux, des personnes ou de n'importe quel personnage."
            ),
            "ตู้": (
                englishName: "Cabinets and mailboxes",
                frenchName: "Armoires et boîtes aux lettres",
                explanation: "Used for mailboxes and other cabinet storage units",
                frenchExplanation: "Utilisé pour les boîtes aux lettres et les unités d'armoires de rangement",
                whyMatters: "Important for neighborhood and daily objects vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des objets du quartier et quotidiens."
            ),
            "ต้น": (
                englishName: "Standing plants and vegetables",
                frenchName: "Plantes et légumes debout",
                explanation: "Used for upright plants and vegetables like leeks and green onions",
                frenchExplanation: "Utilisé pour les plantes droites et les légumes comme les poireaux et les oignons verts",
                whyMatters: "Important for agriculture and cooking vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'agriculture et de la cuisine."
            ),
            "ถุง": (
                englishName: "Bags and sacks",
                frenchName: "Sacs et poches",
                explanation: "Used for bags of groceries and food items",
                frenchExplanation: "Utilisé pour les sacs d'épicerie et les articles alimentaires",
                whyMatters: "Important for shopping and grocery vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des achats et de l'épicerie."
            ),
            "ถ้วย": (
                englishName: "Cups and servings of beverages",
                frenchName: "Tasses et portions de boissons",
                explanation: "Used for cups of custard, tea and other beverages",
                frenchExplanation: "Utilisé pour les tasses de crème anglaise, le thé et autres boissons",
                whyMatters: "Important for cafes and cooking vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des cafés et de la cuisine."
            ),
            "ทาง": (
                englishName: "Paths and ways",
                frenchName: "Chemins et voies",
                explanation: "Used for paths, roads, and directions",
                frenchExplanation: "Utilisé pour les chemins, les routes et les directions",
                whyMatters: "Important for navigation and geography vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la navigation et de la géographie."
            ),
            "ที่": (
                englishName: "Places and locations",
                frenchName: "Lieux et emplacements",
                explanation: "Used for places, locations, and camping sites",
                frenchExplanation: "Utilisé pour les lieux, les emplacements et les sites de camping",
                whyMatters: "Important for travel and tourism vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de voyages et du tourisme."
            ),
            "ท่อน": (
                englishName: "Logs and wooden segments",
                frenchName: "Bûches et segments de bois",
                explanation: "Used for logs, wooden segments, and cylindrical pieces",
                frenchExplanation: "Utilisé pour les bûches, les segments de bois et les pièces cylindriques",
                whyMatters: "Important for construction and outdoor vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la construction et de l'extérieur."
            ),
            "บาง": (
                englishName: "Doors and gates",
                frenchName: "Portes et portails",
                explanation: "Used for doors and gateways",
                frenchExplanation: "Utilisé pour les portes et les portails d'entrée",
                whyMatters: "Important for architecture and home vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'architecture et de la maison."
            ),
            "บาน": (
                englishName: "Windows and mirrors",
                frenchName: "Fenêtres et miroirs",
                explanation: "Used for windows and mirrors in buildings",
                frenchExplanation: "Utilisé pour les fenêtres et les miroirs dans les bâtiments",
                whyMatters: "Important for architecture and interior design vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'architecture et du design intérieur."
            ),
            "ปาก": (
                englishName: "Mouths and openings",
                frenchName: "Bouches et ouvertures",
                explanation: "Used for mouths and similar openings",
                frenchExplanation: "Utilisé pour les bouches et les ouvertures similaires",
                whyMatters: "Important for body anatomy and eating vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'anatomie et de l'alimentation."
            ),
            "ผล": (
                englishName: "Fruits and results",
                frenchName: "Fruits et résultats",
                explanation: "Used for fruits and similar produce at markets",
                frenchExplanation: "Utilisé pour les fruits et les produits similaires aux marchés",
                whyMatters: "Important for shopping and food vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des achats et de l'alimentation."
            ),
            "ผืน": (
                englishName: "Cloth and fabrics",
                frenchName: "Étoffes et tissus",
                explanation: "Used for scarves, blankets and fabric items",
                frenchExplanation: "Utilisé pour les écharpes, les couvertures et les articles textiles",
                whyMatters: "Important for clothing and textile vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des vêtements et des textiles."
            ),
            "ฝัก": (
                englishName: "Vegetables and pods",
                frenchName: "Légumes et gousses",
                explanation: "Used for corn and similar vegetables sold at markets",
                frenchExplanation: "Utilisé pour le maïs et les légumes similaires vendus aux marchés",
                whyMatters: "Important for agriculture and grocery shopping vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'agriculture et des achats au marché."
            ),
            "พระองค์": (
                englishName: "Royalty and honored persons",
                frenchName: "Personnages royaux et honorables",
                explanation: "Used for princesses, kings and royalty",
                frenchExplanation: "Utilisé pour les princesses, les rois et les personnages royaux",
                whyMatters: "Important for formal address and ceremonies.",
                whyMattersFrench: "Important pour les formes polies et les cérémonies officielles."
            ),
            "ฟอง": (
                englishName: "Eggs and egg-shaped objects",
                frenchName: "Œufs et objets en forme d'œuf",
                explanation: "Used for eggs and egg-shaped items",
                frenchExplanation: "Utilisé pour les œufs et les articles en forme d'œuf",
                whyMatters: "Important for cooking and food vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la cuisine et de l'alimentation."
            ),
            "ฟ้า": (
                englishName: "Lightning and sky phenomena",
                frenchName: "Éclairs et phénomènes du ciel",
                explanation: "Used for lightning and other atmospheric phenomena",
                frenchExplanation: "Utilisé pour les éclairs et les autres phénomènes atmosphériques",
                whyMatters: "Important for weather and nature vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la météo et de la nature."
            ),
            "รอย": (
                englishName: "Traces and footprints",
                frenchName: "Traces et empreintes",
                explanation: "Used for animal paws and footprints",
                frenchExplanation: "Utilisé pour les pattes d'animaux et les empreintes",
                whyMatters: "Important for describing animal tracks and signs.",
                whyMattersFrench: "Important pour la description des traces animales et des indices."
            ),
            "ระดับ": (
                englishName: "Levels and degrees",
                frenchName: "Niveaux et degrés",
                explanation: "Used for temperature and level measurements",
                frenchExplanation: "Utilisé pour les mesures de température et de niveaux",
                whyMatters: "Important for science and weather vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire scientifique et météorologique."
            ),
            "รัง": (
                englishName: "Nests and habitats",
                frenchName: "Nids et habitats",
                explanation: "Used for bird nests and animal dwellings",
                frenchExplanation: "Utilisé pour les nids d'oiseaux et les habitats d'animaux",
                whyMatters: "Important for ornithology and nature vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'ornithologie et de la nature."
            ),
            "รูป": (
                englishName: "Shapes and forms",
                frenchName: "Formes et figures",
                explanation: "Used for circles, squares and geometric shapes",
                frenchExplanation: "Utilisé pour les cercles, les carrés et les formes géométriques",
                whyMatters: "Important for art and geometry vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'art et de la géométrie."
            ),
            "ลำ": (
                englishName: "Vessels and aircraft",
                frenchName: "Navires et aéronefs",
                explanation: "Used for boats, planes, and other vessels",
                frenchExplanation: "Utilisé pour les bateaux, les avions et autres navires",
                whyMatters: "Important for travel and transportation vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire du voyage et des transports."
            ),
            "ลิ้น": (
                englishName: "Tongues and lingual objects",
                frenchName: "Langues et objets linguaux",
                explanation: "Used for tongues and similar objects",
                frenchExplanation: "Utilisé pour les langues et les objets similaires",
                whyMatters: "Important for anatomy and body part vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'anatomie et des parties du corps."
            ),
            "ลูก": (
                englishName: "Spherical/Round/Bulky objects",
                frenchName: "Objets sphériques/Ronds/Volumineux",
                explanation: "Used for round, spherical, or bulky objects like balls, fruits, eggs, and small children. The original meaning refers to offspring or young.",
                frenchExplanation: "Utilisé pour les objets ronds, sphériques ou volumineux comme les balles, les fruits, les œufs et les petits enfants. Le sens original se réfère à la progéniture ou aux jeunes créatures.",
                whyMatters: "Very common when shopping or describing fruit, toys, and sports equipment.",
                whyMattersFrench: "Très courant quand on fait les courses ou on décrit des fruits, des jouets et du matériel sportif."
            ),
            "วง": (
                englishName: "Rings and circular objects",
                frenchName: "Bagues et objets circulaires",
                explanation: "Used for rings and circular jewelry items",
                frenchExplanation: "Utilisé pour les bagues et les articles de bijouterie circulaires",
                whyMatters: "Important for jewelry and accessories vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des bijoux et des accessoires."
            ),
            "วัด": (
                englishName: "Temples and religious structures",
                frenchName: "Temples et structures religieuses",
                explanation: "Used for temples and religious buildings",
                frenchExplanation: "Utilisé pour les temples et les bâtiments religieux",
                whyMatters: "Important for religion and culture vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la religion et de la culture."
            ),
            "สะพาน": (
                englishName: "Bridges and structures",
                frenchName: "Ponts et structures",
                explanation: "Used for bridges and similar infrastructure",
                frenchExplanation: "Utilisé pour les ponts et les structures similaires",
                whyMatters: "Important for directions and geography vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des directions et de la géographie."
            ),
            "สาย": (
                englishName: "Lines and routes",
                frenchName: "Lignes et itinéraires",
                explanation: "Used for rainbows, subway lines and similar linear routes",
                frenchExplanation: "Utilisé pour les arcs-en-ciel, les lignes de métro et les itinéraires similaires",
                whyMatters: "Important for travel and transportation vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des voyages et des transports."
            ),
            "สี": (
                englishName: "Colors and hues",
                frenchName: "Couleurs et teintes",
                explanation: "Used for colors and color-related items",
                frenchExplanation: "Utilisé pour les couleurs et les articles liés aux couleurs",
                whyMatters: "Important for art and color vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'art et des couleurs."
            ),
            "หน้า": (
                englishName: "Faces and pages",
                frenchName: "Visages et pages",
                explanation: "Used for faces and also pages of documents",
                frenchExplanation: "Utilisé pour les visages et aussi pour les pages de documents",
                whyMatters: "Important for body parts and daily conversation vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire du corps et de la conversation quotidienne."
            ),
            "หม้อ": (
                englishName: "Pots and cooking vessels",
                frenchName: "Pots et récipients de cuisson",
                explanation: "Used for cooking pots and hotpots",
                frenchExplanation: "Utilisé pour les pots de cuisson et les marmites",
                whyMatters: "Essential for cooking and kitchen vocabulary.",
                whyMattersFrench: "Essentiel pour le vocabulaire de la cuisine et de la cuisine."
            ),
            "หยด": (
                englishName: "Drops and droplets",
                frenchName: "Gouttes et gouttelettes",
                explanation: "Used for droplets and small liquid amounts",
                frenchExplanation: "Utilisé pour les gouttes et les petites quantités de liquide",
                whyMatters: "Important for weather and nature vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la météo et de la nature."
            ),
            "หลง": (
                englishName: "Tents and shelters",
                frenchName: "Tentes et abris",
                explanation: "Used for tents and temporary shelters",
                frenchExplanation: "Utilisé pour les tentes et les abris temporaires",
                whyMatters: "Important for camping and outdoor vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire du camping et de l'extérieur."
            ),
            "หลอด": (
                englishName: "Tubes and cylindrical containers",
                frenchName: "Tubes et conteneurs cylindriques",
                explanation: "Used for toothpaste tubes and test tubes",
                frenchExplanation: "Utilisé pour les tubes de dentifrice et les éprouvettes",
                whyMatters: "Important for bathroom and chemistry vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la salle de bains et de la chimie."
            ),
            "หลัง": (
                englishName: "Buildings and structures",
                frenchName: "Bâtiments et constructions",
                explanation: "Used for buildings and structures such as houses, temples, shops, bathrooms, and similar constructed buildings.",
                frenchExplanation: "Utilisé pour les bâtiments et les constructions comme les maisons, les temples, les magasins, les salles de bains et les bâtiments similaires.",
                whyMatters: "Essential for real estate, directions, architecture, and describing locations.",
                whyMattersFrench: "Essentiel pour l'immobilier, les directions, l'architecture et la description de lieux."
            ),
            "หวี": (
                englishName: "Bunches and clusters",
                frenchName: "Grappes et touffes",
                explanation: "Used for bunches of bananas and similar clustered fruits",
                frenchExplanation: "Utilisé pour les grappes de bananes et les fruits groupés similaires",
                whyMatters: "Important for shopping and food vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des achats et de l'alimentation."
            ),
            "หัว": (
                englishName: "Heads and leafy vegetables",
                frenchName: "Têtes et légumes à feuilles",
                explanation: "Used for heads of lettuce, broccoli, and leafy vegetables",
                frenchExplanation: "Utilisé pour les têtes de laitue, le brocoli et les légumes à feuilles",
                whyMatters: "Important for grocery shopping and cooking vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des achats au marché et de la cuisine."
            ),
            "หาด": (
                englishName: "Beaches and sandy areas",
                frenchName: "Plages et zones sablonneuses",
                explanation: "Used for beaches and sandy coastal areas",
                frenchExplanation: "Utilisé pour les plages et les zones côtières sablonneuses",
                whyMatters: "Important for geography and leisure vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la géographie et des loisirs."
            ),
            "หู": (
                englishName: "Ears and audio devices",
                frenchName: "Oreilles et dispositifs audio",
                explanation: "Used for ears and headphone-type audio devices",
                frenchExplanation: "Utilisé pour les oreilles et les dispositifs audio de type écouteurs",
                whyMatters: "Important for body parts and technology vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des parties du corps et de la technologie."
            ),
            "องค์": (
                englishName: "Royalty and crown objects",
                frenchName: "Royauté et objets de couronne",
                explanation: "Used for princes, princesses, and royal regalia",
                frenchExplanation: "Utilisé pour les princes, les princesses et les insignes royaux",
                whyMatters: "Important for describing royal titles and regalia.",
                whyMattersFrench: "Important pour la description des titres royaux et des insignes royaux."
            ),
            "อัน": (
                englishName: "Pieces and items",
                frenchName: "Pièces et articles",
                explanation: "Used for flatbread and similar food items",
                frenchExplanation: "Utilisé pour les pains plats et articles alimentaires similaires",
                whyMatters: "Important for food and general item vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la nourriture et des articles généraux."
            ),
            "อ่าง": (
                englishName: "Basins and sinks",
                frenchName: "Bassins et éviers",
                explanation: "Used for bathtubs, sinks, and washing basins",
                frenchExplanation: "Utilisé pour les baignoires, les éviers et les bassins de lavage",
                whyMatters: "Important for household and hygiene vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la maison et de l'hygiène."
            ),
            "เกม": (
                englishName: "Games and sports activities",
                frenchName: "Jeux et activités sportives",
                explanation: "Used for games like bowling and video games",
                frenchExplanation: "Utilisé pour les jeux comme le bowling et les jeux vidéo",
                whyMatters: "Important for entertainment and leisure vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire du divertissement et des loisirs."
            ),
            "เครื่อง": (
                englishName: "Machines and appliances",
                frenchName: "Machines et appareils",
                explanation: "Used for machines, appliances, and electronic devices such as phones, televisions, computers, washing machines, and similar equipment.",
                frenchExplanation: "Utilisé pour les machines, les appareils et les appareils électroniques comme les téléphones, les téléviseurs, les ordinateurs, les lave-linge et l'équipement similaire.",
                whyMatters: "Very common in modern life when discussing technology, household appliances, and electronics.",
                whyMattersFrench: "Très courant dans la vie moderne quand on discute de la technologie, des appareils ménagers et de l'électronique."
            ),
            "เตียง": (
                englishName: "Beds and cots",
                frenchName: "Lits et couchettes",
                explanation: "Used for beds and single beds",
                frenchExplanation: "Utilisé pour les lits et les lits simples",
                whyMatters: "Important for bedroom and furniture vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des chambres et des meubles."
            ),
            "เปลือก": (
                englishName: "Shells and outer coverings",
                frenchName: "Coquilles et enveloppes extérieures",
                explanation: "Used for shells and hard outer coverings",
                frenchExplanation: "Utilisé pour les coquilles et les enveloppes extérieures dures",
                whyMatters: "Important for beach and nature collection vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des plages et de la collection naturelle."
            ),
            "เมล็ด": (
                englishName: "Seeds and grains",
                frenchName: "Graines et céréales",
                explanation: "Used for seeds and grain items",
                frenchExplanation: "Utilisé pour les graines et les articles de céréales",
                whyMatters: "Important for agriculture and gardening vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de l'agriculture et du jardinage."
            ),
            "เมือง": (
                englishName: "Cities and towns",
                frenchName: "Villes et localités",
                explanation: "Used for cities and municipal areas",
                frenchExplanation: "Utilisé pour les villes et les zones municipales",
                whyMatters: "Important for geography and addressing vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la géographie et de l'adressage."
            ),
            "เม็ด": (
                englishName: "Grains and spice particles",
                frenchName: "Grains et particules d'épices",
                explanation: "Used for peppers, spices, and small food particles",
                frenchExplanation: "Utilisé pour les poivres, les épices et les petites particules alimentaires",
                whyMatters: "Important for cooking and food shopping vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la cuisine et des achats alimentaires."
            ),
            "เรือน": (
                englishName: "Houses and dwellings",
                frenchName: "Maisons et habitations",
                explanation: "Used for houses, homes, and dwelling places. This classifier specifically refers to family homes and residential properties.",
                frenchExplanation: "Utilisé pour les maisons, les foyers et les lieux d'habitation. Ce classificateur se réfère spécifiquement aux maisons familiales et aux propriétés d'habitation.",
                whyMatters: "Essential for real estate, housing discussions, and describing residential areas.",
                whyMattersFrench: "Essentiel pour l'immobilier, les discussions sur le logement et la description des zones d'habitation."
            ),
            "เรื่อง": (
                englishName: "Stories and movies",
                frenchName: "Histoires et films",
                explanation: "Used for movies, films, and stories",
                frenchExplanation: "Utilisé pour les films et les histoires",
                whyMatters: "Important for entertainment and media vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire du divertissement et des médias."
            ),
            "เลา": (
                englishName: "Musical instruments",
                frenchName: "Instruments de musique",
                explanation: "Used for wind instruments like flutes",
                frenchExplanation: "Utilisé pour les instruments à vent comme les flûtes",
                whyMatters: "Important for music and performance vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la musique et des performances."
            ),
            "เล่ม": (
                englishName: "Bound objects (books, notebooks, volumes)",
                frenchName: "Objets reliés (livres, carnets, tomes)",
                explanation: "Used for bound or compiled documents such as books, notebooks, journals, and volumes. The word comes from the concept of bound pages.",
                frenchExplanation: "Utilisé pour les documents reliés ou compilés comme les livres, les carnets, les journaux et les tomes. Le mot vient du concept de pages reliées.",
                whyMatters: "Essential in academic, professional, and library contexts.",
                whyMattersFrench: "Essentiel dans les contextes académiques, professionnels et de bibliothèque."
            ),
            "เส้น": (
                englishName: "Linear/stringy objects (noodles, ropes, lines)",
                frenchName: "Objets linéaires/filiformes (nouilles, cordes, lignes)",
                explanation: "Used for long, thin, and stringy objects such as noodles, ropes, wires, strings, and strands. The word เส้น means 'line' or 'strand'.",
                frenchExplanation: "Utilisé pour les objets longs, minces et filiformes comme les nouilles, les cordes, les fils, les chaînes et les mèches. Le mot เส้น signifie 'ligne' ou 'filament'.",
                whyMatters: "Very useful for food, crafts, construction, and everyday descriptions.",
                whyMattersFrench: "Très utile pour les aliments, l'artisanat, la construction et les descriptions quotidiennes."
            ),
            "แก้ว": (
                englishName: "Glasses and drinks",
                frenchName: "Verres et boissons",
                explanation: "Used for glasses of beverages such as water, milk, juice, soft drinks, and other drinks served in glasses.",
                frenchExplanation: "Utilisé pour les verres de boissons comme l'eau, le lait, le jus, les boissons gazeuses et d'autres boissons servies dans des verres.",
                whyMatters: "Very common in restaurants, cafes, and everyday drinking situations.",
                whyMattersFrench: "Très courant dans les restaurants, les cafés et les situations de consommation quotidienne."
            ),
            "แท่ง": (
                englishName: "Bars and cylindrical items",
                frenchName: "Barres et articles cylindriques",
                explanation: "Used for chocolate bars and ice cream sticks",
                frenchExplanation: "Utilisé pour les barres de chocolat et les bâtons de crème glacée",
                whyMatters: "Important for food and candy vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la nourriture et des bonbons."
            ),
            "แผ่น": (
                englishName: "Thin flat sheets and layers",
                frenchName: "Feuilles et couches plates minces",
                explanation: "Used for thin, flat objects such as sheets of paper, tiles, metal sheets, slices of food, and similar flat items.",
                frenchExplanation: "Utilisé pour les objets plats et minces comme les feuilles de papier, les carreaux, les feuilles de métal, les tranches d'aliments et les articles plats similaires.",
                whyMatters: "Essential in office work, construction, cooking, and when describing flat materials.",
                whyMattersFrench: "Essentiel dans le travail au bureau, la construction, la cuisine et quand on décrit des matériaux plats."
            ),
            "แห่ง": (
                englishName: "Places and institutions",
                frenchName: "Lieux et institutions",
                explanation: "Used for schools, deserts, and geographic locations",
                frenchExplanation: "Utilisé pour les écoles, les déserts et les emplacements géographiques",
                whyMatters: "Important for geography and institution vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire de la géographie et des institutions."
            ),
            "โต๊ะ": (
                englishName: "Tables and gaming surfaces",
                frenchName: "Tables et surfaces de jeu",
                explanation: "Used for game tables like billiards and pool tables",
                frenchExplanation: "Utilisé pour les tables de jeu comme les tables de billard",
                whyMatters: "Important for games and recreation vocabulary.",
                whyMattersFrench: "Important pour le vocabulaire des jeux et des loisirs."
            ),
            "ใบ": (
                englishName: "Flat objects (leaves, plates, sheets)",
                frenchName: "Objets plats (feuilles, assiettes, feuilles)",
                explanation: "Used for flat, sheet-like, or leaf-shaped objects such as leaves, plates, documents, or sheets of paper. The word ใบ originally means 'leaf'.",
                frenchExplanation: "Utilisé pour les objets plats, en forme de feuille ou de feuille comme les feuilles, les assiettes, les documents ou les feuilles de papier. Le mot ใบ signifie originellement 'feuille'.",
                whyMatters: "Essential when describing plants, dining, office work, and natural items.",
                whyMattersFrench: "Essentiel quand on décrit les plantes, les repas, le travail au bureau et les objets naturels."
            ),
        ]
    }

    private func getCommonMistakes(forClassifier classifier: String, explanation: String) -> [String] {
        let basePatterns = [
            "❌ Missing classifier → ✅ Include classifier with number",
            "❌ Wrong order → ✅ [NUMBER] [CLASSIFIER] [NOUN]",
        ]
        return basePatterns
    }

    private func getCommonMistakesFrench(forClassifier classifier: String, explanation: String) -> [String] {
        let basePatterns = [
            "❌ Classificateur manquant → ✅ Inclure le classificateur avec le nombre",
            "❌ Mauvais ordre → ✅ [NOMBRE] [CLASSIFICATEUR] [NOM]",
        ]
        return basePatterns
    }
}
