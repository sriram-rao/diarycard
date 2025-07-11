import Foundation
import SwiftData
import SwiftUI

struct CardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @Query() var lists: [ListSchemas]
    let card: Card
    
    @State var showPicker: Bool = false
    @State var needsPopover: Bool = false
    
    var showTapBackground: Bool {
        return showPicker || needsPopover
    }
    
    @State var selectedKey: String = ""
    @ScaledMetric var attributeNameWidth: CGFloat = 120
    
    var textKeys: [String] {
        get { card.attributes.filter({ $0.value.kind == .string }).keys.sorted() }
    }
    var otherKeys: [String] {
        get { card.attributes.keys.filter { !textKeys.contains($0) }.sorted()}
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                measures.zIndex(0).blur(radius: 3 * (showTapBackground ? 1 : 0))
            }
            run_if( showTapBackground, {
                return TapBackground {
                    needsPopover = false
                    showPicker = false
                    selectedKey = ""
            }.zIndex(1)} )
            run_if( needsPopover, { return popover.zIndex(2)} )
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var measures: some View {
        VStack {
            Text(getRelativeDay(date: card.date)).font(.title)
            
            VStack {
                renderKeys(keys: textKeys)
                renderKeys(keys: otherKeys)
            }
            .padding(.vertical, 20)
        }
    }
    
    var popover: some View {
        let binding = Binding<[String]>(
            get: { self.card[selectedKey].asStringArray },
            set: { self.card.attributes[selectedKey] = Value.wrap($0) })
        return VStack(alignment: .center) {
            Spacer()
            PopoverList(selected: binding, full: lists.first!.schemas[selectedKey] ?? [])
        }
    }
    
    func renderKeys(keys: [String]) -> some View {
        ForEach(keys, id: \.capitalized) {key in
            Group {
                if (compoundKeys.contains(key)) {
                    renderCompound(key: key)
                }
                else if compoundKeys.contains(where: {compoundKey in
                    key.hasPrefix(compoundKey) }) && isSubKey(key) {
                    EmptyView()
                }
                else {
                    render(key: key)
                }
            }
            .border(Color.gray.opacity(0.2), width: 1)
            .padding(.horizontal, 50)
            .padding(.vertical, 5)
        }
    }
    
    func render(key: String) -> some View {
        return VStack (alignment: .leading) {
            getNameView(name: key)
                .font(.system(size: 16).lowercaseSmallCaps())
                .padding(.leading, 10)
            getView(name: key)
                .font(.system(size: 18))
                .contentShape(Rectangle())
        }
    }
    
    func renderCompound(key: String) -> some View {
        let group = card.attributes.keys.filter { cardKey in
            cardKey.hasPrefix(key) && cardKey != key
        }
        return AnyView(HStack {
            render(key: key)
            ForEach(group, id: \.self) {key in
                render(key: key)
            }
        })
    }
    
    func isSubKey(_ key: String) -> Bool {
        compoundKeys.contains(where: {compoundKey in
            key.hasPrefix(compoundKey)
        })
    }
    
    let compoundKeys: Array<String> = [
        "behaviour.2.suicidal ideation"]
    
    func getPopoverButton(name: String) -> some View {
        Button(action: {
            selectedKey = name
            needsPopover = true
        }, label: {
            Text(ListFormatter().string(from: card[name].asStringArray) ?? "Add skills")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .lineLimit(1)
        })
        .zIndex(0)
    }
    
    func getView(name: String) -> some View {
        switch card[name].kind {
        case .int:
            let binding = Binding<String> (
                get: { String(card[name].asInt) == "0" ? "" : String(card[name].asInt) },
                set: { newValue in
                    card.attributes[name] = .int(Int(newValue) ?? 0)
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
            return AnyView(getPopoverButton(name: name))
            
        case .bool:
            let binding: Binding<Bool> = getBinding(key: name)
            return AnyView(BooleanView(value: binding))
        }
    }

}
