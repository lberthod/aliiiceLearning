import SwiftUI

struct ClassifierLessonView: View {
    let classifier: ClassifierLesson

    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var selectedExampleIndex = 0
    @Environment(\.dismiss) private var dismiss
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
                // Top Navigation Bar
                HStack(spacing: 12) {
                   Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }

                    VStack(spacing: 1) {
                        Text(classifier.thai)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text(classifier.id)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
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

                ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    VStack(spacing: 12) {
                        // Thai Word - Centered
                        HStack(spacing: 12) {
                            Spacer()
                            VStack(spacing: 8) {
                                HStack(spacing: 8) {
                                    Text(classifier.thai)
                                        .font(.system(size: 64, weight: .bold))
                                        .foregroundColor(.white)

                                    Button(action: {
                                        AudioManager.shared.speakThai(classifier.thai)
                                    }) {
                                        Image(systemName: "speaker.wave.2.fill")
                                            .font(.title2)
                                            .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                                            .padding(8)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }

                                HStack(spacing: 8) {
                                    Text(classifier.romanization)
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                                        .fontDesign(.monospaced)

                                    Button(action: {
                                        AudioManager.shared.speakThai(classifier.romanization)
                                    }) {
                                        Image(systemName: "speaker.wave.1.fill")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                }
                            }
                            Spacer()
                        }

                        Text(localization.currentLanguage == "fr" ? classifier.frenchName : classifier.englishName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("\(localization.localize("classifier.lesson.used_for")) \(classifier.uses.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.85))
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 24)

                    VStack(spacing: 16) {
                        // Explanation Card
                        VStack(alignment: .leading, spacing: 14) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "book.fill")
                                        .foregroundColor(.cyan)
                                    Text(localization.localize("classifier.lesson.usage"))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.cyan)
                                }

                                Text(localization.currentLanguage == "fr" ? classifier.frenchExplanation : classifier.explanation)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .lineLimit(nil)
                            }

                            Divider()
                                .background(Color.white.opacity(0.2))

                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.yellow)
                                    Text(localization.localize("classifier.lesson.why_matters"))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.yellow)
                                }

                                Text(localization.currentLanguage == "fr" ? classifier.whyMattersFrench : classifier.whyMatters)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.95))
                            }
                        }
                        .padding(16)
                        .background(Color.black.opacity(0.12))
                        .cornerRadius(12)

                        // Examples Section - Real vocabulary from dataset
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 8) {
                                Image(systemName: "book.fill")
                                    .foregroundColor(.green)
                                Text(localization.localize("classifier.lesson.examples"))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }

                            if !classifier.examples.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(Array(classifier.examples.prefix(4)), id: \.id) { example in
                                        VStack(alignment: .leading, spacing: 12) {
                                            // Thai word + audio
                                            HStack(spacing: 12) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(example.thai)
                                                        .font(.title3)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.white)

                                                    Text(example.romanization)
                                                        .font(.caption2)
                                                        .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                                                        .fontDesign(.monospaced)
                                                }

                                                Spacer()

                                                Button(action: { AudioManager.shared.speakThai(example.thai) }) {
                                                    Image(systemName: "speaker.wave.2.fill")
                                                        .foregroundColor(Color(red: 0.8, green: 0.6, blue: 0.4))
                                                        .padding(8)
                                                        .background(Color.white.opacity(0.15))
                                                        .cornerRadius(6)
                                                }
                                            }

                                            Divider()
                                                .background(Color.white.opacity(0.2))

                                            // Translation
                                            HStack(spacing: 8) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                                    .font(.caption)

                                                Text(localization.currentLanguage == "fr" ? (example.french.isEmpty ? example.english : example.french) : example.english)
                                                    .font(.body)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)

                                                Spacer()
                                            }
                                        }
                                        .padding(14)
                                        .background(Color.black.opacity(0.15))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.black.opacity(0.08))
                        .cornerRadius(12)

                        // Common Mistakes Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(localization.localize("classifier.lesson.common_mistakes"))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                            }

                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(Array(zip(classifier.commonMistakes, classifier.commonMistakesFrench)).indices, id: \.self) { index in
                                    let mistake = localization.currentLanguage == "fr" ? classifier.commonMistakesFrench[index] : classifier.commonMistakes[index]
                                    HStack(alignment: .top, spacing: 10) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .font(.caption)

                                        Text(mistake)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .lineLimit(4)
                                    }
                                    .padding(10)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.black.opacity(0.08))
                        .cornerRadius(12)

                        // Practice Button
                        NavigationLink(destination: ClassifierQuizView(
                            classifier: classifier,
                            onAnswer: { _ in }
                        )) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text(localization.localize("classifier.lesson.practice"))
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.white)
                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.8))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
}


#Preview {
    Text("Preview not available")
}
