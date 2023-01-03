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



struct HStackDropDown: View{

    var title: String
    let systemName: String
    var data: [String]
    
    @Binding var selected: String
    
    let proxy: GeometryProxy

    var body: some View {
        HStack(alignment: .center, spacing: 8.0) {
            
           
            Image(systemName: systemName)
            
            Text(title)
        
            Spacer()

   
            Picker("Pick a language", selection: $selected) { // 3
                ForEach(data, id: \.self) { item in // 4
                    Text(item)
                }
            }.pickerStyle(.menu)
                .frame(width: proxy.size.width*0.4, alignment: .trailing)
                .backgroundCaption()
                .cornerRadius(5)
        }
       
    }


}
