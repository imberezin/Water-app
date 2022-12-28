//
//  Persistence.swift
//  WatterApp
//
//  Created by IsraelBerezin on 30/11/2022.
//

import CoreData
import SwiftUI
import UIKit
import Charts

enum WaterType: Int, CaseIterable{
    case water = 200
    case bigWater = 300
    case coffee = 180
    case tee = 220
    case soda = 210
    
    var imageMame: String
    {
        switch self {
            case .water:    return "watter"
            case .bigWater: return "watter"
            case .coffee:   return "coffee"
            case .tee:      return "tee"
            case .soda:     return "soda"
        }
    }
    
    var name: String {
        switch self {
            case .water:    return "watter"
            case .bigWater: return "bigWater"
            case .coffee:   return "coffee"
            case .tee:      return "tee"
            case .soda:     return "soda"
        }
    }
}

let DayTimeInterval: Int = 60*60*24

struct PersistenceController {
    
    var oneDay: Day?

    lazy var applicationDocumentDirectory: URL = {
        let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.kaltura.waterapp")!
        return containerUrl
    }()
    
    
    
    func getOneDay()-> Day{
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
        let viewContext = container.viewContext

        var drinksTypes = [DrinkItem]()

        for drink in WaterType.allCases {
            
            let newItem = DrinkItem(name: drink.name, amount: Int64(drink.rawValue))
            drinksTypes.append(newItem)
        }
        let newItem = Day(context: viewContext)
        newItem.id = UUID()
        newItem.date = Date()
        
        var drinksList:Set = Set<Drink>()
//        let randomNumber: Int = Int.random(in: 8...15)

        for index in 0..<15 {
            
            let random: Int = Int.random(in: 0..<drinksTypes.count)
            
//                if index < 2 {
//                    random = drinksTypes.count-1
//                }
            let drink = drinksTypes[random]
            
            let newDrink = createNewDrink(selectedDrink: drink, day: newItem,viewContext: viewContext)
            drinksList.insert(newDrink)

        }

        newItem.drink = drinksList as NSSet
        
        return newItem
        
    }
    
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        
        var drinksTypes = [DrinkItem]()

        for drink in WaterType.allCases {
            
            let newItem = DrinkItem(name: drink.name, amount: Int64(drink.rawValue))
            drinksTypes.append(newItem)
        }
                
        for daysToAdd in 0..<7 {
            let newItem = Day(context: viewContext)
            newItem.id = UUID()
            newItem.date = Date().addingTimeInterval(TimeInterval(-DayTimeInterval*daysToAdd))
            
            var drinksList:Set = Set<Drink>()
            let randomNumber: Int = Int.random(in: 8...15)

            for index in 0..<randomNumber {
                
                var random: Int = Int.random(in: 0..<drinksTypes.count)
                
//                if index < 2 {
//                    random = drinksTypes.count-1
//                }
                let drink = drinksTypes[random]
                
                let newDrink = createNewDrink(selectedDrink: drink, day: newItem,viewContext: viewContext)
                drinksList.insert(newDrink)

            }
    
            newItem.drink = drinksList as NSSet
            
        }
        for daysToAdd in 1..<3 {
            let newItem = Day(context: viewContext)
            newItem.id = UUID()
            newItem.date = Date().addingTimeInterval(TimeInterval(DayTimeInterval*daysToAdd))
            
            var drinksList:Set = Set<Drink>()
            let randomNumber: Int = Int.random(in: 8...15)

            for index in 0..<randomNumber {
                
                let random: Int = Int.random(in: 0..<drinksTypes.count)
                
                let drink = drinksTypes[random]
                
                let newDrink = createNewDrink(selectedDrink: drink, day: newItem,viewContext: viewContext)
                drinksList.insert(newDrink)

            }
    
            newItem.drink = drinksList as NSSet

        }
        
        
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    
    var drinksTypes = [DrinkItem]()

    init(inMemory: Bool = false) {
        
        //based: https://medium.com/@pietromessineo/ios-share-coredata-with-extension-and-app-groups-69f135628736
        let storeURL = URL.storeURL(for: "group.com.kaltura.waterapp", databaseName: "WatterApp")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container = NSPersistentContainer(name: "WatterApp")
        container.persistentStoreDescriptions = [storeDescription]

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }else{
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.buildDrinks()
        // self.AddTempData()
       // self.deleteAllData("Day")
    }
    
    
    func deleteAllData(_ entity:String) {
        
        let viewContext = container.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func addDrinkToToday(drink: DrinkType){
        let viewContext = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        fetchRequest.predicate = NSPredicate(format : "date < %@ AND  date > %@", Date().daysAfter(number: 1) as CVarArg, Date().daysBefore(number: 1) as CVarArg)
        do {
            let results = try viewContext.fetch(fetchRequest)
            print(results.count)
            if !results.isEmpty{
                self.updateDayItem(day: results.first! as! Day, drink: drink)
            }else{
                self.createNewDay(date: Date(), drinkItem: DrinkItem(name: drink.name, amount: Int64(drink.amount)))
            }
        } catch  {
            print("error :", error)
        }
    }
    
    static func createNewDrink(selectedDrink: DrinkItem, day:Day, viewContext: NSManagedObjectContext)->Drink{
        
        let newDrink = Drink(context: viewContext)
        newDrink.id = UUID()
        newDrink.amount = selectedDrink.amount
        newDrink.name = selectedDrink.name
        newDrink.time = Date()
        newDrink.date = day
        return newDrink
    }
    
    func createNewDrink(selectedDrink: DrinkItem, day:Day, viewContext: NSManagedObjectContext)->Drink{
        
        let newDrink = Drink(context: viewContext)
        newDrink.id = UUID()
        newDrink.amount = selectedDrink.amount
        newDrink.name = selectedDrink.name
        newDrink.time = Date()
        newDrink.date = day
        return newDrink
    }
    
    
    static func deleteAllMemoryData(_ entity:String) {
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    
    
    func AddTempData(){
        
        self.deleteAllData("Day")
        
        let viewContext = container.viewContext
        
        
        for daysToAdd in 0..<20 {
            let newItem = Day(context: viewContext)
            newItem.id = UUID()
            newItem.date = Date().addingTimeInterval(TimeInterval(-DayTimeInterval*daysToAdd))
            
            var drinksList:Set = Set<Drink>()
            let randomNumber: Int = Int.random(in: 12...20)
            
            for _ in 0..<randomNumber {
                
                let random: Int = Int.random(in: 0..<drinksTypes.count)
                
                let drink = drinksTypes[random]
                
                let newDrink = createNewDrink(selectedDrink: drink, day: newItem)
                drinksList.insert(newDrink)
                
            }
            
            
            newItem.drink = drinksList as NSSet
            
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func createNewDrink(selectedDrink:DrinkItem, day:Day)->Drink{
        
        let viewContext = container.viewContext
        let newDrink = Drink(context: viewContext)
        newDrink.id = UUID()
        newDrink.amount = selectedDrink.amount
        newDrink.name = selectedDrink.name
        newDrink.time = Date()
        newDrink.date = day
        return newDrink
    }
    
    
    func createNewDay(date:Date, drinkItem: DrinkItem){
        let viewContext = container.viewContext

       let newDayItem = Day(context: viewContext)
        newDayItem.id = UUID()
        newDayItem.date = date //Date().addingTimeInterval(TimeInterval(-DayTimeInterval*daysToAdd))
        
        var drinksList:Set = Set<Drink>()
        let newDrink = createNewDrink(selectedDrink: drinkItem, day: newDayItem)
        drinksList.insert(newDrink)
        newDayItem.drink = drinksList as NSSet
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateDayItem(day: Day, drink: DrinkType){
        
        let viewContext = container.viewContext
        
        let drinkItem = DrinkItem(name: drink.name, amount: Int64(drink.amount))
        
        let newDrink = createNewDrink(selectedDrink: drinkItem, day: day)

        var drinksList:Set = day.drink as! Set<Drink>
        
        drinksList.insert(newDrink)

        day.drink = drinksList as NSSet
        
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }


    }
    
    func reomveDrinkFromDay(day: Day, drink: Drink) -> Day?{
        let viewContext = container.viewContext

        var drinksList:Set = day.drink as! Set<Drink>
        drinksList.remove(drink)
        day.drink = drinksList  as NSSet
        
        do {
            try viewContext.save()
            return day
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }

    
    
    
    mutating func buildDrinks(){
        var temp = [DrinkItem]()
        for drink in WaterType.allCases {
            
            let newItem = DrinkItem(name: drink.name, amount: Int64(drink.rawValue))
            temp.append(newItem)
        }
        self.drinksTypes = temp

    }
        
    
    func fetchAllDaysItemsInBg() async-> [DayItem]?{
        
        
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()

        let taskContext = container.newBackgroundContext()
        var results:  [Day] = [Day]()
        do {
        
            try await taskContext.perform({
               results = try taskContext.fetch(fetchRequest)
            })
            
        } catch {
            print("error :", error)
        }
        
        let arr: [DayItem] = covertToDayItemArray(daysList: results)
        
        return arr.sorted(by:{
            $0.date.compare($1.date) == .orderedAscending})
    }
    
    func covertToDayItemArray(daysList:[Day])->[DayItem]{
                
        var arr = [DayItem]()
        for item in daysList{
            if let drink = item.drink{
                let newItem = DayItem(date: item.date!, drink: drink)
                arr.append(newItem)
            }
        }

        return arr
    }

}

