//
//  CustomNumberFiled.swift
//  WatterApp
//
//  Created by IsraelBerezin on 05/12/2022.
//

import Foundation
import SwiftUI


struct CustomTextTapView: View {
    
    let title:String
    let systemName: String
    let subTitleLeading: String
    let subTitleTrailing: String // Hours
//    let reminder: Int
    let onTab: ()->()
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            
            HStack {
                Image(systemName: systemName) // bell
                Text(title) //"Reminder"
                Spacer()
            }
            HStack{
                Text(subTitleLeading) //"Current setting"
                Spacer()
                Text(subTitleTrailing)
                    .padding(.trailing, 8)
                
            }
            .backgroundCaption()
        }.containerShape(Rectangle())
            .onTapGesture {
                onTab()
                //self.showReminder.toggle()
            }
    }
}
