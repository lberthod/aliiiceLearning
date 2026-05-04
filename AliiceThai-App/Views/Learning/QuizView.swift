import SwiftUI

struct SimpleQuizView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var loc = LocalizationManager.shared
    @State private var selectedAnswer: Word?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var showCelebration = false
    @State private var quizOptions: [Word] = []
    @State private var audioOnCooldown = false
    @State private var deepseekFeedback: String?
    @State private var isLoadingFeedback = false

    var body: some View {
        VStack(spacing: 20) {
            if let word = gameViewModel.currentWord {
                // Question: Show Thai word and ask to identify
                VStack(spacing: 8) {
                    Text(loc.localize("quiz.question"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))

                    VStack(spacing: 3) {
                        Text(word.thai)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Text(word.romanization)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 90)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)

                    Button(action: {
                        if !audioOnCooldown {
                            AudioManager.shared.speakThai(word.thai)
                            audioOnCooldown = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                audioOnCooldown = false
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text("🔊")
                            Text(loc.localize("button.hear"))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.white.opacity(0.25))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .disabled(audioOnCooldown)
                    .opacity(audioOnCooldown ? 0.5 : 1.0)
                }

                // Answer Options (2x2 grid - responsive)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(quizOptions, id: \.id) { option in
                        Button(action: {
                            selectedAnswer = option
                            isCorrect = gameViewModel.isCorrectAnswer(option)
                            showResult = true

                            if isCorrect {
                                gameState.addStar()
                                AudioManager.shared.playCorrectSound()
                                showCelebration = true

                                // Track mission progress if word is in current mission
                                if let currentMission = gameState.currentMission,
                                   currentMission.vocabulary.contains(option.id) {
                                    gameState.recordMissionProgress(missionId: currentMission.id)
                                }
                            } else {
                                AudioManager.shared.playWrongSound()
                                // Fetch Deepseek feedback for wrong answer
                                fetchDeepseekFeedback(
                                    userAnswer: option,
                                    correctAnswer: gameViewModel.currentWord
                                )
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(option.emoji)
                                    .font(.system(size: 50))
                                    .lineLimit(1)

                                Text(gameState.getLocalizedString(option.english, option.french))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                            .frame(minHeight: 100)
                            .background(
                                selectedAnswer?.id == option.id
                                    ? (isCorrect ? Color.green.opacity(0.7) : Color.red.opacity(0.7))
                                    : Color.white.opacity(0.15)
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedAnswer?.id == option.id ? Color.white : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                        }
                        .disabled(showResult)
                    }
                }

                if showResult {
                    VStack(spacing: 12) {
                        if isCorrect {
                            HStack(spacing: 8) {
                                Text(loc.localize("quiz.correct"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.green)
                                Text("⭐")
                                    .font(.system(size: 22))
                                    .scaleEffect(showCelebration ? 1.3 : 1.0)
                            }
                        } else {
                            VStack(spacing: 8) {
                                Text(loc.localize("quiz.incorrect"))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.yellow)
                                Text("\(word.emoji) \(gameState.getLocalizedString(word.english, word.french))")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)

                                // Deepseek Feedback
                                if isLoadingFeedback {
                                    HStack(spacing: 8) {
                                        ProgressView()
                                            .frame(width: 14, height: 14)
                                        Text("Analyzing...")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                } else if let feedback = deepseekFeedback {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("💡 Tip:")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                        Text(feedback)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                                    .background(Color.white.opacity(0.08))
                                    .cornerRadius(6)
                                }
                            }
                        }

                        Button(action: {
                            withAnimation {
                                gameViewModel.nextWord()
                                quizOptions = gameViewModel.generateQuizOptions()
                                selectedAnswer = nil
                                showResult = false
                                isCorrect = false
                                showCelebration = false
                            }
                        }) {
                            Text(isCorrect ? loc.localize("button.nextquestion") + " ➜" : loc.localize("button.trynext") + " ➜")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                                .cornerRadius(10)
                        }
                    }
                    .padding(12)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                }

                Spacer()
            }
        }
        .padding(16)
        .onAppear {
            quizOptions = gameViewModel.generateQuizOptions()
        }
    }

    // MARK: - Deepseek Feedback

    private func fetchDeepseekFeedback(userAnswer: Word, correctAnswer: Word?) {
        guard let correctAnswer = correctAnswer else { return }

        isLoadingFeedback = true
        deepseekFeedback = nil

        Task {
            // Check if userAnswer is a confusable word with correctAnswer
            let isConfusablePair = checkIfConfusablePair(
                userAnswerId: userAnswer.id,
                correctAnswerId: correctAnswer.id
            )

            // Track confusable pair mistake if applicable
            if isConfusablePair {
                let pairId = "\(min(userAnswer.id, correctAnswer.id))_\(max(userAnswer.id, correctAnswer.id))"
                gameState.recordConfusablePairMistake(pairId: pairId)
            }

            let feedback: String?

            if isConfusablePair {
                // Use confusable pair feedback
                feedback = await DeepseekAPI.shared.getConfusablePairFeedback(
                    word1: correctAnswer.thai,
                    word2: userAnswer.thai,
                    translation1: gameState.getLocalizedString(correctAnswer.english, correctAnswer.french),
                    translation2: gameState.getLocalizedString(userAnswer.english, userAnswer.french)
                )
            } else {
                // Use regular wrong answer feedback
                feedback = await DeepseekAPI.shared.getWrongAnswerFeedback(
                    question: "Quel est le sens du mot: \(correctAnswer.thai) (\(correctAnswer.romanization))?",
                    userAnswer: gameState.getLocalizedString(userAnswer.english, userAnswer.french),
                    correctAnswer: gameState.getLocalizedString(correctAnswer.english, correctAnswer.french),
                    context: ""
                )
            }

            DispatchQueue.main.async {
                deepseekFeedback = feedback ?? "Essaie encore! La bonne réponse est affichée ci-dessus."
                isLoadingFeedback = false
            }
        }
    }

    private func checkIfConfusablePair(userAnswerId: String, correctAnswerId: String) -> Bool {
        // Get wrapped words to check confusable_with relationship
        guard let correctWordWrapped = gameViewModel.wrappedWords.first(where: { $0.id == correctAnswerId }) else {
            return false
        }

        // Check if userAnswerId is in the confusable_with list
        return correctWordWrapped.relations.confusable_with.contains { $0.id == userAnswerId }
    }
}

#Preview {
    SimpleQuizView()
        .environmentObject(GameState())
        .environmentObject(GameViewModel())
        .background(Color.blue)
}
