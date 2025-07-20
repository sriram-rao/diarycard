import Foundation
import SwiftData
import SwiftUI

struct CardsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Query(sort: \Card.date, order: .reverse) var cards: [Card]
    
    @State var showPicker: Bool = false
    @State var path = NavigationPath()
    
    @State var insertedToday: Bool = false
    @State private var todayCard: Card?
    @State var dateRange: DateInterval?
    
    @State var today: Date = Calendar.current.startOfDay(for: Date())
    
    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                topBar.padding()
                Spacer()
                
                List{
                    ForEach(cards) { card in
                        NavigationLink {
                            CardView(card: card)
                        } label: {
                            createLabel(for: card)
                        }
                    }
                    .onDelete(perform: deleteCard)
                }
                .blur(radius: 3 * (showPicker ? 1 : 0))
                .navigationDestination(for: Card.self) { card in
                    CardView(card: card)
                }
                .task {
                    guard !insertedToday else { return }
                    insertedToday.toggle()
                    todayCard = getCard(for: today)
                }
            }
            
            run_if(showPicker, then: {
                Group {
                    TapBackground { showPicker = false }.zIndex(1)
                    picker.zIndex(2)
                }
            })
        }
    }
    
    var topBar: some View {
        HStack {
            Spacer()
            Text("Diary Cards")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                showPicker.toggle()
            }, label: {
                Image(systemName: "calendar")
                    .font(.title)
                    .foregroundStyle((colorScheme == .light ? Color.black : .white).opacity(0.75))
            })
        }
    }
    
    var picker: some View {
        VStack(alignment: .center) {
            DateView(value: $today)
                .datePickerStyle(.graphical)
                .padding(.vertical, 30)

                .background(Color(.systemBackground).opacity(0.1))
                .background(.ultraThinMaterial.opacity(0.80))
                .cornerRadius(20)
                .scaleEffect(0.85)
                .onChange(of: today) {
                    let date = Calendar.current.startOfDay(for: today)
                    path.append(getCard(for: date))
                }
            Spacer()
        }
    }
    
    func createLabel(for card: Card) -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return Group {
            Text(getRelativeDay(date: card.date))
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
        return newCard
    }
    
    func deleteCard(_ indices: IndexSet) {
        for index in indices {
            modelContext.delete(cards[index])
        }
    }
}
