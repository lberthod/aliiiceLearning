import SwiftUI

struct AudioDictionaryLauncherView: View {
    @ObservedObject var localization = LocalizationManager.shared
    @State private var selectedWords: [WrappedWord] = []
    @State private var showDictionary = false
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
                    Text("Audio Dictionary")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Browse words with audio variants")
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
                                    loadWordsForCategory(category)
                                    showDictionary = true
                                }) {
                                    HStack {
                                        Image(systemName: "book.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(category.capitalized)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)

                                            Text("Browse category words")
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
            .navigationDestination(isPresented: $showDictionary) {
                if !selectedWords.isEmpty {
                    AudioDictionaryView(words: selectedWords)
                }
            }
        }
        .navigationTitle("Audio Dictionary")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let parser = JSONWordParser.shared
            allWords = parser.getAllWords()
            isLoading = false
        }
    }

    private func loadWordsForCategory(_ category: String) {
        let categoryWordIds = Set(ALL_WORDS.filter { $0.category == category }.map { $0.id })
        selectedWords = allWords.filter { categoryWordIds.contains($0.id) }
    }
}

#Preview {
    NavigationStack {
        AudioDictionaryLauncherView()
    }
}
