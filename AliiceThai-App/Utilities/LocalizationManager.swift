import Foundation
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    private let languageKey = "appLanguage"

    @Published var currentLanguage: String {
        didSet { UserDefaults.standard.set(currentLanguage, forKey: languageKey) }
    }

    init() {
        self.currentLanguage = UserDefaults.standard.string(forKey: languageKey) ?? "en"
    }

    func localize(_ key: String) -> String {
        let translations: [String: [String: String]] = [
            // ONBOARDING
            "onboarding.welcome.title": ["en": "Learn Thai with AliiceThai!", "fr": "Apprenez le thaï avec AliiceThai!"],
            "onboarding.welcome.subtitle": ["en": "Tap emojis, tap words, learn and have fun!", "fr": "Tapez des emojis, tapez des mots, apprenez et amusez-vous!"],

            "onboarding.demo.title": ["en": "How to Learn", "fr": "Comment apprendre"],
            "onboarding.demo.emoji": ["en": "Tap emoji to hear the word!", "fr": "Tapez emoji pour entendre le mot!"],
            "onboarding.demo.word": ["en": "Tap word to hear translation!", "fr": "Tapez le mot pour entendre la traduction!"],

            "onboarding.language.title": ["en": "Choose Language", "fr": "Choisir la langue"],
            "onboarding.language.english": ["en": "English", "fr": "Anglais"],
            "onboarding.language.french": ["en": "Français", "fr": "Français"],

            "onboarding.ready.title": ["en": "Ready to Learn!", "fr": "Prêt à apprendre!"],
            "onboarding.ready.subtitle": ["en": "Let's start learning Thai together!", "fr": "Commençons à apprendre le thaï ensemble!"],

            // BUTTONS
            "button.next": ["en": "Next", "fr": "Suivant"],
            "button.back": ["en": "Back", "fr": "Retour"],
            "button.letsgo": ["en": "Let's Go!", "fr": "C'est parti!"],
            "button.hear": ["en": "Hear it!", "fr": "Écoutez!"],
            "button.flashcards": ["en": "📇 Flashcards", "fr": "📇 Cartes"],
            "button.quiz": ["en": "🎯 Quiz", "fr": "🎯 Quiz"],
            "button.nextword": ["en": "Next Word", "fr": "Mot suivant"],
            "button.nextquestion": ["en": "Next Question", "fr": "Question suivante"],
            "button.trynext": ["en": "Try Next One", "fr": "Essayer le suivant"],

            // HOME
            "home.title": ["en": "Learn Thai 🌏", "fr": "Apprenez le thaï 🌏"],
            "home.stars": ["en": "⭐ Stars", "fr": "⭐ Étoiles"],
            "home.lesson.title": ["en": "Today's Lesson", "fr": "Leçon du jour"],
            "vocabulary.categories.title": ["en": "Vocabulary by Category", "fr": "Vocabulaire par catégorie"],

            // CATEGORIES
            "category.adjectives": ["en": "Adjectives", "fr": "Adjectifs"],
            "category.animals": ["en": "Animals", "fr": "Animaux"],
            "category.body": ["en": "Body", "fr": "Corps"],
            "category.characters": ["en": "Characters", "fr": "Personnages"],
            "category.clothes": ["en": "Clothes", "fr": "Vêtements"],
            "category.colors": ["en": "Colors", "fr": "Couleurs"],
            "category.dinos": ["en": "Dinosaurs", "fr": "Dinosaures"],
            "category.drinks": ["en": "Drinks", "fr": "Boissons"],
            "category.events": ["en": "Events", "fr": "Événements"],
            "category.family": ["en": "Family", "fr": "Famille"],
            "category.feelings": ["en": "Feelings", "fr": "Sentiments"],
            "category.food": ["en": "Food", "fr": "Nourriture"],
            "category.fruits": ["en": "Fruits", "fr": "Fruits"],
            "category.home": ["en": "Home", "fr": "Maison"],
            "category.hygiene": ["en": "Hygiene", "fr": "Hygiène"],
            "category.insects": ["en": "Insects", "fr": "Insectes"],
            "category.music": ["en": "Music", "fr": "Musique"],
            "category.nature": ["en": "Nature", "fr": "Nature"],
            "category.numbers": ["en": "Numbers", "fr": "Nombres"],
            "category.places": ["en": "Places", "fr": "Lieux"],
            "category.school": ["en": "School", "fr": "École"],
            "category.sea": ["en": "Sea", "fr": "Mer"],
            "category.shapes": ["en": "Shapes", "fr": "Formes"],
            "category.space": ["en": "Space", "fr": "Espace"],
            "category.sport": ["en": "Sports", "fr": "Sports"],
            "category.tech": ["en": "Technology", "fr": "Technologie"],
            "category.tools": ["en": "Tools", "fr": "Outils"],
            "category.toys": ["en": "Toys", "fr": "Jouets"],
            "category.transport": ["en": "Transport", "fr": "Transport"],
            "category.vegetables": ["en": "Vegetables", "fr": "Légumes"],
            "category.verbs": ["en": "Verbs", "fr": "Verbes"],
            "category.weather": ["en": "Weather", "fr": "Météo"],

            // LEARNING
            "learning.back": ["en": "Back", "fr": "Retour"],

            // QUIZ
            "quiz.question": ["en": "What is this?", "fr": "Qu'est-ce que c'est?"],
            "quiz.correct": ["en": "🎉 Great job!", "fr": "🎉 Excellent!"],
            "quiz.incorrect": ["en": "Try again! The answer is:", "fr": "Réessayez! La réponse est:"],

            // NUMBERS MODULE
            "numbers.title": ["en": "Numbers", "fr": "Nombres"],
            "numbers.quiz.title": ["en": "Quiz - Find the number", "fr": "Quiz - Trouvez le nombre"],
            "numbers.quiz.question": ["en": "What number is this?", "fr": "Quel nombre est-ce?"],
            "numbers.quiz.correct": ["en": "Correct!", "fr": "Correct!"],
            "numbers.quiz.incorrect": ["en": "Not quite!", "fr": "Pas tout à fait!"],
            "numbers.quiz.answer": ["en": "The answer is", "fr": "La réponse est"],
            "numbers.quiz.nextquestion": ["en": "Next Question ➜", "fr": "Question suivante ➜"],
            "numbers.quiz.trynext": ["en": "Try Next ➜", "fr": "Essayer le suivant ➜"],

            // SETTINGS
            "settings.title": ["en": "Settings", "fr": "Paramètres"],
            "settings.language": ["en": "Language", "fr": "Langue"],
            "settings.profile": ["en": "Profile", "fr": "Profil"],
            "settings.stats": ["en": "Statistics", "fr": "Statistiques"],
            "settings.about": ["en": "About", "fr": "À propos"],
            "settings.reset": ["en": "Reset Progress", "fr": "Réinitialiser"],

            "settings.currentlanguage": ["en": "Current Language:", "fr": "Langue actuelle:"],
            "settings.selectlanguage": ["en": "Select Language", "fr": "Sélectionner la langue"],
            "settings.appname": ["en": "AliiceThai", "fr": "AliiceThai"],
            "settings.version": ["en": "Version", "fr": "Version"],
            "settings.total_words": ["en": "Total Words", "fr": "Nombre de mots"],
            "settings.categories": ["en": "Categories", "fr": "Catégories"],
            "settings.total_stars": ["en": "Total Stars Earned", "fr": "Étoiles totales gagnées"],
            "settings.best_category": ["en": "Best Category", "fr": "Meilleure catégorie"],

            "settings.reset.confirm": ["en": "Reset all progress?", "fr": "Réinitialiser tous les progrès?"],
            "settings.reset.warning": ["en": "This cannot be undone. All stars will be lost.", "fr": "Cela ne peut pas être annulé. Toutes les étoiles seront perdues."],
            "settings.reset.yes": ["en": "Yes, Reset", "fr": "Oui, réinitialiser"],
            "settings.reset.cancel": ["en": "Cancel", "fr": "Annuler"],
            "settings.reset.done": ["en": "Progress reset!", "fr": "Progrès réinitialisé!"],

            // TONE MASTERY
            "tone.mastery.title": ["en": "Tones Mastery", "fr": "Maîtrise des tons"],
            "tone.mastery.subtitle": ["en": "Master Thai Tone System", "fr": "Maîtrisez le système des tons thaïs"],
            "tone.lesson": ["en": "Lesson", "fr": "Leçon"],
            "tone.quiz": ["en": "Quiz", "fr": "Quiz"],
            "tone.weak_areas": ["en": "Weak Areas", "fr": "Points faibles"],

            "tone.detection.question": ["en": "Question", "fr": "Question"],
            "tone.detection.correct_count": ["en": "correct", "fr": "correct"],
            "tone.detection.play_audio": ["en": "Play Audio", "fr": "Jouer l'audio"],
            "tone.detection.next_question": ["en": "Next Question →", "fr": "Question suivante →"],
            "tone.detection.finish_quiz": ["en": "Finish Quiz", "fr": "Terminer le quiz"],
            "tone.detection.correct": ["en": "Correct!", "fr": "Correct!"],
            "tone.detection.not_quite": ["en": "Not quite", "fr": "Pas tout à fait"],
            "tone.detection.you_selected": ["en": "You selected:", "fr": "Vous avez sélectionné:"],
            "tone.detection.correct_answer": ["en": "Correct answer:", "fr": "Bonne réponse:"],
            "tone.detection.great_ear": ["en": "Great ear! You're mastering tones!", "fr": "Bien entendu! Vous maîtrisez les tons!"],
            "tone.detection.listen_carefully": ["en": "Try listening more carefully to the pitch. Practice this tone!", "fr": "Écoutez attentivement le ton. Entraînez-vous sur ce ton!"],

            "tone.lesson.title": ["en": "Tone Contrast", "fr": "Contraste des tons"],
            "tone.lesson.learn": ["en": "Master Tone Distinction", "fr": "Maître des tons"],
            "tone.lesson.subtitle": ["en": "Learn how tone changes meaning in Thai", "fr": "Apprenez comment le ton change le sens en thaï"],
            "tone.lesson.tone_label": ["en": "Tone:", "fr": "Ton:"],
            "tone.lesson.listen_correct": ["en": "Listen (Correct)", "fr": "Écouter (Correct)"],
            "tone.lesson.tone1": ["en": "Tone 1:", "fr": "Ton 1:"],
            "tone.lesson.tone2_rising": ["en": "Tone 2: RISING (Different)", "fr": "Ton 2: MONTANT (Différent)"],
            "tone.lesson.listen_different": ["en": "Listen (Different Tone)", "fr": "Écouter (Ton différent)"],
            "tone.lesson.notice_difference": ["en": "Notice the difference in pitch?", "fr": "Remarquez la différence de ton?"],
            "tone.lesson.vs": ["en": "vs", "fr": "vs"],
            "tone.lesson.show_comparison": ["en": "Show Comparison Tone", "fr": "Montrer le ton de comparaison"],
            "tone.lesson.why_matters": ["en": "Why This Matters", "fr": "Pourquoi c'est important"],
            "tone.lesson.importance": ["en": "In Thai, tone is as important as the letters. If you say the wrong tone, native speakers won't understand you—or worse, you'll say a different word entirely!", "fr": "En thaï, le ton est aussi important que les lettres. Si vous dites le mauvais ton, les locuteurs natifs ne vous comprendront pas—ou pire, vous direz un mot différent!"],
            "tone.lesson.test_ear": ["en": "Test Your Ear →", "fr": "Testez votre oreille →"],

            "tone.lesson_list.learn_each": ["en": "Learn Each Tone", "fr": "Apprenez chaque ton"],
            "tone.lesson_list.words": ["en": "words", "fr": "mots"],
            "tone.lesson_list.not_started": ["en": "Not started", "fr": "Non commencé"],
            "tone.lesson_list.loading": ["en": "Loading tones...", "fr": "Chargement des tons..."],
            "tone.lesson_for_tone.title": ["en": "Tone:", "fr": "Ton:"],
            "tone.lesson_for_tone.subtitle": ["en": "Listen to words with this tone and practice pronouncing them correctly.", "fr": "Écoutez les mots avec ce ton et entraînez-vous à les prononcer correctement."],
            "tone.lesson_for_tone.no_words": ["en": "No words available for this tone yet.", "fr": "Aucun mot disponible pour ce ton pour l'instant."],

            "tone.shadowing.title": ["en": "Shadowing Practice", "fr": "Pratique d'imitation"],
            "tone.shadowing.header": ["en": "Shadow the Speaker", "fr": "Répétez le locuteur"],
            "tone.shadowing.subtitle": ["en": "Listen carefully, then repeat the word", "fr": "Écoutez attentivement, puis répétez le mot"],
            "tone.shadowing.listen_model": ["en": "Listen (Model)", "fr": "Écouter (Modèle)"],
            "tone.shadowing.record": ["en": "Record Your Voice", "fr": "Enregistrer votre voix"],
            "tone.shadowing.attempt": ["en": "Attempt", "fr": "Tentative"],
            "tone.shadowing.recording": ["en": "Recording:", "fr": "Enregistrement:"],
            "tone.shadowing.stop": ["en": "Stop", "fr": "Arrêter"],
            "tone.shadowing.analyzing": ["en": "Analyzing pronunciation...", "fr": "Analyse de la prononciation..."],
            "tone.shadowing.excellent": ["en": "Excellent! Next Word →", "fr": "Excellent! Mot suivant →"],
            "tone.shadowing.continue": ["en": "Continue →", "fr": "Continuer →"],
            "tone.shadowing.try_again": ["en": "Try Again", "fr": "Réessayer"],

            "tone.feedback.excellent": ["en": "Excellent!", "fr": "Excellent!"],
            "tone.feedback.complete": ["en": "Analysis Complete", "fr": "Analyse terminée"],
            "tone.feedback.tone_accuracy": ["en": "Tone Accuracy", "fr": "Précision du ton"],
            "tone.feedback.clarity": ["en": "Clarity", "fr": "Clarté"],
            "tone.feedback.feedback": ["en": "Feedback", "fr": "Retour"],

            "tone.weak.title": ["en": "Tones to Focus On", "fr": "Tons à travailler"],
            "tone.weak.subtitle": ["en": "These tones need more practice", "fr": "Ces tons ont besoin de plus de pratique"],
            "tone.weak.great_job": ["en": "Great job!", "fr": "Bien joué!"],
            "tone.weak.no_weak": ["en": "You have no weak tone areas. Keep practicing!", "fr": "Vous n'avez pas de points faibles. Continuez à vous entraîner!"],
            "tone.weak.focus": ["en": "Focus on this word to improve your tone accuracy", "fr": "Concentrez-vous sur ce mot pour améliorer votre précision des tons"],

            "tone.name.mid": ["en": "Mid", "fr": "Moyen"],
            "tone.name.low": ["en": "Low", "fr": "Bas"],
            "tone.name.falling": ["en": "Falling", "fr": "Descendant"],
            "tone.name.rising": ["en": "Rising", "fr": "Montant"],
            "tone.name.high": ["en": "High", "fr": "Haut"],

            // CLASSIFIERS
            "classifier.mastery.title": ["en": "Classifiers Mastery", "fr": "Maîtrise des classificateurs"],
            "classifier.mastery.subtitle": ["en": "Master Thai Classifiers", "fr": "Maîtrisez les classificateurs thaïs"],
            "classifier.lesson": ["en": "Lesson", "fr": "Leçon"],
            "classifier.quiz": ["en": "Quiz", "fr": "Quiz"],
            "classifier.weak_areas": ["en": "Weak Areas", "fr": "Points faibles"],

            "classifier.lesson.title": ["en": "Classifier Lesson", "fr": "Leçon sur les classificateurs"],
            "classifier.lesson.learn": ["en": "Learn Classifiers", "fr": "Apprenez les classificateurs"],
            "classifier.lesson.subtitle": ["en": "Master Thai classifier usage with examples", "fr": "Maîtrisez l'utilisation des classificateurs thaïs avec des exemples"],
            "classifier.lesson.classifier_label": ["en": "Classifier:", "fr": "Classificateur:"],
            "classifier.lesson.listen": ["en": "Listen", "fr": "Écouter"],
            "classifier.lesson.example": ["en": "Example", "fr": "Exemple"],
            "classifier.lesson.usage": ["en": "Usage", "fr": "Utilisation"],
            "classifier.lesson.used_for": ["en": "Used for:", "fr": "Utilisé pour:"],
            "classifier.lesson.why_matters": ["en": "Why It Matters", "fr": "Pourquoi c'est important"],
            "classifier.lesson.examples": ["en": "Examples from vocabulary", "fr": "Exemples du vocabulaire"],
            "classifier.lesson.common_mistakes": ["en": "Common Mistakes", "fr": "Erreurs Courantes"],
            "classifier.lesson.practice": ["en": "Practice Classifiers", "fr": "Pratiquer les classificateurs"],
            "classifier.lesson.test": ["en": "Test Your Knowledge →", "fr": "Testez vos connaissances →"],

            "classifier.principle.what_is": ["en": "What is a Classifier?", "fr": "Qu'est-ce qu'un classificateur?"],
            "classifier.principle.what_is_desc": ["en": "Classifiers are measure words used with numbers in Thai to count objects. In Thai, you cannot simply say a number followed by a noun - you must include the correct classifier.", "fr": "Les classificateurs sont des mots de mesure utilisés avec les nombres en thaï pour compter les objets. En thaï, vous ne pouvez pas simplement dire un nombre suivi d'un nom - vous devez inclure le bon classificateur."],
            "classifier.principle.why_use": ["en": "Why Do We Use Them?", "fr": "Pourquoi les utilisons-nous?"],
            "classifier.principle.why_use_desc": ["en": "Each type of object has its own classifier based on its shape, size, and nature. Classifiers help precisely identify what you are counting.", "fr": "Chaque type d'objet a son propre classificateur basé sur sa forme, sa taille et sa nature. Les classificateurs aident à identifier précisément ce que vous comptez."],
            "classifier.principle.examples": ["en": "Examples", "fr": "Exemples"],
            "classifier.principle.example_animals": ["en": "Used for animals", "fr": "Utilisé pour les animaux"],
            "classifier.principle.example_people": ["en": "Used for people", "fr": "Utilisé pour les personnes"],
            "classifier.principle.example_bound": ["en": "Used for bound objects", "fr": "Utilisé pour les objets reliés"],
            "classifier.principle.key_point": ["en": "Key Point", "fr": "Point Clé"],
            "classifier.principle.essential": ["en": "Mastering classifiers is ESSENTIAL for speaking Thai correctly. It is one of the most important grammatical features of Thai!", "fr": "Maîtriser les classificateurs est ESSENTIEL pour parler le thaï correctement. C'est l'une des caractéristiques grammaticales les plus importantes du thaï!"],
            "classifier.action.ready_to_practice": ["en": "Ready to practice?", "fr": "Prêt à pratiquer?"],
            "classifier.action.ready_description": ["en": "Test your knowledge of Thai classifiers with 10 questions.", "fr": "Testez vos connaissances des classificateurs thaïs avec 10 questions."],
            "classifier.action.start_quiz": ["en": "Start Quiz", "fr": "Commencer le quiz"],
            "classifier.action.try_again": ["en": "Try Again", "fr": "Recommencer"],
            "classifier.action.back": ["en": "Back", "fr": "Retour"],
            "classifier.results.complete": ["en": "Quiz Complete!", "fr": "Quiz terminé!"],
            "classifier.results.accuracy": ["en": "Accuracy", "fr": "Précision"],
            "classifier.results.total_questions": ["en": "Total Questions", "fr": "Total de questions"],

            "classifier.level.essential": ["en": "Essential", "fr": "Essentiel"],
            "classifier.level.essential_desc": ["en": "Learn first (10-15)", "fr": "À apprendre en priorité (10-15)"],
            "classifier.level.important": ["en": "Important", "fr": "Important"],
            "classifier.level.important_desc": ["en": "Learn next (40)", "fr": "À apprendre ensuite (40)"],
            "classifier.level.advanced": ["en": "Advanced", "fr": "Avancé"],
            "classifier.level.advanced_desc": ["en": "For advanced learners (rest)", "fr": "Pour les apprenants avancés (reste)"],

            "classifier.quiz.title": ["en": "Classifier Quiz", "fr": "Quiz sur les classificateurs"],
            "classifier.quiz.question": ["en": "Question", "fr": "Question"],
            "classifier.quiz.correct_count": ["en": "correct", "fr": "correct"],
            "classifier.quiz.select_classifier": ["en": "Select the correct classifier:", "fr": "Sélectionnez le bon classificateur:"],
            "classifier.quiz.next": ["en": "Next Question →", "fr": "Question suivante →"],
            "classifier.quiz.finish": ["en": "Finish Quiz", "fr": "Terminer le quiz"],
            "classifier.quiz.correct": ["en": "Correct!", "fr": "Correct!"],
            "classifier.quiz.incorrect": ["en": "Incorrect", "fr": "Incorrect"],
            "classifier.quiz.not_quite": ["en": "Not quite", "fr": "Pas tout à fait"],
            "classifier.quiz.you_selected": ["en": "You selected:", "fr": "Vous avez sélectionné:"],
            "classifier.quiz.correct_answer": ["en": "Correct answer:", "fr": "Bonne réponse:"],
            "classifier.quiz.great": ["en": "Great job! You're mastering classifiers!", "fr": "Bien joué! Vous maîtrisez les classificateurs!"],
            "classifier.quiz.try_again": ["en": "Review classifier rules carefully. Try again!", "fr": "Examinez attentivement les règles des classificateurs. Réessayez!"],

            "classifier.lesson_list.learn_each": ["en": "Learn Each Classifier", "fr": "Apprenez chaque classificateur"],
            "classifier.lesson_list.not_started": ["en": "Not started", "fr": "Non commencé"],
            "classifier.lesson_list.loading": ["en": "Loading classifiers...", "fr": "Chargement des classificateurs..."],

            "classifier.lesson_for_classifier.title": ["en": "Classifier:", "fr": "Classificateur:"],
            "classifier.lesson_for_classifier.subtitle": ["en": "Learn when and how to use this classifier with examples.", "fr": "Apprenez quand et comment utiliser ce classificateur avec des exemples."],
            "classifier.lesson_for_classifier.no_examples": ["en": "No examples available for this classifier yet.", "fr": "Aucun exemple disponible pour ce classificateur pour l'instant."],

            "classifier.weak.title": ["en": "Classifiers to Focus On", "fr": "Classificateurs à travailler"],
            "classifier.weak.subtitle": ["en": "These classifiers need more practice", "fr": "Ces classificateurs ont besoin de plus de pratique"],
            "classifier.weak.great_job": ["en": "Great job!", "fr": "Bien joué!"],
            "classifier.weak.no_weak": ["en": "You have no weak classifier areas. Keep practicing!", "fr": "Vous n'avez pas de points faibles. Continuez à vous entraîner!"],
            "classifier.weak.focus": ["en": "Focus on this classifier to improve your accuracy", "fr": "Concentrez-vous sur ce classificateur pour améliorer votre précision"],

            // ALPHABET
            "alphabet.title": ["en": "Alphabet", "fr": "Alphabet"],
            "alphabet.letters": ["en": "letters", "fr": "lettres"],
            "alphabet.sprint_title": ["en": "Alphabet Sprint", "fr": "Jeu alphabet express"],
            "alphabet.sprint_description": ["en": "10 fast questions to lock in the letters", "fr": "10 questions rapides pour mémoriser les lettres"],
            "alphabet.class_high": ["en": "High class", "fr": "classe haute"],
            "alphabet.class_mid": ["en": "Mid class", "fr": "classe moyenne"],
            "alphabet.class_low": ["en": "Low class", "fr": "classe basse"],
        ]

        let key_value = translations[key] ?? [:]
        return key_value[currentLanguage] ?? key
    }
}
