//
//  DiaryView.swift
//  diarycard
//
//  Created by Sriram Rao on 5/22/25.
//

import SwiftUI

struct DiaryView: View {
    @Environment(Model.self) var model
    
    @State var timeRange: (Date, Date) = (Date.now.advanced(by: -86400 * 7), Date.now.advanced(by: 86400))
    
    var filteredEntries: [Card] {
        model.correctedCards().filter {
            $0.date >= timeRange.0 && $0.date <= timeRange.1
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                @State var fetchingData: Bool = timeRange.0 < Date.now.advanced(by: -86400 * 7)
                
                DatePicker("Start", selection: $timeRange.0)
                DatePicker("End", selection: $timeRange.1)
                
                ForEach(filteredEntries, id: \.self) { card in
                    NavigationLink { CardView(card: card) } label: {
                        Text(
                            card.date.formatted(date: .complete, time: .omitted)
                        )
                    }
                }
            }
            .navigationTitle("Diary Cards")
        } detail: {
                Text("Which day?")
            }
        
    }
}

#Preview("DiaryView") {
    DiaryView()
        .environment(Model())
}
