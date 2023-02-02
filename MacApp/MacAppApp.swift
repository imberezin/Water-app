//
//  MacAppApp.swift
//  MacApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import SwiftUI
import OSLog

@main
struct MacAppApp: App {
    
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate

    let persistenceController = PersistenceController.shared
    
    let cloudPersistence = iCloudPersistence.shared

    @Environment(\.scenePhase) var scenePhase

    @StateObject var waterTypesListManager: WaterTypesListManager = WaterTypesListManager.shared
    @StateObject var notificationCenterManager: NotificationCenterManager =  NotificationCenterManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(waterTypesListManager)
                .environmentObject(notificationCenterManager)
                .onChange(of: scenePhase) { scenePhase in
                    switch scenePhase {
                    case.active:
                        self.notificationCenterManager.updateNotifactionStatus()
                        print("active")
                 
                    default: return
                    }
                }
                .onAppear{
//        cloudPersistence.addTest()
                    cloudPersistence.refresh(){ error in
                        if error != nil{
                            print(error!)
                        }
                    }
                }

        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
