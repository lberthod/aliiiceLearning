import SwiftUI

struct UtilityTextView: View {
    @ObservedObject var localization = LocalizationManager.shared
    @ObservedObject var audioManager = AudioManager.shared
    @Environment(\.dismiss) var dismiss

    let word: WrappedWord

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

                    Spacer()

                    Text("Word Details")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Spacer()

                    Button {
                        audioManager.playWord(thaiWord: word.core.thai)
                    } label: {
                        Image(systemName: "speaker.wave.3.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding(16)
                .background(Color.black.opacity(0.08))

                ScrollView {
                    VStack(spacing: 16) {
                        // Emoji + Word Header
                        VStack(spacing: 12) {
                            Text(word.core.emoji)
                                .font(.system(size: 64))

                            HStack(spacing: 8) {
                                Text(word.core.thai)
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.white)

                                Button {
                                    audioManager.playWord(thaiWord: word.core.thai)
                                } label: {
                                    Image(systemName: "speaker.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                }
                            }

                            Text(word.core.romanization.with_tone)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.7))

                            if let fr = word.core.translation.fr as? String {
                                Text(fr)
                                    .font(.headline)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }

                            if let en = word.core.translation.en as? String {
                                Text("(\(en))")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        // Word Information
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Word Type:")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                                Text(word.linguistic.word_type)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }

                            if let classifier = word.linguistic.classifier {
                                HStack {
                                    Text("Classifier:")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                    Spacer()
                                    Text(classifier)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                }
                            }

                            HStack {
                                Text("Level:")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                                Text(word.learning.level)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }

                            HStack {
                                Text("Frequency:")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                                Text(word.learning.frequency)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }

                            HStack {
                                Text("Register:")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                                Text(word.linguistic.register)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)

                        // Syllables & Tones
                        if !word.linguistic.syllables.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Syllables")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(word.linguistic.syllables, id: \.thai) { syllable in
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack(spacing: 6) {
                                                Text(syllable.thai)
                                                    .font(.body)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)

                                                Button {
                                                    audioManager.playWord(thaiWord: syllable.thai)
                                                } label: {
                                                    Image(systemName: "speaker.fill")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                                }
                                            }

                                            Text(syllable.romanization)
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.7))

                                            Text("Tone: \(syllable.tone)")
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(10)
                                        .background(Color.white.opacity(0.06))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                        }

                        // Example Sentences
                        if !word.usage.example_sentences.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Example Sentences")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(word.usage.example_sentences, id: \.id) { example in
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack(spacing: 8) {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    HStack(spacing: 6) {
                                                        Text(example.thai)
                                                            .font(.body)
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.white)
                                                            .lineLimit(nil)

                                                        Button {
                                                            audioManager.playWord(thaiWord: example.thai)
                                                        } label: {
                                                            Image(systemName: "speaker.fill")
                                                                .font(.system(size: 12))
                                                                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                                        }
                                                    }

                                                    Text(example.romanization)
                                                        .font(.caption2)
                                                        .foregroundColor(.white.opacity(0.6))
                                                }

                                                Spacer()
                                            }

                                            Text(example.fr)
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))

                                            Text(example.en)
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        .padding(10)
                                        .background(Color.white.opacity(0.06))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                        }

                        // Common Phrases
                        if !word.usage.common_phrases.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Common Phrases")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(word.usage.common_phrases, id: \.thai) { phrase in
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack(spacing: 8) {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    HStack(spacing: 6) {
                                                        Text(phrase.thai)
                                                            .font(.body)
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.white)

                                                        Button {
                                                            audioManager.playWord(thaiWord: phrase.thai)
                                                        } label: {
                                                            Image(systemName: "speaker.fill")
                                                                .font(.system(size: 12))
                                                                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                                        }
                                                    }

                                                    Text(phrase.romanization)
                                                        .font(.caption2)
                                                        .foregroundColor(.white.opacity(0.6))
                                                }

                                                Spacer()
                                            }

                                            Text(phrase.fr)
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))

                                            Text(phrase.en)
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        .padding(10)
                                        .background(Color.white.opacity(0.06))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                        }

                        // Contexts
                        if !word.usage.contexts.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Contexts")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(word.usage.contexts, id: \.self) { context in
                                        HStack {
                                            Image(systemName: "tag.fill")
                                                .font(.caption)
                                                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                            Text(context)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                        .padding(8)
                                        .background(Color.white.opacity(0.06))
                                        .cornerRadius(6)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                        }

                        // Memory Aid
                        if !word.memory.mnemonic_fr.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Memory Aid")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                Text(word.memory.mnemonic_fr)
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                        }

                        Spacer(minLength: 20)
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Text("Preview not available")
}
