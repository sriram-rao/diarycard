import Foundation
import SwiftData
import SwiftUI

struct StartView: View {
    
    var body: some View {
        NavigationStack {
            CardsView()
//            SummaryView()
        }
    }
    
    func initializeData() -> some View {
        return EmptyView()
    }
}
