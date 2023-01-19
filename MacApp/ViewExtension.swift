//
//  ViewExtension.swift
//  MacApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import Foundation
import SwiftUI

extension View{
    
    func getRect() -> CGRect{
        return NSScreen.main!.visibleFrame
    }
}
