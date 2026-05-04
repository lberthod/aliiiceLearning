import SwiftUI

struct AudioDictionaryView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss

    @State var searchText: String = ""
    @State var selectedWord: WrappedWord?
    @State var selectedVariant: String = "normal"
    @State var selectedSpeed: Float = 1.0

    let words: [WrappedWord]

    var filteredWords: [WrappedWord] {
        if searchText.isEmpty {
            return words
        }
        return words.filter { word in
            word.core.thai.contains(searchText) ||
            word.core.romanization.with_tone.localizedCaseInsensitiveContains(searchText) ||
            (word.core.translation.fr as? String)?.localizedCaseInsensitiveContains(searchText) ?? false
        }
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

                    Text(localization.localize("audio.dictionary.title"))
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
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.black.opacity(0.08))

                if selectedWord == nil {
                    // Word list view
                    VStack(spacing: 12) {
                        SearchBar(text: $searchText, placeholder: localization.localize("audio.dictionary.search"))
                            .padding(16)

                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(filteredWords, id: \.id) { word in
                                    WordListItemButton(word: word) {
                                        selectedWord = word
                                        selectedVariant = "normal"
                                        selectedSpeed = 1.0
                                    }
                                }
                            }
                            .padding(16)
                        }
                    }
                } else if let word = selectedWord {
                    // Word detail view
                    ScrollView {
                        VStack(spacing: 16) {
                            // Word header
                            VStack(spacing: 12) {
                                Text(word.core.thai)
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.white)

                                Text(word.core.romanization.with_tone)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                if let en = word.core.translation.en as? String {
                                    Text(en)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }

                                if let fr = word.core.translation.fr as? String {
                                    Text(fr)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)

                            // Playback variants and speed controls
                            VStack(alignment: .leading, spacing: 12) {
                                Text(localization.localize("audio.dictionary.variants"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                HStack(spacing: 8) {
                                    ForEach(["normal", "slow"], id: \.self) { variant in
                                        Button {
                                            selectedVariant = variant
                                        } label: {
                                            Text(variant.capitalized)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(
                                                    selectedVariant == variant
                                                        ? Color(red: 1.0, green: 0.75, blue: 0.3)
                                                        : Color.white.opacity(0.1)
                                                )
                                                .foregroundColor(selectedVariant == variant ? .black : .white)
                                                .cornerRadius(8)
                                        }
                                    }
                                }

                                // Speed controls
                                Text(localization.localize("audio.dictionary.speed"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                HStack(spacing: 8) {
                                    ForEach([0.5, 0.75, 1.0], id: \.self) { speed in
                                        Button {
                                            selectedSpeed = Float(speed)
                                        } label: {
                                            VStack(spacing: 2) {
                                                Text(speed == 0.5 ? "Slow" : speed == 0.75 ? "Normal" : "Fast")
                                                    .font(.caption2)
                                                    .fontWeight(.semibold)

                                                Text("\(String(format: "%.2f", speed))x")
                                                    .font(.caption2)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(
                                                abs(selectedSpeed - Float(speed)) < 0.01
                                                    ? Color(red: 1.0, green: 0.75, blue: 0.3)
                                                    : Color.white.opacity(0.1)
                                            )
                                            .foregroundColor(abs(selectedSpeed - Float(speed)) < 0.01 ? .black : .white)
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)

                            // Play button
                            Button {
                                audioManager.playWord(thaiWord: word.core.thai)
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "speaker.wave.3.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                    Text(localization.localize("audio.dictionary.play"))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }

                            // Back button
                            Button {
                                selectedWord = nil
                            } label: {
                                Text(localization.localize("audio.dictionary.back"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                    .fontWeight(.semibold)
                            }

                            Spacer()
                        }
                        .padding(16)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.5))

            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
}

struct WordListItemButton: View {
    let word: WrappedWord
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(word.core.thai)
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(word.core.romanization.with_tone)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.5))
                }

                if let fr = word.core.translation.fr as? String {
                    Text(fr)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white.opacity(0.08))
            .cornerRadius(8)
        }
    }
}

#Preview {
    Text("Preview not available")
}
