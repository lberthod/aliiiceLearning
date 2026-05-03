import SwiftUI

struct GrammarView: View {
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.8, green: 0.6, blue: 0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(
                    title: gameState.selectedLanguage == "fr" ? "Grammaire" : "Grammar",
                    subtitle: "\(grammarTopicsData.count) " + (gameState.selectedLanguage == "fr" ? "leçons" : "lessons")
                )

                // Grammar Topics List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(grammarTopicsData, id: \.id) { topic in
                            NavigationLink(destination: GrammarDetailView(topic: topic)) {
                                GrammarTopicCard(topic: topic)
                                    .environmentObject(gameState)
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
        GrammarView()
            .environmentObject(GameState())
    }
}
