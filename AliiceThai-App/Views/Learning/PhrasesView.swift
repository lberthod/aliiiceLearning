import SwiftUI

struct PhrasesView: View {
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode

    var totalPhrases: Int {
        phraseCategories.reduce(0) { $0 + $1.phrases.count }
    }

    var totalLearned: Int {
        phraseCategories.reduce(0) { $0 + gameState.getLearnedPhraseCount(in: $1.phrases.map { $0.thai }) }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.8, green: 0.4, blue: 0.6), Color(red: 0.6, green: 0.6, blue: 0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(
                    title: gameState.selectedLanguage == "fr" ? "Phrases" : "Phrases",
                    subtitle: "\(totalLearned)/\(totalPhrases) " + (gameState.selectedLanguage == "fr" ? "phrases maîtrisées" : "phrases mastered")
                )

                // Random modes buttons
                HStack(spacing: 12) {
                    NavigationLink(destination: RandomQuizView()) {
                        VStack(spacing: 8) {
                            Image(systemName: "shuffle")
                                .font(.system(size: 20))
                            Text(gameState.selectedLanguage == "fr" ? "Quiz\nAléa." : "Quiz\nRandom")
                                .font(.system(size: 11, weight: .semibold))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .foregroundColor(.white)
                        .background(Color.green.opacity(0.6))
                        .cornerRadius(12)
                    }

                    NavigationLink(destination: RandomFlashcardView()) {
                        VStack(spacing: 8) {
                            Image(systemName: "square.grid.2x2")
                                .font(.system(size: 20))
                            Text(gameState.selectedLanguage == "fr" ? "Carte\nAléa." : "Card\nRandom")
                                .font(.system(size: 11, weight: .semibold))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .foregroundColor(.white)
                        .background(Color.purple.opacity(0.6))
                        .cornerRadius(12)
                    }
                }
                .padding(16)

                // Categories Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 15)], spacing: 15) {
                        ForEach(phraseCategories, id: \.id) { category in
                            NavigationLink(destination: PhrasesDetailView(category: category)) {
                                VStack(spacing: 10) {
                                    Text(category.icon)
                                        .font(.system(size: 44))

                                    Text(gameState.selectedLanguage == "fr" ? category.nameFr : category.nameEn)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)

                                    VStack(spacing: 4) {
                                        // Progress indicator
                                        let learned = gameState.getLearnedPhraseCount(in: category.phrases.map { $0.thai })
                                        let total = category.phrases.count
                                        let percentage = gameState.getProgressPercentage(in: category.phrases.map { $0.thai })

                                        HStack(spacing: 4) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 9))
                                            Text("\(learned)/\(total)")
                                                .font(.system(size: 11, weight: .semibold))
                                        }
                                        .foregroundColor(.green)

                                        // Progress bar
                                        GeometryReader { geometry in
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(Color.white.opacity(0.2))

                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(
                                                        percentage == 0 ? Color.yellow :
                                                        percentage < 50 ? Color.orange :
                                                        percentage < 100 ? Color.blue :
                                                        Color.green
                                                    )
                                                    .frame(width: geometry.size.width * CGFloat(percentage) / 100)
                                            }
                                        }
                                        .frame(height: 4)

                                        // Percentage text
                                        Text("\(percentage)%")
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 130)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                            }
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
    NavigationStack {
        PhrasesView()
            .environmentObject(GameState())
    }
}
