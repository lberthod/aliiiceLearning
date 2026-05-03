import SwiftUI

struct NumbersView: View {
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var audioOnCooldown: Set<Int> = []
    @State private var selectedMode: NumberMode = .basic

    var numbers: [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] {
        NumbersDataGenerator.getNumbers(for: selectedMode)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.8, blue: 0.6), Color(red: 0.4, green: 0.6, blue: 0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(
                    title: loc.localize("numbers.title"),
                    subtitle: selectedMode == .quiz ?
                        loc.localize("numbers.quiz.title") :
                        "\(numbers.count) " + loc.localize("numbers.title").lowercased()
                )

                // Mode Selector Tabs
                HStack(spacing: 8) {
                    ForEach(NumberMode.allCases, id: \.self) { mode in
                        Button(action: {
                            selectedMode = mode
                            audioOnCooldown.removeAll()
                        }) {
                            Text(mode.displayName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(selectedMode == mode ? .white : .white.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(selectedMode == mode ? Color.white.opacity(0.3) : Color.clear)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(12)

                // Content based on mode
                if selectedMode == .quiz {
                    NumbersQuizView()
                        .environmentObject(gameState)
                } else {
                    // Numbers List
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(numbers, id: \.number) { item in
                                Button(action: {
                                    if !audioOnCooldown.contains(item.number) {
                                        AudioManager.shared.speakThai(item.thai)
                                        audioOnCooldown.insert(item.number)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            audioOnCooldown.remove(item.number)
                                        }
                                    }
                                }) {
                                    HStack(spacing: 16) {
                                        // Number display (text only)
                                        Text(item.emoji)
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 60, alignment: .center)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.thai)
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.white)

                                            Text(item.romanization)
                                                .font(.system(size: 14))
                                                .foregroundColor(.white.opacity(0.7))

                                            HStack {
                                                Text(item.english)
                                                    .font(.system(size: 13))
                                                    .foregroundColor(.yellow)
                                                if gameState.selectedLanguage == "fr" {
                                                    Text("/ \(item.french)")
                                                        .font(.system(size: 13))
                                                        .foregroundColor(.yellow)
                                                }
                                            }
                                        }

                                        Spacer()

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
                                .disabled(audioOnCooldown.contains(item.number))
                                .opacity(audioOnCooldown.contains(item.number) ? 0.5 : 1.0)
                            }
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
    NumbersView()
        .environmentObject(GameState())
}
