import SwiftUI

struct SummariseView: View {
    @Environment(\.modelContext) var modelContext
    @State var start: Date = .today.goBack(2 * 30 * .day)
    @State var end: Date = .today
    @State var cards: [Card] = []
    
    var body: some View {
        List {
            ForEach(cards, id: \.date) {card in
                Text(card.date.description)
            }
        }
        .onAppearOrChange(anyOf: start, end) { fetch() }
    }
    
    var topBar: some View {
        Text("Top Bar")
    }
    
    func fetch() {
        cards = fetch(start: start, end: end, context: modelContext)
        print("Fetched \(cards.count) cards")
    }
    
    func fetchCards() {
        print("Fetching cards...")
        cards = fetch(start: start, end: end, context: modelContext)
        print("Fetched \(cards.count) cards")
    }
}
