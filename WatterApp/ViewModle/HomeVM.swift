//
//  HomeVM.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/12/2022.
//

import Foundation
import SwiftUI

class HomeVM: ObservableObject {
    
    @AppStorage("userPrivateinfo") var userPrivateinfoSaved: UserPrivateinfo?

    
    init(){
        if userPrivateinfoSaved == nil{
            self.userPrivateinfoSaved = UserPrivateinfo(fullName: "", height: 0, weight: 0, age: 0, customTotal: 3000, gender: Gander.male.rawValue, slectedRimniderHour: 3, enabledReminde: false)
        }
    }
    
    func addWaterToCureentDay(waterType : DrinkType, daysItems: FetchedResults<Day>){
        let drinkItem = DrinkItem(name: waterType.name, amount: Int64(waterType.amount), time: Date())
        
        if daysItems.count > 0{
            if let today: Day = daysItems.first(where: {$0.date?.getGregorianDate(dateFormat: "d MMMM yyyy") == Date().getGregorianDate(dateFormat: "d MMMM yyyy")}){
                PersistenceController.shared.updateDayItem(day: today, drink: waterType)
            }else{
                PersistenceController.shared.createNewDay(date: Date(), drinkItem: drinkItem)
            }
        }else{
            PersistenceController.shared.createNewDay(date: Date(), drinkItem: drinkItem)
        }
    }

}

