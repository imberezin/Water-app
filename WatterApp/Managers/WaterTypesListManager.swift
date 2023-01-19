//
//  WaterTypesListManager.swift
//  WatterApp
//
//  Created by IsraelBerezin on 07/12/2022.
//

import Foundation
import SwiftUI
import WidgetKit


enum PlistUrlType{
    case local
    case group
}


class WaterTypesListManager: ObservableObject {
    
    static let shared = WaterTypesListManager()
    
    @Published var drinkTypesList: [DrinkType] = [DrinkType]()
    
    @Published var needToUpdateListWaterList: Bool = false
    
    var plistLocalURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("WaterTypesList.plist")
    }
    
    var plistGroupURL: URL {
        dump("plistGroupURL")
#if os(iOS)
        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.kaltura.waterapp") else {
            fatalError("could not get shared app group directory.")
        }
        return groupURL.appendingPathComponent("WaterTypesList.plist")
#else
        return self.localRadeUrl
        #endif
    }
    
    var localRadeUrl: URL{
        dump("localRadeUrl")
        return Bundle.main.url(forResource: "WaterTypesList", withExtension: "plist")!
        
    }
    
    var drinkNameList: [String]{
       // return self.drinkTypesList.map({$0.name.capitalizedSentence}) .unique
        return fullWaterList
    }
    
    @MainActor
    func loadPropertyList(forceUpdate: Bool = false) {
        if (drinkTypesList.count == 0 || forceUpdate == true){
                        
            if FileManager.default.fileExists(atPath: plistGroupURL.path) {
                Task{
                    self.drinkTypesList = await self.buildDrinkList(urlType: .group)
                }
                
            } else {
                Task{
                     let list = await  buildDrinkList(urlType: .local)
                    print(self.drinkTypesList)
                    self.savePropertyList(for: list)
                    self.drinkTypesList = list
                    
                    // Delay the task by 1 second:
//                    try await Task.sleep(nanoseconds: 1_000_000_00080)
//                    self.savePropertyList(for: list)

                   // self.drinkTypesList =  await  buildDrinkList(urlType: .group)
                    print(self.drinkTypesList)

                    WidgetCenter.shared.reloadAllTimelines()
                    print("===End loadPropertyList ====")


                }
                
            
            }
        }else{
            print("loadPropertyList => list exist => \(self.drinkTypesList.count)")
        }
    }
    
//    func loadDrinks(from url:URL){
//
//        DispatchQueue.global().async { [weak self] in
//
//            if let data = try? Data(contentsOf: url) {
//
//                let decoder = PropertyListDecoder()
//                let list = try? decoder.decode([DrinkType].self, from: data)
//                //print(list as Any)
//                if let list = list {
//                    DispatchQueue.main.async {
//                        self!.drinkTypesList = list
//                    }
//                }
//            }
//        }
//    }
  
    
    func savePropertyList(for drinkTypesList: [DrinkType]) {
        
        let encoder = PropertyListEncoder()
        
        if let data = try? encoder.encode(drinkTypesList) {
            do {
                if FileManager.default.fileExists(atPath: plistGroupURL.path) {
                    // Update an existing plist
                    try FileManager.default.removeItem(atPath: plistGroupURL.path)
                    FileManager.default.createFile(atPath: plistGroupURL.path, contents: data, attributes: nil)
                    
                    //                    try data.write(to: plistURL1)
                } else {
                    // Create a new plist
                    FileManager.default.createFile(atPath: plistGroupURL.path, contents: data, attributes: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }catch{
                print("savePropertyList error")
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    func asyncGetData(url: URL) async throws -> Data {
        try await Task.detached {
            try Data(contentsOf: url)
        }.value
    }
    
    func fetchAndUpdateUI(from url: URL) async  ->  [DrinkType]{ //async -> Task<[DrinkType]?, any Error> {
        do{
             let data = try await asyncGetData(url: url)
            let decoder = PropertyListDecoder()
            let list = try? decoder.decode([DrinkType].self, from: data)
            print(list as Any)
            if let list = list {
                return list
            }
                
            
        }catch{
            print(error.localizedDescription)
        }
        return[DrinkType]()
    }
    
    
    
    
    @MainActor
    func buildDrinkList(urlType:PlistUrlType = .group ,forceUpdate: Bool = false) async -> [DrinkType] {
        if (drinkTypesList.count == 0 || forceUpdate == true){
//            let plistUrl = urlType == .group ? self.plistGroupURL : self.localRadeUrl
            return await fetchAndUpdateUI(from: urlType == .group ? self.plistGroupURL : self.localRadeUrl)
        }else{
            print("buildDrinkList => list exist => \(self.drinkTypesList.count)")
            return  self.drinkTypesList
        }
        
    }
    
    func getAsyncDrinkList(urlType:PlistUrlType = .group) async -> [DrinkType] {
        
        return await self.buildDrinkList(urlType:urlType)
        
       // return await fetchAndUpdateUI(from: self.plistGroupURL)
        
    }
    
#if os(iOS)
    func buildNotificationDrinkActions(maxNumber: Int) -> [UNNotificationAction] {
        
        
        var notificationActionArray: [UNNotificationAction] = [UNNotificationAction]()
        let endIndex = drinkTypesList.count < maxNumber ? drinkTypesList.count : maxNumber
        for index in 0 ..< endIndex {
            let acceptAction = UNNotificationAction(identifier: drinkTypesList[index].id,
                                                    title: "Add \(drinkTypesList[index].name) - \(drinkTypesList[index].amount)Ml",
                                                    options: [], icon: UNNotificationActionIcon(templateImageName: drinkTypesList[index].imageName))
            notificationActionArray.append(acceptAction)
        }
        return notificationActionArray
    }
    
    @MainActor
    func buildHomeScreenQuickDrinkActions(maxNumber: Int) async -> [UIApplicationShortcutItem] {
        
        if drinkTypesList.count == 0{
            //                let fileURL = Bundle.main.url(forResource: fileName, withExtension: "plist")!
            self.drinkTypesList = await fetchAndUpdateUI(from: plistGroupURL)
        }
        var notificationActionArray: [UIApplicationShortcutItem] = [UIApplicationShortcutItem]()
        let endIndex = drinkTypesList.count < maxNumber ? drinkTypesList.count : maxNumber
        for index in 0 ..< endIndex {
            let acceptAction = UIApplicationShortcutItem(type: drinkTypesList[index].id, localizedTitle: "Add \(drinkTypesList[index].name) - \(drinkTypesList[index].amount)Ml", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: drinkTypesList[index].imageName), userInfo: nil)
            
            notificationActionArray.append(acceptAction)
        }
        return notificationActionArray.reversed()
    }
    
#endif
    
    @MainActor
    func saveListIfNeded(isNeded: Bool){
        if isNeded{
            print("save list in Plist file")
            self.savePropertyList(for: self.drinkTypesList)
        }else{
            self.loadPropertyList(forceUpdate: true)
        }
        self.needToUpdateListWaterList = false
    }
    
}



/*
 UIApplicationShortcutItem(
 type: "newMessage",
 localizedTitle: "New Message",
 localizedSubtitle: nil,
 icon: UIApplicationShortcutIcon(type: .compose),
 userInfo: nil
 )
 */



let waterListCoreData : [[String: Any]] = [
    [
        "name": "Water",
        "amount": 200,
        "imageName": "water",
        "calories": 0,
        "orederNumber": 0
        // any other key values
    ],
    [
        "name": "Water",
        "amount": 300,
        "imageName": "water",
        "calories": 0,
        "orederNumber": 0
        // any other key values
    ],
    [
        "name": "Coffee",
        "amount": 180,
        "imageName": "coffee",
        "calories": 0,
        "orederNumber": 0
        // any other key values
    ],
    [
        "name": "Tee",
        "amount": 180,
        "imageName": "tee",
        "calories": 0,
        "orederNumber": 0
        // any other key values
    ],
    [
        "name": "Soda",
        "amount": 200,
        "imageName": "soda",
        "calories": 0,
        "orederNumber": 0
        // any other key values
    ]
]

/*
 
 
 func create(){
 //        let fileManager = FileManager.default
 //
 //        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
 //        let path = documentDirectory.appending("/waterTypesList.plist")
 //
 //        if(!fileManager.fileExists(atPath: path)){
 //            print(path)
 //
 //            let data : [[String: Any]] = waterListCoreData
 //
 //            let someData = NSArray(array: data)
 //            let isWritten = someData.write(toFile: path, atomically: true)
 //            print("is the file created: \(isWritten)")
 //
 //
 //
 //        } else {
 //            print("file exists")
 //        }
 self.readPropertyList()
 
 }
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <array>
 <dict>
 <key>name</key>
 <string>Water</string>
 <key>amount</key>
 <integer>200</integer>
 <key>imageMame</key>
 <string>watter</string>
 <key>calories</key>
 <integer>0</integer>
 <key>orederNumber</key>
 <integer>0</integer>
 </dict>
 <dict>
 <key>name</key>
 <string>Water</string>
 <key>amount</key>
 <integer>300</integer>
 <key>imageMame</key>
 <string>watter</string>
 <key>calories</key>
 <integer>0</integer>
 <key>orederNumber</key>
 <integer>1</integer>
 </dict>
 <dict>
 <key>name</key>
 <string>coffee</string>
 <key>amount</key>
 <integer>180</integer>
 <key>imageMame</key>
 <string>coffee</string>
 <key>calories</key>
 <integer>0</integer>
 <key>orederNumber</key>
 <integer>2</integer>
 </dict>
 <dict>
 <key>name</key>
 <string>Tee</string>
 <key>amount</key>
 <integer>220</integer>
 <key>imageMame</key>
 <string>tee</string>
 <key>calories</key>
 <integer>0</integer>
 <key>orederNumber</key>
 <integer>3</integer>
 </dict>
 <dict>
 <key>name</key>
 <string>Soda</string>
 <key>amount</key>
 <integer>200</integer>
 <key>imageMame</key>
 <string>soda</string>
 <key>calories</key>
 <integer>0</integer>
 <key>orederNumber</key>
 <integer>4</integer>
 </dict>
 <dict>
 <key>name</key>
 <string>Milk</string>
 <key>amount</key>
 <integer>180</integer>
 <key>imageMame</key>
 <string>milk</string>
 <key>calories</key>
 <integer>0</integer>
 <key>orederNumber</key>
 <integer>5</integer>
 </dict>
 <dict>
 <key>name</key>
 <string>Wine</string>
 <key>amount</key>
 <integer>100</integer>
 <key>imageMame</key>
 <string>wine</string>
 <key>calories</key>
 <integer>0</integer>
 <key>orederNumber</key>
 <integer>6</integer>
 </dict>
 <dict>
 <key>name</key>
 <string>Other</string>
 <key>amount</key>
 <integer>200</integer>
 <key>imageMame</key>
 <string></string>
 <key>calories</key>
 <integer>7</integer>
 <key>orederNumber</key>
 <integer>1</integer>
 </dict>
 </array>
 </plist>
 
 
 
 
 //        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String: Any]] else {return}
 
 //        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
 //        let path = paths.appending("/\(fileName).plist")
 //        print(path)
 //        let plistDict = NSDictionary(contentsOfFile: path)
 //        print(plistDict)
 //
 ////        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
 ////        let path = paths.appending("/\(fileName).plist")
 //        let fileManager = FileManager.default
 //        if (!(fileManager.fileExists(atPath: path))){
 //            print("ffff")
 //        }
 
 //         let url = URL(string: path!)!
 
 //        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
 //        let path = documentDirectory.appending("/WaterTypesList.plist")
 //
 ////        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
 //
 //         let fileURL = URL(fileURLWithPath: path)
 ////        var contentString = try? String(contentsOfFile: fileURL.path)
 
 let filePath = Bundle.main.path(forResource: "WaterTypesList", ofType: "plist")!
 // Prints as /var/folders/blah-blah-blah/hello.txt
 
 
 */
