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
            CardView(card: cards.first ?? Card(date: Date()))
            Spacer()
        }
        .navigationTitle("Title")
        .navigationBarTitleDisplayMode(.large)
    }
}
