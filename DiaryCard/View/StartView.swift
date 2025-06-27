//
//  BaseView.swift
//  diarycard
//
//  Created by Sriram Rao on 6/25/25.
//
import SwiftData
import SwiftUI

struct StartView: View {
    @Query() var cards: [Card]

    var body: some View {
        CardView(card: cards[0])
    }
}

#Preview("StartView", traits: .cardSampleData) {
    StartView()
}
