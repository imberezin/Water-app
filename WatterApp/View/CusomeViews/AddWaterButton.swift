//
//  AddWaterButton.swift
//  WatterApp
//
//  Created by IsraelBerezin on 05/12/2022.
//

import Foundation
import SwiftUI


struct AddWaterButton: View{
    
    var waterType: DrinkType
    var onClick: (DrinkType)->()
    
    @State private var angle = 0.0

    var body: some View{
        
        Button(action: {
//            showAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() ){
                angle += 360
                onClick(waterType)
            }
                
        }) {
            VStack{
                
                Image(waterType.imageName)
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("\(waterType.amount)")
                    .font(.system(size: 14))
                
            }
            .padding(8)
            .foregroundColor(.white)
        }
        .frame(width: 80, height: 80)
        .background(Color("azureColor").opacity(0.9))
        .overlay(
            Circle()
                .stroke(Color.blue, lineWidth: 3)
        )
        .clipShape(Circle())
        .rotationEffect(.degrees(angle))
        .animation(.easeIn(duration: 0.3), value: angle)
    }
    
}
