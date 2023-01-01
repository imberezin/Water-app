//
//  WaterEntry.swift
//  WatterApp
//
//  Created by IsraelBerezin on 29/12/2022.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct WaterEntry: TimelineEntry {
    
    let date: Date
    let configuration: ConfigurationIntent
    let displaySize: CGSize
    let customTotal: Int
    let todayTotal: Int
    let drinkTypesList: [DrinkType]
    
    init( date: Date, configuration: ConfigurationIntent, displaySize: CGSize, customTotal: Int , todayTotal: Int, drinkTypesList: [DrinkType]? = nil) {
        self.date = date
        self.configuration = configuration
        self.displaySize = displaySize
        self.customTotal = customTotal
        self.todayTotal = todayTotal
        if let drinkTypesList = drinkTypesList{
            self.drinkTypesList = drinkTypesList
        }else{
            self.drinkTypesList = [DrinkType(name: "Test", amount: 100, imageMame: "other")]
        }
    }
}
