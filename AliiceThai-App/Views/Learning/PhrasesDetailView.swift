import SwiftUI

struct PhrasesDetailView: View {
    let category: PhraseCategory
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMode: String = "list"

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.8, green: 0.4, blue: 0.6), Color(red: 0.6, green: 0.6, blue: 0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Header
                HStack(spacing: 16) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(gameState.selectedLanguage == "fr" ? category.nameFr : category.nameEn)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text("\(category.phrases.count) " + (gameState.selectedLanguage == "fr" ? "phrases" : "phrases"))
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    Text(category.icon)
                        .font(.system(size: 32))
                }
                .padding(16)
                .background(Color.black.opacity(0.2))

                // Mode Selector Tabs
                HStack(spacing: 8) {
                    Button(action: { withAnimation { selectedMode = "list" } }) {
                        HStack(spacing: 6) {
                            Image(systemName: "list.bullet")
                            Text(gameState.selectedLanguage == "fr" ? "Liste" : "List")
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(selectedMode == "list" ? .white : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(selectedMode == "list" ? Color.white.opacity(0.3) : Color.clear)
                        .cornerRadius(10)
                    }

                    Button(action: { withAnimation { selectedMode = "flashcard" } }) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.grid.2x2")
                            Text(gameState.selectedLanguage == "fr" ? "Cartes" : "Cards")
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(selectedMode == "flashcard" ? .white : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(selectedMode == "flashcard" ? Color.white.opacity(0.3) : Color.clear)
                        .cornerRadius(10)
                    }

                    Button(action: { withAnimation { selectedMode = "quiz" } }) {
                        HStack(spacing: 6) {
                            Image(systemName: "questionmark.circle")
                            Text(gameState.selectedLanguage == "fr" ? "Quiz" : "Quiz")
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(selectedMode == "quiz" ? .white : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(selectedMode == "quiz" ? Color.white.opacity(0.3) : Color.clear)
                        .cornerRadius(10)
                    }
                }
                .padding(12)

                // Content Based on Mode
                if selectedMode == "list" {
                    PhrasesListView(phrases: category.phrases)
                        .environmentObject(gameState)
                } else if selectedMode == "flashcard" {
                    PhrasesFlashcardView(phrases: category.phrases)
                        .environmentObject(gameState)
                } else {
                    PhrasesQuizView(phrases: category.phrases)
                        .environmentObject(gameState)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - List Mode
struct PhrasesListView: View {
    let phrases: [Phrase]
    @EnvironmentObject var gameState: GameState

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(phrases, id: \.thai) { phrase in
                    PhraseCard(phrase: phrase)
                        .environmentObject(gameState)
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Flashcard Mode
struct PhrasesFlashcardView: View {
    let phrases: [Phrase]
    @EnvironmentObject var gameState: GameState
    @State private var currentIndex = 0
    @State private var isFlipped = false

    var currentPhrase: Phrase {
        phrases[currentIndex % phrases.count]
    }

    var body: some View {
        VStack(spacing: 20) {
            // Progress
            HStack {
                Text("\(currentIndex + 1)/\(phrases.count)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                ProgressView(value: Double(currentIndex + 1), total: Double(phrases.count))
                    .frame(maxWidth: .infinity)
                    .tint(.yellow)

                Spacer()
                    .frame(width: 8)

                // Learning status indicator
                HStack(spacing: 2) {
                    Image(systemName: gameState.isPhraseLearned(currentPhrase.thai) ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 12))
                        .foregroundColor(gameState.isPhraseLearned(currentPhrase.thai) ? .green : .white.opacity(0.5))
                }
            }
            .padding(16)

            Spacer()

            // Flashcard
            VStack(spacing: 16) {
                // Thai Side or Translation Side
                if isFlipped {
                    VStack(spacing: 12) {
                        Text(gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.yellow)
                            .multilineTextAlignment(.center)

                        Text(gameState.selectedLanguage == "fr" ? currentPhrase.contextFr : currentPhrase.context)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                            .italic()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(16)
                } else {
                    ZStack(alignment: .topTrailing) {
                        VStack(spacing: 12) {
                            Text(currentPhrase.emoji)
                                .font(.system(size: 50))

                            Text(currentPhrase.thai)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text(currentPhrase.romanization)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(16)

                        Button(action: {
                            AudioManager.shared.speakThai(currentPhrase.thai)
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.cyan)
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(12)
                    }
                }

                Text(isFlipped ? gameState.selectedLanguage == "fr" ? "Thaï →" : "← Thai" : gameState.selectedLanguage == "fr" ? "← Traduction" : "Translation →")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.cyan)
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isFlipped.toggle()
                }
            }

            Spacer()

            // Navigation Buttons
            HStack(spacing: 12) {
                Button(action: {
                    if currentIndex > 0 {
                        withAnimation {
                            currentIndex -= 1
                            isFlipped = false
                        }
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
                .disabled(currentIndex == 0)
                .opacity(currentIndex == 0 ? 0.5 : 1.0)

                Button(action: {
                    withAnimation {
                        currentIndex = Int.random(in: 0..<phrases.count)
                        isFlipped = false
                    }
                }) {
                    Image(systemName: "shuffle")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }

                Button(action: {
                    if currentIndex < phrases.count - 1 {
                        withAnimation {
                            currentIndex += 1
                            isFlipped = false
                        }
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
                .disabled(currentIndex == phrases.count - 1)
                .opacity(currentIndex == phrases.count - 1 ? 0.5 : 1.0)
            }
            .padding(16)
        }
    }
}

// MARK: - Quiz Mode
struct PhrasesQuizView: View {
    let phrases: [Phrase]
    @EnvironmentObject var gameState: GameState
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var selectedAnswer: Int?
    @State private var showResult = false
    @State private var quizFinished = false

    // Clean language codes from translations
    func cleanTranslation(_ text: String) -> String {
        return text
            .replacingOccurrences(of: " (ENG)", with: "")
            .replacingOccurrences(of: " (EN)", with: "")
            .replacingOccurrences(of: " (ENGLISH)", with: "")
            .replacingOccurrences(of: " (FR)", with: "")
            .replacingOccurrences(of: " (FRE)", with: "")
            .replacingOccurrences(of: " (FRENCH)", with: "")
            .trimmingCharacters(in: .whitespaces)
    }

    var currentPhrase: Phrase {
        phrases[currentIndex]
    }

    var options: [String] {
        let correct = cleanTranslation(gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation)
        var opts = Set([correct])

        // Get list of distinct wrong phrases to avoid duplicates
        let wrongPhrases = phrases.filter { phrase in
            let translation = cleanTranslation(gameState.selectedLanguage == "fr" ? phrase.frenchTranslation : phrase.englishTranslation)
            return translation != correct
        }

        // Select 3 random distinct wrong options
        var usedIndices = Set<Int>()
        while opts.count < 4 && usedIndices.count < wrongPhrases.count {
            let randomIndex = Int.random(in: 0..<wrongPhrases.count)
            if !usedIndices.contains(randomIndex) {
                let wrongOption = cleanTranslation(gameState.selectedLanguage == "fr"
                    ? wrongPhrases[randomIndex].frenchTranslation
                    : wrongPhrases[randomIndex].englishTranslation)
                opts.insert(wrongOption)
                usedIndices.insert(randomIndex)
            }
        }
        return opts.shuffled()
    }

    var body: some View {
        if quizFinished {
            // Results Screen
            VStack(spacing: 20) {
                Spacer()

                // Score Circle
                VStack(spacing: 16) {
                    let percentage = (score * 100) / phrases.count

                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 8)
                            .frame(width: 150, height: 150)

                        Circle()
                            .trim(from: 0, to: CGFloat(percentage) / 100)
                            .stroke(
                                percentage >= 80 ? Color.green :
                                percentage >= 60 ? Color.blue :
                                Color.orange,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 150, height: 150)
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 8) {
                            Text("\(score)/\(phrases.count)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text("\(percentage)%")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.yellow)
                        }
                    }

                    // Motivational Message
                    VStack(spacing: 8) {
                        Text(
                            percentage >= 80 ? (gameState.selectedLanguage == "fr" ? "Excellent!" : "Excellent!") :
                            percentage >= 60 ? (gameState.selectedLanguage == "fr" ? "Très bien!" : "Great job!") :
                            gameState.selectedLanguage == "fr" ? "Continuez!" : "Keep practicing!"
                        )
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(
                            percentage >= 80 ? .green :
                            percentage >= 60 ? .blue :
                            .orange
                        )

                        Text(
                            percentage >= 80 ? (gameState.selectedLanguage == "fr" ? "Vous maîtrisez le sujet!" : "You've mastered the material!") :
                            percentage >= 60 ? (gameState.selectedLanguage == "fr" ? "Vous vous améliorez!" : "You're improving well!") :
                            gameState.selectedLanguage == "fr" ? "Revisite ce contenu bientôt." : "Review this content soon."
                        )
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    }
                }
                .padding(20)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)

                // Stats
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(gameState.selectedLanguage == "fr" ? "Correct" : "Correct")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(score)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.green)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Text(gameState.selectedLanguage == "fr" ? "Incorrect" : "Incorrect")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(phrases.count - score)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.red)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Text(gameState.selectedLanguage == "fr" ? "Appris" : "Learned")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(gameState.learnedPhrases.count)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(10)
                }
                .padding(16)

                Spacer()

                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        currentIndex = 0
                        score = 0
                        selectedAnswer = nil
                        showResult = false
                        quizFinished = false
                    }) {
                        Text(gameState.selectedLanguage == "fr" ? "Recommencer" : "Try Again")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    Button(action: {} ) {
                        Text(gameState.selectedLanguage == "fr" ? "Retour à la Catégorie" : "Back to Category")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding(16)
            }
        } else {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Score: \(score)/\(phrases.count)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.yellow)

                    Spacer()

                    Text("\(currentIndex + 1)/\(phrases.count)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(16)

            // Question
            VStack(spacing: 12) {
                Text(gameState.selectedLanguage == "fr" ? "Que signifie?" : "What does this mean?")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.8))

                HStack(spacing: 12) {
                    VStack(spacing: 8) {
                        Text(currentPhrase.thai)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)

                        Text(currentPhrase.romanization)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()

                    Button(action: {
                        AudioManager.shared.speakThai(currentPhrase.thai)
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.cyan)
                            .frame(width: 50, height: 50)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(10)
                    }
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.15))
            .cornerRadius(12)
            .padding(16)

            // Options
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Button(action: {
                            selectedAnswer = index
                            let correct = cleanTranslation(gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation)
                            if options[index] == correct {
                                score += 1
                                // Mark phrase as learned on correct answer
                                gameState.markPhraseLearned(currentPhrase.thai)
                            }
                            showResult = true
                        }) {
                            HStack(spacing: 12) {
                                Text(options[index])
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.leading, 8)

                                Spacer()

                                if selectedAnswer == index {
                                    let correct = cleanTranslation(gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation)
                                    Image(systemName: showResult && options[index] == correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(showResult && options[index] == correct ? .green : .red)
                                        .padding(.trailing, 8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(
                                selectedAnswer == index
                                    ? (showResult && options[index] == (gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation) ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                                    : Color.white.opacity(0.15)
                            )
                            .cornerRadius(10)
                        }
                        .disabled(showResult)
                    }
                }
                .padding(16)
            }

            if showResult {
                VStack(spacing: 12) {
                    let correct = cleanTranslation(gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation)
                    let isCorrect = options[selectedAnswer ?? 0] == correct

                    // Result feedback
                    HStack(spacing: 8) {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(isCorrect ? .green : .red)

                        Text(isCorrect ? "Correct!" : "Incorrect")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(isCorrect ? .green : .red)

                        Spacer()

                        Text("\(score)/\(currentIndex + 1)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.yellow)
                    }
                    .padding(12)
                    .background(isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .cornerRadius(8)
                    .padding(16)

                    // Correct answer if wrong
                    if !isCorrect {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(gameState.selectedLanguage == "fr" ? "Réponse correcte:" : "Correct answer:")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.yellow)

                            Text(correct)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)

                            Divider()
                                .background(Color.white.opacity(0.2))

                            Text(gameState.selectedLanguage == "fr" ? "Contexte:" : "Context:")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))

                            Text(gameState.selectedLanguage == "fr" ? currentPhrase.contextFr : currentPhrase.context)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.7))
                                .italic()
                        }
                        .padding(12)
                        .background(Color.yellow.opacity(0.15))
                        .cornerRadius(8)
                        .padding(16)
                    }

                    // Next button
                    Button(action: {
                        if currentIndex < phrases.count - 1 {
                            currentIndex += 1
                            selectedAnswer = nil
                            showResult = false
                        } else {
                            quizFinished = true
                        }
                    }) {
                        Text(currentIndex == phrases.count - 1 ? (gameState.selectedLanguage == "fr" ? "Résultats" : "Results") : (gameState.selectedLanguage == "fr" ? "Suivant" : "Next"))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                            .cornerRadius(10)
                    }
                    .padding(16)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PhrasesDetailView(category: phraseCategories[0])
            .environmentObject(GameState())
    }
}
}
