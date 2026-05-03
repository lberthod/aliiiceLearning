import SwiftUI

struct AlphabetGameView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.presentationMode) var presentationMode

    private let roundSize = 10

    @State private var questionNumber = 1
    @State private var score = 0
    @State private var streak = 0
    @State private var bestStreak = 0
    @State private var currentQuestion = ThaiAlphabetQuestion.make(from: thaiAlphabet)
    @State private var selectedOption: ThaiAlphabetItem?
    @State private var missedLetters: [ThaiAlphabetItem] = []
    @State private var isFinished = false
    @State private var audioOnCooldown = false

    private var isFrench: Bool {
        gameState.selectedLanguage == "fr"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.12, green: 0.33, blue: 0.56), Color(red: 0.87, green: 0.46, blue: 0.27)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if isFinished {
                    resultView
                } else {
                    gameView
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            speakCurrentLetter()
        }
    }

    private var header: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 46, height: 46)
                    .background(Color.white.opacity(0.18))
                    .cornerRadius(10)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(isFrench ? "Jeu alphabet" : "Alphabet Game")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text(isFrench ? "Reconnais vite la bonne lettre" : "Recognize the right letter fast")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.78))
            }

            Spacer()
        }
        .padding(20)
    }

    private var gameView: some View {
        VStack(spacing: 18) {
            progressBar

            VStack(spacing: 10) {
                Text(isFrench ? "Quelle lettre fait ce son ?" : "Which letter makes this sound?")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.82))

                Text(currentQuestion.prompt.name)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)

                HStack(spacing: 8) {
                    Text(currentQuestion.prompt.romanization.isEmpty ? "o" : currentQuestion.prompt.romanization)
                        .font(.system(size: 15, weight: .bold))
                    Text("•")
                    Text(localizedClass(currentQuestion.prompt.consonantClass))
                        .font(.system(size: 15, weight: .semibold))
                    Text("•")
                    Text(currentQuestion.prompt.cue)
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(1)
                }
                .foregroundColor(.white.opacity(0.78))

                Button(action: speakCurrentLetter) {
                    Label(isFrench ? "Réécouter" : "Hear again", systemImage: "speaker.wave.2.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white.opacity(0.18))
                        .cornerRadius(12)
                }
                .disabled(audioOnCooldown)
                .opacity(audioOnCooldown ? 0.55 : 1)
            }
            .padding(18)
            .background(Color.black.opacity(0.18))
            .cornerRadius(14)
            .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(currentQuestion.options) { option in
                    Button(action: { choose(option) }) {
                        VStack(spacing: 8) {
                            Text(option.letter)
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                                .frame(height: 58)

                            Text(option.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.84))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 128)
                        .background(optionBackground(option))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(optionBorder(option), lineWidth: 2)
                        )
                    }
                    .disabled(selectedOption != nil)
                }
            }
            .padding(.horizontal, 16)

            feedbackView

            Spacer(minLength: 10)
        }
    }

    private var progressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(questionNumber)/\(roundSize)")
                Spacer()
                Text(isFrench ? "Score \(score)" : "Score \(score)")
                Spacer()
                Text(isFrench ? "Combo \(streak)" : "Streak \(streak)")
            }
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(.white.opacity(0.86))

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.18))
                    Capsule()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * CGFloat(questionNumber - 1) / CGFloat(roundSize))
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var feedbackView: some View {
        if let selectedOption = selectedOption {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: isCorrectSelection(selectedOption) ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 22, weight: .bold))
                    Text(feedbackTitle(for: selectedOption))
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(isCorrectSelection(selectedOption) ? .green : .yellow)

                if !isCorrectSelection(selectedOption) {
                    Text("\(currentQuestion.prompt.letter)  \(currentQuestion.prompt.name)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }

                Button(action: nextQuestion) {
                    Text(questionNumber == roundSize ? (isFrench ? "Voir le résultat" : "See results") : (isFrench ? "Question suivante" : "Next question"))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(red: 0.16, green: 0.64, blue: 0.38))
                        .cornerRadius(12)
                }
            }
            .padding(16)
            .background(Color.black.opacity(0.24))
            .cornerRadius(14)
            .padding(.horizontal, 16)
        }
    }

    private var resultView: some View {
        VStack(spacing: 18) {
            Spacer()

            Text(score >= 8 ? "ก" : "อ")
                .font(.system(size: 82, weight: .bold))
                .foregroundColor(.white)

            Text(isFrench ? "Session terminée" : "Round complete")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)

            Text(isFrench ? "\(score) bonnes réponses sur \(roundSize)" : "\(score) correct out of \(roundSize)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.82))

            HStack(spacing: 12) {
                statTile(title: isFrench ? "Meilleur combo" : "Best streak", value: "\(bestStreak)")
                statTile(title: isFrench ? "À revoir" : "Review", value: "\(Set(missedLetters.map(\.letter)).count)")
            }
            .padding(.horizontal, 16)

            if !missedLetters.isEmpty {
                missedLettersView
            }

            Button(action: restart) {
                Label(isFrench ? "Rejouer 10 lettres" : "Play 10 more", systemImage: "arrow.clockwise")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(red: 0.16, green: 0.64, blue: 0.38))
                    .cornerRadius(13)
            }
            .padding(.horizontal, 16)

            Spacer()
        }
    }

    private var missedLettersView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(isFrench ? "Mini-révision" : "Quick review")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)

            ForEach(Array(Set(missedLetters)).prefix(4)) { item in
                HStack {
                    Text(item.letter)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 42)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Text("\(item.romanization) • \(localizedClass(item.consonantClass))")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.2))
        .cornerRadius(14)
        .padding(.horizontal, 16)
    }

    private func statTile(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.74))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.16))
        .cornerRadius(12)
    }

    private func choose(_ option: ThaiAlphabetItem) {
        selectedOption = option

        if option == currentQuestion.prompt {
            score += 1
            streak += 1
            bestStreak = max(bestStreak, streak)
            gameState.addStar()
            AudioManager.shared.playCorrectSound()
        } else {
            streak = 0
            missedLetters.append(currentQuestion.prompt)
            AudioManager.shared.playWrongSound()
        }
    }

    private func nextQuestion() {
        if questionNumber == roundSize {
            isFinished = true
            return
        }

        questionNumber += 1
        selectedOption = nil
        currentQuestion = ThaiAlphabetQuestion.make(from: thaiAlphabet, reviewPool: missedLetters)
        speakCurrentLetter()
    }

    private func restart() {
        questionNumber = 1
        score = 0
        streak = 0
        bestStreak = 0
        missedLetters = []
        selectedOption = nil
        isFinished = false
        currentQuestion = ThaiAlphabetQuestion.make(from: thaiAlphabet)
        speakCurrentLetter()
    }

    private func speakCurrentLetter() {
        guard !audioOnCooldown else { return }

        AudioManager.shared.speakThai(currentQuestion.prompt.letter)
        audioOnCooldown = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            audioOnCooldown = false
        }
    }

    private func optionBackground(_ option: ThaiAlphabetItem) -> Color {
        guard let selectedOption else {
            return Color.white.opacity(0.16)
        }

        if option == currentQuestion.prompt {
            return Color.green.opacity(0.62)
        }

        if option == selectedOption {
            return Color.red.opacity(0.62)
        }

        return Color.white.opacity(0.12)
    }

    private func optionBorder(_ option: ThaiAlphabetItem) -> Color {
        guard selectedOption != nil else {
            return Color.white.opacity(0.12)
        }

        return option == currentQuestion.prompt ? Color.white : Color.clear
    }

    private func isCorrectSelection(_ option: ThaiAlphabetItem) -> Bool {
        option == currentQuestion.prompt
    }

    private func feedbackTitle(for option: ThaiAlphabetItem) -> String {
        if isCorrectSelection(option) {
            return isFrench ? "Bien joué, tu l'as reconnue." : "Nice, you recognized it."
        }

        return isFrench ? "Presque. La bonne réponse était :" : "Almost. The correct answer was:"
    }

    private func localizedClass(_ consonantClass: String) -> String {
        guard isFrench else { return "\(consonantClass) class" }

        switch consonantClass {
        case "High": return "classe haute"
        case "Mid": return "classe moyenne"
        default: return "classe basse"
        }
    }
}

private struct ThaiAlphabetQuestion {
    let prompt: ThaiAlphabetItem
    let options: [ThaiAlphabetItem]

    static func make(from alphabet: [ThaiAlphabetItem], reviewPool: [ThaiAlphabetItem] = []) -> ThaiAlphabetQuestion {
        let shouldReviewMiss = !reviewPool.isEmpty && Int.random(in: 0..<100) < 45
        let prompt = shouldReviewMiss ? reviewPool.randomElement()! : alphabet.randomElement()!

        let similarLetters = alphabet.filter {
            $0 != prompt && ($0.romanization == prompt.romanization || $0.consonantClass == prompt.consonantClass)
        }
        let distractors = Array(similarLetters.shuffled().prefix(2))
        let filler = alphabet.filter { $0 != prompt && !distractors.contains($0) }.shuffled().prefix(3 - distractors.count)
        let options = ([prompt] + distractors + filler).shuffled()

        return ThaiAlphabetQuestion(prompt: prompt, options: options)
    }
}

#Preview {
    AlphabetGameView()
        .environmentObject(GameState())
}
