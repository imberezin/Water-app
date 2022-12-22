//
//  WaterTypesListManager.swift
//  WatterApp
//
//  Created by IsraelBerezin on 07/12/2022.
//

import Foundation
import SwiftUI

struct DrinkType : Codable,Identifiable {
    
    let id: String  //= UUID().uuidString
    let name : String
    let amount : Int
    let calories : Int
    let orederNumber : Int
    let imageMame : String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case amount = "amount"
        case calories = "calories"
        case orederNumber = "orederNumber"
        case imageMame = "imageMame"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)!
        name = try values.decodeIfPresent(String.self, forKey: .name)!
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)!
        calories = try values.decodeIfPresent(Int.self, forKey: .calories)  ?? 0
        orederNumber = try values.decodeIfPresent(Int.self, forKey: .orederNumber) ?? 0
        imageMame = try values.decodeIfPresent(String.self, forKey: .imageMame)!
    }
    
}



class WaterTypesListManager: ObservableObject {
    
        
    static let shared = WaterTypesListManager()

    @Published var drinkTypesList: [DrinkType] = [DrinkType]()

    let fileName =  "waterTypesList"
    
    
    init(){
        //self.readPropertyList()
    }
    
    func loadPropertyList() {
        
        let fileURL1 = Bundle.main.url(forResource: "WaterTypesList", withExtension: "plist")!
        
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: fileURL1) {
                
                let decoder = PropertyListDecoder()
                let list = try? decoder.decode([DrinkType].self, from: data)
                //print(list as Any)
                if let list = list {
                    DispatchQueue.main.async {
                        self!.drinkTypesList = list
                    }
                }
            }
        }
    }
    
    func asyncGetData(url: URL) async throws -> Data {
        
        
        try await Task.detached {
            try Data(contentsOf: url)
        }.value
    
        
    }

    
    func fetchAndUpdateUI(from url: URL) async  ->  [DrinkType]{ //async -> Task<[DrinkType]?, any Error> {
        if let data = try? await asyncGetData(url: url){
            let decoder = PropertyListDecoder()
            let list = try? decoder.decode([DrinkType].self, from: data)
            print(list as Any)
            if let list = list {
                return list
            }

        }
        return[DrinkType]()
    }


    
    
    
    //        func chipsOperationPropertyList(operation: chipsOperation) {
    
    func chipsOperationPropertyList() {
        //chipOperation is enum for add, edit and update
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = paths.appending("/StoreData.plist")
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            do {
                let bundlePath : NSString = Bundle.main.path(forResource: fileName, ofType: "plist")! as NSString
                try fileManager.copyItem(atPath: bundlePath as String, toPath: path)
            }catch {
                print(error)
            }
        }
        var plistDict:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path)!
        //        switch operation {
        //           case chipsOperation.add:
        //                plistDict.setValue("Value", forKey: "Key")
        //                break
        //           case chipsOperation.edit:
        //                plistDict["Key"] = "Value1"
        //                break
        //           case chipsOperation.delete:
        //                plistDict.removeObject(forKey: "Key")
        //                break
        //        }
        //        plistDict.write(toFile: path, atomically: true)
    }
    
    @MainActor
    func buildDrinkList() async{
        if drinkTypesList.count == 0{
            let fileURL = Bundle.main.url(forResource: "WaterTypesList", withExtension: "plist")!
            self.drinkTypesList = await fetchAndUpdateUI(from: fileURL)
        }

    }
    
    func buildNotificationDrinkActions(maxNumber: Int) -> [UNNotificationAction] {
        
        
        var notificationActionArray: [UNNotificationAction] = [UNNotificationAction]()
        let endIndex = drinkTypesList.count < maxNumber ? drinkTypesList.count : maxNumber
        for index in 0 ..< endIndex {
            let acceptAction = UNNotificationAction(identifier: drinkTypesList[index].id,
                                                    title: "Add \(drinkTypesList[index].name) - \(drinkTypesList[index].amount)Ml",
                                                    options: [], icon: UNNotificationActionIcon(templateImageName: drinkTypesList[index].imageMame))
            notificationActionArray.append(acceptAction)
        }
        return notificationActionArray
    }
    
    @MainActor
    func buildHomeScreenQuickDrinkActions(maxNumber: Int) async -> [UIApplicationShortcutItem] {
        
        if drinkTypesList.count == 0{
            let fileURL = Bundle.main.url(forResource: "WaterTypesList", withExtension: "plist")!
            self.drinkTypesList = await fetchAndUpdateUI(from: fileURL)
        }
        var notificationActionArray: [UIApplicationShortcutItem] = [UIApplicationShortcutItem]()
        let endIndex = drinkTypesList.count < maxNumber ? drinkTypesList.count : maxNumber
        for index in 0 ..< endIndex {
            let acceptAction = UIApplicationShortcutItem(type: drinkTypesList[index].id, localizedTitle: "Add \(drinkTypesList[index].name) - \(drinkTypesList[index].amount)Ml", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: drinkTypesList[index].imageMame), userInfo: nil)
            
                notificationActionArray.append(acceptAction)
        }
        return notificationActionArray.reversed()
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
