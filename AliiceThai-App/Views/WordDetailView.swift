import SwiftUI

struct WordDetailView: View {
    let word: WrappedWord
    @Environment(\.dismiss) var dismiss
    @ObservedObject var audioManager = AudioManager.shared

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
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding(16)
                .background(Color.black.opacity(0.08))

                ScrollView {
                    VStack(spacing: 16) {
                        // Word Header with Emoji
                        VStack(spacing: 12) {
                            Text(word.core.emoji)
                                .font(.system(size: 64))

                            Text(word.core.thai)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)

                            Text(word.core.romanization.with_tone)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.7))

                            if let fr = word.core.translation.fr as? String {
                                Text(fr)
                                    .font(.headline)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }

                            if let en = word.core.translation.en as? String {
                                Text(en)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        // Word Info
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Level:")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .fontWeight(.semibold)

                                Text(word.learning.level)
                                    .font(.caption)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                Spacer()

                                Text("Frequency:")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .fontWeight(.semibold)

                                Text("\(word.learning.frequency)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(8)

                        // Usage Scenarios
                        if !word.usage.example_sentences.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Real-world Usage")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(word.usage.example_sentences, id: \.id) { example in
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack(spacing: 8) {
                                                Text(word.core.emoji)
                                                    .font(.system(size: 20))

                                                Text(example.thai)
                                                    .font(.body)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                    .lineLimit(nil)
                                            }

                                            Text(example.fr)
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))

                                            Text(example.en)
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.6))
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
