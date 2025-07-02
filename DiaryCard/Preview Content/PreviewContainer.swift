import Foundation
import SwiftData
import SwiftUI

struct CardSampleData: PreviewModifier {
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: Schema([Card.self, ListSchemas.self]),
                                           configurations: .init(isStoredInMemoryOnly: true))
        Card.getSampleData().forEach { container.mainContext.insert($0) }
        container.mainContext.insert(ListSchemas.getSampleData())
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var cardSampleData: Self = .modifier(CardSampleData())
}
