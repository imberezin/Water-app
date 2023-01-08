//
//  ActivityManager.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/01/2023.
//

import Foundation
import ActivityKit
import SwiftUI

// Based:
class ActivityManager: NSObject{
    
    static let shared = ActivityManager()
    
    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?

    
    func getCorrentAmount(for waterType : DrinkType, daysItems: FetchedResults<Day>) -> Int{
        var totalScore = waterType.amount
        if daysItems.count > 0{
            if let today: Day = daysItems.first(where: {$0.date?.getGregorianDate(dateFormat: "d MMMM yyyy") == Date().getGregorianDate(dateFormat: "d MMMM yyyy")}){
                let array = Array(today.drink as! Set<Drink>)
                if array.count > 0{
                    totalScore += Int(array.sum(for: \.amount))
                }
                totalScore -= waterType.amount

            }else{
              //  PersistenceController.shared.createNewDay(date: Date(), drinkItem: drinkItem)
            }
        }else{
            //PersistenceController.shared.createNewDay(date: Date(), drinkItem: drinkItem)
        }

        return totalScore
    }
    
    func sendRequest(for waterType : DrinkType, daysItems: FetchedResults<Day>){
        
        let amountUntilNow: Int = self.getCorrentAmount(for: waterType, daysItems: daysItems)
        print("amountUntilNow = \(amountUntilNow)" )
        
        let minutes: Int = 0
        let seconds:Int = 30
        var future = Calendar.current.date(byAdding: .minute, value: (Int(minutes) ), to: Date())!
        future = Calendar.current.date(byAdding: .second, value: (Int(seconds) ), to: future)!
        let date = Date.now...future

        let initialContentState = WatterWidgetAttributes.ContentState(value: Int(waterType.amount), driverName: "Bill James", deliveryTimer:date)
        let activityAttributes = WatterWidgetAttributes(waterType: waterType, amountUntilNow: amountUntilNow, totalAmount: userPrivateinfoSaved?.customTotal ?? 3000)
        let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)

        do {
            let deliveryActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
            print("Requested a pizza delivery Live Activity \(String(describing: deliveryActivity.id)).")
        } catch (let error) {
            print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
        }

        
        // Finish Activity
        let finalDeliveryStatus = WatterWidgetAttributes.ContentState(value: Int(waterType.amount), driverName: "Bill James", deliveryTimer: Date.now...Date())

        let finalContent = ActivityContent(state: finalDeliveryStatus, staleDate: nil)


        Task.init(priority: .low){
            try await Task.sleep(until: .now + .seconds(30), clock: .continuous)

            for activity in Activity<WatterWidgetAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .default)
                print("Ending the Live Activity: \(activity.id)")
            }
        }


    }

}
