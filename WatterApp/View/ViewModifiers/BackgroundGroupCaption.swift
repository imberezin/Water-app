//
//  BackgroundGroupCaption.swift
//  WatterApp
//
//  Created by IsraelBerezin on 05/12/2022.
//

import Foundation
import SwiftUI


struct BackgroundGroupCaption: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.leading, 5)
            .background(Color("azureColor"))
            .cornerRadius(5)
        
    }
}


