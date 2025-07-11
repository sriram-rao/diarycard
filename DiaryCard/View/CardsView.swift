import Foundation
import SwiftData
import SwiftUI

struct CardsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Card.date, order: .reverse) var cards: [Card]
    @State var showPicker: Bool = false
    @State var path = NavigationPath()
    @State var appStart: Bool = true
    @State var dummyDate: Date = Date()
    
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
                }
                .blur(radius: 3 * (showPicker ? 1 : 0))
                .navigationDestination(for: Card.self) { card in
                    CardView(card: card)
                }
            }
            
            run_if (showPicker, {
                TapBackground { showPicker = false }
                    .zIndex(1)
            })
            run_if( showPicker, { return picker.zIndex(2)} )
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
                    .foregroundStyle(.black)
            })
        }
    }
    
    var picker: some View {
        VStack(alignment: .center) {
            DateView(value: $dummyDate)
                .datePickerStyle(.graphical)
                .padding(.bottom, 15)
            
                .background(Color.white.opacity(0.1))
                .background(.ultraThinMaterial.opacity(0.80))
            
                .border(Color.offwhite)
                .cornerRadius(20)
                .scaleEffect(0.85)
            
                .onChange(of: dummyDate) {
                    let date = Calendar.current.startOfDay(for: dummyDate)
                    path.append(getCard(for: date))
                }
            
            Spacer()
        }
    }
    
    func createLabel(for card: Card) -> some View {
        return Group {
            Text(card.date, style: .date)
            Spacer()
            Text(card["text.comment"].asString)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
    
    func getCard(for date: Date) -> Card {
        if let card = cards.first(where: { $0.date == date }) {
            return card
        }
        let newCard = Card(date: date)
        modelContext.insert(newCard)
        return newCard
    }
}
