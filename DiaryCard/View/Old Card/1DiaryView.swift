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
    
    @State var showFilter: Bool = false
    
    var filteredEntries: [Card] {
        model.cards2
//            .filter {
////            $0.date >= timeRange.0 && $0.date <= timeRange.1
//        }
    }
    
    var body: some View {
        NavigationSplitView {
            HStack {
                Text("Cards")
                    .font(Font.title2)
                Spacer()
                
                Button {
                    showFilter.toggle()
                } label: {
                    Label("Filter", systemImage: "chevron.right.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(.degrees(showFilter ? 90 : 0))
                        .animation(.easeInOut, value: showFilter)
                }
            }
            .padding()
            
            if showFilter {
                HStack {
                    DatePicker("", selection: $timeRange.0, displayedComponents: .date)
                        .labelsHidden()
                    Spacer()
                    Text("to")
                    Spacer()
                    DatePicker("", selection: $timeRange.1, displayedComponents: .date)
                        .labelsHidden()
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
            }
            
//            List {
//                ForEach(filteredEntries, id: \.self) { card in
//                    NavigationLink { CardView2(card: card) } label: {
//                        Text(
//                            card.date.formatted(date: .complete, time: .omitted)
//                        )
//                    }
//                }
//            }
//            .toolbar{
//                ToolbarItem(placement: .topBarTrailing) {
//                }
//            }
        } detail: {
            Text("Which day?")
        }
    }
}

#Preview("DiaryView") {
    DiaryView()
        .environment(Model())
}
