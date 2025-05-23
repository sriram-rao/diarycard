//
//  CardView.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    @Binding var date: Date
    
    var body: some View {
        NavigationStack {
            List(card.groups, id: \.self) { card in
                NavigationLink { DetailView(section: card)
                } label: {
                    MeasureCardView(section: card)
                }
                .listRowBackground(Theme.sky.mainColor)
            }
            
            DatePicker("Date", selection: $date)
            .navigationTitle(card.date.formatted(date: .complete, time: .omitted))
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
            .accessibilityLabel("New Section")
        }
    }
}

#Preview("Default") {
    CardView(card: Model().correctedCards()[0], date: Model().correctedCards()[0].date)
}
