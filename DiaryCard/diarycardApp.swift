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
    @State private var model = Model()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            
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
            StartView()
                .environment(model)
        }
        .modelContainer(sharedModelContainer)
    }
}
