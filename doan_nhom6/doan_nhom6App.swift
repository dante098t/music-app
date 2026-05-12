//
//  doan_nhom6App.swift
//  doan_nhom6
//
//  Created by macbook on 7/5/26.
//

import SwiftUI
import CoreData

@main
struct doan_nhom6App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
