//
//  PreviewContainer.swift
//  diarycard
//
//  Created by Sriram Rao on 6/26/25.
//
import Foundation
import SwiftData
import SwiftUI

struct CardSampleData: PreviewModifier {
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: Card.self, configurations: .init(isStoredInMemoryOnly: true))
        Card.sampleData.forEach { container.mainContext.insert($0) }
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var cardSampleData: Self = .modifier(CardSampleData())
}
