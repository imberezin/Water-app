//
//  WatterAppApp.swift
//  WatterApp
//
//  Created by IsraelBerezin on 30/11/2022.
//

import SwiftUI
import UserNotifications
import Combine
import Foundation

@main
struct WatterAppApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    
    @StateObject var  notificationCenterManager = NotificationCenterManager.shared
    
    @StateObject var waterTypesListManager = WaterTypesListManager.shared
    
    let cloudPersistence = iCloudPersistence.shared
    
    var body: some Scene {
        
        WindowGroup {
            
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(waterTypesListManager)
                .environmentObject(notificationCenterManager)
            
                .onChange(of: scenePhase) { scenePhase in
                    switch scenePhase {
                    case.active:
                        self.notificationCenterManager.updateNotifactionStatus()
                        print("active")
                    case .background:
                        self.addDynamicQuickActions()
                    default: return
                    }
                }
                .onAppear{
                    cloudPersistence.addTest()
//                    cloudPersistence.refresh(){ error in
//                        if error != nil{
//                            print(error!)
//                        }
//                    }
                }
        }
    }
    
    private func addDynamicQuickActions()  {
        Task{
            let actions = await waterTypesListManager.buildHomeScreenQuickDrinkActions(maxNumber: 4)
            DispatchQueue.main.async {
                UIApplication.shared.shortcutItems = actions
            }
        }
    }
    
}


