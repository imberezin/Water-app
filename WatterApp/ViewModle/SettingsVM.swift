//
//  SettingsVM.swift
//  WatterApp
//
//  Created by IsraelBerezin on 05/12/2022.
//

import Foundation
import SwiftUI

class SettingsVM: ObservableObject {
    
    
    @Published var drinkTypesList: [DrinkType] = [DrinkType]()
    @AppStorage("userPrivateinfo") var userPrivateinfoSaved: UserPrivateinfo?
    
    @Published var userPrivateinfo: UserPrivateinfo =  UserPrivateinfo(fullName: "", height: 0, weight: 0, age: 0, customTotal: 3000, gender: Gander.male.rawValue, slectedRimniderHour: 3, enabledReminde: false){
        willSet {
            if newValue == self.userPrivateinfoSaved{
                //print("no change")
            }else{
                self.userPrivateinfoSaved = UserPrivateinfo(fullName: newValue.fullName, height: newValue.height, weight: newValue.weight, age: newValue.age, customTotal: newValue.customTotal, gender: newValue.gender, slectedRimniderHour: newValue.slectedRimniderHour, enabledReminde: newValue.enabledReminde)
                //print(self.userPrivateinfoSaved)
            }
            objectWillChange.send()  // Will be automagically consumed by `Views`.
            
        }
        
    }
    
    let noteficationid = "abcderfghigberezinAppWater12345678"
    
    init(){
        print("init")
        if userPrivateinfoSaved != nil{
            self.userPrivateinfo = userPrivateinfoSaved!
        }
    }
    
    
    @MainActor
    func didSave(startTime: Date, endTime: Date,slectedRimniderHour: Int, enabledReminder: Bool){
        self.userPrivateinfo.enabledReminde = enabledReminder
        self.userPrivateinfo.slectedRimniderHour = slectedRimniderHour
//        NotificationCenterManager.shared.scheduleNotification(hour: slectedRimniderHour, toRepeat: enabledReminder)
        NotificationCenterManager.shared.scheduleNotificationToRange(startTime: startTime, endTime:endTime, hour: slectedRimniderHour, toRepeat: enabledReminder)
    }
    
}
