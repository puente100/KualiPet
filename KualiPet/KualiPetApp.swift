//
//  KualiPetApp.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/23/25.
//

import SwiftUI

@main
struct KualiPetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
