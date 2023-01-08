//
//  watterAppWidget.swift
//  watterAppWidget
//
//  Created by IsraelBerezin on 28/12/2022.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData


struct WatterAppWidget: Widget {
    let kind: String = "watterAppWidget"

    //based https://www.youtube.com/watch?v=q0t_NUpLMWo
    let persistenceController = PersistenceController.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WatterAppWidgetView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .configurationDisplayName("Watter App")
        .description("Watter Reminder App - help you to remmber to drink water during the day.")
        .supportedFamilies([.systemSmall, .systemMedium])

    }
}
