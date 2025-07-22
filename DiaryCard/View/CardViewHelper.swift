import SwiftUI
import SwiftData

extension CardView {
    func getNameView(name: String) -> some View {
        return Group {
            Text(name.isSubType() ? .nothing : name.getFieldName())
                .font(.system(size: 14).lowercaseSmallCaps())
                .foregroundStyle(.blue)
                .fixedSize(horizontal: false, vertical: false)
                .lineLimit(2)
                .truncationMode(.tail)
                .padding(.leading, 10)
        }
    }
    
    func getNextField(after key: String, in list: [String]) -> String {
        let index: Int = list.firstIndex(of: key).orDefaultTo(-1)
        if index.between(0, and: list.endIndex - 1) {
            return list[index + 1]
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
        return Binding<Date>(
            get: {
                return card.date
            },
            set: { newValue in
                card.date = newValue
            })
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

struct NumberView: View {
    @Binding var value: Int
    
    var body: some View {
        let valueString = Binding<String>(
            get: { String(value) },
            set: {newValue in
                value = Int(newValue).orDefaultTo(0)
            }
        )
        
        VStack(alignment: .center) {
            TextField(valueString.wrappedValue, text: valueString)
                .keyboardType(.numberPad)
                .frame(width: 20)
            
            Slider(value: getFloatBinding(), in: 0...10, step: 1) {  }
            minimumValueLabel: { Text("Low") }
            maximumValueLabel: { Text("High") }
                .tint(value.between(4, and: 7) ? .buttercup
                    : value < 4 ? .secondary : .poppy
            )
        }
        .padding(.horizontal, 20)
    }
    
    func getFloatBinding() -> Binding<Float> {
        .init(
            get: { Float(value) },
            set: { newValue in
                value = Int(newValue.rounded())
            }
        )
    }
}

struct TextView : View {
    @Binding var value: String
    
    var body : some View {
        TextField(value, text: $value, axis: .vertical)
            .textFieldStyle(.plain)
            .padding(6)
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
            .font(.callout)
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

struct TapBackground: View {
    let tapAction: () -> Void
    
    var body: some View {
        Rectangle().fill(Color(.systemBackground).opacity(0.4))
            .blur(radius: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onTapGesture {
                tapAction()
            }
    }
}
