//
//  ContentView.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI
import SwiftData

struct InputView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        VStack {
            ProgressView(value: 5, total: 15)
            HStack {
                VStack {
                    Label("Progress 2/4", systemImage: "hourglass.tophalf.fill")
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Current Section")
            .accessibilityValue("Behaviour")
            
            VStack {
                Circle().strokeBorder(lineWidth: 20)
            }
            
            HStack {
                Text("Behaviour")
                Spacer()
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                }
                .accessibilityLabel("Next Section")
            }
        }
        .padding()
#if os(macOS)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
#endif
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    InputView()
        .modelContainer(for: Item.self, inMemory: true)
}
