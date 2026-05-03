import SwiftUI

struct NumbersQuizView: View {
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @State private var quizNumbers: [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] = []
    @State private var currentIndex = 0
    @State private var quizOptions: [Int] = []
    @State private var selectedAnswer: Int?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var showCelebration = false
    @State private var audioOnCooldown = false

    var currentNumber: (number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)? {
        guard currentIndex < quizNumbers.count else { return nil }
        return quizNumbers[currentIndex]
    }

    var body: some View {
        VStack(spacing: 20) {
            if let number = currentNumber {
                // Question: Show Thai number and ask to identify
                VStack(spacing: 8) {
                    Text(loc.localize("numbers.quiz.question"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))

                    VStack(spacing: 3) {
                        Text(number.thai)
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Text(number.romanization)
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
                            AudioManager.shared.speakThai(number.thai)
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

                // Answer Options (2x2 grid)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(quizOptions, id: \.self) { option in
                        Button(action: {
                            selectedAnswer = option
                            isCorrect = (option == number.number)
                            showResult = true

                            if isCorrect {
                                gameState.addStar()
                                AudioManager.shared.playCorrectSound()
                                showCelebration = true
                            } else {
                                AudioManager.shared.playWrongSound()
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(String(option))
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)

                                Text(getLocalizedNumber(option))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                            .frame(minHeight: 100)
                            .background(
                                selectedAnswer == option
                                    ? (isCorrect ? Color.green.opacity(0.7) : Color.red.opacity(0.7))
                                    : Color.white.opacity(0.15)
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedAnswer == option ? Color.white : Color.clear,
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
                                Text(loc.localize("numbers.quiz.correct"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.green)
                                Text("⭐")
                                    .font(.system(size: 22))
                                    .scaleEffect(showCelebration ? 1.3 : 1.0)
                            }
                        } else {
                            VStack(spacing: 4) {
                                Text(loc.localize("numbers.quiz.incorrect"))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.yellow)
                                Text("\(loc.localize("numbers.quiz.answer")) \(number.number) - \(getLocalizedNumber(number.number))")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }

                        Button(action: {
                            withAnimation {
                                currentIndex += 1
                                if currentIndex >= quizNumbers.count {
                                    currentIndex = 0
                                    quizNumbers.shuffle()
                                }
                                quizOptions = generateQuizOptions()
                                selectedAnswer = nil
                                showResult = false
                                isCorrect = false
                                showCelebration = false
                            }
                        }) {
                            Text(isCorrect ? loc.localize("numbers.quiz.nextquestion") : loc.localize("numbers.quiz.trynext"))
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
            quizNumbers = NumbersDataGenerator.generateQuizNumbers()
            quizOptions = generateQuizOptions()
        }
    }

    private func generateQuizOptions() -> [Int] {
        guard let current = currentNumber else { return [] }

        var options: Set<Int> = [current.number]
        let allNumbers = quizNumbers.map { $0.number }

        while options.count < 4 {
            if let random = allNumbers.randomElement() {
                options.insert(random)
            }
        }

        return Array(options).shuffled()
    }

    private func getLocalizedNumber(_ num: Int) -> String {
        if let quizNum = quizNumbers.first(where: { $0.number == num }) {
            return gameState.selectedLanguage == "fr" ? quizNum.french : quizNum.english
        }
        return ""
    }
}

#Preview {
    NumbersQuizView()
        .environmentObject(GameState())
}
