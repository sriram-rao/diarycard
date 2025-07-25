import Foundation
import OrderedCollections
import SwiftData
import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            layer_0
            layer_1
            layer_2
        }
        .toolbar {
            topBar
            keyboardBar
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var layer_0: some View {
        ScrollView {VStack {
            renderKeys(keys: textKeys)
            
            ForEach(nonTextKeys.keys.sorted(), id: \.hashValue) {key in
                VStack {
                    getNameView(name: key).font(.caption.lowercaseSmallCaps())
                    renderKeys(keys: nonTextKeys[key].orDefault([]))
                }
                .padding(.vertical, 10)
            }
        }
        .blurIf(needsTapBackground)
    }}
    
    var layer_1: some View {
        VStack {
            seeIf(needsTapBackground, then: {
                TapBackground {
                    needsPopover = false
                    selectedKey = .nothing
                }
            })
        }
    }
    
    var layer_2: some View {
        seeIf(needsPopover, then: {
            VStack {
                Spacer()
                Text(selectedKey.field.uppercased())
                popover
            }.padding(.bottom, 25)
        })
    }
    
    var topBar: some ToolbarContent {
        ToolbarItemGroup(placement: .principal, content: {
            Text(card.date.getRelativeDay())
                .font(.title3)
                .foregroundStyle(.blue)
                .bold()
        })
    }
    
    var keyboardBar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            seeIf(not(focusField == allKeys.last), then: {
                Button("Next", action: focusNext)
            })
            Button("Done", action: dismissKeyboard)
        }
    }
    
    var popover: some View {
        let binding = Binding<[String]>(
            get: { self.card[selectedKey].asStringArray },
            set: { self.card.attributes[selectedKey] = Value.wrap($0) }
        )
        return PopoverList(selected: binding, full: Skills[selectedKey].orDefault([]))
    }
    
    @State var needsPopover: Bool = false
    @State var selectedKey: String = .nothing
    @FocusState var focusField: String?
    @ScaledMetric var attributeNameWidth: CGFloat = 120
    
    var needsTapBackground: Bool {
        needsPopover
    }
    
    var textKeys: [String] {
        CardSchema.attributes.filter({ $0.value.kind == .string }).keys.sorted()
    }
    
    var nonTextKeys: OrderedDictionary<String, [String]> {
        OrderedDictionary(
            grouping: CardSchema.attributes.keys.filter { !(textKeys.contains($0)) },
            by: { $0.getGroup() }
        )
    }
    
    var allKeys: [String] {
        textKeys + nonTextKeys.values.flatMap(\.self).filter({ not($0.isSubType()) })
    }
    
    func renderKeys(keys: [String]) -> some View {
        return ForEach(keys, id: \.capitalized) {key in
            Group {
                seeIf(not(key.getSubfields(keys: keys).isEmpty),
                      then: { renderCompound(key: key) },
                      otherwise: {
                    seeIf(not(key.isSubType()), then: { render(key: key) })
                })
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
        }
    }
    
    func render(key: String) -> some View {
        VStack (alignment: .leading) {
            getNameView(name: key)
            getView(for: key)
            Divider()
        }
    }
    
    func renderCompound(key: String) -> some View {
        let group = key.key.getSubfields(keys: card.keys)
        return VStack (alignment: .leading) {
            HStack {
                getNameView(name: key)
                Spacer()
                ForEach(group, id: \.self) {key in
                    render(key: key)
                }
            }
            getView(for: key)
        }
    }
    
    // Kept to experiment with autofocusing skills section
    func focusNext() {
        let nextFocus = getNextField(after: focusField.orDefault(.nothing), in: allKeys)
        if !nextFocus.isEmptyOrWhitespace() {
            focusField = nextFocus
        }
        if nextFocus.getGroup() == "skills" {
            selectedKey = nextFocus.key
            needsPopover = true
        }
    }
    
    func getView(for key: String) -> some View {
        getViewUnformatted(for: key)
            .font(.system(size: 16))
            .contentShape(Rectangle())
            .focused($focusField, equals: key)
            .onSubmit {
                focusField = getNextField(after: key, in: allKeys)
            }
    }
    
    func getViewUnformatted(for name: String) -> some View {
        let name = name.key
        if not(card.attributes.keys.contains(name)) {
            return AnyView(Text("Not available \(name)"))
        }

        switch card[name].kind {
        case .int:
            return AnyView(NumberView(value: getBinding(for: name)))
            
        case .string:
            return AnyView(TextView(value: getBinding(for: name)))
            
        case .date:
            return AnyView(DateView(value: getBinding(for: name)))
            
        case .bool:
            return AnyView(BooleanView(value: getBinding(for: name)))
            
        case .stringArray:
            return AnyView(PopoverButton(types: card[name].asStringArray, action: {
                selectedKey = name
                needsPopover = true
            }))
        }
    }
}
