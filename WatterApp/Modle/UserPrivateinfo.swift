//
//  UserPrivateinfo.swift
//  WatterApp
//
//  Created by IsraelBerezin on 08/12/2022.
//

import Foundation


struct UserPrivateinfo: Codable, Identifiable{
    
    var id: String = UUID().uuidString
    var fullName: String
    var height: Int
    var weight: Int
    var age: Int
    var customTotal: Int
    var gender: String
    var slectedRimniderHour: Int
    var enabledReminde: Bool
    
    
    //    init(){
    //        self.fullName = ""
    //        self.height = 0
    //        self.weight = 0
    //        self.customTotal = 300
    //        self.gender = Gander.male.rawValue
    //        self.slectedRimniderHour = 3
    //        self.enabledReminde = false
    //        self.age = 40
    //    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName
        case height
        case weight
        case age
        case customTotal
        case gender
        case slectedRimniderHour
        case enabledReminde
        
    }
    
    
}


extension UserPrivateinfo: RawRepresentable {
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        fullName = try values.decode(String.self, forKey: .fullName)
        height = try values.decode(Int.self, forKey: .height)
        weight = try values.decode(Int.self, forKey: .weight)
        age = try values.decode(Int.self, forKey: .age)
        customTotal = try values.decode(Int.self, forKey: .customTotal)
        gender = try values.decode(String.self, forKey: .gender)
        slectedRimniderHour = try values.decode(Int.self, forKey: .slectedRimniderHour)
        enabledReminde = try values.decode(Bool.self, forKey: .enabledReminde)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(height, forKey: .height)
        try container.encode(weight, forKey: .weight)
        try container.encode(age, forKey: .age)
        try container.encode(customTotal, forKey: .customTotal)
        
        try container.encode(gender, forKey: .gender)
        try container.encode(slectedRimniderHour, forKey: .slectedRimniderHour)
        try container.encode(enabledReminde, forKey: .enabledReminde)
        
    }
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(UserPrivateinfo.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    
    public var rawValue: String {
        guard let data = try? newJSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
        
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
    
}


extension UserPrivateinfo: Equatable{
    static func == (lhs: UserPrivateinfo, rhs: UserPrivateinfo) -> Bool {
        return  (
                (lhs.fullName == rhs.fullName) &&
                (lhs.height == rhs.height) &&
                (lhs.weight == rhs.weight) &&
                (lhs.age == rhs.age) &&
                (lhs.customTotal == rhs.customTotal) &&
                (lhs.gender == rhs.gender) &&
                (lhs.slectedRimniderHour == rhs.slectedRimniderHour) &&
                (lhs.enabledReminde == rhs.enabledReminde)
        )
    }

}

/*
 case fullName
 case height
 case weight
 case age
 case customTotal
 case gender
 case slectedRimniderHour
 case enabledReminde
 */
