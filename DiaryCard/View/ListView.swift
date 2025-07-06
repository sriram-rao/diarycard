import SwiftUI
import SwiftData

extension CardView {
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
    
    func getListView(key: String, textList: [String]) -> some View {
        let cardValues: Binding<[String]> =
        Binding<[String]>(
            get: { card[key].asStringArray },
            set: { newValue in card.getBinding(key: key).wrappedValue = Value.wrap(newValue)! })
        
        
        return VStack(alignment: .leading, spacing: 0) {
            ForEach(textList, id: \.self) {item in
                HStack { Text(item); Spacer()
                    
                    Button(action: {
                        cardValues.wrappedValue.contains(item) ?
                        cardValues.wrappedValue.removeAll(where: { $0 == item }) :
                        cardValues.wrappedValue.append(item)
                        
                    }) {
                        let valuePresent: Bool = cardValues.wrappedValue.contains(item)
                        Image(systemName: valuePresent ? "minus.circle.fill" : "plus.circle.fill")
                            .foregroundStyle(valuePresent ? .bubblegum : .sky)
                    }
                }
                .padding()
            }
            
        }
    }
    
    func getSummaryRowView(key: String, textList: [String]) -> some View {
        NavigationLink(destination: getListView(key: key, textList: textList)) {
            Text(ListFormatter().string(from: card[key].asStringArray) ?? "No selection")
                .lineLimit(1)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
    
    
    func getDateView(key: String = "date") -> some View {
        let dateBinding: Binding<Date> = "date" == key ? getDateBinding() : Binding(
            get: { card[key].asDate },
            set: {newValue in card.getBinding(key: key).wrappedValue = Value.wrap(newValue)!})
        
        return DatePicker(selection: dateBinding, displayedComponents: [.date],
                          label: {Text(Date(), style: .date)})
        .labelsHidden()
    }
    
    func getDateBinding() -> Binding<Date> {
        return Binding<Date>(
            get: { card.date },
            set: { newValue in card.date = newValue })
    }
    
    func getMenuView(key: String, textList: [String]) -> some View {
        Menu {
            Button("Skill") {}
            Button("Skill") {}
            Button("Skill") {}
        } label: {
            Label("Place", systemImage: "chevron.down")
        }
    }
}

#Preview("List Summary", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    @Previewable @Query(sort: \ListSchemas.schemasJson) var lists: [ListSchemas]
    let key: String = "skills.distress tolerance"
    Text("Live Preview: \(cards.first!.get(key: key).toString())")
    NavigationStack{
        CardView(card: cards.first!).getSummaryRowView(key: key,
                                                       textList: lists.first?.schemas[key] ?? [])
    }
}

#Preview("SelectView List", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    @Previewable @Query(sort: \ListSchemas.schemasJson) var lists: [ListSchemas]
    let key: String = "skills.distress tolerance"
    Text("Live Preview: \(cards.first!.get(key: key).toString())")
    CardView(card: cards.first!).getListView(key: key,
                                textList: lists.first?.schemas[key] ?? [])
}

#Preview("Date", traits: .cardSampleData) {
    @Previewable @Query() var cards: [Card]
    Text("Live: \((cards.first!).date)")
    PreviewDatePicker(card: cards.first!)
}


struct PreviewDatePicker: View {
    @State var showPicker: Bool = false
    let card: Card
    
    var body: some View {
        CardView(card: card).getDateView()
    }
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


