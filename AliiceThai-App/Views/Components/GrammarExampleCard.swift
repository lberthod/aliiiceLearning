import SwiftUI

struct GrammarExampleCard: View {
    let example: GrammarExample
    @EnvironmentObject var gameState: GameState
    @State private var audioOnCooldown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Thai text with audio button
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(example.thai)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)

                    Text(example.romanization)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))

                    // Structure label
                    Text(example.structure)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.cyan)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.cyan.opacity(0.2))
                        .cornerRadius(6)
                }

                Spacer()

                // Audio button
                Button(action: {
                    if !audioOnCooldown {
                        AudioManager.shared.speakThai(example.thai)
                        audioOnCooldown = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            audioOnCooldown = false
                        }
                    }
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
                .disabled(audioOnCooldown)
                .opacity(audioOnCooldown ? 0.5 : 1.0)
            }

            Divider()
                .background(Color.white.opacity(0.3))

            // Translation
            VStack(alignment: .leading, spacing: 8) {
                Text("English")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .textCase(.uppercase)

                Text(example.englishTranslation)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)

                if gameState.selectedLanguage == "fr" {
                    Divider()
                        .background(Color.white.opacity(0.3))

                    Text("Français")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)

                    Text(example.frenchTranslation)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    GrammarExampleCard(example: grammarTopicsData[0].examples[0])
        .environmentObject(GameState())
        .padding()
        .background(Color.blue)
}
