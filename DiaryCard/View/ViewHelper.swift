import SwiftUI
import SwiftData

extension CardView {
    func getNameView(name: String) -> some View {
        return Group {
            Text(name.components(separatedBy: ".").last ?? "")
                .fixedSize(horizontal: false, vertical: false)
                .lineLimit(2)
                .truncationMode(.tail)
        }
    }
    
    func getBinding<T>(key: String) -> Binding<T> {
        Binding<T>(
            get: { card[key].unwrap()! },
            set: { newValue in card.attributes[key] = Value.wrap(newValue) }
        )
    }
    
    func getDateBinding() -> Binding<Date> {
        return Binding<Date>(
            get: {
                print("Getter: \(card.date)")
                return card.date
            },
            set: { newValue in
                print("Setter, trying: \(newValue)")
                card.date = newValue
                print("Set to: \(card.date)")
            })
    }
    
    func run_if(_ condition: Bool, _ action: () -> some View) -> AnyView {
        if condition {
            return AnyView(action())
        }
        return AnyView(EmptyView())
    }
    
    func doNothing(name: String...) -> EmptyView {
        EmptyView()
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
        TextField(value, text: $value, axis: .vertical)
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
