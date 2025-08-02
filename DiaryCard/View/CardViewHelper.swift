import SwiftData
import SwiftUI

extension CardView {
    func getNameView(
        for name: String,
        ofSize size: Font = Font.callout
    ) -> some View {
        Text(name).font(size.lowercaseSmallCaps())
            .fixedSize(horizontal: false, vertical: false)
            .lineLimit(2)
            .truncationMode(.tail)
            .padding(.leading, 10)
    }

    func getNextField(after key: String, in list: [String], going forwards: Bool) -> String {
        let index: Int = list.firstIndex(of: key).orUse(0)
        if forwards && index.between(0, and: list.endIndex - 1) {
            return list[index + 1]
        }
        if not(forwards && index.between(1, and: list.endIndex)) {
            return list[index - 1]
        }
        return .nothing
    }

    func getBinding<T>(for key: String) -> Binding<T> {
        Binding<T>(
            get: { card[key].unwrap()! },
            set: { newValue in card.attributes[key] = Value.wrap(newValue) }
        )
    }

    func getDateBinding() -> Binding<Date> {
        Binding<Date>(
            get: {
                return card.date
            },
            set: { newValue in
                card.date = newValue
            })
    }

    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil)
    }
}

struct NumberView: View {
    @Binding var value: Int
    @State var preselectText: Bool = true

    var body: some View {
        let valueString = Binding<String>(
            get: { String(value) },
            set: { value = Int($0).orUse(0) }
        )
        
        TextField(
            valueString.wrappedValue,
            text: valueString,
            selection: getSelectionBinding()
        )
        .multilineTextAlignment(.center)
        .keyboardType(.numberPad)
        .frame(width: 120, height: 30)
        .onChange(of: value, {
            preselectText = false
        })
        .background(getColor().opacity(0.6).gradient)
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
    }

    func getFloatBinding() -> Binding<Float> {
        .init(
            get: { Float(value) },
            set: { newValue in
                value = Int(newValue.rounded())
            }
        )
    }

    func getSelectionBinding() -> Binding<TextSelection?> {
        Binding<TextSelection?>(
            get: {
                preselectText && value > 0
                    ? TextSelection(range: String(value).startIndex..<String(value).endIndex) : nil
            },
            set: { _ in }
        )
    }
    
    func getColor() -> Color {
        if value <= 3 {
            return .secondary.opacity(0.5)
        }
        if value <= 6 {
            return .blue.opacity(0.5)
        }
        return .poppy.opacity(0.75)
    }
}

struct TextView: View {
    @Binding var value: String
    @State var preselectText: Bool = false

    var body: some View {
        TextField(
            value,
            text: $value,
            selection: Binding<TextSelection?>(
                get: {
                    preselectText ? TextSelection(range: value.startIndex..<value.endIndex) : nil
                },
                set: { _ in }),
            axis: .vertical
        )
        .textFieldStyle(.roundedBorder)
        .padding(2)
        .onChange(
            of: value,
            {
                preselectText = false
            })
    }
}

struct DateView: View {
    @Binding var value: Date

    var body: some View {
        ZStack {
            DatePicker(
                selection: $value, displayedComponents: [.date],
                label: { Text(value, style: .date) }
            )
            .labelsHidden()
            .transition(.slide)
        }
    }

    func pickerStyle() -> some View {
        self.datePickerStyle(.graphical)
            .padding(.vertical, 30)
            .background(.ultraThinMaterial.opacity(0.80))
            .cornerRadius(20)
            .scaleEffect(0.85)
    }
}

struct BooleanView: View {
    @Binding var value: Bool

    var body: some View {
        Toggle(value ? "Active" : "Inactive", isOn: $value)
            .font(.caption)
            .toggleStyle(.button)
            .buttonStyle(.borderedProminent)
            .tint(value ? .poppy : .blue)
    }
}

struct HomeButton: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: CardsView(), label: { Text("Cards") })
        }
    }
}
