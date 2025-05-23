//
//  CardView.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI

public struct MeasureCardView: View {
    let section: CardSection
    public var body: some View {
        VStack(alignment: .leading) {
            Text(section.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack {
                Label("\(section.properties.count)", systemImage: "note.text")
                    .accessibilityLabel("\(section.properties.count) attributes")
                Spacer()
                Label("Clock", systemImage: "clock")
                    .accessibilityLabel("Clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(section.theme.accentColor)
    }
}

public struct CardView_Previews: PreviewProvider {
    static var section = CardSection.sample[0]
    public static var previews: some View {
        MeasureCardView(section: section)
            .background(section.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
