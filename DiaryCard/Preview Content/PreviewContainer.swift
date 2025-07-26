import Foundation
import SwiftData
import SwiftUI

struct SampleData: PreviewModifier {
    static func insert(into context: ModelContext) {
        Card.getSampleData().forEach { context.insert($0) }
    }
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: SwiftData.Schema([Card.self]),
                                           configurations: .init(isStoredInMemoryOnly: true))
        insert(into: container.mainContext)
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var cardSampleData: Self = .modifier(SampleData())
}
