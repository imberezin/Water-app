//
//  Home.swift
//  WatterApp
//
//  Created by IsraelBerezin on 30/11/2022.
//

import SwiftUI




struct Home: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var waterTypesListManager: WaterTypesListManager
    @EnvironmentObject var notificationCenterManager: NotificationCenterManager
    
    
    @StateObject var homeVM = HomeVM()
    @StateObject var settingsVM = SettingsVM()
    
    @FocusState private var checkoutInFocus: CheckoutFocusable?
    
    @State var todayInfo: Day? = nil
//    @State var numberOfWoter: Int = 0
    @State var showReminderView: Bool = false
    @State var editWaterList: Bool = false
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],predicate: NSPredicate(format : "date < %@ AND  date > %@", Date().endOfDay as CVarArg, Date().startOfDay as CVarArg))
    private var daysItems: FetchedResults<Day>
    
    let gradientView: Gradient = Gradient(colors: bgWaweColors)
    
    var body: some View {
        
        
        let array =  daysItems.last?.drink  != nil ? Array(daysItems.last?.drink as! Set<Drink>) : [Drink(context: viewContext)]
          let   waterAmountNumber = Int(array.sum(for: \.amount))
        let _ = print("arrayCount = \(daysItems.count)")
        let _ = print("date = \(daysItems.last?.date)")

        let _ = print("waterAmountNumber = \(waterAmountNumber)")

        VStack(spacing: 0.0){
            
            WaveBGHeaderView(){
                HeaderView()
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            
            VStack{
                ContinueRing(cureentNumber: waterAmountNumber, total: Float(homeVM.userPrivateinfoSaved?.customTotal ?? 1000), ringFrame: CGSize(width: 250.0, height: 250.0))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                AddDrinkItemToList()
                
            }
            FooterView(gradient: gradientView)
            //.background(.red)
                .frame(maxWidth: .infinity, maxHeight: 110)
            
        }
        .popup(isPresented: $homeVM.isNeedsToShowAwardView) {
            AwardWinView(selectedAward: homeVM.slectedAwardItem, isDallyPrize: homeVM.showTodayQuota)
        }
        .popup(isPresented: $showReminderView) { // 3
            SettingsRemindeViewV2(settingsVM: settingsVM, showReminder: $showReminderView)
        }
        
        .ignoresSafeArea(.container, edges: .top)
        .onAppear{
            self.waterTypesListManager.loadPropertyList()
           // self.todayWaterInfo()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.homeVM.checkAndUpadteIfUserNeedToGetNewAwardMedal()
            }
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                print("Home - active")
                if let shortcutItem = self.notificationCenterManager.shortcutItem{
                    self.userAddWaterByShortcutItem(shortcutItem: shortcutItem)
                }
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
        .onOpenURL{ url in
            print(url)
            guard
                url.scheme == "watterBerezinApp",
                url.host == "actionIdentifier",
                let actionIdentifier = String(url.pathComponents[1]) as? String
            else{
                print("worng url")
                return
            }
            print("good url, actionIdentifier = \(actionIdentifier)")
            
            self.userAddWaterByNotifcationAction(actionIdentifier: actionIdentifier)
            
        }
    }
    
    /*
     Link(destination: URL(string: "watterBerezinApp://actionIdentifier/\(entry.drinkTypesList[index].id)")!){
     
     */
    @ViewBuilder
    func HeaderView()-> some View{
        
        VStack(alignment: .center, spacing: 10.0) {
            HStack{
                Text("Welcome **\(homeVM.userPrivateinfoSaved?.fullName ?? "")**")
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
                Button {
                    withAnimation{
                        self.showReminderView.toggle()
                    }
                } label: {
                    Image(systemName: "bell.badge")
                        .imageScale(.large)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .blue)
                        .rotationEffect(.degrees(self.showReminderView ? -15 : 30), anchor: .top)
                        .animation(.interpolatingSpring(mass: 0.5, stiffness: 150, damping: 2.5), value: self.showReminderView)
                }
            }
            .padding(.horizontal)
            Text(Date().getGregorianDate())
                .font(.subheadline)
            
        }
        .fontWeight(.semibold)
        .foregroundColor(Color.blue)
        
    }
    
    @ViewBuilder
    func FooterView(gradient: Gradient)-> some View{
        
        WaveBGHeaderView(axis: (x: 1, y: 0, z: 0)){
            HStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 16.0){
                        ForEach(  waterTypesListManager.drinkTypesList.indices, id: \.self) { index in
                            
                            AddWaterButton(waterType: waterTypesListManager.drinkTypesList[index], imageFrame: CGSize(width: 30, height: 30), viewFrame: CGSize(width: 80, height: 80)){ number in
//                                    self.numberOfWoter += number.amount
                                self.homeVM.addWaterToCureentDay(waterType: waterTypesListManager.drinkTypesList[index], daysItems: self.daysItems)
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
            }
            .offset(y:-20)
        }
    }
    
    @ViewBuilder
    func AddDrinkItemToList() -> some View{
        AddWaterButton(waterType: DrinkType(name: "Edit", amount: 0, imageMame: "plus1"),imageFrame: CGSize(width: 30, height: 30),viewFrame: CGSize(width: 50, height: 50)){ number in
            withAnimation{
                self.editWaterList.toggle()
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing,8)
        .padding(.bottom,-8)
        .fullScreenCover(isPresented: $editWaterList, onDismiss: {
            self.waterTypesListManager.saveListIfNeded(isNeded: self.waterTypesListManager.needToUpdateListWaterList)
        }, content: {
            WaterTypesListView(checkoutInFocus: $checkoutInFocus)
        })
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                CustomeToolbarItemGroupView(checkoutInFocus: $checkoutInFocus){ checkoutInFocus in
                    print("checkoutInFocus = \(checkoutInFocus)")
                }
            }
        }
        
    }
        
    func userAddWaterByShortcutItem(shortcutItem: UIApplicationShortcutItem ){
        if let drink: DrinkType = waterTypesListManager.drinkTypesList.first(where: {$0.id == shortcutItem.type}){
            DispatchQueue.main.asyncAfter(deadline:  .now() + 0.3){
                self.updateDrinkAndUI(drink: drink)
                self.notificationCenterManager.shortcutItem = nil
            }
        }
    }
    
    func userAddWaterByNotifcationAction( actionIdentifier: String){
        if let drink: DrinkType = waterTypesListManager.drinkTypesList.first(where: {$0.id == actionIdentifier}){
            print("=========")
            print ("\(drink.id)")
            print ("\(drink.name)")
            print("=========")
            DispatchQueue.main.asyncAfter(deadline:  .now() + 0.3){
                self.updateDrinkAndUI(drink: drink)
                self.notificationCenterManager.actionIdentifier = nil
            }
        }
    }
    
    func updateDrinkAndUI(drink: DrinkType){
//        self.numberOfWoter += drink.amount
        self.homeVM.addWaterToCureentDay(waterType: drink, daysItems: self.daysItems)
        
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WaterTypesListManager())
            .environmentObject(NotificationCenterManager())
    }
}






//                         ForEach( waterTypesListManager.drinkTypesList, id: \.id){ type in



//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)])
//    private var daysItems: FetchedResults<Day>

//            VStack{
//
//                Text("You drink \(numberOfWoter) ML")
//                    .font(.largeTitle)
//                    .fontWeight(.semibold)
//                    .foregroundColor(Color.blue)
//                    .multilineTextAlignment(.center)
//                    .lineLimit(2)
//            }


//.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

///     private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)



/*
 
 init() {
 
 //        let dateFrom = Date().daysBefore(number: 1)
 //        let dateTo = Date().daysAfter(number: 1)
 //        let predicate = NSPredicate(format : "date < %@ AND  date > %@", dateTo as CVarArg, dateFrom as CVarArg)
 //
 //        self._daysItems = FetchRequest(
 //            entity: Day.entity(),
 //            sortDescriptors: [
 //                NSSortDescriptor(keyPath: \Day.date, ascending: true),
 //            ],predicate: predicate)
 
 }
 
 
 //                if daysItems.count > 0 && daysItems.last?.drink != nil {
 //
 //                    let a: [Drink] = ((daysItems.last!.drink!.allObjects) as! [Drink])
 //
 //                    let b = a.sorted { d1, d2 in
 //                        d1.time! < d2.time!
 //                    }
 //
 //                    HStack{
 //                        Text("\(b.last?.amount ?? 0)")
 //                    }
 //                }

 
 
 //        WaveShape()
 //            .fill(gradient)
 //            .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
 //            .overlay(alignment: .center){
 //
 //                HStack {
 //                    ScrollView(.horizontal) {
 //                        HStack(spacing: 16.0){
 //                            ForEach(  waterTypesListManager.drinkTypesList.indices, id: \.self) { index in
 //
 //                                AddWaterButton(waterType: waterTypesListManager.drinkTypesList[index], imageFrame: CGSize(width: 30, height: 30), viewFrame: CGSize(width: 80, height: 80)){ number in
 ////                                    self.numberOfWoter += number.amount
 //                                    self.homeVM.addWaterToCureentDay(waterType: waterTypesListManager.drinkTypesList[index], daysItems: self.daysItems)
 //                                }
 //
 //                            }
 //                        }
 //                        .frame(maxWidth: .infinity, alignment: .leading)
 //                        .padding(.horizontal)
 //                    }
 //                }
 //            }

 */


/*
func todayWaterInfo(){
    if daysItems.count > 0 {
        print("daysItems.count = \(daysItems.count)")
        if let today: Day = daysItems.first(where: {$0.date?.getGregorianDate(dateFormat: "d MMMM yyyy") == Date().getGregorianDate(dateFormat: "d MMMM yyyy")}){
            self.todayInfo = today
//                let array = Array(today.drink! as Set as! Set<Drink>)
//                self.numberOfWoter = Int(array.sum(for: \.amount))
        }
        else{
            print("no day yet")
        }
    }
}
 */
