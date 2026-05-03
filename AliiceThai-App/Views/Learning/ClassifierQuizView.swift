import SwiftUI

struct ClassifierQuizView: View {
    let question: ClassifierQuestion?
    let classifier: ClassifierLesson?
    let questionNumber: Int
    let totalQuestions: Int
    let onAnswer: (Bool) -> Void
    let onFinish: (() -> Void)?

    @ObservedObject var gameState = GameState.shared
    @ObservedObject var gameViewModel = GameViewModel.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var quizQuestions: [ClassifierQuestion] = []
    @State private var currentIndex = 0
    @Environment(\.dismiss) private var dismiss

    init(
        question: ClassifierQuestion? = nil,
        classifier: ClassifierLesson? = nil,
        questionNumber: Int = 1,
        totalQuestions: Int = 10,
        onAnswer: @escaping (Bool) -> Void,
        onFinish: (() -> Void)? = nil
    ) {
        self.question = question
        self.classifier = classifier
        self.questionNumber = questionNumber
        self.totalQuestions = totalQuestions
        self.onAnswer = onAnswer
        self.onFinish = onFinish
    }

    var currentQuestion: ClassifierQuestion? {
        if let question = question {
            return question
        } else if !quizQuestions.isEmpty && currentIndex < quizQuestions.count {
            return quizQuestions[currentIndex]
        }
        return nil
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
                ProgressView(value: Double(questionNumber) / Double(totalQuestions))
                    .tint(.cyan)
                    .frame(height: 4)

                ScrollView {
                    VStack(spacing: 24) {
                        // Question counter
                        HStack {
                            Text("\(localization.localize("classifier.quiz.question")) \(questionNumber)/\(totalQuestions)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                        if let question = currentQuestion {
                            // Question section
                            VStack(alignment: .leading, spacing: 12) {
                                Text(localization.localize("classifier.quiz.select_classifier"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))

                                // Number + ??? + Noun
                                HStack(spacing: 8) {
                                    Text(question.numberThai)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)

                                    Text("???")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)

                                    Text(question.nounThai)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)

                                    Spacer()
                                }
                                .padding(16)
                                .background(Color.black.opacity(0.15))
                                .cornerRadius(12)

                                // English translation
                                Text(localization.currentLanguage == "fr" ?
                                     "\(question.numberEnglish) \(question.nounFrench)" :
                                     "\(question.numberEnglish) \(question.nounEnglish)"
                                )
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(16)
                            .background(Color.black.opacity(0.12))
                            .cornerRadius(12)

                            // Answer options
                            VStack(spacing: 12) {
                                ForEach(question.options, id: \.self) { option in
                                    AnswerButton(
                                        text: option,
                                        isSelected: selectedAnswer == option,
                                        isCorrect: showResult && option == question.correctClassifier,
                                        isIncorrect: showResult && selectedAnswer == option && option != question.correctClassifier,
                                        action: {
                                            if !showResult {
                                                selectedAnswer = option
                                                checkAnswer(option, correctAnswer: question.correctClassifier)
                                                showResult = true
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(16)

                            // Result feedback
                            if showResult {
                                ResultFeedbackView(
                                    isCorrect: isCorrect,
                                    correctAnswer: question.correctClassifier,
                                    explanation: question.explanation
                                )
                                .padding(16)

                                // Next button
                                Button(action: proceedToNext) {
                                    HStack {
                                        Spacer()
                                        Text(currentIndex >= totalQuestions - 1 ?
                                             localization.localize("classifier.quiz.finish") :
                                             localization.localize("classifier.quiz.next")
                                        )
                                        .font(.headline)
                                        Image(systemName: "chevron.right")
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.8))
                                    .cornerRadius(8)
                                    .fontWeight(.semibold)
                                }
                                .padding(16)
                            }
                        }

                        Spacer()
                    }
                }
            }
       
.navigationBarBackButtonHidden(true)
        }
        .onAppear {
            if question == nil && classifier != nil {
                // Generate questions for specific classifier if needed
                loadQuizForClassifier()
            }
        }
    }

    private func checkAnswer(_ answer: String, correctAnswer: String) {
        isCorrect = answer == correctAnswer
        if isCorrect {
            AudioManager.shared.playCelebrationSound()
            gameState.addStar()
        } else {
            AudioManager.shared.playWrongSound()
        }

        // Track classifier-specific mastery
        if let question = currentQuestion {
            gameState.recordClassifierAttempt(classifierId: question.correctClassifierId, isCorrect: isCorrect)
        }

        onAnswer(isCorrect)
    }

    private func proceedToNext() {
        if currentIndex < totalQuestions - 1 {
            currentIndex += 1
            selectedAnswer = nil
            showResult = false
            isCorrect = false
        } else {
            onFinish?()
        }
    }

    private func loadQuizForClassifier() {
        if let classifier = classifier {
            let wrappedWords = JSONWordParser.shared.getAllWords()
                .filter { $0.linguistic.classifier == classifier.id }
            let classifiersData = ClassifiersData.shared
            quizQuestions = classifiersData.generateQuestions(count: 10, from: wrappedWords)
        }
    }
}

// MARK: - Answer Button Component

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isIncorrect: Bool
    let action: () -> Void

    private var textColor: Color {
        if isCorrect { return .green }
        if isIncorrect { return .red }
        if isSelected { return Color(red: 0.2, green: 0.6, blue: 0.8) }
        return .white
    }

    private var backgroundColor: Color {
        if isCorrect { return Color.green.opacity(0.2) }
        if isIncorrect { return Color.red.opacity(0.2) }
        if isSelected { return Color.blue.opacity(0.15) }
        return Color.black.opacity(0.12)
    }

    private var borderColor: Color {
        if isCorrect { return Color.green.opacity(0.5) }
        if isIncorrect { return Color.red.opacity(0.5) }
        if isSelected { return Color.blue.opacity(0.4) }
        return Color.black.opacity(0.2)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(text)
                    .font(.headline)
                    .foregroundColor(textColor)

                Spacer()

                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if isIncorrect {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                } else if isSelected {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.cyan)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Result Feedback Component

struct ResultFeedbackView: View {
    let isCorrect: Bool
    let correctAnswer: String
    let explanation: String

    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isCorrect {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.headline)

                    Text(localization.localize("classifier.quiz.correct"))
                        .font(.headline)
                        .foregroundColor(.green)

                    Spacer()
                }
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.headline)

                        Text(localization.localize("classifier.quiz.incorrect"))
                            .font(.headline)
                            .foregroundColor(.red)

                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(localization.localize("classifier.quiz.correct_answer"))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))

                        Text(correctAnswer)
                            .font(.headline)
                            .foregroundColor(.green)

                        Text(explanation)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(4)
                    }
                }
            }
        }
        .padding(14)
        .background(
            isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15)
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    isCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.3),
                    lineWidth: 1.5
                )
        )
    }
}

#Preview {
    NavigationStack {
        ClassifierQuizView(
            question: ClassifierQuestion(
                id: UUID(),
                numberThai: "สอง",
                numberEnglish: "2",
                nounThai: "แมว",
                nounEnglish: "cats",
                nounFrench: "chats",
                correctClassifier: "ตัว",
                correctClassifierId: "tua",
                correctClassifierThai: "ตัว",
                options: ["ตัว", "คน", "เล่ม", "ใบ"],
                optionsThai: ["ตัว", "คน", "เล่ม", "ใบ"],
                explanation: "ตัว is used for animals"
            ),
            questionNumber: 1,
            totalQuestions: 10,
            onAnswer: { _ in }
        )
    }
}
