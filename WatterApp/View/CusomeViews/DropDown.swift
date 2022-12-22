//
//  DropDown.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/12/2022.
//

import Foundation
import SwiftUI


struct DropDown: View{

    var title: String
    let systemName: String
    var data: [String]
    @Binding var selected: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8.0) {
            HStack{
                Image(systemName: systemName)
                
                Text(title)
            }
            HStack {
                Picker("Pick a language", selection: $selected) { // 3
                        ForEach(data, id: \.self) { item in // 4
                            Text(item)
                              
                        }
                    }.pickerStyle(.menu)
                
                    .backgroundCaption()
                .cornerRadius(5)
            }
        }
    }

}
