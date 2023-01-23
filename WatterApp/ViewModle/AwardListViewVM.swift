//
//  AwardListViewVM.swift
//  WatterApp
//
//  Created by IsraelBerezin on 25/12/2022.
//

import SwiftUI

let awardItemNames: [String] = ["First cup","First Day","7 days","30 days", "3 months",  "6 months", " 1 year","Full daily quota"]
let awardDayssNumbers: [Int] = [0,1,7,30,90,180,365,1]

class AwardListViewVM: ObservableObject {
    
    @Published var awardslist = [AwardItem]()
    
    @Published var moreDaysToAward: Int = -1
    @Published var moreLitersToAward: Int = -1
    
    //@AppStorage("userPrivateinfo") var userPrivateinfoSaved: UserPrivateinfo?
    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?


    init(){
        
    }
    
    func updateAwardslist(checkAlsoListAwards: Bool = true){
        var tempList = [AwardItem]()
        
        for index in 0..<awardItemNames.count-1{
            let awardItem = AwardItem(imageName: "award\(index)", awardName: awardItemNames[index],daysNumber: awardDayssNumbers[index])
            tempList.append(awardItem)
            
        }
        DispatchQueue.main.async {
            self.awardslist = tempList
            if checkAlsoListAwards {
                self.checkIfTheUserHaveAwards()
            }
        }
    }
    
    @MainActor
    func checkIfTheUserHaveAwards() {
        
        Task{
            var tempAwardsIndexs = Array(repeating: false, count: awardItemNames.count)
            let daysItemList: [DayItem] =  await PersistenceController.shared.fetchAllDaysItemsInBg()!
            print("daysList.count = \(daysItemList.count)")
            if daysItemList.count > 0 {
                tempAwardsIndexs[0] = self.checkFirstCupAward(daysList: daysItemList)
                tempAwardsIndexs[1] = self.checkdaysToAward(numberOfDays: 1, daysList: daysItemList)
                tempAwardsIndexs[2] = self.checkdaysToAward(numberOfDays: 7, daysList: daysItemList)
                tempAwardsIndexs[3] = self.checkdaysToAward(numberOfDays: 30, daysList: daysItemList)
                tempAwardsIndexs[4] = self.checkdaysToAward(numberOfDays: 90, daysList: daysItemList)
                tempAwardsIndexs[5] = self.checkdaysToAward(numberOfDays: 180, daysList: daysItemList)
                tempAwardsIndexs[6] = self.checkdaysToAward(numberOfDays: 365, daysList: daysItemList)
            }

            var tempList = self.awardslist.map({$0})
            for index in 0 ..< tempList.count{
                
                tempList[index].active = tempAwardsIndexs[index]
            }
            self.awardslist = tempList//.map({$0})
            print("self.awardslist.map = \(self.awardslist.map({$0.active}))")
            
        }
    }
    
    func getFulldaysList() async -> [DayItem]{
        return await PersistenceController.shared.fetchAllDaysItemsInBg()!
    }
    
    func getTodayList() async -> [DayItem]{
        return await PersistenceController.shared.fatchTodayDrinkInfo()!
    }
    
    
    @MainActor
    func checkhowMoreDaysNeedToGetAward(numberOfDays:Int) {
        Task{
            let daysList: [DayItem] =  await PersistenceController.shared.fetchAllDaysItemsInBg()!
            print("daysList.count = \(daysList.count)")
            if daysList.count > 0{
                
                if numberOfDays > 0 {
                    
                    let testArray = daysList.count >= numberOfDays ? daysList.suffix(numberOfDays) : daysList
                    
                    var customTotalCount = 0;
                    for item in testArray.reversed(){
                        if item.total >= (userPrivateinfoSaved?.customTotal ?? 3000){
                            customTotalCount += 1
                        }else{
                            if item.date != daysList.last?.date{
                                break
                            }
                        }
                    }
                    print("customTotalCount = \(customTotalCount)")
                    self.moreDaysToAward = numberOfDays - customTotalCount
                    print("moreDaysToAward = \(moreDaysToAward)")
                    
                    
                }else{ // to First cup Award
                    if let item = daysList.last{
                        let diff = (userPrivateinfoSaved?.customTotal ?? 3000) - item.total
                        self.moreLitersToAward = diff
                    }
                }
                
            }else{
                if numberOfDays == 0{ // to First cup Award
                    self.moreLitersToAward = userPrivateinfoSaved?.customTotal ?? 3000
                }
            }
        }
    }
    
    
    
    func checkFirstCupAward(daysList:[DayItem])->Bool{
        
        for day:DayItem in daysList {
            if day.drink != nil && day.drink!.count > 0{
                return true
            }
        }
        return false
    }
    
    func checkFullDailyQuota(daysList:[DayItem]) -> Bool{
        if let todayDayItem = daysList.last{
            if todayDayItem.drink != nil && todayDayItem.drink!.count > 0{
                if todayDayItem.total >= (userPrivateinfoSaved?.customTotal ?? -1){
                    return true
                }
            }
        }
        return false
    }
    
    func checkdaysToAward(numberOfDays:Int, daysList:[DayItem])->Bool{
        
        let daysNumber = numberOfDays - 1 // becuase strting ftom 0...
        
        if daysList.count >= numberOfDays{
            
            for indexFirst in 0 ..< daysList.count{
                
                let testDay = daysList[indexFirst]
                
                if testDay.total >= (userPrivateinfoSaved?.customTotal ?? -1){
                    
                    if indexFirst + daysNumber < daysList.count{
                        
                        var customTotalCount = 1;
                        
                        for index in indexFirst ..< indexFirst + daysNumber{
                            
                            if daysList[index].total >= (userPrivateinfoSaved?.customTotal ?? -1){
                                
                                customTotalCount += 1
                                
                            }
                            
                        }
                        
                        if customTotalCount == numberOfDays{
                            
                            return true
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        return false
    }
    
}

