//
//  diarycardApp.swift
//  diarycard
//
//  Created by Sriram Rao on 3/17/25.
//

import SwiftUI
import SwiftData

@main
struct diarycardApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            InputView()
        }
        .modelContainer(sharedModelContainer)
    }
}
