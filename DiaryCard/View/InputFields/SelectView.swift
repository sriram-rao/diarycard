//
//  SelectView.swift
//  diarycard
//
//  Created by Sriram Rao on 6/26/25.
//
import SwiftUI

struct SelectView: View {
    public static let COMMA: String = ","
    public static let PREFIX: String = "List:"
    
    let attribute: Attribute
    
    var body: some View {
        let allItems: [String] = attribute.type.replacingOccurrences(of: SelectView.PREFIX, with: "")
            .components(separatedBy: SelectView.COMMA)
            .map({$0.trimmingCharacters(in: .whitespaces)})
            
        return VStack {
            ForEach(allItems, id: \.self) {item in
                HStack {
                    Text(item)
                    Spacer()
                    Label("", systemImage: attribute.value.contains(item) ? "checkmark.circle.fill" : "")
                        .foregroundStyle(.magenta)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview("SelectView List") {
    SelectView(attribute: Attribute(name: "Skills.Distress Tolerance", value: "List:ACCEPTS", type: "List:ACCEPTS, IMPROVE, TIPP, STOP"))
}
