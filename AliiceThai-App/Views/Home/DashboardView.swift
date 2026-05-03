import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var loc = LocalizationManager.shared
    @State private var showSettings = false

    let learningModules: [(title: String, titleFr: String, icon: String, color: (Double, Double, Double), description: String, descriptionFr: String)] = [
        (
            title: "Today's Lessons",
            titleFr: "Leçons du jour",
            icon: "📅",
            color: (0.9, 0.4, 0.6),
            description: "Daily vocabulary lesson",
            descriptionFr: "Leçon de vocabulaire quotidienne"
        ),
        (
            title: "Categories",
            titleFr: "Catégories",
            icon: "📚",
            color: (0.4, 0.6, 0.9),
            description: "Browse by category",
            descriptionFr: "Parcourir par catégorie"
        ),
        (
            title: "Alphabet",
            titleFr: "Alphabet",
            icon: "🔤",
            color: (0.9, 0.6, 0.2),
            description: "Learn Thai letters",
            descriptionFr: "Apprenez les lettres thaïes"
        ),
        (
            title: "Numbers",
            titleFr: "Nombres",
            icon: "🔢",
            color: (0.2, 0.8, 0.6),
            description: "Learn counting",
            descriptionFr: "Apprenez à compter"
        ),
        (
            title: "Phrases",
            titleFr: "Phrases",
            icon: "💬",
            color: (0.8, 0.4, 0.6),
            description: "Common phrases",
            descriptionFr: "Phrases courantes"
        ),
        (
            title: "Grammar",
            titleFr: "Grammaire",
            icon: "✏️",
            color: (0.6, 0.4, 0.9),
            description: "Basic grammar rules",
            descriptionFr: "Règles de grammaire"
        ),
        (
            title: "Pronunciation",
            titleFr: "Prononciation",
            icon: "🎤",
            color: (0.9, 0.4, 0.4),
            description: "Tone & sounds",
            descriptionFr: "Tons et sons"
        ),
        (
            title: "Classifiers",
            titleFr: "Classificateurs",
            icon: "📦",
            color: (0.8, 0.6, 0.4),
            description: "Master Thai quantity words",
            descriptionFr: "Maîtriser les quantificateurs thaïs"
        ),
        (
            title: "Tones Mastery",
            titleFr: "Maîtrise des Tons",
            icon: "🎵",
            color: (0.6, 0.8, 0.9),
            description: "Learn Thai tone system",
            descriptionFr: "Apprenez le système des tons thaïs"
        )
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.8), Color(red: 0.8, green: 0.2, blue: 0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            NavigationStack {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(gameState.selectedLanguage == "fr" ? "Apprendre le Thaï" : "Learn Thai")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            Text(gameState.selectedLanguage == "fr" ? "Choisissez un sujet" : "Choose a topic")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(20)

                    // Navigation Bar
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            NavigationLink(destination: TodayLessonsView()) {
                                Text("📅")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.9, green: 0.4, blue: 0.6))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: CategoryVocabularyView()) {
                                Text("📚")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.4, green: 0.6, blue: 0.9))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: AlphabetView()) {
                                Text("🔤")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.9, green: 0.6, blue: 0.2))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: NumbersView()) {
                                Text("🔢")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.2, green: 0.8, blue: 0.6))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: PhrasesView()) {
                                Text("💬")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.8, green: 0.4, blue: 0.6))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: GrammarView()) {
                                Text("✏️")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: PronunciationView()) {
                                Text("🎤")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.9, green: 0.4, blue: 0.4))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: ClassifiersView()) {
                                Text("📦")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.8, green: 0.6, blue: 0.4))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: TonesView()) {
                                Text("🎵")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 12)
                                    .background(Color(red: 0.6, green: 0.8, blue: 0.9))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 8)

                    // Learning Modules Grid
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Array(learningModules.enumerated()), id: \.offset) { index, module in
                                if index % 2 == 0 {
                                    HStack(spacing: 12) {
                                        // First module
                                        NavigationLink(destination: getDestinationView(for: index)) {
                                            ModuleCard(
                                                icon: module.icon,
                                                title: gameState.selectedLanguage == "fr" ? module.titleFr : module.title,
                                                description: gameState.selectedLanguage == "fr" ? module.descriptionFr : module.description,
                                                color: module.color
                                            )
                                        }

                                        // Second module (if exists)
                                        if index + 1 < learningModules.count {
                                            let nextModule = learningModules[index + 1]
                                            NavigationLink(destination: getDestinationView(for: index + 1)) {
                                                ModuleCard(
                                                    icon: nextModule.icon,
                                                    title: gameState.selectedLanguage == "fr" ? nextModule.titleFr : nextModule.title,
                                                    description: gameState.selectedLanguage == "fr" ? nextModule.descriptionFr : nextModule.description,
                                                    color: nextModule.color
                                                )
                                            }
                                        } else {
                                            Spacer()
                                        }
                                    }
                                }
                            }

                            Spacer(minLength: 20)
                        }
                        .padding(16)
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    }

    @ViewBuilder
    func getDestinationView(for index: Int) -> some View {
        switch index {
        case 0:
            TodayLessonsView()
        case 1:
            CategoryVocabularyView()
        case 2:
            AlphabetView()
        case 3:
            NumbersView()
        case 4:
            PhrasesView()
        case 5:
            GrammarView()
        case 6:
            PronunciationView()
        case 7:
            ClassifiersView()
        case 8:
            TonesView()
        default:
            TodayLessonsView()
        }
    }
}

struct ModuleCard: View {
    let icon: String
    let title: String
    let description: String
    let color: (Double, Double, Double)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(icon)
                    .font(.system(size: 36))
                Spacer()
            }

            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            Text(description)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)

            Spacer()

            HStack {
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .padding(16)
        .background(Color(red: color.0, green: color.1, blue: color.2))
        .cornerRadius(16)
        .opacity(0.9)
    }
}

struct ComingSoonView: View {
    @Environment(\.presentationMode) var presentationMode
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.8), Color(red: 0.8, green: 0.2, blue: 0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(20)

                Spacer()

                VStack(spacing: 20) {
                    Text(icon)
                        .font(.system(size: 80))

                    Text(title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Text("🚀 Coming Soon")
                        .font(.system(size: 18))
                        .foregroundColor(.yellow)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)

                    Text("This module is being developed")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding(20)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DashboardView()
        .environmentObject(GameState())
        .environmentObject(GameViewModel())
}
