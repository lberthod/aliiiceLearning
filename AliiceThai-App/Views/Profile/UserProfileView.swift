import SwiftUI

struct UserProfileView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var gameViewModel = GameViewModel.shared
    @Environment(\.dismiss) var dismiss

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

                    Text("My Profile")
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

                ScrollView {
                    VStack(spacing: 16) {
                        // User Stats Summary
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Level Progress")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))

                                    let level = gameViewModel.calculateSpeakingLevel()
                                    Text(level.level)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Total XP")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))

                                    Text(String(gameState.totalXP))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(10)

                        // Core Stats
                        VStack(spacing: 10) {
                            Text("Core Statistics")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            HStack(spacing: 10) {
                                StatBox(
                                    title: "Words Learned",
                                    value: String(gameState.learnedPhrases.count),
                                    icon: "book.fill",
                                    color: Color(red: 1.0, green: 0.75, blue: 0.3)
                                )

                                StatBox(
                                    title: "Current Streak",
                                    value: String(gameState.streakDays),
                                    icon: "flame.fill",
                                    color: .red
                                )

                                StatBox(
                                    title: "Stars Earned",
                                    value: String(gameState.currentStars),
                                    icon: "star.fill",
                                    color: .yellow
                                )
                            }
                        }

                        // Mission Stats
                        VStack(spacing: 10) {
                            Text("Mission Progress")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            let completedCount = gameState.completedMissions.count
                            let totalCount = Mission.allMissions.count
                            let completionPercent = totalCount > 0 ? Int(Double(completedCount) / Double(totalCount) * 100) : 0

                            VStack(spacing: 8) {
                                HStack {
                                    Text("Missions Completed")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))

                                    Spacer()

                                    Text("\(completedCount)/\(totalCount)")
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }

                                ProgressView(value: Double(completionPercent) / 100)
                                    .progressViewStyle(LinearProgressViewStyle(
                                        tint: Color(red: 1.0, green: 0.75, blue: 0.3)
                                    ))
                                    .frame(height: 10)

                                Text("\(completionPercent)% Complete")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(10)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        }

                        // Learning Stats
                        VStack(spacing: 10) {
                            Text("Learning Stats")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            let level = gameViewModel.calculateSpeakingLevel()

                            VStack(spacing: 8) {
                                HStack {
                                    Label("Mastery Score", systemImage: "star.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))

                                    Spacer()

                                    Text("\(level.masteryScore)%")
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }

                                HStack {
                                    Label("Tone Accuracy", systemImage: "waveform.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))

                                    Spacer()

                                    Text("\(level.toneScore)%")
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }

                                HStack {
                                    Label("Output Practice", systemImage: "mic.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))

                                    Spacer()

                                    Text("\(level.outputScore)%")
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(10)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        }

                        // Daily Challenge
                        if let challenge = gameState.currentChallenge {
                            VStack(spacing: 10) {
                                Text("Today's Challenge")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                VStack(spacing: 8) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(challenge.title)
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)

                                            Text(challenge.description)
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))
                                        }

                                        Spacer()

                                        if challenge.isCompleted {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.title3)
                                        }
                                    }

                                    ProgressView(value: Double(challenge.progressPercentage) / 100)
                                        .progressViewStyle(LinearProgressViewStyle(
                                            tint: challenge.isCompleted ? Color.green : Color(red: 1.0, green: 0.75, blue: 0.3)
                                        ))
                                        .frame(height: 8)

                                    Text("\(challenge.progressCount)/\(challenge.targetCount)")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(10)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                            }
                        }

                        // Data Persistence Status
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)

                                Text("All data is being automatically saved")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                Spacer()
                            }

                            Text("Your progress, missions, challenges, and XP are synced securely.")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(10)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)

                        Spacer(minLength: 20)
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Stat Box
struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(title)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.white.opacity(0.08))
        .cornerRadius(8)
    }
}

#Preview {
    UserProfileView()
}
