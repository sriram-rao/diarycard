//
//  DateView.swift
//  diarycard
//
//  Created by Sriram Rao on 6/26/25.
//
import SwiftUI

struct DateView: View {
    let card: Card
    
    var dateValue: Binding<Date> {
        Binding<Date> (
            get: {
                return card.date
            },
            set: {newValue in
                card.date = newValue
            }
        )
    }
    
    var body: some View {
        DatePicker(selection: dateValue, displayedComponents: [.date], label: {Text("")})
            .labelsHidden()
            .frame(alignment: .leading)
            
    }
}

#Preview("DateBox") {
    DateView(card: Card(date: Date(), attributes: []))
}
