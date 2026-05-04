import Foundation

struct ConfusablePair: Identifiable {
    let id: String
    let word1: WrappedWord
    let word2: WrappedWord
    let reason: String
    var isStudied: Bool = false

    var displayId: String {
        "\(word1.id)_\(word2.id)"
    }
}
