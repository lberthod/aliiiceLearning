import SwiftUI

struct RandomQuizView: View {
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var selectedAnswer: Int?
    @State private var showResult = false
    @State private var quizStarted = false
    @State private var quizFinished = false
    @State private var shuffledPhrases: [Phrase] = []

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

    var allPhrases: [Phrase] {
        phraseCategories.flatMap { $0.phrases }.shuffled()
    }

    var currentPhrase: Phrase {
        guard !shuffledPhrases.isEmpty && currentIndex < shuffledPhrases.count else {
            return Phrase(thai: "", romanization: "", englishTranslation: "", frenchTranslation: "", emoji: "❓", context: "", contextFr: "")
        }
        return shuffledPhrases[currentIndex]
    }

    var options: [String] {
        let correct = cleanTranslation(gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation)
        var opts = Set([correct])

        // Get list of distinct wrong phrases to avoid duplicates
        let wrongPhrases = shuffledPhrases.filter { phrase in
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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.4, green: 0.8, blue: 0.6), Color(red: 0.2, green: 0.6, blue: 0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack(spacing: 16) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(gameState.selectedLanguage == "fr" ? "Quiz Aléatoire" : "Random Quiz")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text(gameState.selectedLanguage == "fr" ? "190 phrases" : "190 phrases")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    Image(systemName: "shuffle")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                .padding(16)
                .background(Color.black.opacity(0.2))

                if !quizStarted {
                    // Start Screen
                    VStack(spacing: 30) {
                        Spacer()

                        VStack(spacing: 16) {
                            Image(systemName: "shuffle.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)

                            Text(gameState.selectedLanguage == "fr" ? "Quiz Aléatoire" : "Random Quiz")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text(gameState.selectedLanguage == "fr" ? "Testez-vous avec des phrases aléatoires" : "Test yourself with random phrases")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }

                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.yellow)
                                Text(gameState.selectedLanguage == "fr" ? "190 phrases" : "190 phrases")
                                    .foregroundColor(.white)
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "shuffle")
                                    .foregroundColor(.cyan)
                                Text(gameState.selectedLanguage == "fr" ? "Ordre aléatoire" : "Random order")
                                    .foregroundColor(.white)
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(gameState.selectedLanguage == "fr" ? "Suivez votre score" : "Track your score")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Spacer()

                        Button(action: {
                            shuffledPhrases = allPhrases
                            quizStarted = true
                        }) {
                            Text(gameState.selectedLanguage == "fr" ? "Commencer" : "Start")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        .padding(16)
                    }
                } else if quizFinished {
                    // Results Screen
                    VStack(spacing: 20) {
                        Spacer()

                        // Score Circle
                        VStack(spacing: 16) {
                            let percentage = (score * 100) / shuffledPhrases.count

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
                                    Text("\(score)/\(shuffledPhrases.count)")
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
                                    Text("\(shuffledPhrases.count - score)")
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
                                shuffledPhrases = allPhrases
                            }) {
                                Text(gameState.selectedLanguage == "fr" ? "Recommencer" : "Try Again")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }

                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Text(gameState.selectedLanguage == "fr" ? "Retour" : "Back")
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
                    // Quiz Content
                    VStack(spacing: 16) {
                        // Header
                        HStack {
                            Text("Score: \(score)/\(shuffledPhrases.count)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.yellow)

                            Spacer()

                            Text("\(currentIndex + 1)/\(shuffledPhrases.count)")
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
                                                Image(systemName: showResult && options[index] == (gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                    .foregroundColor(showResult && options[index] == (gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation) ? .green : .red)
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

                        // Feedback Section
                        if showResult {
                            VStack(spacing: 12) {
                                let correct = gameState.selectedLanguage == "fr" ? currentPhrase.frenchTranslation : currentPhrase.englishTranslation
                                let isCorrect = options[selectedAnswer ?? 0] == correct

                                // Result indicator
                                HStack(spacing: 8) {
                                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(isCorrect ? .green : .red)

                                    Text(isCorrect ? (gameState.selectedLanguage == "fr" ? "Correct!" : "Correct!") : (gameState.selectedLanguage == "fr" ? "Incorrect" : "Incorrect"))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(isCorrect ? .green : .red)

                                    Spacer()
                                }
                                .padding(12)
                                .background(isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                .cornerRadius(8)

                                // Correct answer display
                                if !isCorrect {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(gameState.selectedLanguage == "fr" ? "Réponse correcte:" : "Correct answer:")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.yellow)

                                        Text(correct)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(12)
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(8)
                                }

                                // Phrase details
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack(spacing: 12) {
                                        Text(currentPhrase.emoji)
                                            .font(.system(size: 18))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(currentPhrase.thai)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)

                                            Text(currentPhrase.romanization)
                                                .font(.system(size: 11))
                                                .foregroundColor(.white.opacity(0.7))
                                        }

                                        Spacer()
                                    }

                                    Divider()
                                        .background(Color.white.opacity(0.2))

                                    Text(gameState.selectedLanguage == "fr" ? "Contexte:" : "Context:")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))

                                    Text(gameState.selectedLanguage == "fr" ? currentPhrase.contextFr : currentPhrase.context)
                                        .font(.system(size: 11))
                                        .foregroundColor(.white.opacity(0.7))
                                        .italic()
                                }
                                .padding(12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding(16)

                            // Navigation button
                            Button(action: {
                                if currentIndex < shuffledPhrases.count - 1 {
                                    currentIndex += 1
                                    selectedAnswer = nil
                                    showResult = false
                                } else {
                                    quizFinished = true
                                }
                            }) {
                                Text(currentIndex == shuffledPhrases.count - 1 ? (gameState.selectedLanguage == "fr" ? "Résultats" : "Results") : (gameState.selectedLanguage == "fr" ? "Suivant" : "Next"))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .padding(16)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        RandomQuizView()
            .environmentObject(GameState())
    }
}
