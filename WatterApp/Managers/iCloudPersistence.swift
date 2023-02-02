//
//  iCloudPersistence.swift
//  WatterApp
//
//  Created by IsraelBerezin on 31/01/2023.
//

import Foundation

import CoreData
import SwiftUI
#if os(iOS)
import UIKit
#endif
import Charts

import CloudKit

// https://github.com/apple?q=cloudkit-sample&type=repository%E2%80%9D
// https://www.kodeco.com/4878052-cloudkit-tutorial-getting-started
// https://stackoverflow.com/a/46084532/1571228
// https://swiftpackageindex.com/ccavnor/MockCloudKitFramework

class iCloudPersistence {
    
    static let shared = iCloudPersistence()
    
    private let db = CKContainer(identifier:"iCloud.com.kaltura.mediaWaApp").publicCloudDatabase
    
    let recordZone = CKRecordZone(zoneName: "DayDrinkInfo")
    
    let zoneID = CKRecordZone.ID(zoneName: "_defaultZone", ownerName: CKCurrentUserDefaultName)
    
    
    init(){
        print(db.databaseScope)
    }
    
    func addTest(){
        print("++++ ***** ++++")
        
        let dayRecored = CKRecord(recordType: "DayDrinkInfo")
        
        let drinkRecord1 =  CKRecord(recordType: "DrinksInfo")
        let drinkRecord2 =  CKRecord(recordType: "DrinksInfo")
        
        dayRecored.setValue(UUID().uuidString, forKey: "id")
        dayRecored.setValue(Date.now, forKey: "date")
        
        var fieldValueReferences = [CKRecord.Reference]()
        
        print("++++ **artworks** ++++")
        
        let reference1 = CKRecord.Reference(recordID: drinkRecord1.recordID, action: .deleteSelf)
        let reference2 = CKRecord.Reference(recordID: drinkRecord2.recordID, action: .deleteSelf)
        
        if !fieldValueReferences.contains(reference1) {
            fieldValueReferences.append(reference1)
        }
        if !fieldValueReferences.contains(reference2) {
            fieldValueReferences.append(reference2)
        }
        dayRecored["drink"] = fieldValueReferences
        print(dayRecored)
        
        
       // drinkRecord1.setValue(UUID().uuidString, forKey: "id")
        drinkRecord1.setValue(300, forKey: "amount")
        drinkRecord1.setValue("Water", forKey: "name")
        drinkRecord1.setValue(Date(), forKey: "time")
    
        let referencedrink = CKRecord.Reference(recordID: dayRecored.recordID, action: .none)
        
        drinkRecord1.setValue(referencedrink, forKey: "date")
        
        print(drinkRecord1)
        
     //   drinkRecord2.setValue(UUID().uuidString, forKey: "id")
        drinkRecord2.setValue(200, forKey: "amount")
        drinkRecord2.setValue("Water", forKey: "name")
        drinkRecord2.setValue(Date(), forKey: "time")
        drinkRecord2.setValue(referencedrink, forKey: "date")
        
        print(drinkRecord2)
        
        print(dayRecored)
        
        print("++++ ***** ++++")
        
        
//        db.modifyRecords(saving: [drinkRecord1,drinkRecord2,dayRecored], deleting: []) { results  in
//            switch results{
//            case let .success((saveResults, deleteResults)):
//                print("++++ ==== ++++")
//                print(saveResults)
//                print(deleteResults)
//                print("++++ ==== ++++")
//
//            case let .failure(error):
//                print(error)
//            }
//        }
        db.save(dayRecored) { record, error in
            print("++++ ==== ++++")
            if record != nil, error == nil {
                print("saved")
                
                let operation = CKModifyRecordsOperation()
                operation.qualityOfService = .utility
                  operation.database =   CKContainer(identifier:"iCloud.com.kaltura.mediaWaApp").publicCloudDatabase
                operation.recordsToSave = [drinkRecord1,drinkRecord2]
                operation.modifyRecordsResultBlock = { result in
                    dump(result)
                }
                self.db.add(operation)
                
            }else{
                print(error?.localizedDescription ?? "Error!")
            }
            print("++++ ==== ++++")
        }
        
    }
    
    func refresh(_ completion: @escaping (Error?) -> Void) {
        // 1.
        let predicate = NSPredicate(value: true)
        // 2.
        let query = CKQuery(recordType: "DayDrinkInfo", predicate: predicate)
        establishments(forQuery: query, completion)
    }
    
    var dayDrinkInfo: [DayDrinkInfo] = []
    
    private func establishments(forQuery query: CKQuery, _ completion: @escaping (Error?) -> Void) {
        /*
         'perform(_:inZoneWith:completionHandler:)' was deprecated in iOS 15.0: renamed to
         fetch(withQuery:inZoneWith:desiredKeys:resultsLimit:completionHandler:)
         */
        // db.fetch(withRecordZoneID: CKRecordZone.default().zoneID){ [weak self] results, error in
        db.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    print("***!!!!!!***")
                    completion(error)
                }
                return
            }
            guard let results = results else { return }
            print(results)
                        self.dayDrinkInfo = results.map {
                            DayDrinkInfo(record: $0, database: self.db)!
                    }
            DispatchQueue.main.async {
                print("*******")
                dump(self.dayDrinkInfo)
                print("*******")
                
                completion(nil)
            }
        }
    }
    
    
    
}

class DayDrinkInfo {
    let id: String
    let date: Date
    //  let drink: String
    
    let database: CKDatabase
    private(set) var drinks: [DrinkInfo]? = nil

    init?(record: CKRecord, database: CKDatabase) {
        print("Init DayDrinkInfo")
        print(record)
        guard
            let id = record["id"] as? String,
            let date = record["date"] as? Date
        else {return nil}
        self.id = id
        self.date = date
        self.database = database
        
      //  if let drinkRecords = record["drink"] as? [CKRecord.Reference] {
            print("---> drinkRecords")
        DrinkInfo.fetchDrinkInfo(for: record["drink"] as! [CKRecord.Reference]) { drinks in
            self.drinks = drinks
          }
     //   }

    }
}


class DrinkInfo {
    let id: String
    let time: Date
    let amount: Int64
    let dayDrinkInfoReference: CKRecord.Reference?

    
    init?(record: CKRecord) {
        guard
            let id = record["id"] as? String,
            let time = record["time"] as? Date,
            let amount = record["amount"] as? Int64
        else {return nil}
        self.id = id
        self.time = time
        self.amount = amount
        self.dayDrinkInfoReference = record["date"] as? CKRecord.Reference


    }
    
    static func fetchDrinkInfo(for references: [CKRecord.Reference], _ completion: @escaping ([DrinkInfo]) -> Void) {
        
        let db = CKContainer(identifier:"iCloud.com.kaltura.mediaWaApp").publicCloudDatabase

        print("---> fetchDrinkInfo")
        print("====> references = \(references)")

        let recordIDs : [CKRecord.ID] = references.map { $0.recordID }
        print("====> recordIDs = \(recordIDs)")

      let operation = CKFetchRecordsOperation()
        operation.recordIDs = recordIDs
      operation.qualityOfService = .utility
    //    operation.database =   CKContainer(identifier:"iCloud.com.kaltura.mediaWaApp").publicCloudDatabase

      //operation.fetchRecordsCompletionBlock = { records, error in
        
        //var fetchRecordsResultBlock: ((_ operationResult: Result<Void, Error>) -> Void)? { get set }
        operation.fetchRecordsResultBlock =  { result in
            
            print("====> fetchRecordsResultBlock")
            dump(result)
            // success if no transaction error
            switch result {
            case .success( let records):
                if  records != nil { // record exists and no errors
                                    print("")
//                                    let drinksInfo = records.values.map(DrinkInfo.init) ?? []
                    
                                  print("---> drinksInfo")
                                  dump(records)
//
                } else { // record does not exist
                    print("record does not exist")

                }
           
            case .failure(let error): // either transaction or partial failure occurred
                print(error)
            }
        }
        
        db.add(operation)
//        operation.start()

//            switch result{
//
//            case records:
//                print("")
//                let drinksInfo = records.a
//                    //.map(DrinkInfo.init) ?? []
//
//              print("---> drinksInfo")
//              dump(drinksInfo)
//
//              var newPlaces = [DrinkInfo]()
//
//
//              for value in drinksInfo{
//                  if let value = value{
//                      newPlaces.append(value)
//                  }
//              }
//
//            DispatchQueue.main.async {
//
//                    completion(newPlaces)
//
//            }
//
//            case error:
//                print(error)
//            }
            
//      }
      
    }


}
