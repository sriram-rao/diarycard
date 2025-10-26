import Foundation
import SwiftData
import SwiftUI

struct StartView: View {

    var body: some View {
        NavigationStack {
            CardsView()
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
        }
    }
    
    func initializeData() -> some View {
        return EmptyView()
    }
}
