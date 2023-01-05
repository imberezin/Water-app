//
//  ActivityManager.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/01/2023.
//

import Foundation
import ActivityKit
import SwiftUI

class ActivityManager: NSObject{
    
    static let shared = ActivityManager()
    
    func sendRequest(drinkItem : DrinkItem){
        let minutes: Int = 0
        let seconds:Int = 30
        var future = Calendar.current.date(byAdding: .minute, value: (Int(minutes) ), to: Date())!
        future = Calendar.current.date(byAdding: .second, value: (Int(seconds) ), to: future)!
        let date = Date.now...future

        let initialContentState = WatterWidgetAttributes.ContentState(value: Int(drinkItem.amount), driverName: "Bill James", deliveryTimer:date)

        let activityAttributes = WatterWidgetAttributes(name: "Water App", totalAmount: "3000")
        let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)

        do {
            let deliveryActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
            print("Requested a pizza delivery Live Activity \(String(describing: deliveryActivity.id)).")
        } catch (let error) {
            print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
        }

    }

}
