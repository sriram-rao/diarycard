import SwiftUI
import SwiftData

@main
struct diarycardApp: App {
    
    var body: some Scene {

        WindowGroup {
            StartView()
        }
        .modelContainer(for: [Card.self, ListSchemas.self])
    }
}
