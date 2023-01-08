//
//  watterAppWidgetBundle.swift
//  watterAppWidget
//
//  Created by IsraelBerezin on 28/12/2022.
//

import WidgetKit
import SwiftUI

@main
struct WatterAppWidgetBundle: WidgetBundle {
    
    
    var body: some Widget {
        WatterAppWidget()
        WatterAppWidgetLiveActivity()
    }
}
