//
//  DiaryView.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI

struct CardView: View {
    let cards: [CardSection]
    
    var body: some View {
        NavigationStack {
            List(cards) { card in
                NavigationLink(destination: DetailView(section: card)) {
                    MeasureCardView(section: card)
                }
                .listRowBackground(card.theme.mainColor)
            }
            .navigationTitle("Diary Card")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
            .accessibilityLabel("New Section")
        }
        Text("DiaryView")
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cards: CardSection.sample)
    }
}
