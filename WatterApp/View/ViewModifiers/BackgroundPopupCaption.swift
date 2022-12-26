//
//  BackgroundPopupCaption.swift
//  WatterApp
//
//  Created by IsraelBerezin on 26/12/2022.
//

import Foundation
import SwiftUI


struct BackgroundPopupCaption: ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .frame(width: 350, height: 520)
            .background(Color("azureColor"))
            .cornerRadius(20).shadow(radius: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    
}
