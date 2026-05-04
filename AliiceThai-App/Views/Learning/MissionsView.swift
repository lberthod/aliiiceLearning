import SwiftUI

struct MissionsView: View {
    @ObservedObject var gameState = GameState.shared
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

                    Text("Missions")
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
                        // Active Mission
                        if let currentMission = gameState.currentMission {
                            VStack(spacing: 12) {
                                Text("Current Mission")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                ActiveMissionCard()
                            }
                        }

                        // All Missions
                        VStack(spacing: 8) {
                            Text("All Missions")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            let allMissions = Mission.allMissions
                            ForEach(allMissions, id: \.id) { mission in
                                NavigationLink(destination: MissionDetailView(mission: mission)) {
                                    MissionListItem(
                                        mission: mission,
                                        isCompleted: gameState.isMissionCompleted(mission.id),
                                        progress: gameState.getMissionProgress(mission.id),
                                        isCurrent: gameState.currentMission?.id == mission.id
                                    )
                                }
                            }
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

// MARK: - Mission List Item
struct MissionListItem: View {
    let mission: Mission
    let isCompleted: Bool
    let progress: Int
    let isCurrent: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                // Status indicator
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                } else if isCurrent {
                    Image(systemName: "flame.fill")
                        .font(.title3)
                        .foregroundColor(.orange)
                } else {
                    Image(systemName: "circle")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.3))
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(mission.title)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Spacer()

                        Text("Week \(mission.week)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Text(mission.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            // Progress bar if in progress or completed
            if !isCompleted || isCurrent {
                VStack(spacing: 4) {
                    HStack {
                        Text("\(progress)/\(mission.targetCount) words")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))

                        Spacer()

                        Text("\(min(Int(Double(progress) / Double(mission.targetCount) * 100), 100))%")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                    }

                    ProgressView(value: Double(progress) / Double(mission.targetCount))
                        .progressViewStyle(LinearProgressViewStyle(
                            tint: Color(red: 1.0, green: 0.75, blue: 0.3)
                        ))
                        .frame(height: 6)
                }
            }

            // Mission details
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "hourglass")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))

                    Text("\(mission.estimatedHours)h")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.orange)

                    Text("+\(mission.rewardXP) XP")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }

                HStack(spacing: 4) {
                    Image(systemName: "tag")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))

                    Text(mission.type.capitalized)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }
        }
        .padding(12)
        .background(Color.white.opacity(isCurrent ? 0.12 : 0.08))
        .cornerRadius(10)
        .border(Color(red: 1.0, green: 0.75, blue: 0.3).opacity(isCurrent ? 0.5 : 0), width: isCurrent ? 2 : 0)
    }
}

#Preview {
    MissionsView()
        .environmentObject(GameState())
}
