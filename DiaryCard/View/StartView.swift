import Foundation
import SwiftData
import SwiftUI

struct StartView: View {
    @Query(sort: \Card.date, order: .reverse) var cards: [Card]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today")
                .font(.largeTitle)
                
            Spacer()
            CardView(card: cards[0])
            Spacer()
        }
        .navigationTitle("Title")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview("StartView", traits: .cardSampleData) {
    StartView()
}
