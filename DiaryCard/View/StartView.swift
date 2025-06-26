//
//  BaseView.swift
//  diarycard
//
//  Created by Sriram Rao on 6/25/25.
//

import SwiftUI

struct StartView: View {
    @Environment(Model.self) var model
    
    var cards: [Dictionary<String, String>] {
        model.cards
    }

    var body: some View {
        CardView(card: model.cards[0], schema: model.schema)
    }
}

#Preview("StartView") {
    StartView()
        .environment(Model())
}
