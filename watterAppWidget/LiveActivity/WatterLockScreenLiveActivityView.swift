//
//  LockScreenLiveActivityView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 08/01/2023.
//

import SwiftUI
import WidgetKit


//based : https://betterprogramming.pub/building-live-activities-for-dynamic-island-in-swift-d76444cb48ab
//      : https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities
struct WatterLockScreenLiveActivityView: View {
    
    let context: ActivityViewContext<WatterWidgetAttributes>

    var body: some View {
        let progressValue:Double = Double(context.attributes.amountUntilNow) / Double(context.attributes.totalAmount)
        HStack(alignment: .center){
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
            .gaugeStyle(SpeedometerGaugeStyle(frame: CGSize(width: 70, height: 70)))
           
            Spacer(minLength: 10)
            
            VStack(alignment: .leading){
                Text("Congratulations!")
                    .font(.headline)
                Text("You have progressed up the road to the daily threshold!")
                    .font(.subheadline)
                
            }
            .foregroundColor(.blue)
            Spacer(minLength: 10)

        }
        
    }
}

//struct LockScreenLiveActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        LockScreenLiveActivityView()
//    }
//}
