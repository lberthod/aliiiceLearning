import SwiftUI

struct ToneQuestion {
    let wordId: String
    let word: String
    let toneMarking: ToneMarking
    let correctTone: String

    static func generate(from toneMarkings: [ToneMarking]) -> ToneQuestion? {
        guard let random = toneMarkings.randomElement() else { return nil }
        return ToneQuestion(
            wordId: random.wordId,
            word: random.thai,
            toneMarking: random,
            correctTone: random.toneName
        )
    }
}

struct ToneDetectionQuizView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss

    let wordId: String?

    @State var currentQuestion: ToneQuestion?
    @State var selectedTone: String?
    @State var showFeedback = false
    @State var isCorrect = false
    @State var questionIndex = 0
    @State var correctAnswers = 0
    let totalQuestions = 10

    var toneMarkings: [ToneMarking] {
        let all = ToneMarkingData.shared.getAllToneMarkings()
        if all.isEmpty {
            print("⚠️  ToneMarkings empty! WordID: \(wordId ?? "none")")
        }
        return all
    }

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
                // Progress bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(localization.localize("tone.detection.question")) \(questionIndex + 1)/\(totalQuestions)")
                            .font(.caption)
                            .foregroundColor(.black)

                        Spacer()

                        Text("\(correctAnswers) \(localization.localize("tone.detection.correct_count"))")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }

                    ProgressView(value: Double(questionIndex), total: Double(totalQuestions))
                        .tint(.cyan)
                }
                .padding()

                // Scrollable content
                ScrollView {
                    if let question = currentQuestion {
                        VStack(spacing: 20) {
                            // Question text
                            VStack(spacing: 12) {
                                Text(question.word)
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color(red: 0.95, green: 0.9, blue: 0.85))
                            .cornerRadius(8)

                            // Play audio button
                            Button {
                                audioManager.playToneVariant(word: question.word, tone: question.correctTone)
                            } label: {
                                HStack {
                                    Image(systemName: "speaker.wave.3.fill")
                                        .font(.system(size: 24))

                                    Text(localization.localize("tone.detection.play_audio"))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 1.0, green: 0.6, blue: 0.2))
                                .cornerRadius(8)
                            }
                            .foregroundColor(.white)

                            // Tone options
                            VStack(spacing: 10) {
                                ForEach(["mid", "low", "falling", "rising", "high"], id: \.self) { tone in
                                    ToneOptionButton(
                                        toneName: tone,
                                        isSelected: selectedTone == tone,
                                        isCorrect: showFeedback && tone == question.correctTone,
                                        isWrong: showFeedback && selectedTone == tone && tone != question.correctTone,
                                        isDisabled: showFeedback
                                    ) {
                                        if !showFeedback {
                                            selectedTone = tone
                                            checkAnswer(userChoice: tone, correctTone: question.correctTone)
                                        }
                                    }
                                }
                            }

                            // Feedback
                            if showFeedback {
                                FeedbackView(
                                    isCorrect: isCorrect,
                                    userChoice: selectedTone ?? "",
                                    correctTone: question.correctTone
                                )

                                Button(questionIndex < totalQuestions - 1 ? localization.localize("tone.detection.next_question") : localization.localize("tone.detection.finish_quiz")) {
                                    nextQuestion()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isCorrect ? Color.green.opacity(0.3) : Color.orange.opacity(0.3))
                                .cornerRadius(8)
                                .foregroundColor(isCorrect ? .green : .orange)
                            }
                        }
                        .padding()
                    } else {
                        Text("Loading...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if currentQuestion == nil {
                loadQuestion()
            }
        }
    }

    func loadQuestion() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentQuestion = ToneQuestion.generate(from: toneMarkings)
            selectedTone = nil
            showFeedback = false
            isCorrect = false
        }
    }

    func checkAnswer(userChoice: String, correctTone: String) {
        isCorrect = userChoice == correctTone
        showFeedback = true

        if isCorrect {
            correctAnswers += 1
            gameState.recordToneAttempt(wordId: currentQuestion?.wordId ?? "", isCorrect: true)
            gameState.addStar()
            audioManager.playCorrectSound()
        } else {
            gameState.recordToneAttempt(wordId: currentQuestion?.wordId ?? "", isCorrect: false)
            audioManager.playWrongSound()
        }
    }

    func nextQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            questionIndex += 1
            if questionIndex < totalQuestions {
                loadQuestion()
            } else {
                dismiss()
            }
        }
    }
}

struct ToneOptionButton: View {
    let toneName: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let isDisabled: Bool
    let action: () -> Void

    var toneVisual: String {
        switch toneName {
        case "mid": return "━━━"
        case "low": return "╲╲╲"
        case "falling": return "╲"
        case "rising": return "╱"
        case "high": return "━"
        default: return ""
        }
    }

    var backgroundColor: Color {
        if isCorrect {
            return Color.green
        } else if isWrong {
            return Color.red
        } else if isSelected {
            return Color(red: 0.2, green: 0.8, blue: 1.0)
        } else {
            return Color(red: 0.95, green: 0.9, blue: 0.85)
        }
    }

    var foregroundColor: Color {
        if isCorrect {
            return .white
        } else if isWrong {
            return .white
        } else if isSelected {
            return .white
        } else {
            return .black
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(toneName.capitalized)
                    .font(.body)
                    .fontWeight(.medium)

                Spacer()

                Text(toneVisual)
                    .font(.system(size: 18))

                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                }

                if isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(8)
        }
        .foregroundColor(foregroundColor)
        .disabled(isDisabled)
        .opacity(isDisabled && !isSelected && !isCorrect && !isWrong ? 0.5 : 1.0)
    }
}

struct FeedbackView: View {
    let isCorrect: Bool
    let userChoice: String
    let correctTone: String
    @ObservedObject var localization = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isCorrect ? .green : .red)

                Text(isCorrect ? localization.localize("tone.detection.correct") : localization.localize("tone.detection.not_quite"))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isCorrect ? .green : .red)

                Spacer()
            }

            if !isCorrect {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(localization.localize("tone.detection.you_selected")) \(userChoice.capitalized)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)

                    Text("\(localization.localize("tone.detection.correct_answer")) \(correctTone.capitalized)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color(red: 1.0, green: 0.6, blue: 0.2))
                        .cornerRadius(4)
                }
            }

            Text(isCorrect ? localization.localize("tone.detection.great_ear") : localization.localize("tone.detection.listen_carefully"))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .italic()
        }
        .padding()
        .background(isCorrect ? Color(red: 0.9, green: 1.0, blue: 0.9) : Color(red: 1.0, green: 0.9, blue: 0.9))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        ToneDetectionQuizView(wordId: "cat")
    }
}
