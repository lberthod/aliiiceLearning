import SwiftUI

struct DailyChallengeWidget: View {
    @ObservedObject var gameState = GameState.shared

    var body: some View {
        VStack(spacing: 12) {
            if let challenge = gameState.currentChallenge {
                // Header with flame streak
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            if gameState.streakDays > 0 {
                                Text("🔥 \(gameState.streakDays)-day streak")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                            } else {
                                Text("Daily Challenge")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                            }
                        }

                        Text(challenge.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    if challenge.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }

                Text(challenge.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Progress Bar
                VStack(spacing: 6) {
                    HStack {
                        Text("\(challenge.progressCount)/\(challenge.targetCount)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Spacer()

                        Text("\(challenge.progressPercentage)%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(challenge.isCompleted ? Color.green : Color(red: 1.0, green: 0.75, blue: 0.3))
                    }

                    ProgressView(value: Double(challenge.progressPercentage) / 100)
                        .progressViewStyle(LinearProgressViewStyle(
                            tint: challenge.isCompleted ? Color.green : Color(red: 1.0, green: 0.75, blue: 0.3)
                        ))
                        .frame(height: 8)
                }

                // Motivational message
                if !challenge.isCompleted {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption)
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                        if challenge.progressPercentage == 0 {
                            Text("Start now to build your streak!")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        } else if challenge.progressPercentage < 50 {
                            Text("You're halfway there!")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        } else {
                            Text("Almost done! Keep it up!")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(6)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.green)

                        Text("Challenge complete! Come back tomorrow for a new one.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
                }
            } else {
                // No challenge state
                VStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.5))

                    Text("Loading your daily challenge...")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.white.opacity(0.05))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
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
            DailyChallengeWidget()
            Spacer()
        }
        .padding(16)
    }
}
