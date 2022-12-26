//
//  AwardListViewVM.swift
//  WatterApp
//
//  Created by IsraelBerezin on 25/12/2022.
//

import SwiftUI

let awardItemNames: [String] = ["First cup","First Day","First 7 days","30 days", "3 months",  "6 months", " 1 year"]

class AwardListViewVM: ObservableObject {
    
    @Published var awardslist = [AwardItem]()
    
    @Published var awardsIndexs = [Bool]()
    
    @AppStorage("userPrivateinfo") var userPrivateinfoSaved: UserPrivateinfo?
    
    
    init(){
        self.awardsIndexs = Array(repeating: false, count: awardItemNames.count)
        
    }
    
    func updateAwardslist(){
        var tempList = [AwardItem]()
        
        for index in 0..<awardItemNames.count{
            let awardItem = AwardItem(imageName: "award\(index)", awardName: awardItemNames[index])
            tempList.append(awardItem)
            
        }
        DispatchQueue.main.async {
            self.awardslist = tempList
            self.checkIfTheUserHaveAwards()
        }
    }
    
    @MainActor
    func checkIfTheUserHaveAwards() {
        
        Task{
            var tempAwardsIndexs = Array(repeating: false, count: awardItemNames.count)
            let daysList: [DayItem] =  await PersistenceController.shared.fetchAllDaysItemsInBg()!
            print("daysList.count = \(daysList.count)")
            if daysList.count > 0 {
                tempAwardsIndexs[0] = self.checkFirstCupAward(daysList: daysList)
                tempAwardsIndexs[1] = self.checkdaysToAward(numberOfDays: 1, daysList: daysList)
                tempAwardsIndexs[2] = self.checkdaysToAward(numberOfDays: 7, daysList: daysList)
                tempAwardsIndexs[3] = self.checkdaysToAward(numberOfDays: 30, daysList: daysList)
                tempAwardsIndexs[4] = self.checkdaysToAward(numberOfDays: 90, daysList: daysList)
                tempAwardsIndexs[5] = self.checkdaysToAward(numberOfDays: 180, daysList: daysList)
                tempAwardsIndexs[6] = self.checkdaysToAward(numberOfDays: 365, daysList: daysList)
            }
            self.awardsIndexs =  tempAwardsIndexs
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

