import SwiftUI

struct WordItemView: View {
    let word: Word
    @EnvironmentObject var gameState: GameState
    @State private var isAudioOnCooldown = false

    var body: some View {
        Button(action: {
            AudioManager.shared.speakThai(word.thai)
            isAudioOnCooldown = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isAudioOnCooldown = false
            }
        }) {
            HStack(spacing: 16) {
                Text(word.emoji)
                    .font(.system(size: 32))
                    .frame(width: 50)

                VStack(alignment: .leading, spacing: 4) {
                    Text(word.thai)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text(word.romanization)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Text(gameState.selectedLanguage == "fr" ? word.french : word.english)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: 100, alignment: .trailing)

                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .padding(.horizontal, 16)
            .background(Color.white.opacity(0.15))
            .cornerRadius(12)
        }
        .disabled(isAudioOnCooldown)
        .opacity(isAudioOnCooldown ? 0.5 : 1.0)
    }
}

#Preview {
    VStack {
        WordItemView(word: Word(
            id: "cat",
            emoji: "🐱",
            thai: "แมว",
            romanization: "maew",
            english: "cat",
            french: "chat",
            category: "animals"
        ))
    }
    .padding(20)
    .background(
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.9, green: 0.4, blue: 0.6), Color(red: 0.4, green: 0.2, blue: 0.9)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    )
    .environmentObject(GameState())
}
