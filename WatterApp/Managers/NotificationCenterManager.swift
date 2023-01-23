//
//  NotificationCenter.swift
//  WatterApp
//
//  Created by IsraelBerezin on 11/12/2022.
//

import Foundation
import UserNotifications
import SwiftUI

@MainActor
class NotificationCenterManager: NSObject, ObservableObject{
    
    
    static let shared = NotificationCenterManager()
    
    var settings: UNNotificationSettings?
    var dumbData: UNNotificationResponse?
    
    
    let noteficationid = "abcderfghigberezinAppWater12345678"
    
    let waterTypesListManager: WaterTypesListManager  =  WaterTypesListManager.shared
    
#if os(iOS)
    @Published var shortcutItem: UIApplicationShortcutItem?
#endif
    @Published var actionIdentifier: String?
    @Published var isAllowedToSendPush: Bool = true
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    func registerForPushNotifications() {
        //        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound, .providesAppNotificationSettings]){
            
            //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // 1. Check to see if permission is granted
            //            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            if granted{
                //                self.isAllowedToSendPush = true
                DispatchQueue.main.async {
#if os(iOS)
                    UIApplication.shared.registerForRemoteNotifications()
#endif
                }
            }else{
                print("not granted")
                //                self.isAllowedToSendPush = false
            }
        }
    }
    
    
    func removeScheduledNotification() {
        print("removeScheduledNotification")
        DispatchQueue.main.async {
            //self.savedDate = nil
        }
//        UNUserNotificationCenter.current()
//            .removePendingNotificationRequests(withIdentifiers: [noteficationid])
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
    }
    
    
    func scheduleNotificationToRange(startTime: Date, endTime: Date, hour: Int = 3, toRepeat:Bool){

        let delta = startTime.distance(to: endTime)
        print("delta = \(delta)")
        let diff = delta / (60*60)
        
        let numberOfReminer:Int = Int(diff/Double(hour)) + 1
        var triggers:[UNCalendarNotificationTrigger] = [UNCalendarNotificationTrigger]()
        
        let startDayHour = Calendar.current.component(.hour, from: startTime)
        let startDayMinute = Calendar.current.component(.minute, from: startTime)

        for index in 0 ..< numberOfReminer{
            let time = Int(startDayHour) + (index * hour)
            print("time = \(time)")
            let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents.triggerFor(hour:time , minute: startDayMinute), repeats: toRepeat)
//            let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents.triggerFor(hour:21 , minute: time+45), repeats: toRepeat)

            print("trigger = \(trigger)")

            triggers.append(trigger)
        }
        
        self.removeScheduledNotification()

        for trigger in triggers {
            scheduleNotification(trigger: trigger)
        }
    }
    
    
    func scheduleNotification(trigger: UNCalendarNotificationTrigger) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Drink now"
        notificationContent.body = "Your body needs water!"
        notificationContent.badge = 0
        notificationContent.categoryIdentifier = "WatterApp"
        notificationContent.threadIdentifier = noteficationid
        
        // notifcation image
        if let path = Bundle.main.path(forResource: "water3", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                notificationContent.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        // notifcation sound
        notificationContent.sound = UNNotificationSound.default
        
        var notificationActionArray: [UNNotificationAction] = [UNNotificationAction]()
        let endIndex = waterTypesListManager.drinkTypesList.count < 4 ? waterTypesListManager.drinkTypesList.count : 4
        for index in 0 ..< endIndex {
            let acceptAction = UNNotificationAction(identifier: waterTypesListManager.drinkTypesList[index].id,
                                                    title: "Add \(waterTypesListManager.drinkTypesList[index].name) - \(waterTypesListManager.drinkTypesList[index].amount)Ml",
                                                    options: [], icon: UNNotificationActionIcon(templateImageName: waterTypesListManager.drinkTypesList[index].imageName))
            notificationActionArray.append(acceptAction)
        }
        let meetingInviteCategory =
        UNNotificationCategory(identifier: "WatterApp",
                               actions: notificationActionArray,
                               intentIdentifiers: [],
                               hiddenPreviewsBodyPlaceholder: "",
                               options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: notificationContent, trigger: trigger)
        
        self.requestAuthorization { allowed in
            DispatchQueue.main.async {
                if allowed{
                    self.isAllowedToSendPush = true
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }else{
                    self.isAllowedToSendPush = false
                }
            }
        }
        
    }
    
    func scheduleNotification(hour: Int = 3, toRepeat:Bool) {
        
        self.removeScheduledNotification()
        //https://viblo.asia/p/tao-local-remote-notification-co-media-attachments-voi-usernotifications-Ljy5Vx8GZra
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Drink now"
        notificationContent.body = "Your body needs water!"
        notificationContent.badge = 0
        //        notificationContent.subtitle = "div1"
        notificationContent.categoryIdentifier = "WatterApp"
        notificationContent.threadIdentifier = noteficationid
        
        // notifcation image
        if let path = Bundle.main.path(forResource: "water3", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                notificationContent.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        // notifcation sound
        notificationContent.sound = UNNotificationSound.default
        
        var notificationActionArray: [UNNotificationAction] = [UNNotificationAction]()
        let endIndex = waterTypesListManager.drinkTypesList.count < 4 ? waterTypesListManager.drinkTypesList.count : 4
        for index in 0 ..< endIndex {
            let acceptAction = UNNotificationAction(identifier: waterTypesListManager.drinkTypesList[index].id,
                                                    title: "Add \(waterTypesListManager.drinkTypesList[index].name) - \(waterTypesListManager.drinkTypesList[index].amount)Ml",
                                                    options: [], icon: UNNotificationActionIcon(templateImageName: waterTypesListManager.drinkTypesList[index].imageName))
            notificationActionArray.append(acceptAction)
        }
        let meetingInviteCategory =
        UNNotificationCategory(identifier: "WatterApp",
                               actions: notificationActionArray,
                               intentIdentifiers: [],
                               hiddenPreviewsBodyPlaceholder: "",
                               options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        
        let timeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((60*60*hour)), repeats: toRepeat)
        //        let timeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.1, repeats: false)
        
        /// Fire in 30 minutes (60 seconds times 30)
        //          var trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((60*60*hour)), repeats: toRepeat)
        
        let request = UNNotificationRequest(identifier: "test", content: notificationContent, trigger: timeIntervalNotificationTrigger)
        
        self.requestAuthorization { allowed in
            if allowed{
                DispatchQueue.main.async {
                    self.isAllowedToSendPush = true
                }
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }else{
                DispatchQueue.main.async {
                    
                    self.isAllowedToSendPush = false
                }
                
            }
        }
        
        
    }
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                self.fetchNotificationSettings()
                completion(granted)
            }
    }
    
    func fetchNotificationSettings() {
        // 1
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // 2
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    func updateNotifactionStatus(){
        self.requestAuthorization(){ allowed in
            if allowed{
                DispatchQueue.main.async {
                    self.isAllowedToSendPush = allowed
                }
            }
        }
    }
}


extension NotificationCenterManager: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("willPresent")
        let userInfo = notification.request.content.userInfo
        print("userInfo = \(userInfo)") // the payload that is attached to the push notification
        
        completionHandler([.banner, .sound])
    }
    
#if os(iOS)

    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        print("App opened from PushNotification -> NotificationCenterManager")
        let userInfo = response.notification.request.content.userInfo
        // Print full message.
        print("didReceive",userInfo)
        
        let application = UIApplication.shared
        
        if(application.applicationState == .active){
            print("user tapped the notification bar when the app is in foreground")
        }
        
        if(application.applicationState == .inactive)
        {
            print("user tapped the notification bar when the app is in background")
        }
        
        application.applicationIconBadgeNumber = 0
        print("response.actionIdentifier = \(response.actionIdentifier)")
        NotificationCenterManager.shared.actionIdentifier = response.actionIdentifier
        
        
        completionHandler()
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?){
        print("userNotificationCenter")
        Task{
            let opened = await UIApplication.shared.openAppNotificationSettings()
            if !opened {
                print("lol fail")
            }
        }
    }
    
#endif
    
    
}

#if os(iOS)

extension UIApplication {
    private static let notificationSettingsURLString: String? = {
        if #available(iOS 16, *) {
            return UIApplication.openNotificationSettingsURLString
        }
        
        //    if #available(iOS 15.4, *) {
        //      return UIApplicationOpenNotificationSettingsURLString
        //    }
        //
        //    if #available(iOS 8.0, *) {
        //      // just opens settings
        //      return UIApplication.openSettingsURLString
        //    }
        
        // lol bruh
        return nil
    }()
    
    private static let appNotificationSettingsURL = URL(
        string: notificationSettingsURLString ?? ""
    )
    
    func openAppNotificationSettings() async -> Bool {
        guard
            let url = UIApplication.appNotificationSettingsURL//            self.canOpen(url)
        else { return false }
        return await self.open(url)
    }
}

#endif
