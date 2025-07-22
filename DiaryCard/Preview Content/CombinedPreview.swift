import SwiftData
import SwiftUI

#Preview("Export View") {
    ExportView()
}

#Preview("Default Card", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    NavigationStack {
        CardView(card: cards.first!)
    }
}

#Preview("Default Cards Search View", traits: .cardSampleData) {
    NavigationStack { CardsView() }
}


#Preview("App Start View", traits: .cardSampleData) {
    NavigationStack {
        StartView()
    }
}
