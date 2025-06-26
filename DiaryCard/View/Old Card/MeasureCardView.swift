//
//  CardView.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI

public struct MeasureCardView: View {
    let section: MeasureGroup
    public var body: some View {
        VStack(alignment: .leading) {
            Text(section.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            HStack {
                Label("\(section.properties.count)", systemImage: "note.text")
                    .accessibilityLabel("\(section.properties.count) attributes")
                Spacer()
                Label("Clock", systemImage: "clock")
                    .accessibilityLabel("Clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
            Spacer()
        }
        .padding()
        .foregroundColor(Color.black)
    }
}

#Preview {
//    MeasureCardView(section: Model().cards2[0].groups[0])
//        .background(Theme.periwinkle.mainColor)
}
