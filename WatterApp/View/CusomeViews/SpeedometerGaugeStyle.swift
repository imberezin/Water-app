//
//  SpeedometerGaugeStyle.swift
//  WatterApp
//
//  Created by IsraelBerezin on 29/12/2022.
//

import Foundation
import SwiftUI


struct SpeedometerGaugeStyle: GaugeStyle {
    //based: https://www.appcoda.com/swiftui-gauge/#:~:text=Creating%20a%20Custom%20Gauge%20Style
    let frame: CGSize
    
    init(frame: CGSize) {
        self.frame = frame
    }
    
    private var colorGradient = LinearGradient(gradient: Gradient(colors: [ Color.blue.opacity(0.5), Color.blue.opacity(1.0)]), startPoint: .trailing, endPoint: .leading)

    func makeBody(configuration: Configuration) -> some View {
        ZStack {

            Circle()
                .foregroundColor(Color(.systemGray6))

            Circle()
                .stroke(Color("azureColor"), lineWidth: 6)
                .rotationEffect(.degrees(270))

            Circle()
                .trim(from: 0, to: 1 * configuration.value)
                .stroke(colorGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270))
            
                configuration.currentValueLabel

        }
        .frame(width: frame.width, height: frame.height)

    }

}


/*
 case butt = 0

 case round = 1

 case square = 2

 */
