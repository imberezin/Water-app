//
//  AppDelegate.swift
//  MacApp
//
//  Created by IsraelBerezin on 25/01/2023.
//

import Foundation
import UserNotifications
import Combine
import SwiftUI
import OSLog

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let defaultLog = Logger()

    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        defaultLog.log("==== applicationDidFinishLaunching ====")

        NotificationCenterManager.shared.registerForPushNotifications()
        defaultLog.log("==== notification = \(notification) ====")

        print("notification = \(notification)")
//        if let s = notification{
//            NotificationCenterManager.shared.actionIdentifier = s.
//        }

    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        defaultLog.log("==== open urls ====")
        defaultLog.log("\(urls)")
    }
    
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        defaultLog.log("==== deviceToken ====")

        print ("deviceToken")
    }

    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        defaultLog.log("==== AppDelegate didReceiveRemoteNotification ====")

        print ("didReceiveRemoteNotification")

    }

    
}
