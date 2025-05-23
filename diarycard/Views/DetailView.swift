//
//  DetailView.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI

struct DetailView: View {
    let section: MeasureGroup
    
    var body: some View {
        let keys = section.properties.keys.map { key in
            String.init(key)
        }
    
        List(keys, id: \.self) { key in
                Section(header: Text("Info")) {
                    Label("Self Care", systemImage: "brain.head.profile")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    HStack {
                        Label(key, systemImage: "scissors")
                        Spacer()
                        Text("\(section.properties[key] ?? 0)")
                    }
                    .accessibilityElement(children: .combine)
                    
                    HStack {
                        Label("Theme", systemImage: "paintpalette")
                        Spacer()
                        Text(Theme.poppy.name)
                            .padding(4)
                            .foregroundColor(Color.white)
                            .background(Theme.poppy.mainColor)
                            .cornerRadius(8)
                    }
                    .accessibilityElement(children: .combine)
                
            }
        }
    }
}

#Preview {
    DetailView(section: Model().cards[0].groups[0])
}
