import SwiftUI

struct VocabularyListView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var audioOnCooldown: Set<String> = []

    let category: String

    var categoryWords: [Word] {
        gameViewModel.allWords.filter { $0.category == category }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.4, green: 0.6, blue: 0.9), Color(red: 0.2, green: 0.8, blue: 0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                        Spacer()
                        VStack(spacing: 4) {
                            Text(loc.localize("category.\(category)"))
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text("\(categoryWords.count) " + (gameState.selectedLanguage == "fr" ? "mots" : "words"))
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        NavigationLink(destination: DashboardView()) {
                            Image(systemName: "house.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(20)

                // Vocabulary List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(categoryWords, id: \.id) { word in
                            Button(action: {
                                AudioManager.shared.speakThai(word.thai)
                                audioOnCooldown.insert(word.id)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    audioOnCooldown.remove(word.id)
                                }
                            }) {
                                HStack(spacing: 16) {
                                    // Emoji
                                    Text(word.emoji)
                                        .font(.system(size: 40))
                                        .frame(width: 60)

                                    // Word info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(word.thai)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)

                                        Text(word.romanization)
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.7))

                                        Text(gameState.getLocalizedString(word.english, word.french))
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.yellow)
                                    }

                                    Spacer()

                                    // Speaker icon
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(10)
                                }
                                .padding(16)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                            }
                            .disabled(audioOnCooldown.contains(word.id))
                            .opacity(audioOnCooldown.contains(word.id) ? 0.5 : 1.0)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    VocabularyListView(category: "animals")
        .environmentObject(GameState())
        .environmentObject(GameViewModel())
}
