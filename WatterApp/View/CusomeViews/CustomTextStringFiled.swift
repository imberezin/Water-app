//
//  CustomNumberFiled.swift
//  WatterApp
//
//  Created by IsraelBerezin on 05/12/2022.
//

import Foundation
import SwiftUI

struct CustomTextStringFiled: View{
    
    
    let title:String
    let systemName: String
    let keyboardType: UIKeyboardType
    @Binding var value: String
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Image(systemName: systemName)
                Text(title)
            }
            TextField(title, text: $value)
                .backgroundCaption()
                .keyboardType(keyboardType)
                .id(CheckoutFocusable.fullNameType.rawValue)
        }
        .padding(.vertical,8)
    }
}
