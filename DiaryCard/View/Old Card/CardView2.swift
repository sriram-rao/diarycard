//
//  CardView.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI

struct CardView2: View {
    let card: Card
    
    var body: some View {
//        NavigationStack {
//            List(card.groups, id: \.self) { card in
//                NavigationLink { DetailView(section: card)
//                } label: {
//                    MeasureCardView(section: card)
//                }
//                .listRowBackground(Theme.sky.mainColor)
//            }
//            
//            .navigationTitle(card.date.formatted(date: .complete, time: .omitted))
//            .toolbar {
//                Button(action: {}) {
//                    Image(systemName: "plus")
//                }
//            }
//            .accessibilityLabel("New Section")
//        }
    }
}

#Preview("Default") {
    CardView2(card: Model().cards2[0])
}
