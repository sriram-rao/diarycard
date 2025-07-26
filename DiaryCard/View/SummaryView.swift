import HtmlToPdf
import OrderedCollections
import WebKit
import PDFKit
import SwiftUI

struct SummaryView: View {
    @Environment(\.modelContext) var modelContext
    @State var start: Date = .today.goBack(2 * 30 * .day)
    @State var end: Date = .today
    @State var cards: [Card] = []
    @State var refresh: Bool = false
    
    @State var pdfUrl: URL = FileManager.default.temporaryDirectory.appendingPathComponent("test.pdf")
//    @State var pdfUrl: URL = Bundle.main.url(forResource: "default", withExtension: ".pdf")
//        .orDefaultTo(FileManager.default.temporaryDirectory.appendingPathComponent("test.pdf"))
    
    var body: some View {
        VStack{
            if refresh {
                PDFDisplay(url: self.pdfUrl, refresh: refresh)
            }
            else {
                PDFDisplay(url: self.pdfUrl, refresh: refresh)
            }
        }
        .task {
            self.refresh = true
            refreshCards()
            self.pdfUrl = generatePdf()
        }
        .toolbar { bottomBar }
    }
    
    var topBar: some View {
        Text("Top Bar")
    }
    
    var bottomBar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar, content: {
            HStack {
                Spacer()
                Button("Refresh PDF") {
                    Task {
                        self.refresh.toggle()
                    }
                }
            }
        })
    }
    
    func generatePdf() -> URL {
        let outputUrl: URL = FileManager.default.temporaryDirectory
            .appendingPathComponent("Diary Card \(self.end.toString()).pdf")
        
        _ = Task {
            try? await generateHtml().print(to: outputUrl)
        }
        
        return outputUrl
    }
    
    func refreshCards() {
        cards = fetch(from: start, to: end, in: modelContext)
    }
    
    var sortedCards: [Card] {
        cards.sorted(by: { $0.date > $1.date })
    }
}

extension SummaryView {
    func generateHtml() -> String {
        Html.generateHtml(
            for: getComments(for: Schema.getKeysOf(group: "text")),
            and: getMeasures(for: Schema.getKeysOf(group: "text", excluded: true)),
            weekEnding: (sortedCards.first?.date).orDefaultTo(Date())
        )
    }
    
    func getComments(for keys: [String]) -> Dictionary<String, RowSet> {
        [
            "Comments": getTextRowsHeader(with: keys) +
            sortedCards.map({ card in
                [.date(card.date)] + getTextRow(for: keys, in: card)
            })
        ]
    }
    
    func getMeasures(for keys: [String]) -> Dictionary<String, RowSet> {
        Dictionary(uniqueKeysWithValues: Set(keys.map(\.group.capitalized))
            .sorted()
            .map({ group in
                (group, getSummaries(for: keys.ofGroup(group)))
            })
        )
    }
    
    func getSummaries(for attributes: [String]) -> RowSet {
        getDatesRowHeader() +
        attributes.map { attribute in
            [.string(attribute.name.capitalized)] + Array((Summary
                .create(for: attribute, from: sortedCards).data
                .map{$0.value}
            ))
        }
    }
    
    func getDatesRowHeader() -> RowSet {
        [ [.string("Date")] + sortedCards.map{ .date($0.date) } ]
    }
    
    func getTextRowsHeader(with keys: [String]) -> RowSet {
        [[Value.string("Date")] + keys.fields.map({ Value.string($0) })]
    }
    
    func getTextRow(for keys: [String], in card: Card) -> Row {
        let dict = OrderedDictionary(grouping: keys, by: \.field)
        return dict.map {_, keyNames in
            print("Key names: \(keyNames)")
            return Value.string(
            keyNames.map{ key in
                
                print("Key: \(key)")
                return [ key.isSubfield ? [key.subfield.capitalized, .colon, .space].merged: .nothing,
                  card[key.key].asString,
                  .newline, MarkupTag.LINE_BREAK ].merged
            }.merged
        )}
    }
}
