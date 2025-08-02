import Foundation
import OrderedCollections
import SwiftData
import SwiftUI

struct CardView: View {
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
                renderKeys(keys: textKeys)
                renderColumns()
                renderKeys(
                    keys: Schema.attributes.filter { $0.value.kind == .stringArray }.keys.elements)
            }
            .blurIf(needsTapBackground)
        }
        .onTapGesture {
            focusField = .nothing
            dismissKeyboard()
        }
    }

    var layer1: some View {
        VStack {
            checkIf(
                needsTapBackground,
                then: {
                    TapBackground {
                        withAnimation {
                            needsPopover = false
                            needsDateSelection = false
                            selectedKey = .nothing
                            focusField = .nothing
                            dismissKeyboard()
                        }
                    }
                    .transition(.opacity)
                })
        }
    }

    var layer2: some View {
        Group {
            checkIf(needsPopover) {
                VStack {
                    Spacer()
                    Text(selectedKey.field.capitalized)
                        .font(.headline)
                        .padding(.bottom, 20)
                    popover
                    HStack{
                        Spacer()
                        checkIf(focusField != allKeys.first, then: {
                            Button(
                                action: { withAnimation {
                                    focusNext(forwards: false)
                                } },
                                label: { Text("Previous") })
                            .padding(.trailing, 20)
                            .buttonStyle(.borderedProminent)
                            .tint(.secondary)
                        })
                        checkIf(focusField != allKeys.last, then: {
                            Button(action: { withAnimation { focusNext() } },
                                   label: { Text("Next") })
                            .padding(.trailing, 20)
                            .buttonStyle(.borderedProminent)
                        })
                    }
                }.padding(.bottom, 25)
                    .transition(.opacity)
            }

            checkIf(needsDateSelection) {
                DateView(value: card.getDateBinding())
                    .pickerStyle()
            }
        }
    }

    var topBar: some ToolbarContent {
        ToolbarItemGroup(
            placement: .principal,
            content: {
                Button(
                    action: {
                        withAnimation { needsDateSelection = true }
                    },
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
            checkIf(
                not(focusField == allKeys.first),
                then: {
                    Button("Previous", action: {
                        withAnimation { focusNext(forwards: false) }
                    })
                })
            checkIf(
                not(focusField == allKeys.last),
                then: {
                    Button("Next", action: { withAnimation { focusNext() } })
                })
            Button("Done", action: dismissKeyboard)
        }
    }

    var popover: some View {
        let binding = Binding<[String]>(
            get: { self.card[selectedKey.key].asStringArray },
            set: { self.card.attributes[selectedKey.key] = Value.wrap($0) }
        )
        return PopoverList(selected: binding, full: Skills[selectedKey.key].orUse([]))
    }

    @State var needsPopover: Bool = false
    @State var needsDateSelection: Bool = false
    @State var selectedKey: String = .nothing
    @FocusState var focusField: String?
    @ScaledMetric var attributeNameWidth: CGFloat = 120

    var needsTapBackground: Bool {
        needsPopover || needsDateSelection
    }

    var textKeys: [String] {
        Schema.attributes.filter({ $0.value.kind == .string }).keys.sorted()
    }

    var nonTextKeys: OrderedDictionary<String, [String]> {
        OrderedDictionary(
            grouping: Schema.attributes.keys.filter { !(textKeys.contains($0)) },
            by: { $0.group }
        )
    }

    var allKeys: [String] {
        textKeys + nonTextKeys.values.flatMap(\.self).filter({ not($0.isSubfield) })
    }

    func renderKeys(keys: [String], alignment: HorizontalAlignment = .leading) -> some View {
        ForEach(keys, id: \.capitalized) { key in
            VStack(alignment: alignment) {
                checkIf(
                    not(key.getSubfields(keys: keys).isEmpty),
                    then: { renderCompound(key: key) },
                    otherwise: {
                        checkIf(key.checkStandalone(in: keys), then: { render(key: key) })
                    })
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
    }

    func render(key: String, aligned: HorizontalAlignment = .leading) -> some View {
        VStack(alignment: aligned) {
            getNameView(for: key.checkStandalone(in: card.keys)
                        ? key.label : .nothing)
                .foregroundStyle(.blue)
            getView(for: key)
        }
    }

    func renderCompound(key: String, aligned: HorizontalAlignment = .center) -> some View {
        let group = key.key.getSubfields(keys: card.keys)
        return VStack(alignment: aligned) {
            getNameView(for: key.field).foregroundStyle(.blue)
            ForEach(group, id: \.self) { key in
                render(key: key)
            }
            getView(for: key)
        }
    }

    func renderColumns(aligned: HorizontalAlignment = .center) -> some View {
        let measureKeys = Schema.attributes.filter {
            not([.string, .stringArray].contains($0.value.kind))
        }.keys
        let groups = OrderedDictionary(
            grouping: measureKeys, by: { $0.key.group }
        )
        return HStack(alignment: .firstTextBaseline) {
            ForEach(groups.keys.sorted(), id: \.hashValue) { key in
                VStack(alignment: aligned) {
                    getNameView(for: key, ofSize: .callout)
                        .foregroundStyle(.black)
                    renderKeys(keys: groups[key].orUse([]), alignment: .center)
                }
                .frame(maxWidth: 370 / 2)
                .padding(.vertical, 10)
            }
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
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(focusField == key ? Color.sky : Color.clear, lineWidth: 1)
            )
    }

    func getViewUnformatted(for attribute: String) -> some View {
        let name = attribute.key
        if not(card.keys.contains(name)) {
            return AnyView(Text("Not available \(name)"))
        }

        switch card[name].kind {
        case .int:
            return AnyView(NumberView(value: getBinding(for: name), preselectText: true))
            
        case .string:
            return AnyView(TextView(value: getBinding(for: name), preselectText: true))
            
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
