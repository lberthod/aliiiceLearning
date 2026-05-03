import SwiftUI

struct CategoryDetailView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var loc = LocalizationManager.shared
    @State private var selectedMode: String = "flashcard"
    @Environment(\.presentationMode) var presentationMode

    let category: String

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.4, green: 0.6, blue: 0.9), Color(red: 0.2, green: 0.8, blue: 0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
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
                    Text(loc.localize("category.\(category)"))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("🌟")
                        .font(.system(size: 28))
                }
                .padding(20)

                // Mode Selection
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        Button(action: { selectedMode = "flashcard" }) {
                            Text(loc.localize("button.flashcards"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(selectedMode == "flashcard" ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .font(.headline)
                        }

                        Button(action: { selectedMode = "quiz" }) {
                            Text(loc.localize("button.quiz"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(selectedMode == "quiz" ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .font(.headline)
                        }
                    }

                    NavigationLink(destination: VocabularyListView(category: category)) {
                        Text("📚 Vocabulaire")
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color(red: 0.9, green: 0.6, blue: 0.2))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .font(.headline)
                    }
                }
                .padding(20)

                Spacer()

                if selectedMode == "flashcard" {
                    FlashcardView()
                        .environmentObject(gameState)
                        .environmentObject(gameViewModel)
                } else {
                    SimpleQuizView()
                        .environmentObject(gameState)
                        .environmentObject(gameViewModel)
                }

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            gameState.selectedCategory = category
            gameViewModel.selectedCategory = category
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: "animals")
            .environmentObject(GameState())
            .environmentObject(GameViewModel())
    }
}
