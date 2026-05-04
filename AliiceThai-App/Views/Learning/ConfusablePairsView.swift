import SwiftUI

struct ConfusablePairsView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var gameState = GameState.shared
    @State var pairs: [ConfusablePair] = []
    @State var currentIndex = 0
    @State var isLoading = true
    @State var selectedCategory: String?
    @Environment(\.dismiss) var dismiss

    var currentPair: ConfusablePair? {
        guard currentIndex < pairs.count else { return nil }
        return pairs[currentIndex]
    }

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

                    VStack(spacing: 1) {
                        Text("Confusable Pairs")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        if let pair = currentPair {
                            Text("\(currentIndex + 1)/\(pairs.count)")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
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
                        Text("Loading confusable pairs...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if pairs.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.5))
                        Text("No confusable pairs found")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("More pairs will be added soon!")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let pair = currentPair {
                    ScrollView {
                        VStack(spacing: 12) {
                            // Progress bar
                            ProgressView(value: Double(currentIndex + 1), total: Double(pairs.count))
                                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 1.0, green: 0.75, blue: 0.3)))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)

                            // Two word comparison
                            HStack(spacing: 10) {
                                // Word 1
                                WordComparisonCard(
                                    word: pair.word1,
                                    audioManager: audioManager
                                )

                                // VS text
                                VStack {
                                    Text("vs")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .frame(maxHeight: .infinity, alignment: .center)

                                // Word 2
                                WordComparisonCard(
                                    word: pair.word2,
                                    audioManager: audioManager
                                )
                            }
                            .padding(10)

                            // Difference explanation
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Why are they confusing?")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)

                                Text(pair.reason)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .lineLimit(nil)
                            }
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(10)
                            .padding(.horizontal, 10)

                            // Mark as studied
                            HStack {
                                Image(systemName: pairs[currentIndex].isStudied ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(pairs[currentIndex].isStudied ? .green : .white.opacity(0.5))

                                Text(pairs[currentIndex].isStudied ? "Studied" : "Mark as studied")
                                    .font(.caption)
                                    .foregroundColor(.white)

                                Spacer()
                            }
                            .padding(10)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                pairs[currentIndex].isStudied.toggle()
                                gameState.recordConfusablePairStudy(pairId: pair.displayId)
                            }

                            // Navigation buttons
                            HStack(spacing: 10) {
                                Button {
                                    if currentIndex > 0 {
                                        currentIndex -= 1
                                    }
                                } label: {
                                    Text("← Previous")
                                        .font(.caption)
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .background(currentIndex == 0 ? Color.white.opacity(0.05) : Color.white.opacity(0.1))
                                        .cornerRadius(6)
                                }
                                .disabled(currentIndex == 0)

                                Button {
                                    if currentIndex < pairs.count - 1 {
                                        currentIndex += 1
                                    } else {
                                        // Mark mission progress if this is part of curriculum
                                        if let mission = gameState.currentMission {
                                            gameState.recordMissionProgress(missionId: mission.id)
                                        }
                                        dismiss()
                                    }
                                } label: {
                                    Text(currentIndex == pairs.count - 1 ? "Done ✓" : "Next →")
                                        .font(.caption)
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .background(Color.orange)
                                        .cornerRadius(6)
                                }
                            }
                            .padding(10)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadConfusablePairs()
        }
    }

    func loadConfusablePairs() {
        DispatchQueue.main.async {
            guard let allWords = JSONWordParser.shared.loadWordsFromJSON() else {
                isLoading = false
                return
            }

            var loadedPairs: [ConfusablePair] = []

            for word in allWords {
                for confusableWord in word.relations.confusable_with {
                    if let relatedWord = allWords.first(where: { $0.id == confusableWord.id }) {
                        // Avoid duplicates by only adding if word1.id < word2.id
                        if word.id < relatedWord.id {
                            let pair = ConfusablePair(
                                id: "\(word.id)_\(relatedWord.id)",
                                word1: word,
                                word2: relatedWord,
                                reason: confusableWord.reason,
                                isStudied: gameState.studiedConfusablePairs.contains("\(word.id)_\(relatedWord.id)")
                            )
                            loadedPairs.append(pair)
                        }
                    }
                }
            }

            pairs = loadedPairs.shuffled()
            isLoading = false
        }
    }
}

struct WordComparisonCard: View {
    let word: WrappedWord
    let audioManager: AudioManager

    var body: some View {
        VStack(spacing: 8) {
            // Thai text
            Text(word.core.thai)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // Romanization
            Text(word.core.romanization.with_tone)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))

            // French translation
            Text(word.core.translation.fr)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)

            // Play button
            Button {
                audioManager.playWord(thaiWord: word.core.thai)
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.white.opacity(0.08))
        .cornerRadius(10)
    }
}

#Preview {
    Text("Preview not available")
}
