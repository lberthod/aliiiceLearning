import SwiftUI

struct NarrativeView: View {
    @ObservedObject var narrative = NarrativeFrame.shared
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss

    @State var selectedWeek: Int = 1
    @State var selectedSceneId: String?

    let storyOverview = NarrativeFrame.shared.getStoryOverview()

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

                    Text(localization.localize("narrative.title"))
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

                if selectedSceneId == nil {
                    // Main narrative view
                    ScrollView {
                        VStack(spacing: 16) {
                            // Story title
                            VStack(alignment: .center, spacing: 8) {
                                HStack {
                                    Image(systemName: "book.fill")
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                        .font(.title)

                                    Text(storyOverview.title)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }

                                Text(storyOverview.narrative)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .lineLimit(5)
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)

                            // Week selector
                            VStack(alignment: .leading, spacing: 12) {
                                Text(localization.localize("narrative.choose_week"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                HStack(spacing: 8) {
                                    ForEach(1...4, id: \.self) { week in
                                        WeekIndicator(
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

                            // Scenes for selected week
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(localization.localize("narrative.scenes"))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))

                                    Spacer()

                                    let progress = narrative.getSceneProgress(weekNumber: selectedWeek)
                                    Text("\(progress.completed)/\(progress.total)")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                }

                                VStack(spacing: 10) {
                                    ForEach(narrative.getScenesByWeek(selectedWeek), id: \.id) { scene in
                                        SceneCardButton(scene: scene, isCompleted: narrative.completedSceneIds.contains(scene.id)) {
                                            selectedSceneId = scene.id
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)

                            Spacer()
                        }
                        .padding(16)
                    }
                } else if let sceneId = selectedSceneId, let scene = narrative.getScene(id: sceneId) {
                    // Scene detail view
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Back button
                            Button {
                                selectedSceneId = nil
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .font(.caption)

                                    Text(localization.localize("narrative.back"))
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.white.opacity(0.08))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }

                            // Scene title
                            VStack(alignment: .leading, spacing: 8) {
                                Text(scene.title)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                Text(scene.setting)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)

                            // Narrative text
                            VStack(alignment: .leading, spacing: 8) {
                                Text(localization.localize("narrative.story"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                Text(scene.narrative)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .lineLimit(10)
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)

                            // Characters
                            VStack(alignment: .leading, spacing: 8) {
                                Text(localization.localize("narrative.characters"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(scene.characters, id: \.self) { character in
                                        HStack(spacing: 8) {
                                            Image(systemName: "person.fill")
                                                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                                .font(.caption)

                                            Text(character)
                                                .font(.caption)
                                                .foregroundColor(.white)
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

                            // Vocabulary themes
                            VStack(alignment: .leading, spacing: 8) {
                                Text(localization.localize("narrative.vocabulary"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(scene.vocabularyThemes, id: \.self) { theme in
                                        HStack(spacing: 8) {
                                            Image(systemName: "tag.fill")
                                                .foregroundColor(.green)
                                                .font(.caption)

                                            Text(theme)
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

                            // Mark as complete button
                            Button {
                                narrative.markSceneCompleted(id: sceneId)
                                selectedSceneId = nil
                            } label: {
                                HStack {
                                    Image(systemName: narrative.completedSceneIds.contains(sceneId) ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)

                                    Text(narrative.completedSceneIds.contains(sceneId) ? localization.localize("narrative.completed") : localization.localize("narrative.mark_complete"))
                                        .font(.body)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(narrative.completedSceneIds.contains(sceneId) ? Color.green : Color(red: 1.0, green: 0.75, blue: 0.3))
                                .foregroundColor(narrative.completedSceneIds.contains(sceneId) ? .white : .black)
                                .cornerRadius(8)
                            }

                            Spacer()
                        }
                        .padding(16)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SceneCardButton: View {
    let scene: NarrativeScene
    let isCompleted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(scene.title)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text(scene.setting)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()

                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isCompleted ? .green : Color(red: 1.0, green: 0.75, blue: 0.3))
                        .font(.title3)
                }

                Text(scene.narrative)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white.opacity(0.08))
            .cornerRadius(8)
        }
    }
}

struct WeekIndicator: View {
    let week: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text("W")
                    .font(.caption2)

                Text(String(week))
                    .font(.body)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color(red: 1.0, green: 0.75, blue: 0.3) : Color.white.opacity(0.1))
            .foregroundColor(isSelected ? .black : .white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    Text("Preview not available")
}
