//
//  PieDateVM.swift
//  WatterApp
//
//  Created by IsraelBerezin on 08/12/2022.
//

import Foundation
import SwiftUI

class PieDateVM : ObservableObject{
    
    var total: Double
    @Published var data: [PieDateUnit] = [PieDateUnit]()
    var mumberOfPieces : Int = 0
    let colors = [Color.cyan,Color.green,Color.yellow,Color.orange, Color.brown,Color.pink,Color.red]
    var progress: Double = 0.0
    
    @AppStorage("userPrivateinfo") var userPrivateinfoSaved: UserPrivateinfo? // = UserPrivateinfo(fullName: "", height: 0, weight: 0, age: 0, customTotal: 3000, gender: Gander.male.rawValue, slectedRimniderHour: 3, enabledReminde: false, awardsWins: [Bool]())

    init( ){
        self.data = [PieDateUnit(name: "", amount: 0)]
        let d =  [PieDateUnit(name: "", amount: 0)]

        self.total = Double(d.sum(for: \.amount))
        self.mumberOfPieces = self.data.count
        
        self.progress = Double(self.total)/Double(userPrivateinfoSaved?.customTotal ?? 3000)

    }
    
    init( dayInfo: DayItem){
        
        print("init PieDateVM")
        let drink = dayInfo.drinkItems
        
        
        let array = drink.sorted(by: {$0.name > $1.name})
        
        let grouped: [[DrinkItem]] = (array.reduce(into: []) {
            $0.last?.last?.name == $1.name ?
            $0[$0.index(before: $0.endIndex)].append($1) :
            $0.append([$1])
        })
        
        var tempData : [PieDateUnit] =  [PieDateUnit]()
        
        for group in grouped {
            let name = group.first?.name
            let total = group.sum(for: \.amount)
            let p = PieDateUnit(name: name!, amount: Double(total))
            tempData.append(p)
        }
        
        self.data = tempData.sorted(by: {$0.amount > $1.amount})
        let d = tempData.sorted(by: {$0.amount > $1.amount})
        self.mumberOfPieces = tempData.count
        self.total = Double(d.sum(for: \.amount))
        self.mumberOfPieces = tempData.count
        
        self.progress = Double(self.total)/Double(userPrivateinfoSaved?.customTotal ?? 3000)
        print(self.data)
        print(self.total)
        print(self.progress)

        self.calaulateDegrees(tempData: self.data)
    }
    
    
    init(date: [PieDateUnit]) {
        self.data = date
        
        if date.count > 0{
            self.total = Double(date.sum(for: \.amount))
        }else{
            self.total = 0
        }
    }
    
    
    func update( dayInfo: DayItem){
        
        print("update dayInfo: DayItem")
        let drink = dayInfo.drinkItems
        
        
        let array = drink.sorted(by: {$0.name > $1.name})
        
        let grouped: [[DrinkItem]] = (array.reduce(into: []) {
            $0.last?.last?.name == $1.name ?
            $0[$0.index(before: $0.endIndex)].append($1) :
            $0.append([$1])
        })
        
        var tempData : [PieDateUnit] =  [PieDateUnit]()
        
        for group in grouped {
            let name = group.first?.name
            let total = group.sum(for: \.amount)
            let p = PieDateUnit(name: name!, amount: Double(total))
            tempData.append(p)
        }
        
//        tempData = tempData.sorted(by: {$0.amount > $1.amount})
//            self.data = tempData.sorted(by: {$0.amount > $1.amount})
            self.total = Double(tempData.sum(for: \.amount))
            self.mumberOfPieces = tempData.count
            
        self.progress = Double(self.total)/Double(self.userPrivateinfoSaved?.customTotal ?? 3000)
            print(tempData)
            print(self.total)
            print(self.progress)

        self.calaulateDegrees(tempData: tempData.sorted(by: {$0.amount > $1.amount}))

    }
    
    func calaulateDegrees(tempData : [PieDateUnit]){
        
        let onePresent:Double = 100/self.total
        
//        var oldData: [PieDateUnit] = [PieDateUnit]()
        
//        oldData.append(contentsOf: tempData)

        for index in 0 ..< tempData.count{
            
            let data = tempData[index]
            var start = 0.0
            var end = 0.0
            
            let percentFromTotal:Double = onePresent*data.amount
            let degreesInPie = percentFromTotal*360/100
            
            if index == 0{
                start = 0.0
                end = degreesInPie
            }else{
                //                let startArraySlice = self.data[0..<index] // using Range
                start = tempData.sum(for: \.degrees)
                end = start + degreesInPie
            }
            print("percentFromTotal = \(percentFromTotal)")
            print("degrees = \(degreesInPie)")
            print("start = \(start)")
            print("end = \(end)\n")
            
            data.update(percent: percentFromTotal, degrees: degreesInPie, start: start, end: end, color: index < colors.count ? colors[index] : Color.black)
            
        }
        
        DispatchQueue.main.async {
            self.data = tempData
        }
    }
}
