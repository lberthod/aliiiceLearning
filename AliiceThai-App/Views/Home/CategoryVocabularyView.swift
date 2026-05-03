import SwiftUI

struct CategoryVocabularyView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode

    var categoryEmojis: [(category: String, emoji: String)] {
        let categoryEmojis: [String: String] = [
            "adjectives": "✨",
            "animals": "🦁",
            "body": "👤",
            "characters": "🧑",
            "clothes": "👕",
            "colors": "🎨",
            "dinos": "🦕",
            "drinks": "🧃",
            "events": "🎉",
            "family": "👨‍👩‍👧",
            "feelings": "😊",
            "food": "🍕",
            "fruits": "🍎",
            "home": "🏠",
            "hygiene": "🚿",
            "insects": "🐝",
            "music": "🎸",
            "nature": "🌳",
            "numbers": "1️⃣",
            "places": "🏛️",
            "school": "✏️",
            "sea": "🌊",
            "shapes": "⭐",
            "space": "🚀",
            "sport": "⚽",
            "tech": "💻",
            "tools": "🔧",
            "toys": "🎮",
            "transport": "🚗",
            "vegetables": "🥕",
            "verbs": "🏃",
            "weather": "⛅"
        ]

        return gameViewModel.categories.map { category in
            (category, categoryEmojis[category] ?? "🌟")
        }
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
                HeaderView(
                    title: loc.localize("vocabulary.categories.title"),
                    subtitle: "\(categoryEmojis.count) " + (gameState.selectedLanguage == "fr" ? "catégories" : "categories")
                )

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 15)], spacing: 15) {
                        ForEach(categoryEmojis, id: \.category) { cat in
                            NavigationLink(destination: CategoryDetailView(category: cat.category)) {
                                VStack(spacing: 6) {
                                    Text(cat.emoji)
                                        .font(.system(size: 50))
                                    Text(loc.localize("category.\(cat.category)"))
                                        .font(.caption)
                                        .foregroundColor(.white)

                                    let totalWords = gameViewModel.allWords.filter { $0.category == cat.category }.count
                                    let bestStars = gameState.getBestStars(for: cat.category)
                                    let wordsAcquired = bestStars > 0 ? min(bestStars / 3, totalWords) : 0

                                    Text("\(wordsAcquired)/\(totalWords)")
                                        .font(.caption2)
                                        .foregroundColor(.cyan)

                                    if bestStars > 0 {
                                        Text("⭐ \(bestStars)")
                                            .font(.caption2)
                                            .foregroundColor(.yellow)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 140)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(15)
                                .scaleEffect(0.95)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        CategoryVocabularyView()
            .environmentObject(GameState())
            .environmentObject(GameViewModel())
    }
}
