import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showResetConfirm = false
    @State private var showResetSuccess = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.8), Color(red: 0.8, green: 0.2, blue: 0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
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
                        Text(loc.localize("settings.title"))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("⚙️")
                            .font(.system(size: 24))
                    }
                    .padding(20)

                    ScrollView {
                        VStack(spacing: 20) {
                            // LANGUAGE SECTION
                            SettingSection(title: loc.localize("settings.language")) {
                                VStack(spacing: 12) {
                                    Text(loc.localize("settings.currentlanguage"))
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.8))

                                    HStack(spacing: 12) {
                                        Button(action: {
                                            gameState.selectedLanguage = "en"
                                            AudioManager.shared.playCategorySelectSound()
                                        }) {
                                            VStack(spacing: 8) {
                                                Text("🇬🇧")
                                                    .font(.system(size: 40))
                                                Text("English")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 100)
                                            .background(gameState.selectedLanguage == "en" ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.white.opacity(0.15))
                                            .cornerRadius(12)
                                        }

                                        Button(action: {
                                            gameState.selectedLanguage = "fr"
                                            AudioManager.shared.playCategorySelectSound()
                                        }) {
                                            VStack(spacing: 8) {
                                                Text("🇫🇷")
                                                    .font(.system(size: 40))
                                                Text("Français")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 100)
                                            .background(gameState.selectedLanguage == "fr" ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.white.opacity(0.15))
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                            }

                            // PROFILE SECTION
                            SettingSection(title: loc.localize("settings.profile")) {
                                VStack(spacing: 12) {
                                    SettingRow(label: loc.localize("settings.appname"), value: "AliiceThai 🌏")
                                    SettingRow(label: loc.localize("settings.version"), value: "1.0")
                                }
                            }

                            // STATISTICS SECTION
                            SettingSection(title: loc.localize("settings.stats")) {
                                VStack(spacing: 12) {
                                    let totalWords = gameViewModel.allWords.count
                                    let totalCategories = gameViewModel.categories.count
                                    let totalStars = gameState.bestStarsByCategory.values.reduce(0, +)
                                    let totalWordsAcquired = min(totalStars / 3, totalWords)

                                    SettingRow(label: loc.localize("settings.total_words"), value: "\(totalWords)")
                                    SettingRow(label: gameState.selectedLanguage == "fr" ? "Mots acquis" : "Words acquired", value: "\(totalWordsAcquired)/\(totalWords)")
                                    SettingRow(label: loc.localize("settings.categories"), value: "\(totalCategories)")
                                    SettingRow(label: loc.localize("settings.total_stars"), value: "\(totalStars) ⭐")

                                    if let bestCat = gameState.bestStarsByCategory.max(by: { $0.value < $1.value })?.key {
                                        SettingRow(label: loc.localize("settings.best_category"), value: loc.localize("category.\(bestCat)"))
                                    }
                                }
                            }

                            // PROGRESS BY CATEGORY
                            SettingSection(title: gameState.selectedLanguage == "fr" ? "📊 Progrès par catégorie" : "📊 Progress by Category") {
                                VStack(spacing: 8) {
                                    ForEach(gameViewModel.categories.sorted(), id: \.self) { category in
                                        let categoryWords = gameViewModel.allWords.filter { $0.category == category }.count
                                        let categoryStars = gameState.getBestStars(for: category)
                                        let categoryWordsAcquired = categoryStars > 0 ? min(categoryStars / 3, categoryWords) : 0

                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(loc.localize("category.\(category)"))
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Text("\(categoryWordsAcquired)/\(categoryWords)")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.cyan)
                                            }

                                            // Progress bar
                                            GeometryReader { geometry in
                                                ZStack(alignment: .leading) {
                                                    Color.white.opacity(0.1)

                                                    if categoryWords > 0 {
                                                        Color(red: 0.2, green: 0.8, blue: 0.4)
                                                            .frame(width: geometry.size.width * CGFloat(categoryWordsAcquired) / CGFloat(categoryWords))
                                                    }
                                                }
                                                .cornerRadius(4)
                                            }
                                            .frame(height: 8)
                                        }
                                        .padding(10)
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(8)
                                    }
                                }
                            }

                            // ABOUT SECTION
                            SettingSection(title: loc.localize("settings.about")) {
                                VStack(spacing: 12) {
                                    Text("Made with ❤️ for children learning Thai")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.9))
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                        .padding()

                                    HStack(spacing: 16) {
                                        VStack(spacing: 6) {
                                            Text("400+")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.yellow)
                                            Text("Words")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)

                                        VStack(spacing: 6) {
                                            Text("20+")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.cyan)
                                            Text("Categories")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)

                                        VStack(spacing: 6) {
                                            Text("3")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.pink)
                                            Text("Languages")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                }
                            }

                            // DANGER ZONE
                            SettingSection(title: "⚠️ " + loc.localize("settings.reset")) {
                                Button(action: { showResetConfirm = true }) {
                                    Text(loc.localize("settings.reset"))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.red.opacity(0.7))
                                        .cornerRadius(10)
                                }
                            }

                            Spacer(minLength: 20)
                        }
                        .padding(20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(loc.localize("settings.reset.confirm"), isPresented: $showResetConfirm) {
            Button(loc.localize("settings.reset.cancel"), role: .cancel) { }
            Button(loc.localize("settings.reset.yes"), role: .destructive) {
                gameState.bestStarsByCategory = [:]
                gameState.currentStars = 0
                gameState.saveState()
                showResetSuccess = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showResetSuccess = false
                }
            }
        } message: {
            Text(loc.localize("settings.reset.warning"))
        }
        .alert("✅ " + loc.localize("settings.reset.done"), isPresented: $showResetSuccess) {
            Button("OK") { }
        }
    }
}

struct SettingSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal)

            VStack(spacing: 12) {
                content()
            }
            .padding(16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct SettingRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.yellow)
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    SettingsView()
        .environmentObject(GameState())
        .environmentObject(GameViewModel())
}
