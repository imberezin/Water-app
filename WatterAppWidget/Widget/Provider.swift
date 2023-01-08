//
//  Provider.swift
//  watterAppWidgetExtension
//
//  Created by IsraelBerezin on 28/12/2022.
//

import WidgetKit
import SwiftUI
import CoreData
import Intents
import OSLog

struct Provider: IntentTimelineProvider {


    func placeholder(in context: Context) -> WaterEntry {
        let defaultLog = Logger()
        defaultLog.log("==== placeholder ====")
        @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?
        let customTotal = userPrivateinfoSaved?.customTotal ?? defaultCustomTotal
        return WaterEntry( date: Date(), configuration: ConfigurationIntent(), displaySize: context.displaySize, customTotal: customTotal, todayTotal: 1000)
        
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WaterEntry) -> ()) {
        
        Task{

            @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?
            
            let daysItemList: [DayItem] =  await PersistenceController.shared.fatchTodayDrinkInfo()!

            let todayTotal = self.todayWaterInfo(daysItems: daysItemList)

            let customTotal = userPrivateinfoSaved?.customTotal ?? defaultCustomTotal
            
            let waterList =  await WaterTypesListManager.shared.getAsyncDrinkList()
            let fitst4 = Array(waterList.prefix(4))

            let defaultLog = Logger()
            defaultLog.log("==== getSnapshot ====")
            defaultLog.log("getSnapshot: userPrivateinfoSaved?.customTotal = \(customTotal)")
            defaultLog.log("getSnapshot: todayTotal = \(todayTotal)")
            defaultLog.log("getSnapshot: waterList = \(waterList.count)")

            let entry = WaterEntry(date: Date(), configuration: configuration, displaySize: context.displaySize, customTotal: customTotal, todayTotal: todayTotal, drinkTypesList: fitst4)
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<WaterEntry>) -> ()) {
        
        Task{
            @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?
            
            var entries: [WaterEntry] = []

            let currentDate = Date()
            
            let nextUpdate = Calendar.current.date(byAdding: .minute,  value: 1, to: currentDate)!
                        
            let daysItemList: [DayItem] =  await PersistenceController.shared.fatchTodayDrinkInfo()!

            let todayTotal = self.todayWaterInfo(daysItems: daysItemList)
            
            let customTotal = userPrivateinfoSaved?.customTotal ?? defaultCustomTotal

            let waterList =  await WaterTypesListManager.shared.getAsyncDrinkList()

            let defaultLog = Logger()
            defaultLog.log("==== nextTimelineUpdate ====")
            defaultLog.log("getTimeline: userPrivateinfoSaved?.customTotal = \(customTotal)")
            defaultLog.log("getTimeline: todayTotal = \(todayTotal)")
            defaultLog.log("getTimeline: waterList = \(waterList.count)")

            let fitst4 = Array(waterList.prefix(4))
            let entry = WaterEntry(date: nextUpdate, configuration: configuration, displaySize: context.displaySize, customTotal: customTotal,todayTotal: todayTotal, drinkTypesList: fitst4)
            entries.append(entry)
            
            let today = Date()
            let date = Calendar.gregorian.startOfDay(for: today)
            var newDate  = Calendar.gregorian.date(byAdding: .minute,value: 1, to: date)
            newDate = Calendar.gregorian.date(byAdding: .day,value: 1, to: date)
            defaultLog.log("date = \(date)")
            defaultLog.log("newDate = \(newDate!)")

            //update autaomaticlly only in new date :00:01, widget by WidgetCenter.shared.reloadAllTimelines() when user insert or remove from DB!
            let timeline = Timeline(entries: entries, policy: .after(newDate!))
            
            completion(timeline)
        }
        
    }
    
    func todayWaterInfo(daysItems: [DayItem]) -> Int{
        if daysItems.count > 0 {
            print("daysItems.count = \(daysItems.count)")
            if let today: DayItem = daysItems.first(where: {$0.date.getGregorianDate(dateFormat: "d MMMM yyyy") == Date().getGregorianDate(dateFormat: "d MMMM yyyy")}){
                Logger().log("todayWaterInfo = \(today.total)")
                return today.total
            }
        }
        return 0
    }
    
}

