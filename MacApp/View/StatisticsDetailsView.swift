//
//  StatisticsDetailsView.swift
//  MacApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import SwiftUI
import WidgetKit

struct StatisticsDetailsView: View {
    
    @State var item: Day
    @State var UpdateUI: Bool = false
    
    @StateObject var pieDateVM = PieDateVM()
    
    let colors1 = [Color.blue.opacity(0.30),Color.blue.opacity(0.50),Color.blue.opacity(0.70)]
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])

    
    var body: some View {
        let array = Array(item.drink! as Set as! Set<Drink>).sorted(by:{
            $0.time!.compare($1.time!) == .orderedDescending})
        let totalScore = array.sum(for: \.amount)
        
        let newArray: [DrinkItem] = array.map({.init(name: $0.name ?? "", amount: $0.amount, time:  $0.time ?? Date())})
        
        GeometryReader { geometry in
            
            //           let _ = print(geometry.size)
            
            VStack {
                
                TitleHeaderView(title: "\(item.date?.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .complete, time: .omitted))")
                
                ZStack(alignment: .top) {
                    
                    VStack(alignment: .center, spacing: 16){
                        
                        Pie(pieDateVM: pieDateVM)
                            .frame(width: 500,height: 400)
                            .padding(.horizontal)
                            .onAppear{
                                withAnimation(.linear(duration: 0.7)){
                                    self.pieDateVM.update(dayInfo: DayItem(date: item.date ?? Date(), drink: item.drink))
                                }
                            }
                            .padding(.top,36)
                        
                        
                        Table(newArray) {
//                            TableColumn("Name", value: \.name){ water in
//                                Text(String(water.name))
//                                    .font(.headline)
//                            }
                            TableColumn("") { water in
                                HStack{
                                    Text(String(water.name))
                                        .font(.subheadline)
                                    Spacer()

                                    Text(String(water.amount))
                                        .font(.subheadline)
                                    Spacer()
                                    Button(action: {}){
                                        Text("Remove")
                                            .padding(6)
                                            .background(.red)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .padding(6)
                                    }
                                }
                                    .frame( height: 36, alignment: .leading)
                            }
                            
                        }.tableStyle(.bordered)
                            .scrollDisabled(true)
                            .scrollIndicators(.visible)

//                        List{
//                            ForEach(array, id: \.self) { drink in
//                                DrinkListRow(drink: drink)
//                            }
//                               .onDelete { onDelete(indexSet: $0) }
//
//                        }
                        

                        .padding(.horizontal, 48)
          
                        .scrollContentBackground(.hidden)
                        .zIndex(0)
                        
                        Text("Your total drink is **\(totalScore)**")
                            .padding(.bottom)
                        
                    }
                }
            }
        }
        
    }
    
    
    @ViewBuilder
    func DrinkListRow(drink: Drink) -> some View{
        HStack{
            VStack(alignment: .leading){
                Text("\(drink.name?.capitalizedSentence ?? "") ")
                Text("\(drink.time ?? Date(), formatter: timeFormatter)")
                    .font(.caption)
                    .fontWeight(.light)
            }
            Spacer()
            Text("\(drink.amount)")
        }
    }
    
    func onDelete(indexSet : IndexSet){
        
        let array = Array(item.drink! as Set as! Set<Drink>).sorted(by:{
            $0.time!.compare($1.time!) == .orderedDescending})

        let drinkInArray = array[indexSet.first!]
        print("drinkInArray.id = \(drinkInArray.id?.uuidString ?? "")")
        
        let coreDrink = item.drink
        
        let drink: Drink = coreDrink?.first(where: { ($0 as! Drink).id == drinkInArray.id }) as! Drink
        
        print("drink.id = \(drink.id?.uuidString ?? "")")
        DispatchQueue.main.async {
            
            let updateedItem = PersistenceController.shared.reomveDrinkFromDay(day: self.item, drink: drink)!
            self.item = updateedItem
            withAnimation(.linear(duration: 0.7)){
                self.pieDateVM.update(dayInfo: DayItem(date: updateedItem.date ?? Date(), drink: updateedItem.drink))
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                WidgetCenter.shared.reloadAllTimelines()

            }

//            self.UpdateUI.toggle()

        }
    }
    
    
      private let itemFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateStyle = .long
          formatter.timeStyle = .none
          return formatter
      }()
      
      private let timeFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateStyle = .none
          formatter.timeStyle = .short
          return formatter
      }()
}

struct StatisticsDetailsView_Previews: PreviewProvider {

    static var previews: some View {
        let day = PersistenceController.shared.getOneDay()
        StatisticsDetailsView(item: day)
            .frame(width: 1000,  height: 800,  alignment: .leading)

            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WaterTypesListManager())

    }
}
