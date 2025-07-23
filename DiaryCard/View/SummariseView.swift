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
        .onAppearOrChange(of: start, or: end, refreshCards)
    }
    
    var topBar: some View {
        Text("Top Bar")
    }
    
    func getTemplate() -> String {
        guard let template = Bundle.main.url(forResource: "template", withExtension: "html"),
              let html = try? String(contentsOf: template, encoding: .utf8) else {
            return .nothing
        }
        return html
    }
    
    func refreshCards() {
        cards = fetch(from: start, to: end, in: modelContext)
    }
}
