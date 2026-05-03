import SwiftUI

struct ClassifiersView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var gameViewModel = GameViewModel.shared
    @ObservedObject var classifiersData = ClassifiersData.shared
    @ObservedObject var localization = LocalizationManager.shared

    @State private var selectedMode: ClassifierMode = .lists
    @State private var isLoading = true

    enum ClassifierMode {
        case principles
        case lists
        case quiz
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
                HeaderView(
                    title: localization.localize("classifier.mastery.title"),
                    subtitle: localization.localize("classifier.mastery.subtitle"),
                    showBackButton: true,
                    showHomeButton: true
                )

                HStack(spacing: 12) {
                    ModeTab(label: localization.localize("classifier.lesson"), labelFr: localization.localize("classifier.lesson"), isSelected: selectedMode == .principles, action: { selectedMode = .principles })
                    ModeTab(label: localization.localize("classifier.lesson"), labelFr: localization.localize("classifier.lesson"), isSelected: selectedMode == .lists, action: { selectedMode = .lists })
                    ModeTab(label: localization.localize("classifier.quiz"), labelFr: localization.localize("classifier.quiz"), isSelected: selectedMode == .quiz, action: { selectedMode = .quiz })
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                if isLoading {
                    VStack {
                        ProgressView().scaleEffect(1.5).tint(.white)
                        Text(localization.localize("classifier.lesson_list.loading")).font(.caption).foregroundColor(.white)
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                } else {
                    Group {
                        if selectedMode == .principles {
                            PrinciplesView()
                        } else if selectedMode == .lists {
                            ClassifiersListsView(classifiers: classifiersData.getAllClassifiers())
                        } else {
                            ClassifierQuizContainerView()
                        }
                    }
                }

                Spacer()
            }
        
        .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            DispatchQueue.main.async {
                loadClassifiers()
            }
        }
    }

    private func loadClassifiers() {
        if let wrappedWords = JSONWordParser.shared.loadWordsFromJSON() {
            classifiersData.buildFromWrappedWords(wrappedWords)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isLoading = false
            }
        } else {
            print("❌ Failed to load wrapped words")
            isLoading = false
        }
    }
}

struct ModeTab: View {
    let label: String
    let labelFr: String
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject var gameState = GameState.shared

    var body: some View {
        Button(action: action) {
            Text(gameState.selectedLanguage == "fr" ? labelFr : label)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

struct PrinciplesView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "book.fill").foregroundColor(.yellow)
                            Text(localization.localize("classifier.principle.what_is")).font(.headline).foregroundColor(.yellow)
                        }
                        Text(localization.localize("classifier.principle.what_is_desc")).font(.body).foregroundColor(.white)
                    }.padding(14).background(Color.black.opacity(0.12)).cornerRadius(10)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill").foregroundColor(.orange)
                            Text(localization.localize("classifier.principle.why_use")).font(.headline).foregroundColor(.orange)
                        }
                        Text(localization.localize("classifier.principle.why_use_desc")).font(.body).foregroundColor(.white)
                    }.padding(14).background(Color.black.opacity(0.12)).cornerRadius(10)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles").foregroundColor(.cyan)
                            Text(localization.localize("classifier.principle.examples")).font(.headline).foregroundColor(.cyan)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            ClassifierPrincipleExample(thai: "หนึ่งตัวแมว", classifier: "ตัว", meaning: localization.currentLanguage == "fr" ? "1 chat" : "1 cat", explanation: localization.localize("classifier.principle.example_animals"))
                            ClassifierPrincipleExample(thai: "สองคนคน", classifier: "คน", meaning: localization.currentLanguage == "fr" ? "2 personnes" : "2 people", explanation: localization.localize("classifier.principle.example_people"))
                            ClassifierPrincipleExample(thai: "สามเล่มหนังสือ", classifier: "เล่ม", meaning: localization.currentLanguage == "fr" ? "3 livres" : "3 books", explanation: localization.localize("classifier.principle.example_bound"))
                        }
                    }.padding(14).background(Color.black.opacity(0.12)).cornerRadius(10)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            Text(localization.localize("classifier.principle.key_point")).font(.headline).foregroundColor(.green)
                        }
                        Text(localization.localize("classifier.principle.essential")).font(.body).foregroundColor(.white).fontWeight(.semibold)
                    }.padding(14).background(Color.green.opacity(0.1)).cornerRadius(10)
                }
                .padding(16).background(Color.black.opacity(0.08)).cornerRadius(14)
            }
            .padding(.horizontal, 16).padding(.vertical, 12)
        }
    }
}

struct ClassifierPrincipleExample: View {
    let thai: String
    let classifier: String
    let meaning: String
    let explanation: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Text(thai).font(.headline).foregroundColor(.white)
                Button(action: { AudioManager.shared.speakThai(thai) }) {
                    Image(systemName: "speaker.wave.2.fill").foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0)).padding(6).background(Color.black.opacity(0.2)).cornerRadius(6)
                }
            }
            HStack(spacing: 12) {
                Text("[\(classifier)]").font(.caption).foregroundColor(.yellow).fontWeight(.semibold)
                Text(meaning).font(.caption).foregroundColor(.white.opacity(0.8))
            }
            Text(explanation).font(.caption2).foregroundColor(.white.opacity(0.7))
        }
        .padding(10).background(Color.white.opacity(0.05)).cornerRadius(8)
    }
}

struct LearningModeView: View {
    let classifiers: [ClassifierLesson]
    @ObservedObject var gameState = GameState.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(classifiers) { classifier in
                    NavigationLink(destination: ClassifierLessonView(classifier: classifier)) {
                        VStack(alignment: .leading, spacing: 16) {
                            // Header: Thai + Romanized
                            VStack(alignment: .leading, spacing: 6) {
                                Text(classifier.thai)
                                    .font(.system(size: 56, weight: .bold))
                                    .foregroundColor(.white)

                                Text(classifier.englishName)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                            }

                            Divider().background(Color.white.opacity(0.2))

                            // Definition
                            Text(gameState.selectedLanguage == "fr" ? classifier.frenchExplanation : classifier.explanation)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.85))

                            // Real Examples from Dataset
                            VStack(alignment: .leading, spacing: 10) {
                                Label("Examples from vocabulary", systemImage: "book.fill")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.7))

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(Array(classifier.examples.prefix(3)), id: \.id) { example in
                                        HStack(alignment: .top, spacing: 12) {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(example.thai)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)

                                                Text(example.romanization)
                                                    .font(.caption2)
                                                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                                            }

                                            Spacer()

                                            VStack(alignment: .trailing, spacing: 2) {
                                                Text(gameState.selectedLanguage == "fr" ? example.french : example.english)
                                                    .font(.caption)
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                        }
                                        .padding(8)
                                        .background(Color.black.opacity(0.15))
                                        .cornerRadius(6)
                                    }
                                }
                            }

                            HStack {
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding(16)
                        .background(Color.black.opacity(0.25))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

struct ClassifierCardView: View {
    let classifier: ClassifierLesson
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Thai + Romanization Header
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(classifier.thai)
                            .font(.system(size: 44, weight: .bold))
                            .foregroundColor(.white)
                        Text(classifier.id)
                            .font(.caption)
                            .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                            .fontDesign(.monospaced)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.title3)
                }
            }

            Divider().background(Color.white.opacity(0.2))

            // Definition in user's language
            VStack(alignment: .leading, spacing: 8) {
                Text(gameState.selectedLanguage == "fr" ? classifier.frenchName : classifier.englishName)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(gameState.selectedLanguage == "fr" ? classifier.frenchExplanation : classifier.explanation)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)
            }

            // Usage Categories
            VStack(alignment: .leading, spacing: 6) {
                Label(
                    localization.localize("classifier.lesson.used_for"),
                    systemImage: "tag.fill"
                )
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(classifier.uses.prefix(3)), id: \.self) { use in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(red: 0.3, green: 0.7, blue: 1.0))
                                .frame(width: 4, height: 4)
                            Text(use)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.25))
        .cornerRadius(12)
    }
}

struct ClassifierQuizContainerView: View {
    @ObservedObject var gameViewModel: GameViewModel = GameViewModel.shared
    @ObservedObject var classifiersData: ClassifiersData = ClassifiersData.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var quizQuestions: [ClassifierQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var isQuizActive = false
    @State private var correctCount = 0
    @State private var incorrectCount = 0

    var body: some View {
        if !isQuizActive {
            VStack(spacing: 20) {
                Spacer()
                VStack(alignment: .leading, spacing: 12) {
                    Text(localization.localize("classifier.action.ready_to_practice")).font(.headline).foregroundColor(.white)
                    Text(localization.localize("classifier.action.ready_description")).font(.body).foregroundColor(.white.opacity(0.9))
                }
                .padding(16).background(Color.white.opacity(0.1)).cornerRadius(12)
                Button(action: startQuiz) {
                    Text(localization.localize("classifier.action.start_quiz")).font(.headline).foregroundColor(Color(red: 0.8, green: 0.6, blue: 0.4)).frame(maxWidth: .infinity).padding(12).background(Color.white.opacity(0.9)).cornerRadius(8).fontWeight(.semibold)
                }
                Spacer()
            }
            .padding(16)
        } else if !quizQuestions.isEmpty && currentQuestionIndex < quizQuestions.count {
            ClassifierQuizView(
                question: quizQuestions[currentQuestionIndex],
                questionNumber: currentQuestionIndex + 1,
                totalQuestions: quizQuestions.count,
                onAnswer: { isCorrect in
                    if isCorrect {
                        correctCount += 1
                    } else {
                        incorrectCount += 1
                    }
                    moveToNextQuestion()
                },
                onFinish: { endQuiz() }
            )
        } else {
            QuizFinishView(
                totalQuestions: quizQuestions.count,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                onRetry: { startQuiz() },
                onExit: { isQuizActive = false }
            )
        }
    }

    private func startQuiz() {
        quizQuestions = classifiersData.generateQuestions(count: 10, from: gameViewModel.wrappedWords)
        currentQuestionIndex = 0
        isQuizActive = true
        correctCount = 0
        incorrectCount = 0
    }

    private func moveToNextQuestion() {
        currentQuestionIndex += 1
    }

    private func endQuiz() {
        isQuizActive = false
        currentQuestionIndex = 0
    }
}

struct QuizFinishView: View {
    let totalQuestions: Int
    let correctCount: Int
    let incorrectCount: Int
    let onRetry: () -> Void
    let onExit: () -> Void
    @ObservedObject var gameState = GameState.shared

    var accuracyPercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return (correctCount * 100) / totalQuestions
    }

    var body: some View {
        let localization = LocalizationManager.shared
        return VStack(spacing: 20) {
            Spacer()
            VStack(spacing: 20) {
                Text(localization.localize("classifier.results.complete")).font(.title).fontWeight(.bold).foregroundColor(.white)
                QuizScoreView(correctCount: correctCount, incorrectCount: incorrectCount, totalQuestions: totalQuestions, accuracyPercentage: accuracyPercentage)
                QuizActionButtonsView(onRetry: onRetry, onExit: onExit)
            }
            .padding(20).background(Color.white.opacity(0.1)).cornerRadius(16)
            Spacer()
        }
        .padding(16)
    }
}

// MARK: - Quiz Score View
struct QuizScoreView: View {
    let correctCount: Int
    let incorrectCount: Int
    let totalQuestions: Int
    let accuracyPercentage: Int
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared

    var body: some View {
        VStack(spacing: 16) {
            // Accuracy Percentage
            VStack(spacing: 8) {
                Text(localization.localize("classifier.results.accuracy"))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text("\(accuracyPercentage)%")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                ProgressView(value: Double(correctCount) / Double(totalQuestions))
                    .tint(.green)
                    .frame(height: 6)
            }
            .padding(16)
            .background(Color.black.opacity(0.15))
            .cornerRadius(12)

            // Correct and Incorrect
            HStack(spacing: 12) {
                QuizScoreCard(icon: "checkmark.circle.fill", label: "Correct", value: correctCount, color: .green)
                QuizScoreCard(icon: "xmark.circle.fill", label: "Incorrect", value: incorrectCount, color: .red)
            }

            // Total Questions
            HStack {
                Text(localization.localize("classifier.results.total_questions"))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                Text("\(totalQuestions)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(12)
            .background(Color.black.opacity(0.12))
            .cornerRadius(8)
        }
    }
}

// MARK: - Quiz Score Card
struct QuizScoreCard: View {
    let icon: String
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(label)
                    .font(.caption)
                    .foregroundColor(color)
            }
            Text("\(value)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(color.opacity(0.15))
        .cornerRadius(10)
    }
}

// MARK: - Quiz Action Buttons
struct QuizActionButtonsView: View {
    let onRetry: () -> Void
    let onExit: () -> Void
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onRetry) {
                Text(localization.localize("classifier.action.try_again"))
                    .font(.headline)
                    .foregroundColor(Color(red: 0.8, green: 0.6, blue: 0.4))
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(8)
                    .fontWeight(.semibold)
            }
            Button(action: onExit) {
                Text(localization.localize("classifier.action.back"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(8)
                    .fontWeight(.semibold)
            }
        }
    }
}

// MARK: - Classifiers Lists View (Organized by Level)
struct ClassifiersListsView: View {
    let classifiers: [ClassifierLesson]
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared

    var essentialClassifiers: [ClassifierLesson] {
        classifiers.filter { $0.level == .essential }
    }

    var importantClassifiers: [ClassifierLesson] {
        classifiers.filter { $0.level == .important }
    }

    var advancedClassifiers: [ClassifierLesson] {
        classifiers.filter { $0.level == .advanced }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Essential Level
                ClassifierLevelSection(
                    title: localization.localize("classifier.level.essential"),
                    subtitle: localization.localize("classifier.level.essential_desc"),
                    color: Color(red: 1.0, green: 0.4, blue: 0.2),
                    classifiers: essentialClassifiers,
                    gameState: gameState
                )

                // Important Level
                ClassifierLevelSection(
                    title: localization.localize("classifier.level.important"),
                    subtitle: localization.localize("classifier.level.important_desc"),
                    color: Color(red: 1.0, green: 0.8, blue: 0.2),
                    classifiers: importantClassifiers,
                    gameState: gameState
                )

                // Advanced Level
                ClassifierLevelSection(
                    title: localization.localize("classifier.level.advanced"),
                    subtitle: localization.localize("classifier.level.advanced_desc"),
                    color: Color(red: 0.5, green: 0.8, blue: 1.0),
                    classifiers: advancedClassifiers,
                    gameState: gameState
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Classifier Level Section
struct ClassifierLevelSection: View {
    let title: String
    let subtitle: String
    let color: Color
    let classifiers: [ClassifierLesson]
    @ObservedObject var gameState: GameState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Circle().fill(color).frame(width: 12, height: 12)
                    Text(title)
                        .font(.headline)
                        .foregroundColor(color)
                    Spacer()
                    Text("(\(classifiers.count))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(12)
            .background(Color.black.opacity(0.15))
            .cornerRadius(10)

            VStack(spacing: 10) {
                ForEach(classifiers) { classifier in
                    NavigationLink(destination: ClassifierLessonView(classifier: classifier)) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Text(classifier.thai)
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)

                                        Button(action: {
                                            AudioManager.shared.speakThai(classifier.thai)
                                        }) {
                                            Image(systemName: "speaker.wave.2.fill")
                                                .font(.caption)
                                                .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                                                .padding(4)
                                        }
                                    }

                                    Text(classifier.romanization)
                                        .font(.caption2)
                                        .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))

                                    Text(gameState.selectedLanguage == "fr" ? classifier.frenchName : classifier.englishName)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.4))
                            }

                            Text(gameState.selectedLanguage == "fr" ? classifier.frenchExplanation : classifier.explanation)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.75))
                                .lineLimit(2)
                        }
                        .padding(12)
                        .background(Color(color).opacity(0.08))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.1))
        .cornerRadius(14)
    }
}
