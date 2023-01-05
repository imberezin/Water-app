//
//  watterAppWidgetLiveActivity.swift
//  watterAppWidget
//
//  Created by IsraelBerezin on 28/12/2022.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct watterAppWidgetLiveActivity: Widget {
    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WatterWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text(userPrivateinfoSaved?.fullName ?? "Test")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
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
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
