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

struct TapBackground: View {
    let tapAction: () -> Void
    
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.4))
            .blur(radius: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onTapGesture {
                tapAction()
            }
    }
}
