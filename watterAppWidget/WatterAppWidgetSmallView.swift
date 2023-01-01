//
//  WatterAppWidgetSmallView.swift
//  watterAppWidgetExtension
//
//  Created by IsraelBerezin on 29/12/2022.
//

import SwiftUI

struct WatterAppWidgetSmallView: View {
    var entry : WaterEntry
    let colors1 = [Color.blue.opacity(0.25),Color.blue.opacity(1.0)]
    
    var body: some View {
        
        let progressValue:Double = Double(entry.todayTotal) / Double(entry.customTotal)
        
        VStack{
            Gauge(value: progressValue,in: 0...1,
                  label:{ },
                  currentValueLabel:{
                
                        VStack(spacing: 10.0) {
                            Image(systemName: "drop.fill")
                                .imageScale(.large)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.blue)
                            
                            Text(progressValue.round(to: 2).formatted(.percent))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
            })
            .gaugeStyle(SpeedometerGaugeStyle(frame: CGSize(width: 90, height: 90)))
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(
            VStack{
                WaveShape()
                    .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: -1, z: 0))
                    .frame(width: entry.displaySize.width, height: entry.displaySize.height/8)
                Spacer(minLength: 50)
                WaveShape()
                    .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
                    .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                    .frame(width: entry.displaySize.width, height: entry.displaySize.height/8)
            })
    }
}

struct WatterAppWidgetSmallView_Previews: PreviewProvider {
    static var previews: some View {
        WatterAppWidgetSmallView(entry: WaterEntry( date: Date(), configuration: ConfigurationIntent(), displaySize: CGSize(width: 329, height: 155), customTotal: defaultCustomTotal, todayTotal: 1000))
    }
}


