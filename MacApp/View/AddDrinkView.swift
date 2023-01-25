//
//  AddDrinkView.swift
//  MacApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import SwiftUI

struct AddDrinkView: View {

    @Environment(\.scenePhase) var scenePhase

    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var waterTypesListManager: WaterTypesListManager
    @EnvironmentObject var notificationCenterManager: NotificationCenterManager

    @StateObject var homeVM: HomeVM
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],predicate: NSPredicate(format : "date < %@ AND  date > %@", Date().endOfDay as CVarArg, Date().startOfDay as CVarArg))
    private var daysItems: FetchedResults<Day>

    var body: some View {
        
        let array =  daysItems.last?.drink  != nil ? Array(daysItems.last?.drink as! Set<Drink>) : [Drink(context: viewContext)]
          let   waterAmountNumber = Int(array.sum(for: \.amount))
//        let _ = print("arrayCount = \(daysItems.count)")
//        let _ = print("date = \(daysItems.last?.date)")

        VStack{
            
            Spacer()
            
            ContinueRing(cureentNumber: waterAmountNumber, total: Float(homeVM.userPrivateinfoSaved?.customTotal ?? 1000), ringFrame: CGSize(width: 350.0, height: 350.0))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            Spacer()

            FooterView()
        }

        .onAppear{
            self.waterTypesListManager.loadPropertyList()
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                print("Home - active")
                if let actionIdentifier = self.notificationCenterManager.actionIdentifier{
                    self.userAddWaterByNotifcationAction(actionIdentifier: actionIdentifier)
                }
            case .background:
                print("Home - background")
                
                // 3
            default:
                break
            }
        }
    }
    
    @ViewBuilder
    func FooterView() -> some View{
        HStack {
            GeometryReader { geometry in
                
                ScrollView(.horizontal) {
                    HStack(spacing: 36.0){
                        ForEach(  waterTypesListManager.drinkTypesList.indices, id: \.self) { index in
                            
                            AddWaterButton(waterType: waterTypesListManager.drinkTypesList[index], imageFrame: CGSize(width: 50, height: 50), viewFrame: CGSize(width: 100, height: 100)){ number in
                                self.homeVM.addWaterToCureentDay(waterType: waterTypesListManager.drinkTypesList[index], daysItems: self.daysItems)
                            }
                            
                        }
                        
                    }
                   // .background(.red)
                    
// .frame(width: geometry.size.width)      // Make the scroll view full-width
// .frame(minHeight: geometry.size.height) // Set the content’s min height to the parent

                    .frame(height: geometry.size.height)
                    .frame(minWidth: geometry.size.width)
                }

            }
            .frame(height: 120)
           // .background(.green)

        }
      //  .offset(y:-20)

    }
    
    func userAddWaterByNotifcationAction( actionIdentifier: String){
        if let drink: DrinkType = waterTypesListManager.drinkTypesList.first(where: {$0.id == actionIdentifier}){
            print("=========")
            print ("\(drink.id)")
            print ("\(drink.name)")
            print("=========")
            DispatchQueue.main.asyncAfter(deadline:  .now() + 0.3){
                self.homeVM.addWaterToCureentDay(waterType: drink, daysItems: self.daysItems)
                self.notificationCenterManager.actionIdentifier = nil
            }
        }
    }

}

struct AddDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WaterTypesListManager())
            .environmentObject(NotificationCenterManager())


    }
}
