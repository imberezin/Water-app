//
//  WatterAppWidgetEntryView.swift
//  watterAppWidgetExtension
//
//  Created by IsraelBerezin on 28/12/2022.
//

import WidgetKit
import SwiftUI
import CoreData
import OSLog

struct WatterAppWidgetView: View {
    var entry : WaterEntry
    
    let gradient: Gradient = Gradient(colors: bgWaweColors)
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
                
        switch widgetFamily{
        case .systemMedium :
            WatterAppWidgetMediumView(entry: entry)
        default:
            WatterAppWidgetSmallView(entry: entry)
        }
    }
    
}

struct watterAppWidget_Previews: PreviewProvider {
    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?

    static var previews: some View {
        WatterAppWidgetView(entry: WaterEntry( date: Date(), configuration: ConfigurationIntent(), displaySize: CGSize(width: 329, height: 155), customTotal: defaultCustomTotal, todayTotal: 1000))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

