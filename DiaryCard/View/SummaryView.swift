import HtmlToPdf
import OrderedCollections
import WebKit
import PDFKit
import SwiftUI

struct SummaryView: View {
    @Environment(\.modelContext) var modelContext
    @State var start: Date
    @State var end: Date
    @State var cards: [Card] = []
    @State var refresh: Bool = false
    @State var pdfUrl: URL = Bundle.main.url(forResource: "default", withExtension: ".pdf")
        .orUse(URL.documentsDirectory)
    
    init(from start: Date = .today.goBack(7 * .day), to end: Date = .today) {
        self.start = start
        self.end = end
    }
    
    var body: some View {
        VStack{
            // To make SwiftUI refresh the screen because there isn't a direct way.
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
        .overlay(content: {
            bottomBar
        })
    }
    
    var bottomBar: some View {
        VStack{
            Spacer()
            HStack {
                refreshButton
                Spacer()
                saveButton
                shareButton
            }
            .padding(.horizontal, 30)
            .background(Color.clear)
            .font(.title3)
        }
    }
    
    var refreshButton: some View {
        Button(action: { self.refresh.toggle() },
               label: { Label(String.nothing, systemImage: "arrow.clockwise")
        }).minimalStyle()
    }
    
    var shareButton: some View {
        ShareLink(item: pdfUrl, subject: Text("Diary Card \(self.end.toString())")){
            Label(String.nothing, systemImage: "square.and.arrow.up")
        }.minimalStyle()
    }
    
    var saveButton: some View {
        Button(action: { _ = self.saveToDisk() },
               label: { Label(String.nothing, systemImage: "internaldrive") })
        .minimalStyle()
    }
    
    func generatePdf() -> URL {
        let outputUrl: URL = FileManager.default.temporaryDirectory
            .appendingPathComponent("Diary Card \(self.end.toString()).pdf")
        
        _ = Task {
            try await generateHtml().print(to: outputUrl)
        }
        return outputUrl
    }
    
    func saveToDisk() -> URL {
        let savePath = getSavePath()
        do {
            try FileManager.default.createDirectory(at: savePath.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try FileManager.default.copyItem(at: pdfUrl, to: savePath)
        } catch (let error) {
            print("Unable to save. Error: \(error)")
        }
        return savePath
    }
    
    func getSavePath() -> URL {
        guard let directory = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        else {
            fatalError("Error with finding save location.")
        }
        
        return directory.appending(path: "Cards")
            .appending(path: "Diary Card \(end.toString())")
            .appendingPathExtension("pdf")
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
            weekEnding: (sortedCards.first?.date).orUse(Date())
        )
    }
    
    func getComments(for keys: [String]) -> Dictionary<String, RowSet> {
        [
            "Comments": getTextRowHeader(with: keys) +
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
    
    func getTextRowHeader(with keys: [String]) -> RowSet {
        [[Value.string("Date")] + keys.fields.map({ Value.string($0) })]
    }
    
    func getTextRow(for keys: [String], in card: Card) -> Row {
        OrderedDictionary(grouping: keys, by: \.field)
            .map {_, keyNames in
                Value.string(keyNames.map{ key in
                    [ key.isSubfield ? [key.subfield.capitalized, .colon, .space].merged: .nothing,
                      card[key.key].asString,
                      .newline, MarkupTag.LINE_BREAK ].merged
                }.merged)}
    }
}
