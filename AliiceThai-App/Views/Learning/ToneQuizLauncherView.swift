import SwiftUI

struct ToneQuizLauncherView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var selectedToneMarkings: [ToneMarking] = []
    @State private var showQuiz = false
    @State private var isLoading = true

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.6, blue: 0.4),
                    Color(red: 0.7, green: 0.5, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text(localization.localize("tone.detection.question"))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Select a category to practice")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)

                // Category selection
                if isLoading {
                    ProgressView()
                        .foregroundColor(.white)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(["animals", "fruits", "vegetables", "food", "drinks"], id: \.self) { category in
                                Button(action: {
                                    startQuizForCategory(category)
                                }) {
                                    HStack {
                                        Image(systemName: "waveform.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(category.capitalized)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)

                                            Text("Practice tone identification")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                }

                Spacer()
            }
            .navigationDestination(isPresented: $showQuiz) {
                if !selectedToneMarkings.isEmpty {
                    ToneDetectionQuizView(wordId: nil)
                }
            }
        }
        .navigationTitle(localization.localize("tone.quiz.title") ?? "Tone Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isLoading = false
        }
    }

    private func startQuizForCategory(_ category: String) {
        // Get tone markings for the category using simple Word data
        let categoryWords = ALL_WORDS.filter { $0.category == category }
        let categoryWordIds = Set(categoryWords.map { $0.id })

        selectedToneMarkings = ToneMarkingData.shared.getAllToneMarkings()
            .filter { marking in
                categoryWordIds.contains(marking.wordId)
            }

        if !selectedToneMarkings.isEmpty {
            showQuiz = true
        }
    }
}

#Preview {
    NavigationStack {
        ToneQuizLauncherView()
    }
}
