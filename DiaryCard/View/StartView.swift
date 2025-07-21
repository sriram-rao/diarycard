import Foundation
import SwiftData
import SwiftUI

struct StartView: View {
    @Query(sort: \Card.date, order: .reverse) var cards: [Card]
    
    
    var body: some View {
        NavigationStack {
            CardsView()
        }
    }
    
    func initializeData() -> some View {
        
        return EmptyView()
    }
}
