import Foundation
import OrderedCollections
import SwiftData
import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    let card: Card

    var body: some View {
        ZStack {
            layer0
            layer1
            layer2
        }
        .toolbar {
            topBar
            keyboardBar
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    var layer0: some View {
        ScrollView {
            VStack {
                renderKeys(textKeys)
                renderColumns()
                renderKeys(Schema.getKeysIf(type: .stringArray))
            }
            .blurIf(needsTapBackground)
        }
        .onTapGesture {
            focusField = .nothing
            dismissKeyboard()
        }
    }

    var layer1: some View {
        VStack {checkIf(needsTapBackground) {
            TapBackground {
                needsPopover = false
                needsDateSelection = false
                selectedKey = .nothing
                focusField = .nothing
                dismissKeyboard()
            }
        }}
    }

    var layer2: some View {
        Group {
            checkIf(needsPopover) {
                VStack {
                    Spacer()
                    popover
                    HStack{
                        Spacer()
                        getPaddedNextButton(forwards: false)
                            .tint(.secondary)
                        getPaddedNextButton()
                    }
                }
                .padding(.bottom, 25)
                .transition(.opacity)
            }

            checkIf(needsDateSelection) {
                VStack{
                    DateView(value: card.getDateBinding())
                        .pickerStyle()
                        .padding(.top, 30)
                    Spacer()
                }
            }
        }
    }

    var topBar: some ToolbarContent {
        ToolbarItemGroup(
            placement: .principal,
            content: {
                Button(action: { withAnimation { needsDateSelection = true } },
                       label: {
                    Text(card.date.getRelativeDay())
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .bold()
                })
            })
    }

    var keyboardBar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            getNextButton(forwards: false)
            getNextButton()
            Button("Done", action: dismissKeyboard)
        }
    }
    
    func getPaddedNextButton(forwards: Bool = true) -> some View {
        getNextButton(forwards: forwards)
            .padding(.trailing, 20)
            .buttonStyle(.borderedProminent)
    }
    
    func getNextButton(forwards: Bool = true) -> some View {
        checkIf((forwards && not(focusField == allKeys.last))
                || (not(forwards) && not(focusField == allKeys.first))) {
            Button(forwards ? "Next" : "Previous",
                   action: { withAnimation { focusNext(forwards: forwards) } })
        }
    }

    var popover: some View {
        let binding = Binding<[String]>(
            get: { self.card[selectedKey.key].asStringArray },
            set: { self.card.attributes[selectedKey.key] = Value.wrap($0) }
        )
        return VStack {
            Text(selectedKey.field.capitalized)
                .font(.headline)
                .padding(.bottom, 20)
            
            PopoverList(selected: binding, full: Skills[selectedKey.key].orUse([]))
                .transition(.slide)
        }
    }

    @State var needsPopover: Bool = false
    @State var needsDateSelection: Bool = false
    @State var selectedKey: String = .nothing
    @FocusState var focusField: String?
    @ScaledMetric var attributeNameWidth: CGFloat = 120

    var needsTapBackground: Bool {
        needsPopover || needsDateSelection
    }

    var textKeys: [String] { Schema.getKeysIf(type: .string) }

    var nonTextKeys: OrderedDictionary<String, [String]> {
        OrderedDictionary(
            grouping: Schema.getKeysIf { not(textKeys.contains($0)) },
            by: { $0.group }
        )
    }

    var allKeys: [String] {
        textKeys + nonTextKeys.values.flatMap(\.self).filter({ not($0.isSubfield) })
    }
    
    func renderColumns(aligned: HorizontalAlignment = .center) -> some View {
        let groups = OrderedDictionary(
            grouping: Schema.getKeysIf(include: false, types: [.string, .stringArray]),
            by: { $0.key.group })
        
        return HStack(alignment: .firstTextBaseline) {
            ForEach(groups.keys.sorted(), id: \.hashValue) { key in
                VStack(alignment: aligned) {
                    getNameView(for: key, ofSize: .callout)
                        .foregroundStyle(.secondary)
                    renderKeys(groups[key].orUse([]), alignment: .center)
                }
                .frame(maxWidth: 370 / 2)
                .padding(.vertical, 10)
            }
        }
    }

    func renderKeys(_ keys: [String], alignment: HorizontalAlignment = .leading) -> some View {
        ForEach(keys, id: \.capitalized) { key in
            checkIf(key.isStandalone(in: keys)) {
                VStack(alignment: alignment) {
                    render(key: key, group: key.getSubfields(keys: keys))
                }}
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
    }

    func render(key: String, group: [String]) -> some View {
        VStack(alignment: group.isEmpty ? .leading : .center) {
            getNameView(for: key.isStandalone(in: card.keys) ? key.label : .nothing)
                .blackAndWhite(theme: colorScheme)
            
            VStack(alignment: .center) {
                ForEach(group, id: \.self) { key in
                    getView(for: key) }
            }
            getView(for: key)
        }
    }

    func focusNext(forwards: Bool = true) {
        let nextFocus = getNextField(
            after: focusField.orUse(selectedKey),
            in: allKeys, going: forwards)
        if not(nextFocus.isBlank()) {
            focusField = nextFocus
        }
        needsPopover = nextFocus.group.equals("skills")
        selectedKey = needsPopover ? nextFocus : .nothing
    }

    func getView(for key: String) -> some View {
        getViewUnformatted(for: key)
            .font(.system(size: 16))
            .focused($focusField, equals: key)
            .frame(alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 7)
                .stroke(focusField == key ? Color.sky : Color.clear, lineWidth: 1)
            )
    }

    func getViewUnformatted(for attribute: String) -> some View {
        let name = attribute.key
        if not(card.keys.contains(name)) {
            return AnyView(Text("Not available \(name)."))
        }

        switch card[name].kind {
        case .int:
            return AnyView(NumberView(value: getBinding(for: name), preselectText: true))
            
        case .string:
            return AnyView(TextView(value: getBinding(for: name), preselectText: false))
            
        case .date:
            return AnyView(DateView(value: getBinding(for: name)))
            
        case .bool:
            return AnyView(BooleanView(value: getBinding(for: name)))
            
        case .stringArray:
            return AnyView(
                PopoverButton(
                    types: card[name].asStringArray,
                    action: {
                        focusField = attribute
                        selectedKey = attribute
                        needsPopover = true
                    }
                ))
        }
    }
}
