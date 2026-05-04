import SwiftUI

struct MissionDetailView: View {
    @ObservedObject var gameState = GameState.shared
    let mission: Mission
    @Environment(\.dismiss) var dismiss
    @State var selectedAction: MissionAction?

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

                    Text(mission.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    if gameState.isMissionCompleted(mission.id) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.green)
                    } else {
                        Text("Week \(mission.week)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.08))

                ScrollView {
                    VStack(spacing: 16) {
                        // Mission Header with XP and Time
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(mission.longDescription)
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .lineLimit(nil)
                                }

                                Spacer()
                            }

                            HStack(spacing: 12) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)

                                    Text("+\(mission.rewardXP) XP")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(6)

                                HStack(spacing: 4) {
                                    Image(systemName: "hourglass")
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                    Text("~\(mission.estimatedHours)h")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(6)

                                Spacer()
                            }
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(10)

                        // Progress Section
                        if !gameState.isMissionCompleted(mission.id) {
                            let progress = gameState.getMissionProgress(mission.id)
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Mission Progress")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.orange)

                                    Spacer()

                                    Text("\(progress)/\(mission.targetCount)")
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }

                                ProgressView(value: Double(progress) / Double(mission.targetCount))
                                    .progressViewStyle(LinearProgressViewStyle(
                                        tint: Color(red: 1.0, green: 0.75, blue: 0.3)
                                    ))
                                    .frame(height: 10)
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(10)
                        }

                        // Actions/Steps Section
                        VStack(spacing: 10) {
                            Text("Mission Steps")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(mission.actions, id: \.step) { action in
                                ActionCard(
                                    action: action,
                                    mission: mission,
                                    isSelected: selectedAction?.step == action.step,
                                    onTap: {
                                        selectedAction = action
                                    }
                                )
                            }
                        }

                        // Start Mission Button
                        if !gameState.isMissionCompleted(mission.id) {
                            NavigationLink(destination: MissionExercisesView(mission: mission)) {
                                HStack {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 16))

                                    Text("Start Mission →")
                                        .font(.body)
                                        .fontWeight(.semibold)

                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        } else {
                            VStack(spacing: 8) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)

                                    Text("Mission Completed! 🎉")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)

                                    Spacer()
                                }

                                Text("You've earned \(mission.rewardXP) XP and can now move to the next mission!")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(14)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                        }

                        // Vocabulary List
                        VStack(spacing: 8) {
                            Text("Vocabulary to Master (\(mission.vocabulary.count) words)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(mission.vocabulary.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(10)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
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

// MARK: - Action Card
struct ActionCard: View {
    let action: MissionAction
    let mission: Mission
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Step \(action.step)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                        Text(action.title)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Spacer()

                        Image(systemName: getIconForExerciseType(action.exerciseType))
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                    }

                    Text(action.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }

            HStack(spacing: 8) {
                Text("Target: \(action.targetCount)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))

                Spacer()

                NavigationLink(destination: getExerciseDestination(action)) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right")
                            .font(.caption2)

                        Text("Go")
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(isSelected ? 0.12 : 0.08))
        .cornerRadius(8)
        .onTapGesture {
            onTap()
        }
    }

    private func getIconForExerciseType(_ type: String) -> String {
        switch type {
        case "vocabulary": return "book.fill"
        case "tone": return "waveform.circle.fill"
        case "output": return "mic.circle.fill"
        case "listening": return "speaker.wave.2.fill"
        default: return "play.circle.fill"
        }
    }

    @ViewBuilder
    private func getExerciseDestination(_ action: MissionAction) -> some View {
        switch action.exerciseType {
        case "vocabulary":
            CategoryVocabularyView()
        case "tone":
            ToneQuizLauncherView()
        case "output":
            OutputTasksLauncherView()
        case "listening":
            ListeningLauncherView()
        default:
            CategoryVocabularyView()
        }
    }
}

// MARK: - Exercises View (Container for the mission)
struct MissionExercisesView: View {
    let mission: Mission
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            CategoryVocabularyView()
        }
    }
}

#Preview {
    MissionDetailView(mission: Mission.allMissions.first ?? Mission.allMissions[0])
}
