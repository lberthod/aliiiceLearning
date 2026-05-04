import SwiftUI

struct ListeningLauncherView: View {
    @ObservedObject var localization = LocalizationManager.shared
    @State private var selectedWord: WrappedWord?
    @State private var showListening = false
    @State private var allWords: [WrappedWord] = []
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
                    Text("Listening Practice")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Select a word to practice")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)

                // Word list by category
                if isLoading {
                    ProgressView()
                        .foregroundColor(.white)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(["animals", "fruits", "vegetables", "food", "drinks"], id: \.self) { category in
                                ListeningCategorySection(
                                    category: category,
                                    allWords: allWords,
                                    onSelectWord: { word in
                                        selectedWord = word
                                        showListening = true
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }

                Spacer()
            }
            .navigationDestination(isPresented: $showListening) {
                if let word = selectedWord {
                    ListeningView(word: word)
                }
            }
        }
        .navigationTitle("Listening Practice")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadAllWords()
        }
    }

    private func loadAllWords() {
        let parser = JSONWordParser.shared
        allWords = parser.getAllWords()
        isLoading = false
    }
}

struct ListeningCategorySection: View {
    let category: String
    let allWords: [WrappedWord]
    let onSelectWord: (WrappedWord) -> Void

    var categoryWords: [WrappedWord] {
        let categoryWordIds = Set(ALL_WORDS.filter { $0.category == category }.map { $0.id })
        return allWords.filter { categoryWordIds.contains($0.id) }.prefix(5).map { $0 }
    }

    var body: some View {
        if !categoryWords.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(category.capitalized)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                VStack(spacing: 8) {
                    ForEach(categoryWords, id: \.id) { word in
                    Button(action: {
                        onSelectWord(word)
                    }) {
                        HStack {
                            Text(word.core.emoji)
                                .font(.system(size: 24))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(word.core.thai)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                Text(word.core.translation.fr)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(6)
                    }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListeningLauncherView()
    }
}
