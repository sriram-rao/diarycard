import SwiftData
import SwiftUI

#Preview("Default Card", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    NavigationStack {
        CardView(card: cards.first!)
    }
}

#Preview("Default Cards Search View", traits: .cardSampleData) {
    CardsView()
}


#Preview("App Start View", traits: .cardSampleData) {
    StartView()
}
