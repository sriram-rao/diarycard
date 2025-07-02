import SwiftUI
import SwiftData

extension CardView {
    func getListView(key: String, textLists: [String]) -> some View {
        let cardValues: Binding<[String]> =
                Binding<[String]>(
                    get: { card[key].asStringArray },
                    set: { newValue in card.getBinding(key: key).wrappedValue = Value.wrap(newValue)! })
        
        
        return VStack(alignment: .leading, spacing: 0) {
            Text("Skills: \(textLists.count)")
            Text("Card: \(card.attributes.count)")
            ForEach(textLists, id: \.self) {item in
                HStack {
                    Text(item)
                    Spacer()
                    
                    Button(action: {
                        let valuePresent: Bool = cardValues.wrappedValue.contains(item)
                        if valuePresent {
                            cardValues.wrappedValue.removeAll(where: { $0 == item })
                        }
                        else {
                            cardValues.wrappedValue.append(item)
                        }
                    }) {
                        let valuePresent: Bool = cardValues.wrappedValue.contains(item)
                        Image(systemName: valuePresent ? "minus.circle.fill" : "plus.circle.fill")
                            .foregroundStyle(valuePresent ? .bubblegum : .sky)
                    }
                }
                .padding()
                
                Divider()
            }
        }
    }
    
    func getDateView(key: String = "date") -> some View {
        let dateBinding: Binding<Date> = "date" == key ?
            Binding<Date>(
                get: { card.date },
                set: { newValue in card.date = newValue }) :
            Binding(
                get: { card[key].asDate },
                set: {newValue in card.getBinding(key: key).wrappedValue = Value.wrap(newValue)!})
        
        return
            DatePicker(selection: dateBinding,
                       displayedComponents: [.date], label: {Text("")})
                .labelsHidden()
                .frame(alignment: .leading)
        
    }
}

struct SelectRowButton: View {
    @State var fill: Bool = false
    
    var body: some View {
        Button {
            fill.toggle()
        } label: {
            Label("Toggle Skill Used", systemImage: fill ? "checkmark.circle.fill" : "circle")
                .labelStyle(IconOnlyLabelStyle())
                .foregroundStyle(.magenta)
        }
    }
}

#Preview("SelectView List", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    @Previewable @Query(sort: \ListSchemas.schemasJson) var lists: [ListSchemas]
    let key: String = "skills.distress tolerance"
    Text("Live Preview: \(cards.first!.get(key: key).toString())")
    Text("List: \(lists.first!.schemas[key]?.joined(separator: ", ") ?? "No List")")
    CardView(card: cards.first!).getListView(key: key,
                                textLists: lists.first?.schemas[key] ?? [])
}

#Preview("Select Row Button", traits: .cardSampleData) {
    Group {
        SelectRowButton()
        SelectRowButton(fill: true)
    }
}

#Preview("Date", traits: .cardSampleData) {
    @Previewable @Query() var cards: [Card]
    Text("Live: \((cards.first!).date)")
    CardView(card: cards.first!).getDateView()
}
