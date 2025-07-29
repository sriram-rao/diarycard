import Foundation
import SwiftData
import SwiftUI

struct CardsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State var cards: [Card] = []

    @State var showPicker = false
    @State var path = NavigationPath()

    @State var start = Date().goBack(7 * .day)
    @State var end = Date()

    @State var pickerDate: Date = .today
    @State var selectedDate: Binding<Date>? = nil

    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                topBar

                HStack {
                    dateRangeFilter
                    Spacer()
                    navigationLinks
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 20)

                Spacer()

                cardList
                    .navigationDestination(for: Card.self) { CardView(card: $0) }
            }
            pickerView.zIndex(1)
        }
        .onAppearOrChange(of: start, or: end, refreshCards)
    }

    var topBar: some View {
        Text("Diary Cards")
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    var dateRangeFilter: some View {
        VStack(alignment: .leading, spacing: 15) {
            getRangeButton(for: $start)
            getRangeButton(for: $end)
        }
    }

    var navigationLinks: some View {
        VStack(alignment: .trailing, spacing: 15) {
            getToolbarButton(
                for: $pickerDate, called: "Go To",
                showing: { Image(systemName: "calendar") }
            )
            .onChange(
                of: pickerDate,
                {
                    path.append(getCard(for: pickerDate.startOfDay))
                })

            getQuickLink(
                to: "Export", with: "richtext.page",
                at: SummaryView(from: start, to: end))
        }
    }

    var cardList: some View {
        List {
            ForEach(cards) { card in
                NavigationLink(
                    destination: CardView(card: card),
                    label: { createLabel(for: card) })
            }
            .onDelete(perform: deleteCard)
        }
        .blurIf(showPicker)
        .task { _ = getCard(for: .today) }
    }

    var pickerView: some View {
        checkIf(
            showPicker,
            then: {
                Group {
                    TapBackground { showPicker = false }
                    VStack(alignment: .center) {
                        DateView(value: selectedDate.orDefault(to: $pickerDate))
                            .pickerStyle()
                        Spacer()
                    }
                }
            })
    }

    func getRangeButton(for date: Binding<Date>) -> some View {
        getToolbarButton(
            for: date,
            called: (date.wrappedValue == end ? "To" : "From"),
            showing: { Text(date.wrappedValue.getRelativeDay()).foregroundStyle(.blue) })
    }

    func getToolbarButton(
        for date: Binding<Date>, called name: String = .nothing, showing label: () -> some View
    ) -> some View {
        Button(
            action: {
                showPicker = true
                selectedDate = date
            },
            label: {
                Group {
                    Text(name)
                    label()
                }
                .font(.headline)
                .blackAndWhite(theme: colorScheme)
            })
    }

    func getQuickLink(
        to name: String, with systemImage: String,
        at destination: some View
    ) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(name)
                Image(systemName: systemImage)
            }.font(.headline)
                .blackAndWhite(theme: colorScheme)
        }
    }

    func createLabel(for card: Card) -> some View {
        Group {
            Text(card.date.getRelativeDay())
                .foregroundStyle(.secondary)
            Text(card["text.comment"].asString)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }

    func getCard(for date: Date) -> Card {
        let date = Calendar.current.startOfDay(for: date)
        if let card = cards.first(where: { $0.date == date }) {
            return card
        }
        let newCard = Card(date: date, attributes: Schema.get())
        do {
            modelContext.insert(newCard)
            try modelContext.save()
            refreshCards()
        } catch (let error) {
            print(error)
        }
        return newCard
    }

    func deleteCard(_ indices: IndexSet) {
        do {
            for index in indices {
                modelContext.delete(cards[index])
            }
            try modelContext.save()
        } catch (let error) {
            print(error)
        }
    }

    func refreshCards() {
        self.cards = fetch(from: start, to: end, in: modelContext)
    }
}
