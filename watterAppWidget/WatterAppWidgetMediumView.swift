//
//  WatterAppWidgetMediumView.swift
//  watterAppWidgetExtension
//
//  Created by IsraelBerezin on 29/12/2022.
//

import SwiftUI
import WidgetKit
//import Intents
//import CoreData
import OSLog

struct WatterAppWidgetMediumView: View {
    var entry : WaterEntry
    
    let gradient: Gradient = Gradient(colors: bgWaweColors)
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        
        VStack{
            HeaderView()
            Spacer()
            FotterView()
        }
        .background(
            WaveShape()
                .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .frame(width: entry.displaySize.width, height: entry.displaySize.height/3)
            ,alignment: .bottom )
    }
    
    @ViewBuilder
    func HeaderView()->some View{
        let progressValue:Double = Double(entry.todayTotal) / Double(entry.customTotal)
        
        HStack(alignment: .top){
            Text("You drink **\(entry.todayTotal)ml** a total of \(entry.customTotal)ml today")
                .lineSpacing(10)
            
            Spacer()
            
            Gauge(value: progressValue,in: 0...1,
                  label:{ },
                  currentValueLabel:{
                Text(progressValue.round(to: 2).formatted(.percent))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
            })
            .gaugeStyle(SpeedometerGaugeStyle(frame: CGSize(width: 50, height: 50)))
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    func FotterView()-> some View{
        HStack {
            HStack(spacing: 16.0){
                ForEach( entry.drinkTypesList.indices, id: \.self) { index in
                    Link(destination: URL(string: "watterBerezinApp://actionIdentifier/\(entry.drinkTypesList[index].id)")!){
                        AddWaterWidgetButton(waterType: entry.drinkTypesList[index])
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
            .padding(.bottom,8)
        }
    }
    
    @ViewBuilder
    func AddWaterWidgetButton(waterType: DrinkType) -> some View{
        VStack{
            Image(waterType.imageMame)
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.bottom,-4)
            Text("\(waterType.amount)")
                .font(.system(size: 14))
            
        }
        .padding(8)
        .foregroundColor(.white)
        .frame(width: 50, height: 50)
        .background(Color("azureColor").opacity(0.9))
        .overlay(
            Circle()
                .stroke(Color.blue, lineWidth: 3)
        )
        .clipShape(Circle())
    }
}

struct WatterAppWidgetMediumView_Previews: PreviewProvider {
    static var previews: some View {
        WatterAppWidgetMediumView(entry: WaterEntry( date: Date(), configuration: ConfigurationIntent(), displaySize: CGSize(width: 329, height: 155), customTotal: defaultCustomTotal, todayTotal: 1000))
    }
}
