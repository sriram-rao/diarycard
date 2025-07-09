import SwiftUI
import SwiftData

extension CardView {
    func getDateBinding() -> Binding<Date> {
        return Binding<Date>(
            get: { card.date },
            set: { newValue in card.date = newValue })
    }
    
    func getRelativeDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let calendar = Calendar.current

        let day = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: Date())
        let timeBetween = abs(today.timeIntervalSince(day))
        
        if timeBetween >= TimeInterval(7 * 86_400) {
            return DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
        }
        if timeBetween == TimeInterval(0) {
            return "Today"
        }
        if timeBetween < TimeInterval(2 * 86_400) {
            return today > day ? "Yesterday" : "Tomorrow"
        }
        formatter.locale = .current
        formatter.dateFormat = "EEEE"
        return "\(day < today ? "Last" : "") \(formatter.string(from: date))"
    }
}

struct NumberView: View {
    @Binding var value: String
    
    var body: some View {
        TextField(
            value,
            text: $value,
            axis: .vertical
        )
        .keyboardType(.numberPad)
        .padding(.leading, 40)
    }
}

struct TextView : View {
    @Binding var value: String
    
    var body : some View {

        TextField(value, text: $value, axis: .vertical)
            .textFieldStyle(.plain)
    }
}

struct DateView: View {
    @Binding var value: Date
    
    var body: some View {
        ZStack {
            DatePicker(selection: $value, displayedComponents: [.date],
                       label: {Text(value, style: .date)})
            .labelsHidden()
        }
    }
}

struct BooleanView: View {
    @Binding var value: Bool
    
    var body: some View {
        Toggle(value ? "Yes" : "No", isOn: $value)
                .frame(maxWidth: 100, maxHeight: 50)
    }
}

struct HomeButton: View {
    @State var buttonActive: Bool = true
    var body: some View {
        NavigationStack {
            NavigationLink {
                CardsView()
            } label: {
                Text("Cards")
            }
        }
    }
}

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

#Preview("Card", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    NavigationStack {
        CardView(card: cards.first!)
    }
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
