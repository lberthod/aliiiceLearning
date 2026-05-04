import SwiftUI

struct WordLibraryView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @ObservedObject var wordDataManager = WordDataManager.shared
    @State var searchText = ""
    @State var selectedLevel = "all"
    @State var sortBy = "thai"
    @State var isShuffled = false
    @State var debouncedSearch = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var selectedWordIndex: Int = 0

    var filteredWords: [WrappedWord] {
        var filtered = wordDataManager.allWords

        // Filter by search (debounced)
        if !debouncedSearch.isEmpty {
            filtered = filtered.filter { word in
                word.core.thai.contains(debouncedSearch) ||
                word.core.romanization.with_tone.localizedCaseInsensitiveContains(debouncedSearch) ||
                (word.core.translation.fr as? String)?.localizedCaseInsensitiveContains(debouncedSearch) ?? false
            }
        }

        // Filter by level
        if selectedLevel != "all" {
            filtered = filtered.filter { $0.learning.level == selectedLevel }
        }

        // Sort
        if isShuffled {
            filtered.shuffle()
        } else {
            switch sortBy {
            case "frequency":
                filtered.sort { $0.learning.frequency < $1.learning.frequency }
            case "level":
                filtered.sort { $0.learning.level < $1.learning.level }
            default:
                filtered.sort { $0.core.thai < $1.core.thai }
            }
        }

        return filtered
    }

    var uniqueLevels: [String] {
        ["all"] + Set(wordDataManager.allWords.map { $0.learning.level }).sorted()
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
                    Text("Words")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()

                    Text(filteredWords.count < 1000 ? "\(filteredWords.count)" : "\(wordDataManager.allWords.count)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(16)
                .background(Color.white.opacity(0.1))

                ScrollView {
                    VStack(spacing: 12) {
                        // Search Bar
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.caption)

                            TextField("Search", text: $searchText)
                                .foregroundColor(.white)
                                .textInputAutocapitalization(.never)
                                .onChange(of: searchText) { newValue in
                                    searchTask?.cancel()
                                    searchTask = Task {
                                        try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
                                        DispatchQueue.main.async {
                                            debouncedSearch = newValue
                                        }
                                    }
                                }

                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    debouncedSearch = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white.opacity(0.5))
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .font(.callout)

                        // Quick Filters (Compact)
                        VStack(spacing: 8) {
                            // Level Filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 6) {
                                    ForEach(uniqueLevels, id: \.self) { level in
                                        Button(action: { selectedLevel = level }) {
                                            Text(level == "all" ? "All" : level)
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(selectedLevel == level ? Color(red: 1.0, green: 0.75, blue: 0.3) : Color.white.opacity(0.1))
                                                .foregroundColor(selectedLevel == level ? .black : .white)
                                                .cornerRadius(4)
                                        }
                                    }
                                }
                            }

                            // Sort Picker & Shuffle
                            HStack(spacing: 10) {
                                Picker("Sort", selection: $sortBy) {
                                    Text("Thai").tag("thai")
                                    Text("Frequency").tag("frequency")
                                    Text("Level").tag("level")
                                }
                                .pickerStyle(.segmented)
                                .font(.caption2)
                                .disabled(isShuffled)

                                Button {
                                    isShuffled.toggle()
                                } label: {
                                    Image(systemName: isShuffled ? "shuffle.circle.fill" : "shuffle")
                                        .font(.title3)
                                        .foregroundColor(isShuffled ? Color(red: 1.0, green: 0.75, blue: 0.3) : .white.opacity(0.7))
                                }
                            }
                        }
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(8)

                        // Current Word Display (Isolated Component)
                        if !filteredWords.isEmpty && selectedWordIndex < filteredWords.count {
                            CurrentWordCard(
                                word: filteredWords[selectedWordIndex],
                                index: selectedWordIndex,
                                total: filteredWords.count,
                                onPrevious: {
                                    if selectedWordIndex > 0 {
                                        selectedWordIndex -= 1
                                    }
                                },
                                onNext: {
                                    if selectedWordIndex < filteredWords.count - 1 {
                                        selectedWordIndex += 1
                                    }
                                },
                                canGoPrevious: selectedWordIndex > 0,
                                canGoNext: selectedWordIndex < filteredWords.count - 1
                            )
                        }

                        // Words List - Virtualized with LazyVStack
                        if filteredWords.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white.opacity(0.3))

                                Text("No words found")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(32)
                        } else {
                            LazyVStack(spacing: 8, pinnedViews: []) {
                                ForEach(filteredWords, id: \.id) { word in
                                    NavigationLink(destination: UtilityTextView(word: word)) {
                                        CompactWordRow(word: word)
                                    }
                                }
                            }
                        }

                        Spacer(minLength: 20)
                    }
                    .padding(12)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            searchTask?.cancel()
        }
    }
}

// Compact Word Row - Ultra-fast with Emoji and TTS
struct CompactWordRow: View {
    let word: WrappedWord
    @ObservedObject var audioManager = AudioManager.shared
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: 10) {
            // Emoji
            Text(word.core.emoji)
                .font(.system(size: 24))

            // Word Info
            VStack(alignment: .leading, spacing: 1) {
                Text(word.core.thai)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(word.core.romanization.with_tone)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(1)
            }

            Spacer()

            // TTS Button
            Button(action: {
                audioManager.playWord(thaiWord: word.core.thai)
                isPlaying = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isPlaying = false
                }
            }) {
                Image(systemName: isPlaying ? "speaker.wave.3.fill" : "speaker.2.fill")
                    .font(.system(size: 14))
                    .foregroundColor(isPlaying ? Color(red: 1.0, green: 0.75, blue: 0.3) : .white.opacity(0.7))
            }

            // Level Badge
            Text(word.learning.level)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.white.opacity(0.06))
        .cornerRadius(6)
    }
}

// Current Word Card - Isolated Component
struct CurrentWordCard: View {
    let word: WrappedWord
    let index: Int
    let total: Int
    let onPrevious: () -> Void
    let onNext: () -> Void
    let canGoPrevious: Bool
    let canGoNext: Bool

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: onPrevious) {
                    Image(systemName: "chevron.up")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }
                .disabled(!canGoPrevious)

                Spacer()

                Text("\(index + 1)/\(total)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))

                Spacer()

                Button(action: onNext) {
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }
                .disabled(!canGoNext)
            }

            VStack(spacing: 12) {
                NavigationLink(destination: UtilityTextView(word: word)) {
                    VStack(spacing: 8) {
                        Text(word.core.emoji)
                            .font(.system(size: 40))

                        Text(word.core.thai)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(word.core.romanization.with_tone)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))

                        if let fr = word.core.translation.fr as? String {
                            Text(fr)
                                .font(.headline)
                                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(12)
                }

                // TTS Button
                Button {
                    AudioManager.shared.playWord(thaiWord: word.core.thai)
                } label: {
                    HStack {
                        Image(systemName: "speaker.wave.3.fill")
                        Text("Listen")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.06))
        .cornerRadius(12)
        .gesture(
            DragGesture()
                .onEnded { value in
                    let verticalAmount = value.translation.height
                    if verticalAmount > 50 && canGoNext {
                        onNext()
                    } else if verticalAmount < -50 && canGoPrevious {
                        onPrevious()
                    }
                }
        )
    }
}

#Preview {
    WordLibraryView()
}
