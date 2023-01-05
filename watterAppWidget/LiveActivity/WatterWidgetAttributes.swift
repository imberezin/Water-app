//
//  WatterWidgetAttributes.swift
//  watterAppWidgetExtension
//
//  Created by IsraelBerezin on 04/01/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI


//Dynamic Island
struct WatterWidgetAttributes: ActivityAttributes {
    
    public typealias WatterAttributesStatus = ContentState

    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
        var driverName: String
        var deliveryTimer: ClosedRange<Date>

    }

    // Fixed non-changing properties about your activity go here!
    var name: String
    var totalAmount: String

}


/*
 public typealias PizzaDeliveryStatus = ContentState

     public struct ContentState: Codable, Hashable {
         var driverName: String
         var deliveryTimer: ClosedRange<Date>
     }

     var numberOfPizzas: Int
     var totalAmount: String
     var orderNumber: String

 */
