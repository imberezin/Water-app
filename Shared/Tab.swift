//
//  Tab.swift
//  WatterApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import Foundation
import SwiftUI


enum Tab: String, CaseIterable{
    
    case home = "mug"
#if os(iOS)
    case scan = "figure.walk"
#endif
    case folder = "list.bullet.clipboard"
    case cart = "gearshape"
    
    
    var title: String {
        switch self {
            case .home:    return "Home"

            case .folder:   return "Statistics"
            case .cart:      return "Settings"
#if os(iOS)
            case .scan: return "Run"
#endif
        }
    }
}

