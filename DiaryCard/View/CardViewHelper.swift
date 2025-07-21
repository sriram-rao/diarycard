import SwiftUI
import SwiftData

extension CardView {
    func getNameView(name: String) -> some View {
        return Group {
            Text(name.isSubType() ? "" : name.getFieldName())
                .foregroundStyle(.blue)
                .fixedSize(horizontal: false, vertical: false)
                .lineLimit(2)
                .truncationMode(.tail)
        }
    }
    
    func getNextField(after key: String, in list: [String]) -> String {
        let index: Int = list.firstIndex(of: key) ?? -1
        print("Focus on \(key) at (index + 1) \(index + 1) out of \(list.count).")
        if index < 0 || index >= list.endIndex - 1 {
            return ""
        }
        print("Moving focus to \(list[index + 1])")
        return list[index + 1]
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
                return card.date
            },
            set: { newValue in
                card.date = newValue
            })
    }
    
    func clearKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

struct NumberView: View {
    @Binding var value: Float
    
    var body: some View {
        let valueString = Binding<String>(
            get: { String(Int(value)) },
            set: {newValue in
                value = Float(newValue) ?? 0
            }
        )
        
        VStack(alignment: .center) {
            TextField(valueString.wrappedValue, text: valueString)
                .keyboardType(.numberPad)
                .frame(width: 20)
            
            Slider(value: $value, in: 0...10, step: 1)
            {  }
            minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("10")
            }
            .tint(
                value >= 0 && value <= 3 ? .secondary :
                    value >= 4 && value <= 7 ? .bubblegum : .red
            )
        }
        .padding(.horizontal, 20)
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
        self
            .datePickerStyle(.graphical)
            .padding(.vertical, 30)
        
            .background(Color(.systemBackground).opacity(0.1))
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
            .tint(value ? .oxblood : .blue)
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
            .fill(Color(.systemBackground).opacity(0.4))
            .blur(radius: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onTapGesture {
                tapAction()
            }
    }
}
