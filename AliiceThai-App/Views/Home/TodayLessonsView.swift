import SwiftUI

struct TodayLessonsView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var loc = LocalizationManager.shared

    var todaysLessonWords: [Word] {
        gameViewModel.getTodaysLessonWords()
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.9, green: 0.4, blue: 0.6), Color(red: 0.4, green: 0.2, blue: 0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(
                    title: loc.localize("home.lesson.title"),
                    subtitle: "\(todaysLessonWords.count) " + (gameState.selectedLanguage == "fr" ? "mots à apprendre" : "words to learn")
                )

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(todaysLessonWords, id: \.id) { word in
                            WordItemView(word: word)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        TodayLessonsView()
            .environmentObject(GameState())
            .environmentObject(GameViewModel())
    }
}
