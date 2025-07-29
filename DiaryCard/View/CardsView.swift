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
                Spacer()
                cardList
                .navigationDestination(for: Card.self) { card in
                    CardView(card: card)
                }
            }
            pickerView.zIndex(1)
        }
        .onAppearOrChange(of: start, or: end, refreshCards)
    }
    
    var topBar: some View {
        VStack {
            Text("Diary Cards")
                .font(.largeTitle)
                .fontWeight(.bold)
            HStack {
                VStack (alignment: .leading, spacing: 15) {
                    getRangeButton(for: $start)
                    getRangeButton(for: $end)
                }
                
                Spacer()
                VStack (alignment: .trailing, spacing: 15) {
                    getToolbarButton(for: selectedDate.orDefaultTo($pickerDate),
                                     called: "Go To",
                                     showing: { Image(systemName: "calendar") })

                    getQuickLink(to: "Export", with: "richtext.page",
                                 at: SummaryView(from: start, to: end))
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
        }
    }
    
    var cardList: some View {
        List{
            ForEach(cards) { card in
                NavigationLink(destination: CardView(card: card),
                               label: { createLabel(for: card) })
            }
            .onDelete(perform: deleteCard)
        }
        .blurIf(showPicker)
        .task { _ = getCard(for: .today) }
    }
    
    var pickerView: some View {
        checkIf(showPicker, then: {
            Group {
                TapBackground { showPicker = false }
                getPicker(for: selectedDate.orDefaultTo($pickerDate))
            }
        })
    }
    
    func getPicker(for date: Binding<Date>) -> some View {
        VStack(alignment: .center) {
            DateView(value: date)
                .pickerStyle()
                .onChange(of: date.wrappedValue, {
                    print("Path appending")
                    path.append(getCard(for: date.wrappedValue.startOfDay))
                })
            Spacer()
        }
    }
    
    func getRangeButton(for date: Binding<Date>) -> some View {
        getToolbarButton(for: date,
                         called: (date.wrappedValue == end ? "To" : "From"),
                         showing: { Text(date.wrappedValue.getRelativeDay()).foregroundStyle(.blue) })
    }
    
    func getToolbarButton(for date: Binding<Date>, called name: String = .nothing, showing label: () -> some View) -> some View {
        Button(action: {
            showPicker = true
            selectedDate = date
        }, label: {
            Group {
                Text(name)
                label()
            }
            .font(.headline)
            .blackAndWhite(theme: colorScheme)
        })
    }
    
    func getQuickLink(to name: String, with systemImage: String,
                      at destination: some View) -> some View {
        NavigationLink(destination: destination) {
            HStack { Text(name)
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
        } catch(let error) {
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
