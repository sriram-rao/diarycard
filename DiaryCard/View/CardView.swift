import Foundation
import OrderedCollections
import SwiftData
import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    let card: Card


    var body: some View {
        ZStack {
            backgroundLayer
            layer0
            layer1
            layer2
            errorLayer
        }
        .toolbar {
            topBar
            keyboardBar
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var backgroundLayer: some View {
        Background()
            .blurIf(needsTapBackground)
    }

    var layer0: some View {
        ScrollView {
            VStack {
                renderKeys(textKeys)
                showColumns()
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
        Color.clear
            .contentShape(Rectangle())
            .allowsHitTesting(needsTapBackground)
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.3)) {
                    viewState.needsPopover = false
                    viewState.needsDateSelection = false
                    viewState.selectedKey = .nothing
                    focusField = .nothing
                    dismissKeyboard()
                }
            }
    }

    var layer2: some View {
        Group {
            checkIf(viewState.needsPopover) {
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

            checkIf(viewState.needsDateSelection) {
                VStack{
                    DateView(value: card.getDateBinding())
                        .padding(.top, 30)
                    Spacer()
                }
            }
        }
    }

    var errorLayer: some View {
        ErrorView(message: viewState.errorMessage) {
            withAnimation {
                viewState.errorMessage = nil
            }
        }
    }

    var topBar: some ToolbarContent {
        ToolbarItemGroup(
            placement: .principal,
            content: {
                Button(action: { withAnimation { viewState.needsDateSelection = true } },
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
            .buttonStyle(.glass)
            .controlSize(.regular)
            .font(.callout)
            .padding(.trailing, 12)
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
            get: {
                guard card.keys.contains(viewState.selectedKey.key) else {
                    showError("Invalid key: \(viewState.selectedKey.key)")
                    return []
                }
                return self.card[viewState.selectedKey.key].asStringArray
            },
            set: {
                self.card.attributes[viewState.selectedKey.key] = Value.wrap($0)
            }
        )
        return VStack(spacing: 20) {
            Text(viewState.selectedKey.field.capitalized)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            PopoverList(selected: binding, items: Skills[viewState.selectedKey.key].orUse([]))
                .transition(.slide)
        }
        .padding(24)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .contentShape(Rectangle())
    }

    @State private var viewState = ViewState()
    @FocusState private var focusField: String?
    @ScaledMetric private var attributeNameWidth: CGFloat = 60

    struct ViewState {
        var needsPopover: Bool = false
        var needsDateSelection: Bool = false
        var selectedKey: String = .nothing
        var errorMessage: String?
    }

    var needsTapBackground: Bool {
        viewState.needsPopover || viewState.needsDateSelection
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
    
    func showColumns(aligned: HorizontalAlignment = .center) -> some View {
        let groups = OrderedDictionary(
            grouping: Schema.getKeysIf(include: false, types: [.string, .stringArray]),
            by: { $0.key.group })

        return HStack(alignment: .firstTextBaseline, spacing: 8) {
            ForEach(groups.keys.sorted(), id: \.hashValue) { key in
                VStack(alignment: aligned, spacing: 0) {
                    getNameView(for: key, ofSize: .callout)
                        .foregroundStyle(.secondary)
                    renderKeys(groups[key].orUse([]), alignment: .center)
                }
                .frame(maxWidth: 390 / 2)
            }
        }
    }

    func renderKeys(_ keys: [String], alignment: HorizontalAlignment = .leading) -> some View {
        VStack(spacing: 3) {
            ForEach(keys, id: \.capitalized) { key in
                VStack(alignment: alignment) {
                    render(key: key, group: key.getSubfields(keys: keys))
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 5)
            }
        }
    }
    
    func render(key: String, group: [String]) -> some View {
        if not(key.isStandalone(in: card.keys)) {
            return AnyView(EmptyView())
        }
        switch card[key.key].kind {
            case .int: return AnyView(render_number(key: key, group: group))
            case .string: return AnyView(render_text(key: key, group: group))
            case .stringArray: return AnyView(render_list(key: key, group: group))
            case .bool: return AnyView(render_text(key: key, group: group))
            case .date: return AnyView(render_text(key: key, group: group))
        }
    }
    
    func render_text(key: String, group: [String]) -> some View {
        render_base(key: key, group: group, arrange: {(keyView, valueView, subKeyView) in
            VStack(alignment: .leading) {
                keyView
                valueView
                subKeyView
            }
        })
    }
    
    func render_number(key: String, group: [String]) -> some View {
        return render_base(key: key, group: group, arrange: {(keyView, valueView, subKeyView) in
            VStack(alignment: .center) {
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 40, height: 30)
                        .foregroundStyle(.clear)
                    keyView.padding(.bottom, 60)
                    valueView.padding(.top, 10)
                }
                subKeyView.padding(.top, -35)
            }
        })
    }
    
    func render_list(key: String, group: [String]) -> some View {
        render_base(key: key, group: group, arrange: {(keyView, valueView, subKeyView) in
            VStack(alignment: .leading) {
                valueView
                subKeyView
            }
        })
    }
    
    func render_base(key: String, group: [String], arrange: (AnyView, AnyView, AnyView) -> (some View)) -> some View {

        let keyView = AnyView(getNameView(
            for: key.isStandalone(in: card.keys) ? key.label : .nothing,
            description: FieldDescriptions[key.key]
        ).padding(.bottom, 5))
        
        let valueView = AnyView(getView(for: key)
            .focused($focusField, equals: key))
        
        let subKeyView = AnyView(ForEach(group, id: \.self) { subKey in
            getView(for: subKey)
        })
        
        return arrange(keyView, valueView, subKeyView)
    }

    func focusNext(forwards: Bool = true) {
        let nextFocus = getNextField(
            after: focusField.orUse(viewState.selectedKey),
            in: allKeys, going: forwards)
        if not(nextFocus.isBlank()) {
            focusField = nextFocus
        }
        viewState.needsPopover = nextFocus.group.equals("skills")
        viewState.selectedKey = viewState.needsPopover ? nextFocus : .nothing
    }
    
    func showError(_ message: String) {
        withAnimation {
            viewState.errorMessage = message
        }
        
        // Auto-dismiss after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                if viewState.errorMessage == message { // Only clear if it's the same message
                    viewState.errorMessage = nil
                }
            }
        }
    }

    @ViewBuilder
    func getView(for key: String) -> some View {
        let base = getViewUnformatted(for: key)
            .font(.system(size: 16))
            .focused($focusField, equals: key)
            .frame(alignment: .center)

        if card[key.key].kind != .stringArray {
            base.glassyTextBackground(
                isFocused: $focusField.wrappedValue == key,
                tinted: getColor(for: key)
            )
        } else {
            base
        }
    }
    
    func getColor(for key: String) -> Color {
        if card[key.key].kind != .int {
            return Color.clear
        }
        let value = card[key.key].asInt
        if value <= 3 {
            return Color.gray
        }
        if value < 7 {
            return Color.blue
        }
        return Color.red
    }

    @ViewBuilder
    func getViewUnformatted(for attribute: String) -> some View {
        let name = attribute.key
        if !card.hasKey(name) {
            EmptyView()
        } else {
            switch card[name].kind {
            case .int:
                NumberView(value: getBinding(for: name), preselectText: true)
                    .accessibilityLabel("\(attribute.field) number")
                
            case .string:
                TextView(value: getBinding(for: name), preselectText: false)
                    .accessibilityLabel("\(attribute.field) text")
                
            case .date:
                DateView(value: getBinding(for: name))
                    .accessibilityLabel("\(attribute.field) date")
                
            case .bool:
                BooleanView(value: getBinding(for: name))
                    .accessibilityLabel("\(attribute.field) toggle")
                
            case .stringArray:
                PopoverButton(
                    title: attribute.field.capitalized,
                    types: card[name].asStringArray,
                    action: {
                        focusField = attribute
                        viewState.selectedKey = attribute
                        viewState.needsPopover = true
                    }
                )
                .accessibilityLabel("\(attribute.field) skills")
                .accessibilityHint("Double-tap to select")
                .padding(.top, 8)
            }
        }
    }
}

#Preview("Default Card", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    NavigationStack {
        CardView(card: cards.first!)
    }
}

