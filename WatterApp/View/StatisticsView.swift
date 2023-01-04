//
//  ContentViewA.swift
//  WatterApp
//
//  Created by IsraelBerezin on 01/12/2022.
//

import SwiftUI


    /*
     
     */
struct StatisticsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],predicate: NSPredicate(format : "date < %@ AND  date > %@", Date().endOfWeek() as CVarArg, Date().startOfWeek() as CVarArg))
    private var items: FetchedResults<Day>
        


    var body: some View {
        
        NavigationView {
            let startWeek = Date().startOfWeek()
            let endWeek = Date().endOfWeek()
            let array = covertToArray()

            ZStack (alignment: .top){
                WaveBGHeaderView(){
                    TitleHeaderView(title: "Week: \(startWeek.getGregorianDate(dateFormat: "d.MM")) - \(endWeek.getGregorianDate(dateFormat: "d.MM"))")
                }
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    
                    Spacer(minLength: 60)
                    
                    if array.count > 0 {
                        ChartsView(days: array)
                            .padding(8)
                        
                        List {
                            ForEach(items) { item in
                                NavigationLink {
                                    StatisticsDetailsView(item: item)
                                } label: {
                                    Text(item.date!, formatter: itemFormatter)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .scrollContentBackground(.hidden)
                        .toolbar {
    #if os(iOS)
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
    #endif
                        }
                        .padding(-8)
                    }
                }
            }
            Text("Select an item")
        }
    }
    
    
    
    private func addItem() {
        withAnimation {
            let newItem = Day(context: viewContext)
            newItem.date = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    func covertToArray()->[DayItem]{
        var arr = [DayItem]()
        for item in self.items{
            let newItem = DayItem(date: item.date!, drink: item.drink!)
            arr.append(newItem)
        }
        
        return arr
    }

    
}

struct ContentViewA_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



