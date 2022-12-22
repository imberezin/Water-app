//
//  DayItem.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/12/2022.
//

import Foundation


struct DayItem: Identifiable{
    
     public var id: String = UUID().uuidString
     public var date: Date
     public var total: Int = 0
     public var drink: [Drink]?
     public var animation: Bool = false
     public var drinkItems: [DrinkItem]
    
    
    
    init(date: Date, drink: NSSet?) {
        self.date = date
        self.animation = false
        self.drink = nil
        self.total = 0
        self.drinkItems = [DrinkItem(name: "", amount: 0)]

        if drink != nil{
            let array = Array(drink as! Set<Drink>)
            if array.count > 0{
                self.drink = array
                let totalScore = array.sum(for: \.amount)
                self.total = Int(totalScore)
                self.drinkItems = array.map({DrinkItem(name: $0.name!, amount: $0.amount)})
            }
            
        }

        
    }
    
    
    init (date: Date, drinkItems: [DrinkItem]) {
        self.date = date
        self.drinkItems = drinkItems
    }
    
    mutating func updateAnumation(value: Bool){
        self.animation = value
    }
    
    
}
