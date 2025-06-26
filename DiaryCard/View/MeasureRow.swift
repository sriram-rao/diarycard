//
//  MeasureRow.swift
//  diarycard
//
//  Created by Sriram Rao on 6/25/25.
//

import SwiftUI

struct MeasureRow: View {
    let attribute: String
    let value: String
    let type: String
    
    var body: some View {
        HStack {
            Text(attribute)
                .font(.subheadline.lowercaseSmallCaps())
            Spacer()
            Text(formatValue(value, type))
                .font(.title3)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

#Preview("MeasureRow") {
    MeasureRow(attribute: "Behaviour.Self Care", value: Model().cards[0]["Behaviour.Self Care"] ?? "", type: Model().schema["Behaviour.Self Care"] ?? "String")
}

#Preview("MeasureRow List") {
    var attribute: String = "Skills.Distress Tolerance"
    MeasureRow(attribute: attribute, value: Model().cards[0][attribute] ?? "", type: Model().schema[attribute] ?? "String")
}

let formatters: Dictionary<String, (String, String) -> String> = [
    "number": {(value, type) in
        value
    },
    "date": {(value, type) in
        var dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = Model.dateReadFormat
        return dateFormatter.date(from: value)!.formatted(date: .long, time: .omitted)
    },
    "list": {(value, type) in
        value.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").joined(separator: "\n")
    }
]

func formatValue(_ value: String, _ type: String) -> String {
    if !formatters.contains(where: { $0.key.lowercased() == type.lowercased() }) {
        return value
    }

    return formatters[type.lowercased()]!(value, type)
}
