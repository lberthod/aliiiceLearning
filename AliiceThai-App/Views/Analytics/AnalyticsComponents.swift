import SwiftUI

// MARK: - Speaking Level Card
struct SpeakingLevelCard: View {
    let speakingLevel: SpeakingLevel

    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                Text("Your Speaking Level")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(speakingLevel.level)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                        Text("\(speakingLevel.score)/100")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Progress to")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))

                        Text(speakingLevel.nextLevel)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        ProgressView(value: Double(speakingLevel.progressToNext) / 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 1.0, green: 0.75, blue: 0.3)))
                            .frame(height: 6)

                        Text("\(speakingLevel.progressToNext)%")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }

            Divider()
                .background(Color.white.opacity(0.2))

            // Component Breakdown
            VStack(spacing: 10) {
                ScoreComponentRow(
                    label: "Word Mastery",
                    value: speakingLevel.masteryScore,
                    icon: "star.fill",
                    color: Color(red: 1.0, green: 0.75, blue: 0.3)
                )

                ScoreComponentRow(
                    label: "Tone Accuracy",
                    value: speakingLevel.toneScore,
                    icon: "waveform.circle.fill",
                    color: Color(red: 0.5, green: 0.8, blue: 1.0)
                )

                ScoreComponentRow(
                    label: "Output Practice",
                    value: speakingLevel.outputScore,
                    icon: "mic.circle.fill",
                    color: Color(red: 0.8, green: 0.5, blue: 1.0)
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
    }
}

// MARK: - Score Component Row
struct ScoreComponentRow: View {
    let label: String
    let value: Int
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                ProgressView(value: Double(value) / 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: color))
                    .frame(height: 6)
            }

            Text("\(value)%")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 45, alignment: .trailing)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)

                Spacer()
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.08))
        .cornerRadius(10)
    }
}

// MARK: - Weak Tone Word Card
struct WeakToneWordCard: View {
    let word: WrappedWord
    let accuracy: Int
    let audioManager: AudioManager

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(word.core.thai)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(word.core.romanization.with_tone)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Text("\(accuracy)%")
                        .font(.headline)
                        .foregroundColor(accuracy < 50 ? Color.red : Color.yellow)

                    Button {
                        audioManager.playWord(thaiWord: word.core.thai)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                    }
                }

                ProgressView(value: Double(accuracy) / 100)
                    .progressViewStyle(LinearProgressViewStyle(
                        tint: accuracy < 50 ? Color.red : Color.yellow
                    ))
                    .frame(width: 80, height: 4)
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

// MARK: - Due Word Item
struct DueWordItem: View {
    let word: WrappedWord
    let daysUntilDue: Int
    let audioManager: AudioManager

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(word.core.thai)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                HStack(spacing: 4) {
                    Text(word.core.romanization.with_tone)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))

                    Text("•")
                        .foregroundColor(.white.opacity(0.5))

                    Text(word.core.translation.fr)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            Spacer()

            HStack(spacing: 10) {
                VStack(alignment: .trailing, spacing: 2) {
                    if daysUntilDue == 0 {
                        Text("Due today")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    } else if daysUntilDue == 1 {
                        Text("Tomorrow")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    } else {
                        Text("In \(daysUntilDue)d")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Button {
                    audioManager.playWord(thaiWord: word.core.thai)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

// MARK: - Empty State
struct AnalyticsEmptyState: View {
    let title: String
    let description: String
    let icon: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.5))

            Text(title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview {
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
            SpeakingLevelCard(
                speakingLevel: SpeakingLevel(
                    score: 45,
                    level: "A1.2",
                    progressToNext: 65,
                    masteryScore: 50,
                    toneScore: 40,
                    outputScore: 35
                )
            )

            StatCard(
                title: "Words Learned",
                value: "24",
                icon: "book.fill",
                color: Color(red: 1.0, green: 0.75, blue: 0.3)
            )

            Spacer()
        }
        .padding(16)
    }
}
