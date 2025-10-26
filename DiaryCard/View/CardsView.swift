import Foundation
import OrderedCollections
import SwiftData
import SwiftUI

struct CardsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State var cards: [Card] = []
    @State var hiddenCards: [Card] = []

    @State var showPicker = false
    @State var showHidden = true
    @State var path = NavigationPath()

    @State var start = Date().goBack(7 * .day)
    @State var end = Date()
    @State var toLatest = true

    @State var pickerDate: Date = .today
    @State var selectedDate: Binding<Date>?

    var body: some View {
        ZStack {
            Background()
                .blurIf(showPicker)
            NavigationStack(path: $path) {
                topBar

                HStack {
                    dateRangeFilter
                    Spacer()
                    navigationLinks
                }
                .padding(.horizontal, 20)
                
                HStack {
                    hideButton
                    Spacer()
                    todayCard
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                
                Spacer()
                cardList
                    .padding(.horizontal, 15)
            }
            
            pickerView.zIndex(1)
        }
        .onAppearOrChange(of: start, or: end, { refreshCards() })
    }

    var topBar: some View {
        Text("Diary Cards")
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    var dateRangeFilter: some View {
        VStack(alignment: .leading, spacing: 20) {
            getRangeButton(for: $start)
            
            HStack {
                Text("To").font(.headline)
                    .foregroundStyle(.opacity(0.5))
                    
                Toggle("Newest", isOn: $toLatest)
                    .toggleStyle(.button)
                    .buttonStyle(.borderless)
                    .font(.headline)
                    .animation(.linear, value: toLatest)
                
                getRangeButton(for: $end,
                               withColour: rangeBlue,
                               addGlass: !toLatest)
                    .onChange(of: end, {
                        toLatest = false
                    })
                    .animation(.linear, value: not(toLatest))
            }
            .padding(.leading, 10)
            .glassEffect(.clear)
            .background(rangeBlue.opacity(0.13))
            .foregroundStyle(rangeBlue)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            
        }
    }

    var navigationLinks: some View {
        VStack(alignment: .trailing, spacing: 20) {
            getToolbarButton(
                for: $pickerDate,
                showingText: "Go To",
                showingImage: "calendar",
                withColour: colorScheme == .light ? .oxblood.opacity(0.75) : .tan
            )
            .onChange(of: pickerDate, {
                path.append(getCard(for: pickerDate.startOfDay))
            })
            .navigationDestination(for: Card.self, destination: { CardView(card: $0) })
            
            NavigationLink(destination:
                            SummaryView(from: start, to: not(toLatest) ? end
                                        : .today.goForward(4 * .week)),
                           label: {
                createLabel(titleText: "Export", image: "richtext.page",
                            colour: colorScheme == .light ? .oxblood.opacity(0.75) : .tan)
            })
        }
    }
    
    var hideButton: some View {
        Button {
            showHidden.toggle()
        } label: {
            createLabel(label: showHidden ? "Hide" + String.init(repeating: .space, count: 5) : "Unhide",
                        image: showHidden ? "eye" : "eye.slash",
                        colour: showHidden ? rangeBlue : toolbarPink)
        }
    }
    
    var todayCard: some View {
        let card = getCard(for: .today)
        return NavigationLink(
            destination: CardView(card: card),
            label: { createLabel(for: card, addSuffix: " - ", withColour: toolbarPink) }
        )
    }

    var cardList: some View {
        let filtered = showHidden ? cards : cards.filter { !hiddenCards.contains($0) }

        return List {
            ForEach(filtered) { card in
                HStack {
                    createLabel(for: card, withColour: .primary, glass: false, backgroundOpacity: 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .glassEffect(.clear)
                        .foregroundStyle(.primary.opacity(hiddenCards.contains(card) ? 0.2 : 1))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 7)
                        .foregroundColor(.navy) //Apply color for arrow only
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    let isHidden = hiddenCards.contains(card)
                    Button(isHidden ? "Unhide" : "Hide", role: isHidden ? nil : .destructive) {
                        if isHidden {
                            hiddenCards.removeAll(where: { $0 == card })
                        } else {
                            hiddenCards.append(card)
                        }
                    }
                    .tint(isHidden ? .orange : .red)
                }
                .background(content: {
                    NavigationLink(destination: CardView(card: card)) {}
                        .opacity(0)
                })
            }
        }
        .listStyle(.plain)
        .background(Color.clear)
        .listRowSpacing(8)
        .scrollContentBackground(.hidden)
        .blurIf(showPicker)
        .onAppear { _ = getCard(for: .today) }
        .onAppearOrChange(of: start, or: end, { refreshCards() })
        .onChange(of: toLatest) { refreshCards() }
        .animation(.bouncy, value: cards.filter({ hiddenCards.contains($0) }).count)
    }

    var pickerView: some View {
        checkIf(
            showPicker,
            then: {
                ZStack {
                    DismissibleOverlay { showPicker = false }
                    
                    VStack(alignment: .center) {
                        DateView(value: selectedDate.orUse($pickerDate))
                            .transition(.scale.combined(with: .opacity))
                        Spacer()
                    }
                }
                .animation(.bouncy, value: showPicker)
            })
    }
    
    var rangeBlue: Color { .themed(colorScheme, light: .blue, dark: .cyan) }
    
    var toolbarPink: Color { .themed(colorScheme, light: .magenta, dark: .bubblegum) }

    func getRangeButton(for date: Binding<Date>,
                        withColour colour: Color = .blue,
                        addGlass: Bool = true) -> some View {
        getToolbarButton(
            for: date,
            called: (date.wrappedValue == end ? .nothing : "From"),
            showingText: date.wrappedValue.getRelativeDay(),
            withColour: colour == .blue ? rangeBlue : colour,
            addGlass: addGlass,
            
        )
    }

    func getToolbarButton(
        for date: Binding<Date>, called name: String = .nothing, showingText mainText: String = .nothing, showingImage image: String = .nothing, withColour colour: Color = .blue, addGlass: Bool = true
    ) -> some View {
        Button(
            action: {
                showPicker = true
                selectedDate = date
            },
            label: {
                createLabel(label: name, titleText: mainText, image: image, colour: colour, glass: addGlass)
            })
    }

    func createLabel(for card: Card, addSuffix suffix: String = .nothing, withColour colour: Color = .clear, glass: Bool = true, withImage image: String = .nothing, backgroundOpacity: Double = 0.1) -> some View {
        createLabel(
            label: [card.date.getRelativeDay(), .space, .space, .space, suffix].merged,
            titleText: ["text.comment",
                        "text.5-minute journal:fuck yeahs",
                        "text.5-minute journal:gratitude"]
                .map({ card[$0].asString })
                .filter({ not($0.isBlank()) })
                .joined(separator: ", "),
            image: image,
            colour: colour,
            glass: glass,
            font: .body,
            backgroundOpacity: backgroundOpacity
        )
    }
    
    func createLabel(label: String = .nothing, titleText: String = .nothing,
                     image: String = .nothing, colour: Color = .clear, glass: Bool = true, font size: Font = .headline, backgroundOpacity: Double = 0.1) -> some View {
        HStack {
            checkIf(not(label.isEmpty), then: {
                Text(label)
                    .foregroundStyle(.secondary)
            })
            Text(titleText).lineLimit(1)
                .truncationMode(.tail)
            checkIf(not(image.isEmpty), then: {
                Group {
                    Image(systemName: image)
                }
            })
        }
        .padding(.horizontal, 10)
        .font(size)
        .linkButtonStyle(colour: colour, backgroundOpacity: backgroundOpacity, colourScheme: colorScheme, addGlass: glass)
    }

    func getCard(for date: Date) -> Card {
        let date = Calendar.current.startOfDay(for: date)
        if let card = cards.first(where: { $0.date == date }) {
            return card
        }
        if let card = fetch(from: date, to: date, in: modelContext).first {
            return card
        }
        
        let newCard = Card(date: date, attributes: Schema.get())
        do {
            modelContext.insert(newCard)
            try modelContext.save()
            refreshCards()
        } catch let error {
            print(error)
        }
        return newCard
    }

    func refreshCards() {
        self.cards = fetch(
            from: start, to: not(toLatest) ? end : .today.goForward(4 * .week),
            in: modelContext)
    }
}

struct SwipeableRow<Content: View, ActionContent: View>: View {
    let actionWidth: CGFloat
    let onAction: () -> Void
    @ViewBuilder let actionContent: () -> ActionContent
    @ViewBuilder let content: () -> Content

    @GestureState private var dragX: CGFloat = 0
    @State private var offsetX: CGFloat = 0

    private func clampedOffset(for translationWidth: CGFloat) -> CGFloat {
        let proposed = offsetX + translationWidth
        return min(0, max(-actionWidth, proposed))
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            // Trailing action background/content
            actionContent()
                .frame(maxWidth: .infinity, alignment: .trailing)

            // Foreground content that slides
            content()
                .offset(x: offsetX + dragX)
                .contentShape(Rectangle())
                .highPriorityGesture(
                    DragGesture(minimumDistance: 10, coordinateSpace: .local)
                        .updating($dragX) { value, state, _ in
                            let clamped = clampedOffset(for: value.translation.width)
                            state = clamped - offsetX
                        }
                        .onEnded { value in
                            let clamped = clampedOffset(for: value.translation.width)
                            let shouldOpen = clamped < -actionWidth * 0.5
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                                offsetX = shouldOpen ? -actionWidth : 0
                            }
                        }
                )
                .overlay(
                    Group {
                        if offsetX != 0 {
                            Color.clear
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                                        offsetX = 0
                                    }
                                }
                        }
                    }
                )
        }
        .frame(maxWidth: .infinity)
        .clipped()
    }
}


#Preview("Default Cards Search View", traits: .cardSampleData) {
    NavigationStack { CardsView() }
}

