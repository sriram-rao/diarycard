//
//  Card.swift
//  diarycard
//
//  Created by Sriram Rao on 6/25/25.
//

import Foundation
import SwiftData
import SwiftUI

struct CardView: View {
    let card: Card

    var orderedAttributes: [Attribute] {
        let tempCard: [Attribute] = card.attributes.filter({ $0.name.lowercased() != "date" && !$0.name.lowercased().contains("text")})
        return tempCard.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }
    
    var textAttributes: [Attribute] {
        return card.attributes.filter({ $0.name.lowercased().contains("text")})
    }
    
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Date")
                    .font(.subheadline.lowercaseSmallCaps())
                Spacer(minLength: 0)
                DateView(card: card)
            }
            .padding(.horizontal)
            
            ForEach(textAttributes) {attribute in
                MeasureRow(attribute: attribute)

            }
            
            List {
                ForEach(orderedAttributes) {attribute in
                    MeasureRow(attribute: attribute)
                }
            }
        }
    }
}

#Preview("Default", traits: .cardSampleData) {
    @Previewable @Query(sort: \Card.date) var cards: [Card]
    CardView(card: cards[0])
}
