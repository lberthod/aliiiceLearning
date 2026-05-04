import SwiftUI

struct ActiveMissionCard: View {
    @ObservedObject var gameState = GameState.shared
    let audioManager = AudioManager.shared

    var body: some View {
        VStack(spacing: 12) {
            if let mission = gameState.currentMission {
                // Header with mission info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Active Mission")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)

                            Text(mission.title)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        // XP Display
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("+\(mission.rewardXP) XP")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                            Text("Total: \(gameState.totalXP)")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }

                    Text(mission.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }

                Divider()
                    .background(Color.white.opacity(0.2))

                // Progress Section
                let progress = gameState.getMissionProgress(mission.id)
                let percentage = min(Int(Double(progress) / Double(mission.targetCount) * 100), 100)

                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Progress")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))

                            HStack(spacing: 4) {
                                Text("\(progress)/\(mission.targetCount)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                Text("words")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }

                        Spacer()

                        if percentage >= 100 {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.headline)

                                Text("Complete!")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }
                        } else {
                            Text("\(percentage)%")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                        }
                    }

                    ProgressView(value: Double(percentage) / 100)
                        .progressViewStyle(LinearProgressViewStyle(
                            tint: percentage >= 100 ? Color.green : Color(red: 1.0, green: 0.75, blue: 0.3)
                        ))
                        .frame(height: 8)
                }

                Divider()
                    .background(Color.white.opacity(0.2))

                // Mission Info Grid
                HStack(spacing: 12) {
                    MissionInfoPill(
                        icon: "hourglass",
                        label: "Est.",
                        value: "\(mission.estimatedHours)h"
                    )

                    MissionInfoPill(
                        icon: "target",
                        label: "Type",
                        value: mission.type.capitalized
                    )

                    MissionInfoPill(
                        icon: "tag",
                        label: "Week",
                        value: "\(mission.week)"
                    )
                }
            } else {
                // No mission state
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)

                    Text("All Missions Complete!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("You've mastered all available missions")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))

                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.9, blue: 0.0))

                        Text("Total XP: \(gameState.totalXP)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
    }
}

// MARK: - Mission Info Pill
struct MissionInfoPill: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(6)
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
            ActiveMissionCard()
            Spacer()
        }
        .padding(16)
    }
}
