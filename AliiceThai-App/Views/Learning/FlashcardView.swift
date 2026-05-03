import SwiftUI

struct FlashcardView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var loc = LocalizationManager.shared
    @State private var isFlipped = false
    @State private var selectedSide: String = "emoji"
    @State private var audioOnCooldown: Set<String> = []

    var body: some View {
        VStack(spacing: 30) {
            if let word = gameViewModel.currentWord {
                // Large Emoji Button
                VStack(spacing: 20) {
                    Button(action: {
                        if !audioOnCooldown.contains("thai") {
                            AudioManager.shared.speakThai(word.thai)
                            audioOnCooldown.insert("thai")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                audioOnCooldown.remove("thai")
                            }
                        }
                        withAnimation(.spring()) {
                            selectedSide = "emoji"
                        }
                    }) {
                        Text(word.emoji)
                            .font(.system(size: 120))
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        selectedSide == "emoji" ? Color.yellow : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                    }
                    .disabled(audioOnCooldown.contains("thai"))
                    .opacity(audioOnCooldown.contains("thai") ? 0.5 : 1.0)

                    // Thai Word Button
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedSide = "word"
                        }
                    }) {
                        VStack(spacing: 10) {
                            Text(word.thai)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                            Text(word.romanization)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                            Text(gameState.getLocalizedString(word.english, word.french))
                                .font(.headline)
                                .foregroundColor(.yellow)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    selectedSide == "word" ? Color.yellow : Color.clear,
                                    lineWidth: 3
                                )
                        )
                    }
                    .disabled(audioOnCooldown.contains("translation"))
                    .opacity(audioOnCooldown.contains("translation") ? 0.5 : 1.0)

                    // Next Button
                    Button(action: {
                        withAnimation(.easeInOut) {
                            gameViewModel.nextWord()
                            selectedSide = "emoji"
                        }
                        AudioManager.shared.playTapSound()
                    }) {
                        HStack {
                            Text(loc.localize("button.nextword"))
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                        .cornerRadius(15)
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Text("No words in this category!")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }

            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    FlashcardView()
        .environmentObject(GameState())
        .environmentObject(GameViewModel())
        .background(Color.blue)
}
