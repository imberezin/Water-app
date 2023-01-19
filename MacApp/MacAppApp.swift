//
//  MacAppApp.swift
//  MacApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import SwiftUI

@main
struct MacAppApp: App {
    
    let persistenceController = PersistenceController.shared
        
    @StateObject var waterTypesListManager = WaterTypesListManager.shared

    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(waterTypesListManager)

        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
