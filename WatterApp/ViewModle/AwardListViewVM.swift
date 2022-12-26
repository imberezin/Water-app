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
    func checkIfTheUserHaveAwards() { //-> Task<[Bool], Error>{

        Task{
            var tempAwardsIndexs = Array(repeating: false, count: awardItemNames.count)
            let daysList: [DayItem] =  await PersistenceController.shared.fetchAllDaysItemsInBg()!
            print(daysList.count)
            if daysList.count > 0 {
                tempAwardsIndexs[0] = self.checkFirstCupAward(daysList: daysList)
                tempAwardsIndexs[1] = self.checkFirstDayAward(daysList: daysList)
                tempAwardsIndexs[2] = self.checkFirst7daysAward(daysList: daysList)

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
    
    func checkFirstDayAward(daysList:[DayItem])->Bool{
        
        for day:DayItem in daysList {
            if day.total >= (userPrivateinfoSaved?.customTotal ?? -1){
                return true
            }
        }
        return false

    }
    
    func checkFirst7daysAward(daysList:[DayItem])->Bool{
        
                
        
        if daysList.count >= 7{
            for indexFirst in 0 ..< daysList.count{
                let testDay = daysList[indexFirst]
                if testDay.total >= (userPrivateinfoSaved?.customTotal ?? -1){
                    if indexFirst + 6 < daysList.count{
                        var customTotalCount = 1;
                        for index in indexFirst ..< indexFirst + 6{
                            if daysList[index].total >= (userPrivateinfoSaved?.customTotal ?? -1){
                                customTotalCount += 1
                            }
                        }
                        if customTotalCount == 7{
                            return true
                        }
                    }
                }
                
            }
        }
        
        return false

        
    }
    
    
    func check2WeekAward()->Bool{
        
        return false

    }


    
}

