import SwiftUI

struct RandomFlashcardView: View {
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var shuffledPhrases: [Phrase] = []
    @State private var hasStarted = false

    var allPhrases: [Phrase] {
        phraseCategories.flatMap { $0.phrases }.shuffled()
    }

    var currentPhrase: Phrase {
        guard !shuffledPhrases.isEmpty && currentIndex < shuffledPhrases.count else {
            return Phrase(thai: "", romanization: "", englishTranslation: "", frenchTranslation: "", emoji: "❓", context: "", contextFr: "")
        }
        return shuffledPhrases[currentIndex]
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.8, green: 0.6, blue: 0.4), Color(red: 0.9, green: 0.4, blue: 0.6)]),
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
                        Text(gameState.selectedLanguage == "fr" ? "Flashcard Aléatoire" : "Random Flashcard")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text(gameState.selectedLanguage == "fr" ? "190 phrases" : "190 phrases")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                .padding(16)
                .background(Color.black.opacity(0.2))

                if !hasStarted {
                    // Start Screen
                    VStack(spacing: 30) {
                        Spacer()

                        VStack(spacing: 16) {
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)

                            Text(gameState.selectedLanguage == "fr" ? "Flashcard Aléatoire" : "Random Flashcard")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text(gameState.selectedLanguage == "fr" ? "Apprenez avec des flashcards aléatoires" : "Learn with random flashcards")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }

                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.cyan)
                                Text(gameState.selectedLanguage == "fr" ? "190 phrases" : "190 phrases")
                                    .foregroundColor(.white)
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "shuffle")
                                    .foregroundColor(.orange)
                                Text(gameState.selectedLanguage == "fr" ? "Ordre aléatoire" : "Random order")
                                    .foregroundColor(.white)
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "flip.horizontal.fill")
                                    .foregroundColor(.yellow)
                                Text(gameState.selectedLanguage == "fr" ? "Tapez pour retourner" : "Tap to flip")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Spacer()

                        Button(action: {
                            shuffledPhrases = allPhrases
                            hasStarted = true
                        }) {
                            Text(gameState.selectedLanguage == "fr" ? "Commencer" : "Start")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.purple)
                                .cornerRadius(12)
                        }
                        .padding(16)
                    }
                } else {
                    // Flashcard Content
                    VStack(spacing: 20) {
                        // Progress
                        HStack {
                            Text("\(currentIndex + 1)/\(shuffledPhrases.count)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))

                            Spacer()

                            ProgressView(value: Double(currentIndex + 1) / Double(shuffledPhrases.count))
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
                                    currentIndex = Int.random(in: 0..<shuffledPhrases.count)
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
                                if currentIndex < shuffledPhrases.count - 1 {
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
                            .disabled(currentIndex == shuffledPhrases.count - 1)
                            .opacity(currentIndex == shuffledPhrases.count - 1 ? 0.5 : 1.0)
                        }
                        .padding(16)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        RandomFlashcardView()
            .environmentObject(GameState())
    }
}
