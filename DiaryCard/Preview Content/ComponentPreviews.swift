import OrderedCollections
import SwiftUI
import SwiftData

#Preview("Text") {
    @Previewable @State var text: String = "text.comment"
    Text("Live Preview: \(text)")
    TextView(value: $text)
}

#Preview("Number") {
    @Previewable @State var number: Int = 10
    Text("Live Preview: \(number)")
    NumberView(value: $number)
}

#Preview("Bool") {
    @Previewable @State var value: Bool = false
    Text("Live Preview: \(value)")
    BooleanView(value: $value)
}

#Preview("Home Button") {
    HomeButton()
}

#Preview("Date") {
    @Previewable @State var value: Date = Date()
    Text("Live Preview: \(value)\n")
    Spacer()
    DateView(value: $value)
    Spacer()
}

#Preview("Date Picker", traits: .cardSampleData) {
    @Previewable @State var value: Date = Date().goBack(1 * .week)
    @Previewable @State var path = NavigationPath()
    Text("Live Preview: \(value)\n")
    Spacer()
    NavigationStack(path: $path) {
        CardsView().getPicker(for: $value)
    }
    Spacer()
}

#Preview("Calendar") {
    @Previewable @State var value: Date = Date()
    Text("Live Preview: \(value)\n")
    Spacer()
    CalendarView()
    Spacer()
}

#Preview("Tap Background") {
    TapBackground(tapAction: { })
}

#Preview("Popover List") {
    @Previewable @State var selected: [String] = Card.getSampleData().first!.get(key: "skills.distress tolerance").asStringArray
    Text("Live View: \(selected)")
    PopoverList(selected: $selected, full: Skills["skills.distress tolerance"]! )
}


#Preview("Popover Button") {
    @Previewable @State var selected: Bool = false
    Text("Live View: \(selected)")
    PopoverButton(types: ["type1", "type2"], action: { selected.toggle() })
}

#Preview("Get on submit test") {
//    let list: [String] = CardSchema.attributes.keys.sorted()
    var textKeys: [String] {
        get { Schema.attributes.filter({ $0.value.kind == .string }).keys.sorted() }
    }
    
    var nonTextKeys: OrderedDictionary<String, [String]> {
        get {
            OrderedDictionary(
                grouping: Schema.attributes.keys
                    .filter { !(textKeys.contains($0)) },
                by: { $0.group }
            )
        }
    }
    
    var allKeys: [String] {
        textKeys + nonTextKeys.values.flatMap(\.self).filter({ !$0.isSubfield })
    }
    
    let currentKey: String = "behaviour.7.suicidal ideation"
    Text("all keys: \(allKeys)")
    Text("Next focus:" + CardView(card: Card(date: Date()))
            .getNextField(after: currentKey, in: allKeys))
}
