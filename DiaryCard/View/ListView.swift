import SwiftUI
import SwiftData

extension CardView {
    func getListView(key: String) -> some View {
        @Query() var lists: ListSchemas
        
        let cardValues: Binding<[String]> =
                Binding<[String]>(
                    get: { card[key].asStringArray },
                    set: { newValue in card.getBinding(key: key).wrappedValue = Value.wrap(newValue)! })
        
        
        return VStack(alignment: .leading, spacing: 0) {
            Text("skills \(lists[key])")
//            ForEach(skills[key], id: \.self) {item in
//                HStack {
//                    Text(item)
//                    Spacer()
//                    
//                    Button(action: {
//                        let valuePresent: Bool = cardValues.wrappedValue.contains(item)
//                        if valuePresent {
//                            cardValues.wrappedValue.removeAll(where: { $0 == item })
//                        }
//                        else {
//                            cardValues.wrappedValue.append(item)
//                        }
//                    }) {
//                        let valuePresent: Bool = cardValues.wrappedValue.contains(item)
//                        Image(systemName: valuePresent ? "minus.circle.fill" : "plus.circle.fill")
//                            .foregroundStyle(valuePresent ? .bubblegum : .sky)
//                    }
//                }
//                .padding()
//                
//                Divider()
//            }
        }
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

#Preview("SelectView List", traits: .cardSampleData, .lists) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    Text("Live Preview: \(cards.last!["skills.distress tolerance"].toString())")
    CardView(card: cards.last!).getListView(key: "skills.distress tolerance")
}

#Preview("Select Row Button", traits: .cardSampleData) {
    Group {
        SelectRowButton()
        SelectRowButton(fill: true)
    }
}
