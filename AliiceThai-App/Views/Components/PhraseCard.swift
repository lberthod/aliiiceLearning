import SwiftUI

struct PhraseCard: View {
    let phrase: Phrase
    @EnvironmentObject var gameState: GameState
    @State private var audioOnCooldown = false

    var translation: String {
        gameState.selectedLanguage == "fr" ? phrase.frenchTranslation : phrase.englishTranslation
    }

    var context: String {
        gameState.selectedLanguage == "fr" ? phrase.contextFr : phrase.context
    }

    var languageLabel: String {
        gameState.selectedLanguage == "fr" ? "FR" : "EN"
    }

    var body: some View {
        Button(action: {
            if !audioOnCooldown {
                AudioManager.shared.speakThai(phrase.thai)
                audioOnCooldown = true
                // Mark as learned on interaction
                gameState.markPhraseLearned(phrase.thai)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    audioOnCooldown = false
                }
            }
        }) {
            HStack(spacing: 12) {
                // Learned indicator
                if gameState.isPhraseLearned(phrase.thai) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 20, height: 20)
                }

                // Emoji
                Text(phrase.emoji)
                    .font(.system(size: 32))

                // Phrase content
                VStack(alignment: .leading, spacing: 8) {
                    // Thai + Romanization
                    VStack(alignment: .leading, spacing: 2) {
                        Text(phrase.thai)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Text(phrase.romanization)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Divider()
                        .background(Color.white.opacity(0.2))

                    // Translation + Context
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(translation)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.yellow)

                            Spacer()

                            Text(languageLabel)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(4)
                        }

                        Text(context)
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.6))
                            .italic()
                    }
                }

                Spacer()
                    .frame(maxWidth: 40)

                // Mark as known button
                Button(action: {
                    gameState.markPhraseLearned(phrase.thai)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: gameState.isPhraseLearned(phrase.thai) ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.system(size: 18))
                            .foregroundColor(gameState.isPhraseLearned(phrase.thai) ? .green : .white.opacity(0.6))

                        Text("Known")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .frame(width: 45, height: 50)
                .background(Color.white.opacity(0.15))
                .cornerRadius(10)

                // Audio button
                VStack(spacing: 6) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)

                    Text("TTS")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(width: 45, height: 50)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
            }
            .padding(14)
            .background(Color.white.opacity(0.15))
            .cornerRadius(12)
        }
        .disabled(audioOnCooldown)
        .opacity(audioOnCooldown ? 0.5 : 1.0)
    }
}

#Preview {
    PhraseCard(phrase: phraseCategories[0].phrases[0])
        .environmentObject(GameState())
        .padding()
        .background(Color.blue)
}
