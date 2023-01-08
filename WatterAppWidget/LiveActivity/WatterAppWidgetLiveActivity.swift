//
//  watterAppWidgetLiveActivity.swift
//  watterAppWidget
//
//  Created by IsraelBerezin on 28/12/2022.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct WatterAppWidgetLiveActivity: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WatterWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here

            WatterLockScreenLiveActivityView(context: context)
            .padding(.all)
            
            .activityBackgroundTint(Color("azureColor"))
            .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Text(context.attributes.waterType.name)
                        Text("\(context.attributes.amountUntilNow)")
                        Text("\(context.attributes.totalAmount)")
                    }
                    // more content
                }
            } compactLeading: {
                Image(systemName: "drop.fill")
                    .imageScale(.medium)
//                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue)
                    .transition(.move(edge: .trailing))
            } compactTrailing: {
                Image(systemName: "drop.fill")
                    .imageScale(.medium)
//                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue)
                    .transition(.move(edge: .leading))

            } minimal: {
                Text("Min")
                    .foregroundColor(.yellow)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
