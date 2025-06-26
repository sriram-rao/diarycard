//
//  Card.swift
//  diarycard
//
//  Created by Sriram Rao on 6/25/25.
//

import Foundation
import SwiftUI

struct CardView: View {
    
    let card: Dictionary<String, String>
    let schema: Dictionary<String, String>
    var orderedKeys: [String] {
        let tempCard: [String] = card.keys.filter({ $0.lowercased() != "date" && !$0.lowercased().contains("text")})
        return tempCard.sorted(by: { $0.lowercased().components(separatedBy: ".").first! < $1.lowercased().components(separatedBy: ".").first! })
        }
    
    var textKeys: [String] {
        return card.keys.filter({ $0.lowercased().contains("text")})
    }
    
    
    var body: some View {
        
        VStack {
            Divider()
            
            MeasureRow(attribute: "Date", value: card["Date"]!, type: "Date")
            ForEach(textKeys, id: \.hash) {textKey in
                MeasureRow(attribute: textKey, value: card[textKey]!, type: "text")
            }
            
            Divider()
            Spacer()
            Divider()
            
            ForEach(orderedKeys, id: \.hash) {attribute in
                MeasureRow(attribute: attribute.components(separatedBy: ".").last!,
                           value: card[attribute]!,
                           type: schema[attribute] ?? "String")
                Divider()
            }
            Spacer()
        }
    }
}

#Preview("Default") {
    CardView(card: Model().cards[0], schema: Model().schema)
}
