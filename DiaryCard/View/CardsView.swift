//
//  CardsView.swift
//  diarycard
//
//  Created by Sriram Rao on 6/26/25.
//
import Foundation
import SwiftData
import SwiftUI

struct CardsView: View {
    @Query(sort: \Card.date, order: .reverse) var cards: [Card]
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(cards) { card in
                    NavigationLink {
                        CardView(card: card)
                    } label: {
                        Text(card.date, style: .date)
                        Spacer()
                        Text(card["text.comment"].asString)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
            .navigationTitle(Text("Diary Cards"))
        }
    }
}

#Preview(traits: .cardSampleData) {
    CardsView()
}
