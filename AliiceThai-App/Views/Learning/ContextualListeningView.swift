import SwiftUI

struct ContextualListeningQuestion {
    let id: String
    let phraseThai: String
    let phraseRomanized: String
    let phraseEn: String
    let phraseFr: String
    let correctAnswer: String
    let options: [String]

    static func generateSamples() -> [ContextualListeningQuestion] {
        return [
            ContextualListeningQuestion(
                id: "greeting_1",
                phraseThai: "สวัสดีครับ",
                phraseRomanized: "sawasdee krap",
                phraseEn: "Hello (polite)",
                phraseFr: "Bonjour (poli)",
                correctAnswer: "Greeting",
                options: ["Greeting", "Goodbye", "Thank you", "Sorry"]
            ),
            ContextualListeningQuestion(
                id: "greeting_2",
                phraseThai: "ชื่อฉันคือ...",
                phraseRomanized: "chyue chan khyue...",
                phraseEn: "My name is...",
                phraseFr: "Je m'appelle...",
                correctAnswer: "Introducing yourself",
                options: ["Asking a question", "Introducing yourself", "Ordering food", "Asking directions"]
            ),
            ContextualListeningQuestion(
                id: "food_1",
                phraseThai: "ขอน้ำหนึ่งแก้วครับ",
                phraseRomanized: "kho nam neung gaew krap",
                phraseEn: "One water please",
                phraseFr: "Un verre d'eau s'il vous plaît",
                correctAnswer: "Ordering a drink",
                options: ["Greeting", "Ordering a drink", "Asking price", "Complaining"]
            ),
            ContextualListeningQuestion(
                id: "direction_1",
                phraseThai: "ไปตลาดได้ไหม",
                phraseRomanized: "pai talat dai mai",
                phraseEn: "Can I go to the market",
                phraseFr: "Puis-je aller au marché",
                correctAnswer: "Asking directions",
                options: ["Asking time", "Asking price", "Asking directions", "Ordering food"]
            ),
            ContextualListeningQuestion(
                id: "polite_1",
                phraseThai: "ขอบคุณมากครับ",
                phraseRomanized: "khop khun mak krap",
                phraseEn: "Thank you very much",
                phraseFr: "Merci beaucoup",
                correctAnswer: "Thanking",
                options: ["Apologizing", "Thanking", "Greeting", "Saying goodbye"]
            ),
            ContextualListeningQuestion(
                id: "price_1",
                phraseThai: "เท่าไหร่",
                phraseRomanized: "tao rai",
                phraseEn: "How much",
                phraseFr: "Combien",
                correctAnswer: "Asking price",
                options: ["Asking time", "Asking price", "Asking location", "Asking name"]
            ),
            ContextualListeningQuestion(
                id: "family_1",
                phraseThai: "ครอบครัวของฉัน",
                phraseRomanized: "krob krua khong chan",
                phraseEn: "My family",
                phraseFr: "Ma famille",
                correctAnswer: "Describing family",
                options: ["Describing location", "Describing food", "Describing family", "Describing weather"]
            ),
            ContextualListeningQuestion(
                id: "food_2",
                phraseThai: "ไม่เผ็ด",
                phraseRomanized: "mai ped",
                phraseEn: "Not spicy",
                phraseFr: "Pas épicé",
                correctAnswer: "Ordering food",
                options: ["Ordering food", "Asking time", "Greeting", "Apologizing"]
            )
        ]
    }
}

struct ContextualListeningView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss

    @State var currentQuestion: ContextualListeningQuestion?
    @State var selectedAnswer: String?
    @State var showFeedback = false
    @State var isCorrect = false
    @State var questionIndex = 0
    @State var correctAnswers = 0
    let totalQuestions = 8
    let questions = ContextualListeningQuestion.generateSamples()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.6, blue: 0.4),
                    Color(red: 0.7, green: 0.5, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }

                    VStack(spacing: 0) {
                        Text(localization.localize("contextual.listening.title"))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text("\(questionIndex + 1)/\(totalQuestions)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "house.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.08))

                ScrollView {
                    VStack(spacing: 10) {
                        // Progress
                        ProgressView(value: Double(questionIndex), total: Double(totalQuestions))
                            .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 1.0, green: 0.75, blue: 0.3)))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)

                        // Audio section
                        VStack(spacing: 8) {
                            Text(localization.localize("contextual.listening.instruction"))
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))

                            Button {
                                if let question = currentQuestion {
                                    audioManager.playWord(thaiWord: question.phraseThai)
                                }
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: "speaker.wave.3.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                    Text(localization.localize("contextual.listening.play"))
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                            }

                            if let question = currentQuestion {
                                VStack(spacing: 3) {
                                    // Thai text
                                    Text(question.phraseThai)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)

                                    // Thai romanization
                                    Text(question.phraseRomanized)
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                        .italic()
                                }
                            }
                        }
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(10)

                        // Answer options
                        VStack(spacing: 7) {
                            ForEach(currentQuestion?.options ?? [], id: \.self) { option in
                                AnswerOptionButton(
                                    text: option,
                                    isSelected: selectedAnswer == option,
                                    isCorrect: showFeedback && option == currentQuestion?.correctAnswer,
                                    isWrong: showFeedback && selectedAnswer == option && option != currentQuestion?.correctAnswer
                                ) {
                                    if !showFeedback {
                                        selectedAnswer = option
                                        checkAnswer()
                                    }
                                }
                            }
                        }
                        .padding(10)

                        // Feedback section
                        if showFeedback {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(isCorrect ? .green : .red)

                                    Text(isCorrect ? "Correct!" : "Try again")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isCorrect ? .green : .red)
                                }

                                if !isCorrect, let question = currentQuestion {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(localization.localize("contextual.listening.correct_answer"))
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.7))

                                        Text(question.correctAnswer)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color(red: 1.0, green: 0.75, blue: 0.3).opacity(0.2))
                                            .cornerRadius(6)
                                    }
                                }

                                Button(questionIndex < totalQuestions - 1 ? localization.localize("contextual.listening.next") : localization.localize("contextual.listening.finish")) {
                                    nextQuestion()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                                .foregroundColor(.black)
                                .cornerRadius(6)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            }
                            .padding(10)
                            .background(Color.black.opacity(0.12))
                            .cornerRadius(10)
                        }

                    }
                    .padding(8)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadQuestion()
        }
    }

    func loadQuestion() {
        guard questionIndex < questions.count else { return }
        currentQuestion = questions[questionIndex]
        selectedAnswer = nil
        showFeedback = false
    }

    func checkAnswer() {
        isCorrect = selectedAnswer == currentQuestion?.correctAnswer
        showFeedback = true

        if isCorrect {
            correctAnswers += 1
            gameState.addStar()
        }
    }

    func nextQuestion() {
        questionIndex += 1
        if questionIndex < totalQuestions {
            loadQuestion()
        } else {
            dismiss()
        }
    }
}

struct AnswerOptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(
                    isCorrect ? Color.green.opacity(0.2) :
                    isWrong ? Color.red.opacity(0.2) :
                    isSelected ? Color.cyan.opacity(0.2) :
                    Color.white.opacity(0.1)
                )
                .cornerRadius(6)
        }
        .foregroundColor(
            isCorrect ? .green :
            isWrong ? .red :
            .primary
        )
    }
}

#Preview {
    Text("Preview not available")
}
