import SwiftUI

struct HomeView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Curriculum Tab
            NavigationStack {
                CurriculumHomeView()
            }
            .tabItem {
                Label(localization.localize("home.curriculum"), systemImage: "book.fill")
            }
            .tag(0)

            // Learning Tab
            NavigationStack {
                LearningHomeView()
            }
            .tabItem {
                Label(localization.localize("home.learning"), systemImage: "waveform")
            }
            .tag(1)

            // Word Library Tab
            NavigationStack {
                WordLibraryView()
            }
            .tabItem {
                Label(localization.localize("home.library"), systemImage: "book.circle")
            }
            .tag(2)

            // Progress Tab
            NavigationStack {
                ProgressTabView()
            }
            .tabItem {
                Label(localization.localize("home.progress"), systemImage: "chart.bar")
            }
            .tag(3)
        }
    }
}

// CURRICULUM HOME
struct CurriculumHomeView: View {
    @ObservedObject var localization = LocalizationManager.shared
    let curriculum = CurriculumPath.shared
    let narrative = NarrativeFrame.shared

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

            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 8) {
                        Text(localization.localize("curriculum.title"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Week 1-4 Learning Journey")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)

                    // Curriculum Path
                    NavigationLink(destination: CurriculumPathView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "target")
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                    .font(.title3)

                                Text("Learning Path")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.5))
                            }

                            Text("4-week A1→A2 progression with weekly missions")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                    }

                    // Narrative
                    NavigationLink(destination: NarrativeView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                    .font(.title3)

                                Text("Story: Alice's Thailand Journey")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.5))
                            }

                            Text("8 narrative scenes - Airport → Bangkok → Markets → Directions")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                    }

                    Spacer()
                }
                .padding(16)
            }
        }
        .navigationTitle("Curriculum")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// LEARNING HOME
struct LearningHomeView: View {
    @ObservedObject var localization = LocalizationManager.shared

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

            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Learning Modes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Choose your practice method")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)

                    // PHASE 1: TONE
                    VStack(spacing: 10) {
                        Text("Phase 1: Tone Mastery")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        NavigationLink(destination: TonesView()) {
                            LearningModeCard(
                                icon: "waveform",
                                title: "Tone Lessons",
                                description: "Side-by-side tone comparison"
                            )
                        }

                        NavigationLink(destination: ToneQuizLauncherView()) {
                            LearningModeCard(
                                icon: "music.note.list",
                                title: "Tone Quiz",
                                description: "Identify tones 1-5 by ear"
                            )
                        }
                    }

                    // PHASE 2: OUTPUT
                    VStack(spacing: 10) {
                        Text("Phase 2: Output Tasks")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        NavigationLink(destination: OutputTasksLauncherView()) {
                            LearningModeCard(
                                icon: "mic.circle",
                                title: "Speaking Tasks",
                                description: "Shadowing, cloze, transcription, translation"
                            )
                        }
                    }

                    // PHASE 2.2: LISTENING
                    VStack(spacing: 10) {
                        Text("Phase 2.2: Listening Immersion")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        NavigationLink(destination: ListeningLauncherView()) {
                            LearningModeCard(
                                icon: "speaker.wave.2",
                                title: "Listening Practice",
                                description: "Variable speed word listening"
                            )
                        }

                        NavigationLink(destination: ContextualListeningView()) {
                            LearningModeCard(
                                icon: "text.bubble",
                                title: "Contextual Listening",
                                description: "Hear phrases, identify meaning"
                            )
                        }

                        NavigationLink(destination: AudioDictionaryLauncherView()) {
                            LearningModeCard(
                                icon: "book.circle",
                                title: "Audio Dictionary",
                                description: "Search words, hear variants"
                            )
                        }
                    }

                    // PHASE 4: CONFUSABLE PAIRS
                    VStack(spacing: 10) {
                        Text("Phase 4: Advanced Learning")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        NavigationLink(destination: ConfusablePairsLauncherView()) {
                            LearningModeCard(
                                icon: "questionmark.circle",
                                title: "Confusable Pairs",
                                description: "Learn words that are easily confused"
                            )
                        }

                        NavigationLink(destination: MissionsView()) {
                            LearningModeCard(
                                icon: "target",
                                title: "Missions",
                                description: "Complete curriculum missions for rewards"
                            )
                        }
                    }

                    Spacer()
                }
                .padding(16)
            }
        }
        .navigationTitle("Learning")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// PROGRESS VIEW
struct ProgressTabView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared

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

            ScrollView {
                VStack(spacing: 16) {
                    // Active Mission Card
                    ActiveMissionCard()

                    // Daily Challenge Widget
                    DailyChallengeWidget()

                    VStack(spacing: 8) {
                        Text("Progress Metrics")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)

                        Text("Track your learning journey")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)

                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Stars")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                Text(String(gameState.currentStars))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Words Learned")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                Text(String(gameState.learnedPhrases.count))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)
                        }

                        NavigationLink(destination: AnalyticsDashboard()) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                    .font(.title3)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("View Full Analytics")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)

                                    Text("Speaking level, weak areas, due words")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)
                        }
                    }

                    NavigationLink(destination: UserProfileView()) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("View Full Profile")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                Text("Complete stats, missions, and achievements")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(8)
                    }

                    Spacer(minLength: 20)
                }
                .padding(16)
            }
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// LEARNING MODE CARD
struct LearningModeCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
}
