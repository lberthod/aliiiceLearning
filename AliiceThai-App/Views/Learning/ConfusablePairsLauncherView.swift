import SwiftUI

struct ConfusablePairsLauncherView: View {
    @State var isLoading = true
    @State var pairCount = 0
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

            VStack(spacing: 20) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }

                    Text("Confusable Pairs")
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

                if isLoading {
                    VStack {
                        ProgressView()
                            .tint(.orange)
                        Text("Loading pairs...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    VStack(spacing: 20) {
                        VStack(alignment: .center, spacing: 15) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.orange)

                            VStack(spacing: 8) {
                                Text("Learn Confusable Words")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("\(pairCount) pairs to study")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))

                                Text("Understand what makes similar words different")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)

                        NavigationLink(destination: ConfusablePairsView()) {
                            HStack {
                                Text("Start Learning →")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(12)
                            .background(Color.orange)
                            .cornerRadius(8)
                        }

                        Spacer()
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadPairCount()
        }
    }

    func loadPairCount() {
        DispatchQueue.main.async {
            if let allWords = JSONWordParser.shared.loadWordsFromJSON() {
                var count = 0

                for word in allWords {
                    count += word.relations.confusable_with.count
                }

                pairCount = count / 2  // Divide by 2 because each pair is counted twice
            }
            isLoading = false
        }
    }
}

#Preview {
    Text("Preview not available")
}
