import SwiftUI

struct AnalyticsDashboard: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var gameViewModel = GameViewModel.shared
    @ObservedObject var audioManager = AudioManager.shared
    @Environment(\.dismiss) var dismiss
    @State var speakingLevel: SpeakingLevel?
    @State var isLoading = true

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

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }

                    Text("Analytics")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "house.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.08))

                if isLoading {
                    VStack {
                        ProgressView()
                            .tint(.orange)
                        Text("Loading analytics...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let level = speakingLevel {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Speaking Level Card
                            SpeakingLevelCard(speakingLevel: level)

                            // Quick Stats
                            VStack(spacing: 10) {
                                Text("Progress Overview")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(spacing: 10) {
                                    StatCard(
                                        title: "Words Learned",
                                        value: String(gameState.learnedPhrases.count),
                                        icon: "book.fill",
                                        color: Color(red: 1.0, green: 0.75, blue: 0.3)
                                    )

                                    StatCard(
                                        title: "Total Stars",
                                        value: String(gameState.currentStars),
                                        icon: "star.fill",
                                        color: Color(red: 1.0, green: 0.9, blue: 0.0)
                                    )
                                }
                            }
                            .padding(.horizontal, 10)

                            // Tone Weakness Analysis
                            ToneWeaknessSection(
                                gameState: gameState,
                                gameViewModel: gameViewModel,
                                audioManager: audioManager
                            )

                            // Due Words Section
                            DueWordsSection(
                                gameViewModel: gameViewModel,
                                audioManager: audioManager
                            )

                            Spacer(minLength: 20)
                        }
                        .padding(16)
                    }
                } else {
                    AnalyticsEmptyState(
                        title: "No Analytics Available",
                        description: "Complete some lessons to see your progress",
                        icon: "chart.bar"
                    )
                    .padding(16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadAnalytics()
        }
    }

    private func loadAnalytics() {
        DispatchQueue.main.async {
            speakingLevel = gameViewModel.calculateSpeakingLevel()
            isLoading = false
        }
    }
}

// MARK: - Tone Weakness Section
struct ToneWeaknessSection: View {
    let gameState: GameState
    let gameViewModel: GameViewModel
    let audioManager: AudioManager
    @State var expandedWeakness = true

    var body: some View {
        VStack(spacing: 10) {
            Button {
                withAnimation {
                    expandedWeakness.toggle()
                }
            } label: {
                HStack {
                    Text("Tone Accuracy Analysis")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)

                    Spacer()

                    Image(systemName: expandedWeakness ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            if expandedWeakness {
                let weakWords = getWeakToneWords()

                if weakWords.isEmpty {
                    AnalyticsEmptyState(
                        title: "Great Job!",
                        description: "Your tone accuracy is strong across all words",
                        icon: "waveform.circle.fill"
                    )
                } else {
                    VStack(spacing: 8) {
                        Text("Words needing tone practice (< 70% accuracy)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(weakWords.prefix(5), id: \.id) { word in
                            WeakToneWordCard(
                                word: word,
                                accuracy: gameState.toneAccuracyByWord[word.id] ?? 0,
                                audioManager: audioManager
                            )
                        }

                        if weakWords.count > 5 {
                            Text("... and \(weakWords.count - 5) more")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        // Action Button
                        NavigationLink(destination: ToneQuizLauncherView()) {
                            HStack {
                                Image(systemName: "waveform")
                                    .font(.system(size: 14))

                                Text("Start Tone Drill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)

                                Spacer()

                                Image(systemName: "arrow.right")
                                    .font(.system(size: 12))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(red: 0.5, green: 0.8, blue: 1.0))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }

    private func getWeakToneWords() -> [WrappedWord] {
        return gameViewModel.wrappedWords.filter { word in
            let accuracy = gameState.toneAccuracyByWord[word.id] ?? 0
            return accuracy < 70 && accuracy > 0
        }
        .sorted { a, b in
            let accA = gameState.toneAccuracyByWord[a.id] ?? 0
            let accB = gameState.toneAccuracyByWord[b.id] ?? 0
            return accA < accB
        }
    }
}

// MARK: - Due Words Section
struct DueWordsSection: View {
    let gameViewModel: GameViewModel
    let audioManager: AudioManager
    @State var expandedDue = true

    var body: some View {
        VStack(spacing: 10) {
            Button {
                withAnimation {
                    expandedDue.toggle()
                }
            } label: {
                HStack {
                    Text("Due for Review")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)

                    Spacer()

                    let dueCount = gameViewModel.getTodaysDueWords().count
                    if dueCount > 0 {
                        Text("\(dueCount) words")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red.opacity(0.3))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    }

                    Image(systemName: expandedDue ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            if expandedDue {
                let dueWords = gameViewModel.getTodaysDueWords()

                if dueWords.isEmpty {
                    AnalyticsEmptyState(
                        title: "All Caught Up!",
                        description: "No words are due for review today",
                        icon: "checkmark.circle.fill"
                    )
                } else {
                    VStack(spacing: 8) {
                        Text("Review these words to maintain your streak")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(dueWords.prefix(10), id: \.id) { word in
                            DueWordItem(
                                word: word,
                                daysUntilDue: 0,
                                audioManager: audioManager
                            )
                        }

                        if dueWords.count > 10 {
                            Text("... and \(dueWords.count - 10) more")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        // Action Button
                        NavigationLink(destination: ToneQuizLauncherView()) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 14))

                                Text("Start Review Session")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)

                                Spacer()

                                Image(systemName: "arrow.right")
                                    .font(.system(size: 12))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(red: 0.8, green: 0.5, blue: 1.0))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    AnalyticsDashboard()
}
