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
                    renderKeys(keys: nonTextKeys[key] ?? [])
                }
                .padding(.vertical, 10)
            }
        }
        .blurIf(showTapBackground)
    }}
    
    var layer_1: some View {
        VStack {
            run_if(showTapBackground, then: {
                TapBackground {
                    needsPopover = false
                    selectedKey = ""
                }
            })
        }
    }
    
    var layer_2: some View {
        run_if(needsPopover, then: {
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
            if  (focusField != allKeys.last) {
                Button("Next", action: focusNext)
            }
            Button("Done", action: clearKeyboard)
        }
    }
    
    var debug: some View {
        Text("Current Focus: \(focusField ?? "")")
            .padding(.bottom, 100)
            .bold()
    }
    
    var popover: some View {
        let binding = Binding<[String]>(
            get: { self.card[selectedKey].asStringArray },
            set: { self.card.attributes[selectedKey] = Value.wrap($0) }
        )
        return PopoverList(selected: binding, full: Skills[selectedKey] ?? [])
    }
    
    @State var needsPopover: Bool = false
    @State var selectedKey: String = ""
    @FocusState var focusField: String?
    @ScaledMetric var attributeNameWidth: CGFloat = 120
    
    var showTapBackground: Bool {
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
        textKeys + nonTextKeys.values.flatMap(\.self).filter({ !$0.isSubType() })
    }
    
    func renderKeys(keys: [String]) -> some View {
        return ForEach(keys, id: \.capitalized) {key in
            Group {
                if key.getSubfields(keys: keys).count > 0 {
                    renderCompound(key: key)
                }
                else if key.isSubType() {
                    EmptyView()
                }
                else {
                    render(key: key)
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
        }
    }
    
    func render(key: String) -> some View {
        VStack (alignment: .leading) {
            getNameView(name: key)
                .font(.system(size: 16).lowercaseSmallCaps())
                .padding(.leading, 10)
            getView(name: key)
                .font(.system(size: 18))
                .contentShape(Rectangle())
                .focused($focusField, equals: key)
                .onSubmit {
                    focusField = getNextField(after: key, in: allKeys)
                }
            Divider()
        }
    }
    
    func renderCompound(key: String) -> some View {
        let group = key.key.getSubfields(keys: card.keys)
        return AnyView(
            VStack (alignment: .leading) {
                HStack {
                    getNameView(name: key)
                        .font(.system(size: 16).lowercaseSmallCaps())
                        .padding(.leading, 10)
                    
                    Spacer()
                    ForEach(group, id: \.self) {key in
                        render(key: key)
                    }
                }
                
                getView(name: key)
                    .font(.system(size: 18))
                    .contentShape(Rectangle())
                    .focused($focusField, equals: key)
                    .onSubmit {
                        focusField = getNextField(after: key, in: allKeys)
                    }
            }
        )
    }
    
    func focusNext() {
        let nextFocus = getNextField(after: focusField ?? "", in: allKeys)
        if !nextFocus.isEmptyOrWhitespace() {
            focusField = nextFocus
        }
        if nextFocus.getGroup() == "skills" {
            selectedKey = nextFocus.key
            needsPopover = true
        }
        
        print(String(repeating: "-", count: 50))
    }
    
    func getView(name: String) -> some View {
        let name = name.key
        if !card.attributes.keys.contains(name) {
            return AnyView(Text("Not available \(name)"))
        }
        
        switch card[name].kind {
        case .int:
            let binding = Binding<Float> (
                get: { Float(card[name].asInt) },
                set: { newValue in
                    card.attributes[name] = .int(Int(newValue) )
                })
            return AnyView(NumberView(value: binding))
            
        case .string:
            let binding: Binding<String> = getBinding(key: name)
            return AnyView(TextView(value: binding))
            
        case .date:
            let binding: Binding<Date> = getBinding(key: name)
            return AnyView(DateView(value: binding))
            
        case .stringArray:
            let _: Binding<[String]> = getBinding(key: name)
            return AnyView(PopoverButton(types: card[name].asStringArray, action: {
                selectedKey = name
                needsPopover = true
            }))
            
        case .bool:
            let binding: Binding<Bool> = getBinding(key: name)
            return AnyView(BooleanView(value: binding))
        }
    }
}
