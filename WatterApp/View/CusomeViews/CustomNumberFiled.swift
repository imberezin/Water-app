//
//  CustomNumberFiled.swift
//  WatterApp
//
//  Created by IsraelBerezin on 05/12/2022.
//

import Foundation
import SwiftUI

struct CustomNumberFiled: View{
    
    
    let title:String
    let systemName: String
    let keyboardType: UIKeyboardType
    let checkoutFocusableId: CheckoutFocusable
    @Binding var value: Int
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Image(systemName: systemName)
                Text(title)
            }
            TextField(title, value: $value, formatter: NumberFormatter())
                .backgroundCaption()
                .keyboardType(keyboardType)
                .id(checkoutFocusableId.rawValue)
        }
        .padding(.vertical,8)
    }
}


struct CustomHStackNumberFiled: View{
    
    
    let title:String
    let systemName: String
    let keyboardType: UIKeyboardType
    let checkoutFocusableId: CheckoutFocusable?
    @Binding var value: Int
    
    var body: some View {
        
        
        HStack {
            Image(systemName: systemName)
            Text(title)
            Spacer()
            TextField(title, value: $value, formatter: NumberFormatter())
                .backgroundCaption()
                .keyboardType(keyboardType)
                .id(checkoutFocusableId?.rawValue)
                .frame(width: 50)
        }
        .padding(.vertical,8)
    }
}

