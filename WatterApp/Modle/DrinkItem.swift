//
//  DrinkItem.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/12/2022.
//

import Foundation

struct DrinkItem: Identifiable{
    public var id: String = UUID().uuidString
    public var name: String
    public var amount: Int64
    public var date: Day?
    public var time: Date?
    
    init(name: String, amount: Int64, date: Day? = nil, time: Date = Date()) {
        self.name = name
        self.amount = amount
        self.date = date
        self.time = time
    }
}
