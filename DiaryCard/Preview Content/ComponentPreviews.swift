import SwiftUI
import SwiftData

#Preview("Text") {
    @Previewable @State var text: String = "text.comment"
    Text("Live Preview: \(text)")
    TextView(value: $text)
}

#Preview("Number") {
    @Previewable @State var number: Value = .int(10)
    let binding = Binding<String> (
        get: { String(number.asInt) },
        set: { newValue in number = .int(Int(newValue) ?? 0) }
    )
    Text("Live Preview: \(number)")
    NumberView(value: binding)
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

#Preview("Date Picker") {
    @Previewable @State var value: Date = Date()
    Text("Live Preview: \(value)\n")
    Spacer()
    CardsView().picker
    Spacer()
}

#Preview("Calendar") {
    @Previewable @State var value: Date = Date()
    Text("Live Preview: \(value)\n")
    Spacer()
    CalendarView()
    Spacer()
}
