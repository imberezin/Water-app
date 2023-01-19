//
//  Photo.swift
//  WatterApp
//
//  Created by IsraelBerezin on 26/12/2022.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#endif
struct AwardItem: Identifiable, Equatable{
    static func == (lhs: AwardItem, rhs: AwardItem) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String = UUID().uuidString
    let imageName: String
    let awardName: String
    var active: Bool = false
    let photo :Photo
    let daysNumber: Int
    
    init(imageName: String, awardName: String, active: Bool = false,daysNumber:Int) {
        self.imageName = imageName
        self.awardName = awardName
        self.active = active
        self.daysNumber = daysNumber
//        let oldImage = UIImage(named: imageName)
#if os(iOS)
        let newImage = UIImage(named: imageName)!.maskWithColor(color: .red)
        self.photo = Photo(image: Image(uiImage: newImage!), caption: awardName, description: "I am happy to share that I won the \(awardName) medal")
#else
        self.photo = Photo(image: Image(imageName), caption: awardName, description: "I am happy to share that I won the \(awardName) medal")
#endif
    }
}




//https://stackoverflow.com/a/48276943/1571228


struct Photo: Identifiable {
    var id = UUID()
    var image: Image
    var caption: String
    var description: String
}


extension Photo: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
}
