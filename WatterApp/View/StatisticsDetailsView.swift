//
//  StatisticsDetailsView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/12/2022.
//

import SwiftUI

struct StatisticsDetailsView: View {
    
    //@AppStorage("userPrivateinfo") var userPrivateinfoSaved: UserPrivateinfo? //= UserPrivateinfo(fullName: "", height: 0, weight: 0, age: 0, customTotal: 3000, gender: Gander.male.rawValue, slectedRimniderHour: 3, enabledReminde: false, awardsWins: [Bool]())
    @AppStorage("userPrivateinfo", store: UserDefaults(suiteName: "group.com.kaltura.waterapp")) var userPrivateinfoSaved: UserPrivateinfo?

    @State var item: Day
    @State var UpdateUI: Bool = false
    
    @StateObject var pieDateVM = PieDateVM()
    
    let colors1 = [Color.blue.opacity(0.30),Color.blue.opacity(0.50),Color.blue.opacity(0.70)]
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])

    
    var body: some View {
        
        let array = Array(item.drink! as Set as! Set<Drink>).sorted(by:{
            $0.time!.compare($1.time!) == .orderedDescending})
        let totalScore = array.sum(for: \.amount)

        GeometryReader { geometry in

//           let _ = print(geometry.size)
            
            VStack(alignment: .center, spacing: 16){
                
                Pie(pieDateVM: pieDateVM)
                    .frame(width: 350,height: 300)
                   .padding(.horizontal)
                   .onAppear{
                       withAnimation(.linear(duration: 0.7)){
                           self.pieDateVM.update(dayInfo: DayItem(date: item.date ?? Date(), drink: item.drink))
                       }
                   }
                
                List{
                        ForEach(array, id: \.self) { drink in
                            DrinkListRow(drink: drink)
                        }
                        .onDelete { onDelete(indexSet: $0) }

                    }
                    .padding(.leading, -8)
                    .padding(.trailing,8)
                    .scrollContentBackground(.hidden)
                    .zIndex(0)

                Text("Your total drink is **\(totalScore)**")
                    .padding(.bottom)

            }
        }
        
        .navigationTitle("\(item.date ?? Date(), formatter: itemFormatter)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }

    }
    
    @ViewBuilder
    func DrinkListRow(drink: Drink) -> some View{
        HStack{
            VStack(alignment: .leading){
                Text("\(drink.name ?? "") ")
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
        NavigationView{
            StatisticsDetailsView(item: day)
                .navigationBarTitleDisplayMode(.inline)
        }
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
    
}



//            Gauge(value: progress,in: 0...1,
//                  label:{ },
//                  currentValueLabel:{
//                      Text(progress.round(to: 2).formatted(.percent))
//                          .font(.subheadline)
//                          .fontWeight(.medium)
//                          .foregroundColor(.blue)
//
//            })
//            .gaugeStyle(.accessoryCircularCapacity)
//            .tint(gradient)
//            .scaleEffect(2)
//           // .animation(.linear(duration: 0.3), value: progress)
//            .zIndex(1)
/*
 @State var progress: Double = 0.0 //Double(totalScore)/3000.0
 //        let gradient = Gradient(colors: [.blue, .green, .pink])

 .onAppear{
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
         withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 1.8)){
             progress = Int(Double(totalScore))/customTotal > 1 ? 1 : Double(totalScore)/Double(customTotal)
             print(progress)
         }
     }

 }
*/
