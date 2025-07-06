import Foundation
import SwiftData
import SwiftUI

struct CardView: View {
    @Query() var lists: [ListSchemas]
    let card: Card
    
    @State var showPicker: Bool = false
    
    var textKeys: [String] {
        get { card.attributes.filter({ $0.value.kind == .string }).keys.sorted() }
    }
    var otherKeys: [String] {
        get { card.attributes.keys.filter { !textKeys.contains($0) }.sorted()}
    }
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                //                render(name: Text("Date"),
                //                       view: getDateView()).padding(.horizontal)
                Text(showPicker.description)
                
                ForEach(textKeys, id: \.hash) {key in
                    render(name: getNameView(name: key),
                           view: getTextKeyView(key: key))
                }
                
                List {
                    ForEach(otherKeys, id: \.self) {key in
                        render(name: getNameView(name: key),
                               view: getView(name: key)
                        )
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                DatePicker("", selection: getDateBinding(), displayedComponents: [.date])
                    .padding(.all, 10)
                    .backgroundStyle(Color.red)
            }
        })
    }
    
    func render(name: some View, view: some View) -> some View {
        HStack{
            name.font(.subheadline.lowercaseSmallCaps())
            view.frame(maxWidth: 200, alignment: .leading)
                .contentShape(Rectangle())
        }
    }
    
    func getNameView(name: String) -> some View {
        return Group {
            Text(name.components(separatedBy: ".").last ?? "")
                .fixedSize(horizontal: false, vertical: false)
                .frame(maxWidth: 100, alignment: .leading)
        }
    }
    
    func getView(name: String) -> some View {
        switch card[name].kind {
        case .int:
            return AnyView(self.getNumberView(key: name))
        case .string:
            return AnyView(self.getTextKeyView(key: name))
        case .date:
            return AnyView(self.getDateView(key: name))
        case .stringArray:
            return AnyView(self.getSummaryRowView(key: name, textList: lists.first!.schemas[name] ?? []))
        default:
            return AnyView(Text(""))
        }
    }
}

#Preview("Default", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    NavigationStack {
        CardView(card: cards.first!)
    }
}

#Preview("List Summary", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    @Previewable @Query(sort: \ListSchemas.schemasJson) var lists: [ListSchemas]
    let key: String = "skills.distress tolerance"
    Text("Live Preview: \(cards.first!.get(key: key).toString())")
    VStack {
//        Text(lists[0].schemasJson)
        CardView(card: cards.first!).getSummaryRowView(
            key: key, textList: lists.first?.schemas[key] ?? [])
    }
}
