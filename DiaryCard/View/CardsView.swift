import Foundation
import SwiftData
import SwiftUI

struct CardsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State var cards: [Card] = []
    
    @State var showPicker = false
    @State var path = NavigationPath()
    
    @State var start = Date().goBack(30 * .day)
    @State var end = Date()
    
    @State var today: Date = Calendar.current.startOfDay(for: Date())
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
        .onChange(anyOf: start, end) { fetch() }
    }
    
    var topBar: some View {
        VStack {
            Text("Diary Cards")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack {
                getRangeButton(for: $start).padding(.leading, 20)
                getRangeButton(for: $end)
                Spacer()
                pickerButton.padding(.trailing, 20)
            }
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
        .task { _ = getCard(for: today) }
    }
    
    var pickerView: some View {
        seeIf(showPicker, then: {
            Group {
                TapBackground { showPicker = false }
                getPicker(for: selectedDate ?? $today)
            }
        })
    }
    
    func getPicker(for date: Binding<Date>) -> some View {
        VStack(alignment: .center) {
            DateView(value: date)
                .pickerStyle()
                .onChange(of: today) {
                    let date = Calendar.current.startOfDay(for: today)
                    path.append(getCard(for: date))
                }
            Spacer()
        }
    }
    
    var pickerButton: some View {
        Button(action: {
            showPicker = true
            selectedDate = $today
        }, label: {
            Text("Date")
                .font(.headline)
                .blackAndWhite(theme: colorScheme)
            Image(systemName: "calendar")
                .font(.headline)
                .blackAndWhite(theme: colorScheme)
        })
    }
    
    func getRangeButton(for date: Binding<Date>) -> some View {
        Button(action: {
            showPicker = true
            selectedDate = date
        }, label: {
            Text(date.wrappedValue == start ? "From" : "To")
                .blackAndWhite(theme: colorScheme)
            Text(date.wrappedValue.getRelativeDay())
                .font(.headline)
                .foregroundStyle(.blue)
        })
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
        let newCard = Card(date: date, attributes: CardSchema.get())
        modelContext.insert(newCard)
        fetch()
        return newCard
    }
    
    func deleteCard(_ indices: IndexSet) {
        for index in indices {
            modelContext.delete(cards[index])
        }
    }
    
    func fetch() {
        let fetcher = FetchDescriptor<Card>(
            predicate: #Predicate { $0.date >= start && $0.date <= end },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        cards = (try? modelContext.fetch(fetcher)) ?? []
    }
}
