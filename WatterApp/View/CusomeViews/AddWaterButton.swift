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
    let imageFrame: CGSize
    let viewFrame:  CGSize

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
                    .frame(width: imageFrame.width, height: imageFrame.height)
                if waterType.amount > 0{
                    Text("\(waterType.amount)")
                        .font(.system(size: 14))
                }
                
            }
            .padding(8)
            .foregroundColor(.white)
        }
        .frame(width: viewFrame.width, height: viewFrame.height)
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
