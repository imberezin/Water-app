//
//  AppDelegate.swift
//  WatterApp
//
//  Created by IsraelBerezin on 12/12/2022.
//

import Foundation
import UserNotifications
import Combine
import SwiftUI



class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        if let shortcutItem = options.shortcutItem {
            NotificationCenterManager.shared.shortcutItem = shortcutItem
        }
        if let s = options.notificationResponse{
            NotificationCenterManager.shared.actionIdentifier = s.actionIdentifier
        }
        
        let configuration = UISceneConfiguration(name: connectingSceneSession.configuration.name, sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("didFinishLaunchingWithOptions")
        
        NotificationCenterManager.shared.registerForPushNotifications()
        
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            print("didFinishLaunchingWithOptions from push")
        }else{
            print("didFinishLaunchingWithOptions Not from push")
        }
        
        return true
    }
    
}



class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        NotificationCenterManager.shared.shortcutItem = shortcutItem
        
        completionHandler(true)
    }
    
}



/*
 private func registerForPushNotifications() {
 UNUserNotificationCenter.current().delegate = self
 UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
 (granted, error) in
 // 1. Check to see if permission is granted
 guard granted else { return }
 // 2. Attempt registration for remote notifications on the main thread
 DispatchQueue.main.async {
 UIApplication.shared.registerForRemoteNotifications()
 }
 }
 }
 
 
 
 
 }
 
 extension AppDelegate: UNUserNotificationCenterDelegate {
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 print("didRegisterForRemoteNotificationsWithDeviceToken")
 }
 
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
 print("didFailToRegisterForRemoteNotificationsWithError")
 print(error)
 }
 
 
 
 
 */
//class CombineNotificationSender {
//
//    var message : String
//
//    init(_ messageToSend: String) {
//        message = messageToSend
//    }
//
//    static let combineNotification = Notification.Name("CombineNotification")
//}

//            let notify = NotificationCenter.default
//            notify.post(name: Notification.Name("UserWaterSelected"), object: nil,userInfo:["actionIdentifier":response.actionIdentifier])

//            switch response.actionIdentifier {
//            case "ACCEPT_ACTION":
//               print("ACCEPT_ACTION")
//            break
//
//            case "DECLINE_ACTION":
//                print("DECLINE_ACTION")
//               break
//
//            // Handle other actions…
//
//            default:
//                print(response.actionIdentifier)
//
//               break
//            }
