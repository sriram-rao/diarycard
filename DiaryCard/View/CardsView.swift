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
                .onChange(of: date.wrappedValue) {
                    print("Date: \(date.wrappedValue)")
                    path.append(getCard(for: date.wrappedValue.startOfDay))
                }
            Spacer()
        }
    }
    
    var pickerButton: some View {
        Button(action: {
            showPicker = true
            selectedDate = $pickerDate
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
            Text(date.wrappedValue == end ? "To" : .nothing)
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
        refreshCards()
        return newCard
    }
    
    func deleteCard(_ indices: IndexSet) {
        for index in indices {
            modelContext.delete(cards[index])
        }
    }
    
    func refreshCards() {
        self.cards = fetch(from: start, to: end, in: modelContext)
    }
}
