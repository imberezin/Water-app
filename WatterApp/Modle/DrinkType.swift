//
//  DrinkType.swift
//  WatterApp
//
//  Created by IsraelBerezin on 02/01/2023.
//

import Foundation

struct DrinkType : Codable,Identifiable{
    
    let id : String
    var name : String
    var amount : Int
    var calories : Int
    var orederNumber : Int
    var imageName : String
    
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
        calories = try values.decodeIfPresent(Int.self, forKey: .calories)!
        orederNumber = try values.decodeIfPresent(Int.self, forKey: .orederNumber)!
        imageName = try values.decodeIfPresent(String.self, forKey: .imageMame)!
    }
    
    
    init(name:String, amount: Int, imageMame : String ) {
        self.id = UUID().uuidString
        self.name = name
        self.amount = amount
        self.calories = 0
        self.orederNumber = 100
        self.imageName = imageMame
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
        try container.encode(calories, forKey: .calories)
        try container.encode(orederNumber, forKey: .orederNumber)
        try container.encode(imageName, forKey: .imageMame)
        
    }
    
}
