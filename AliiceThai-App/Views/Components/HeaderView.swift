import SwiftUI

struct HeaderView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var loc = LocalizationManager.shared

    let title: String
    let subtitle: String
    let showBackButton: Bool
    let showHomeButton: Bool
    let onBackTap: (() -> Void)?
    let onHomeTap: (() -> Void)?

    init(
        title: String,
        subtitle: String,
        showBackButton: Bool = true,
        showHomeButton: Bool = true,
        onBackTap: (() -> Void)? = nil,
        onHomeTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showBackButton = showBackButton
        self.showHomeButton = showHomeButton
        self.onBackTap = onBackTap
        self.onHomeTap = onHomeTap
    }

    var body: some View {
        HStack {
            if showBackButton {
                Button(action: {
                    if let onBackTap = onBackTap {
                        onBackTap()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
            } else {
                Spacer()
                    .frame(width: 50)
            }

            Spacer()

            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            if showHomeButton {
                NavigationLink(destination: DashboardView()) {
                    Image(systemName: "house.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
            } else {
                Spacer()
                    .frame(width: 50)
            }
        }
        .padding(20)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.9, green: 0.4, blue: 0.6), Color(red: 0.4, green: 0.2, blue: 0.9)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack {
            HeaderView(
                title: "Today's Lesson",
                subtitle: "8 words"
            )
            Spacer()
        }
    }
    .environmentObject(GameState())
    .environmentObject(GameViewModel())
}
