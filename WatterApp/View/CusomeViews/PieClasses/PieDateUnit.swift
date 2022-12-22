//
//  PieDateUnit.swift
//  WatterApp
//
//  Created by IsraelBerezin on 08/12/2022.
//

import Foundation
import SwiftUI

class PieDateUnit : Identifiable{
    let id: String = UUID().uuidString
    let name: String
    let amount: Double
    
    var degrees: Double = 0.0
    var start: Double = 0.0
    var end: Double = 360.0
    var color: Color = Color.blue
    var percent: Double = 0
    
    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
    
    
    init(name: String, amount: Double, percent: Double,degrees: Double, start: Double, end: Double, color: Color){
        self.name = name
        self.amount = amount
        self.start = start
        self.end = end
        self.color = color
        self.degrees = degrees
        self.percent = percent
    }
    
    func update(percent: Double,degrees: Double, start: Double, end: Double, color: Color){
        self.start = start
        self.end = end
        self.color = color
        self.degrees = degrees
        self.percent = percent
    }
}
