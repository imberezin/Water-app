//
//  HomeVM.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/12/2022.
//

import Foundation
import SwiftUI

class HomeVM: ObservableObject {
    
//    @AppStorage("userPrivateinfo") var userPrivateinfoSaved: UserPrivateinfo?
    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?

    @Published var awardListViewVM = AwardListViewVM()
    
    @Published var isNeedsToShowAwardView: Bool = false
    
    var slectedAwardItem: AwardItem? = nil
    
    init(){
        if userPrivateinfoSaved == nil{
            self.userPrivateinfoSaved = UserPrivateinfo(fullName: "", height: 0, weight: 0, age: 0, customTotal: 3000, gender: Gander.male.rawValue, slectedRimniderHour: 3, enabledReminde: false, awardsWins: Array(repeating: false, count: awardItemNames.count))
        }
    }
    
    @MainActor
    func checkAndUpadteIfUserNeedToGetNewAwardMedal(){
        self.awardListViewVM.updateAwardslist(checkAlsoListAwards: false)
        Task{
            self.isNeedsToShowAwardView = false
            self.slectedAwardItem = nil
            
            if var tempAwardsWins = userPrivateinfoSaved?.awardsWins  {
                print(tempAwardsWins)
                if tempAwardsWins.isEmpty{
                    tempAwardsWins = Array(repeating: false, count: awardItemNames.count)
                    userPrivateinfoSaved?.awardsWins = tempAwardsWins
                }
                for index in 0 ..< tempAwardsWins.count{
                    
                    var flag = false
                    
                    if tempAwardsWins[index] == false{
                        
                        let awaedItem = awardListViewVM.awardslist[index]
                        let list = await awardListViewVM.getFulldaysList()
                        
                        if index == 0 {
                            flag = awardListViewVM.checkFirstCupAward(daysList: list)
                        }else{
                            flag = awardListViewVM.checkdaysToAward(numberOfDays: awaedItem.daysNumber, daysList: list)
                        }
                        
                        if flag {
                            print(index)
                            print(awaedItem.awardName)
                            userPrivateinfoSaved?.awardsWins[index] = true
                            slectedAwardItem = awaedItem
                            self.isNeedsToShowAwardView = true
                            break
                        }
                    }
                }
            }
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.checkAndUpadteIfUserNeedToGetNewAwardMedal()
        }
    }
    
}

