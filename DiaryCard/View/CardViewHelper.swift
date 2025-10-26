import SwiftData
import SwiftUI

enum CardError: LocalizedError {
    case invalidValue(String)
    case keyNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidValue(let message):
            return message
        case .keyNotFound(let key):
            return "Key not found: \(key)"
        }
    }
}

extension CardView {
    func getNameView(
        for name: String,
        description: String? = nil,
        ofSize size: Font = Font.callout
    ) -> some View {
        NameViewWithTooltip(
            name: name,
            description: description,
            size: size,
            colorScheme: colorScheme
        )
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
            get: { 
                do {
                    guard let value: T = card[key].unwrap() else {
                        throw CardError.invalidValue("Could not unwrap value for key: \(key)")
                    }
                    return value
                } catch {
                    showError("Failed to get value for \(key): \(error.localizedDescription)")
                    // Return a default value - this might crash but that's what you want during development
                    return card[key].unwrap()!
                }
            },
            set: { newValue in
                card.attributes[key] = Value.wrap(newValue)
            }
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
        .textFieldStyle(.plain)
        .multilineTextAlignment(.center)
        .keyboardType(.numberPad)
        .frame(width: 80, height: 30)
        .onChange(of: value, {
            preselectText = false
        })
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
    }

    func getSelectionBinding() -> Binding<TextSelection?> {
        Binding<TextSelection?>(
            get: {
                preselectText && value > 0
                ? TextSelection(range: String(value).startIndex..<String(value).endIndex)
                : nil
            },
            set: { _ in }
        )
    }
    
    func getColor() -> Color {
        if value <= 3 { return .secondary.opacity(( Double(5 - value) / 5)) }
        if value <= 6 { return .blue.opacity(Double(value - 2) / 5) }
        return .poppy.opacity(Double(value - 5) / 5)
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
        .padding(10)
        .textFieldStyle(.plain)
        .onChange(of: value, {
            preselectText = false
        })
    }
}

struct DateView: View {
    @Binding var value: Date

    var body: some View {
        DatePicker(
            "Select Date",
            selection: $value,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
        .glassEffect(
            .regular.interactive(),
            in: .rect(cornerRadius: 20)
        )
        .scaleEffect(0.85)
    }
}

struct BooleanView: View {
    @Binding var value: Bool

    var body: some View {
        Toggle(value ? " Active " : "Inactive", isOn: $value)
            .font(.caption)
            .toggleStyle(.button)
            .buttonStyle(.glass)
            .tint(value ? .poppy : .blue)
            .animation(.easeInOut, value: value)
    }
}

struct NameViewWithTooltip: View {
    let name: String
    let description: String?
    let size: Font
    let colorScheme: ColorScheme

    @State private var showingTooltip = false

    var body: some View {
        HStack(spacing: 4) {
            Text(name.capitalized).font(size)
                .fixedSize(horizontal: false, vertical: false)
                .lineLimit(2)
                .truncationMode(.tail)
                .blackAndWhite(theme: colorScheme)

            if description != nil {
                Image(systemName: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if description != nil {
                showingTooltip.toggle()
            }
        }
        .popover(isPresented: $showingTooltip, content: {
            if let description = description {
                Text(description)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .frame(idealWidth: 280, idealHeight: 2)
                    .presentationCompactAdaptation(.popover)
            }
        })
        
    }
}

struct HomeButton: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: CardsView(), label: { Text("Cards") })
        }
    }
}


#Preview("Number") {
    @Previewable @State var number: Int = 10
    Text(verbatim: "Live Preview: \(number)")
    NumberView(value: $number, preselectText: true)
}

#Preview("Text") {
    @Previewable @State var text: String = "text.comment"
    Text(verbatim: "Live Preview: \(text)")
    TextView(value: $text, preselectText: false)
}

#Preview("Name View") {
    @Previewable @State var number: Int = 10
    VStack {
        CardView(card: Card()).getNameView(for: "Number")
        NumberView(value: $number, preselectText: true)
    }.background(Color(.systemGray6))
}

#Preview("Stack") {
    @Previewable @State var number: Int = 10
    VStack {
        VStack {
            CardView(card: Card()).getNameView(for: "Number")
            NumberView(value: $number, preselectText: true)
        }.background(Color(.systemGray6))
        VStack {
            CardView(card: Card()).getNameView(for: "Number")
            NumberView(value: $number, preselectText: true)
        }.background(Color(.systemGray6))
    }
}
