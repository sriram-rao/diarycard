import Foundation
import SwiftData
import SwiftUI

struct CardView: View {
    @Query() var lists: [ListSchemas]
    let card: Card
    
    var textKeys: [String] {
        get { card.attributes.filter({ $0.value.kind == .string }).keys.sorted() }
    }
    var otherKeys: [String] {
        get { card.attributes.keys.filter { !textKeys.contains($0) }.sorted()}
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            render(name: Text("Date"),
                   view: getDateView())
                .padding(.horizontal)
            
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
    
    func render(name: some View, view: some View) -> some View {
        HStack{
            name.font(.subheadline.lowercaseSmallCaps())
            view.frame(maxWidth: 200, alignment: .leading)
                .contentShape(Rectangle())
        }
    }
    
    func getTextKeyView(key: String) -> some View {
        let cardText: Binding<Value> = card.getBinding(key: key)
        let textBinding = Binding<String>(
            get: { cardText.wrappedValue.asString },
            set: { newValue in cardText.wrappedValue = Value.wrap(newValue)! }
        )
        
        return TextField(card[key].toString(), text: textBinding, axis: .vertical)
            .textFieldStyle(.plain)
    }
    
    func getNumberView(key: String) -> some View {
        
        return TextField(
            value: Binding(
                get: { card.get(key: key).asInt },
                set: { newVal in
                    card.attributes[key] = .int(newVal)
                }),
            format: IntegerFormatStyle(),
        ) { Text("Enter number") }

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
            return AnyView(self.getListView(key: name, textLists: lists.first!.schemas[name] ?? []))
        default:
            return AnyView(Text(""))  // Default case if no match
        }
    }
}

#Preview("Default", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    CardView(card: cards.first!)
}

#Preview("Text", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    Text("Live: \((cards.first!)["text.comment"].toString())")
    CardView(card: cards.first!).getTextKeyView(key: "text.comment")
}

#Preview("Number", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    Text("Live: \((cards.first!)["emotions.anxiety"].toString())")
    CardView(card: cards.first!).getNumberView(key: "emotions.anxiety")
}
