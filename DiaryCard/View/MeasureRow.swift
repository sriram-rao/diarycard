//
//  MeasureRow.swift
//  diarycard
//
//  Created by Sriram Rao on 6/25/25.
//

import SwiftUI

struct MeasureRow: View {
    let attribute: Attribute
    
    var body: some View {
        HStack {
            Text(attribute.name.components(separatedBy: ".").last ?? "")
                .font(.subheadline.lowercaseSmallCaps())
                .fixedSize(horizontal: false, vertical: false)
                .frame(maxWidth: 100, alignment: .leading)
            Spacer()
            format(attribute: attribute)
                .frame(maxWidth: 300, alignment: .leading)
        }
        .padding(.horizontal)
    }
}

let formatters: Dictionary<String, (Attribute) -> any View> = [
    "list" : {attr in
        SelectView(attribute: attr)
    },
    "text": {attr in
        TextBoxView(attribute: attr)
    },
    "number": {attr in
        TextBoxView(attribute: attr)
    }
]

//@ViewBuilder
func format(attribute: Attribute) -> AnyView {
    let attributeType: String = attribute.type.lowercased().components(separatedBy: ":").first ?? ""
    if let formatter = formatters[attributeType]{
        return AnyView(formatter(attribute))
    }
    else {
        return AnyView(TextBoxView(attribute: attribute))
    }
}

#Preview("MeasureRow") {
    MeasureRow(attribute: Attribute(name: "Test", value: "Freeform\nFree fallin'", type: "String"))
}

#Preview("MeasureRow List") {
    var attribute: String = "Skills.Distress Tolerance"
    MeasureRow(attribute: Attribute(name: "Skills.Distress Tolerance", value: "List:ACCEPTS", type: "List:ACCEPTS,IMPROVE,TIPP,STOP"))
}

#Preview("Date") {
    MeasureRow(attribute: Attribute(name: "Date", value: "2025-06-26", type: "Date"))
}
