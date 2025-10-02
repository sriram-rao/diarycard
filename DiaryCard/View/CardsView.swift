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
                .padding(.horizontal, 20)
                Spacer()
                cardList
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
        VStack(alignment: .leading, spacing: 15) {
            getRangeButton(for: $start)
            
            HStack {
                Text("To").font(.headline)
                    .foregroundStyle(.opacity(0.5))
                    
                Toggle("Newest", isOn: $toLatest)
                    .toggleStyle(.button)
                    .buttonStyle(.borderless)
                    .font(.headline)
                    .animation(.linear, value: toLatest)
                
                getRangeButton(for: $end, withColour: toLatest ? .clear : rangeBlue)
                    .onChange(of: end, {
                        toLatest = false
                    })
                    .animation(.linear, value: not(toLatest))
            }
            .padding(.leading, 10)
            .background(rangeBlue.opacity(0.13))
            .foregroundStyle(rangeBlue)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            
        }
    }

    var navigationLinks: some View {
        VStack(alignment: .trailing, spacing: 15) {
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
        ScrollView {
            ForEach(cards.filter({ not(hiddenCards.contains($0))
                                || showHidden })) { card in
                NavigationLink(
                    destination: CardView(card: card),
                    label: {
                        createLabel(for: card)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .foregroundStyle(.primary.opacity(
                    hiddenCards.contains(card) ? 0.5 : 1))
                .padding(5)
                .glassEffect(.clear)
                .swipeActions {
                    Button(role: .destructive){
                        hiddenCards.contains(card)
                        ? hiddenCards.removeAll(where: { $0 == card })
                        : hiddenCards.append(card)
                    } label: {
                        hiddenCards.contains(card)
                        ? Label("Hide", systemImage: "eye.slash")
                        : Label("Unhide", systemImage: "eye")
                    }
                }
                .padding(5)
            }
        }
        .backgroundStyle(.clear)
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
                        withColour colour: Color = .blue ) -> some View {
        getToolbarButton(
            for: date,
            called: (date.wrappedValue == end ? .nothing : "From"),
            showingText: date.wrappedValue.getRelativeDay(),
            withColour: colour == .blue ? rangeBlue : colour
        )
    }

    func getToolbarButton(
        for date: Binding<Date>, called name: String = .nothing, showingText mainText: String = .nothing, showingImage image: String = .nothing, withColour colour: Color = .blue
    ) -> some View {
        Button(
            action: {
                showPicker = true
                selectedDate = date
            },
            label: {
                createLabel(label: name, titleText: mainText, image: image, colour: colour)
            })
    }

    func createLabel(for card: Card, addSuffix suffix: String = .nothing, withColour colour: Color = .clear, withImage image: String = .nothing) -> some View {
        createLabel(
            label: [card.date.getRelativeDay(), suffix].merged,
            titleText: ["text.comment",
                        "text.5-minute journal:fuck yeahs",
                        "text.5-minute journal:gratitude"]
                .map({ card.get(key: $0) .asString })
                .filter({ not($0.isBlank()) })
                .joined(separator: ", "),
            image: image,
            colour: colour,
            font: .body,
        )
    }
    
    // createLabel(
    func createLabel(label: String = .nothing, titleText: String = .nothing,
                     image: String = .nothing, colour: Color = .clear, font size: Font = .headline) -> some View {
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
        .font(size)
        .linkButtonStyle(colour: colour, colourScheme: colorScheme)
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


#Preview("Default Cards Search View", traits: .cardSampleData) {
    NavigationStack { CardsView() }
}
