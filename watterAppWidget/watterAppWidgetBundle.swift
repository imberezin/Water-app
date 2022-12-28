//
//  watterAppWidgetBundle.swift
//  watterAppWidget
//
//  Created by IsraelBerezin on 28/12/2022.
//

import WidgetKit
import SwiftUI

@main
struct watterAppWidgetBundle: WidgetBundle {
    
    
    var body: some Widget {
        watterAppWidget()
        watterAppWidgetLiveActivity()
    }
}
