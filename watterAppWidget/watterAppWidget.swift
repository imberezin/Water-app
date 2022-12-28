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


struct Provider: IntentTimelineProvider {
    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?


    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(userPrivateinfoSaved: userPrivateinfoSaved, date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(userPrivateinfoSaved: userPrivateinfoSaved, date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 30 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(userPrivateinfoSaved: userPrivateinfoSaved, date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
     var userPrivateinfoSaved: UserPrivateinfo?

    let date: Date
    let configuration: ConfigurationIntent
    
    init(userPrivateinfoSaved: UserPrivateinfo?, date: Date, configuration: ConfigurationIntent) {
        self.userPrivateinfoSaved = userPrivateinfoSaved
        self.date = date
        self.configuration = configuration
    }
}

struct watterAppWidgetEntryView : View {
    var entry: Provider.Entry

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],predicate: NSPredicate(format : "date < %@ AND  date > %@", Date().daysAfter(number: 1) as CVarArg, Date().daysBefore(number: 1) as CVarArg))
    private var daysItems: FetchedResults<Day>

    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?

    var body: some View {
        VStack {
            let _ = print(entry.userPrivateinfoSaved as Any)
            Text(entry.date, style: .time)
            Text(userPrivateinfoSaved?.fullName ?? "Test test")
            Text("\(userPrivateinfoSaved?.customTotal ?? 200)")

            Text("\(daysItems.count)")
        }
        
    }
}

struct watterAppWidget: Widget {
    let kind: String = "watterAppWidget"

    //based https://www.youtube.com/watch?v=q0t_NUpLMWo
    let persistenceController = PersistenceController.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            watterAppWidgetEntryView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
        .configurationDisplayName("Watter App")
        .description("Watter Reminder App - help you to remmber to drink water during the day.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])

    }
}

struct watterAppWidget_Previews: PreviewProvider {
    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?

    static var previews: some View {
        watterAppWidgetEntryView(entry: SimpleEntry(userPrivateinfoSaved: UserPrivateinfo(fullName: "Israel Berezin", height: 178, weight: 104, age: 42, customTotal: 3000, gender: Gander.male.rawValue, slectedRimniderHour: 3, enabledReminde: true, awardsWins: [Bool]()), date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
