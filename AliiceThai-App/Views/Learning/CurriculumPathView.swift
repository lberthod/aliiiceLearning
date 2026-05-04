import SwiftUI

struct CurriculumPathView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss

    @State var selectedWeek: Int = 1
    let curriculumPath = CurriculumPath.shared

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

                    Text(localization.localize("curriculum.title"))
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

                ScrollView {
                    VStack(spacing: 16) {
                        // Week selector
                        VStack(alignment: .leading, spacing: 12) {
                            Text(localization.localize("curriculum.choose_week"))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))

                            HStack(spacing: 8) {
                                ForEach(1...4, id: \.self) { week in
                                    WeekButton(
                                        week: week,
                                        isSelected: selectedWeek == week
                                    ) {
                                        selectedWeek = week
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)

                        // Week content
                        if let currentWeek = curriculumPath.getWeekSchedule(weekNumber: selectedWeek) {
                            // Goal section
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "target")
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(localization.localize("curriculum.week_goal"))
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))

                                        Text(currentWeek.goal)
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    }
                                }

                                Text(currentWeek.description)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .lineLimit(3)
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)

                            // Mission briefing
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "map.fill")
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                        .font(.title3)

                                    Text(localization.localize("curriculum.mission"))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(currentWeek.missionTitle)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                    Text(currentWeek.missionDescription)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineLimit(3)
                                }

                                NavigationLink(destination: MissionsView()) {
                                    HStack {
                                        Text(localization.localize("curriculum.start_mission"))
                                            .font(.caption)
                                            .fontWeight(.semibold)

                                        Image(systemName: "arrow.right")
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                }
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)

                            // Skills focus
                            VStack(alignment: .leading, spacing: 12) {
                                Text(localization.localize("curriculum.skills"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(currentWeek.skillFocus, id: \.self) { skill in
                                        HStack(spacing: 8) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.caption)

                                            Text(skill)
                                                .font(.caption)
                                                .foregroundColor(.white)

                                            Spacer()
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)

                            // Progress
                            VStack(alignment: .leading, spacing: 12) {
                                Text(localization.localize("curriculum.progress"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(currentWeek.targetWordCount) " + localization.localize("curriculum.words"))
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))

                                        Text(String(currentWeek.targetWordCount))
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(8)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(localization.localize("curriculum.exercises"))
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))

                                        Text(String(currentWeek.listeningExercises + currentWeek.outputTasks))
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                        }

                        Spacer()
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WeekButton: View {
    let week: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text("Week")
                    .font(.caption2)

                Text(String(week))
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                isSelected
                    ? Color(red: 1.0, green: 0.75, blue: 0.3)
                    : Color.white.opacity(0.1)
            )
            .foregroundColor(isSelected ? .black : .white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    Text("Preview not available")
}
