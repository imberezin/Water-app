//
//  SettingsViewView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 30/11/2022.
//

import SwiftUI


enum CheckoutFocusable: Int, Hashable {
    case fullNameType = 0
    case heightType
    case weightType
    case ageType
    case customTotalType
    case genderType
}

//    let genderArray: [String] = ["Male", "Fmale", "Other"]

let bgWaweColors = [Color("azureColor").opacity(1),Color("azureColor").opacity(0.8),Color("azureColor").opacity(0.4),Color("azureColor").opacity(0.2)]


struct SettingsView: View {
    
    @EnvironmentObject var waterTypesListManager: WaterTypesListManager
    
    @StateObject var settingsVM = SettingsVM()
    
    @FocusState private var checkoutInFocus: CheckoutFocusable?
    
    @State var showReminder: Bool = false
    
    @StateObject var awardListViewVM = AwardListViewVM()

    let genderArray: [String] = ["Male", "Fmale", "Other"]
    
    @State var selectedAward: AwardItem = AwardItem(imageName: "award0", awardName: "fake", daysNumber:-1)
    @State var showAwardView: Bool = false
    
    
    var body: some View {
        
        VStack(spacing: 20){
            HeaderView()
                .frame(maxWidth: .infinity, maxHeight: 100)
            
            ScrollViewReader { value in
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 0.0) {
                        CustomTextTapView(title: "Reminder", systemName: "bell", subTitleLeading: "Current setting", subTitleTrailing: "\(settingsVM.userPrivateinfo.slectedRimniderHour) Hours"){
                            self.showReminder.toggle()
                        }
                        .padding(.bottom,8)
                        
                        AwardListView(selectedAward: $selectedAward)
                            .padding(.vertical,8)
                            .onChange(of: selectedAward){ newValue in
                                if newValue.awardName != "fake"{
                                    self.showAwardView = true
                                    if newValue.active == false {
                                        self.awardListViewVM.checkhowMoreDaysNeedToGetAward(numberOfDays: newValue.daysNumber)
                                    }

                                }
                            }
                            .onChange(of: showAwardView){ newValue in
                                if newValue == false{
                                    self.selectedAward = AwardItem(imageName: "award0", awardName: "fake", daysNumber: -1)
                                    
                                }
                            }
                        
                        CustomTextStringFiled(title: "Full Name", systemName: "person", keyboardType: .default, value: $settingsVM.userPrivateinfo.fullName)
                            .focused($checkoutInFocus, equals: .fullNameType)
                        
                        CustomNumberFiled(title: "Height", systemName: "arrow.up.to.line", keyboardType: .numberPad, checkoutFocusableId: CheckoutFocusable.heightType, value: $settingsVM.userPrivateinfo.height)
                            .focused($checkoutInFocus, equals: .heightType)
                        
                        CustomNumberFiled(title: "Weight", systemName: "scalemass", keyboardType: .numberPad, checkoutFocusableId: CheckoutFocusable.weightType, value: $settingsVM.userPrivateinfo.weight)
                            .focused($checkoutInFocus, equals: .weightType)
                        
                        CustomNumberFiled(title: "Age", systemName: "hourglass", keyboardType: .numberPad, checkoutFocusableId: CheckoutFocusable.weightType, value: $settingsVM.userPrivateinfo.age)
                            .focused($checkoutInFocus, equals: .ageType)
                        
                        CustomNumberFiled(title: "Amount Of water per day (ML)", systemName: "takeoutbag.and.cup.and.straw", keyboardType: .numberPad, checkoutFocusableId: CheckoutFocusable.customTotalType, value: $settingsVM.userPrivateinfo.customTotal)
                            .focused($checkoutInFocus, equals: .customTotalType)
                        
                        
                        DropDown(title: "Gender", systemName: "figure.dress.line.vertical.figure", data: Gander.allCases.map({$0.rawValue}), selected: $settingsVM.userPrivateinfo.gender)
                            .padding(.top,8)
                    }
                    
                    
                    Spacer(minLength: 100)
                    
                    
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                CustomeToolbarItemGroup(){ checkoutInFocus in
                                    withAnimation{
                                        value.scrollTo(checkoutInFocus.rawValue, anchor: .center)
                                    }
                                }
                            }
                        }
                }
            }
            .padding(.horizontal,24)
            .padding(.top,64)
            Spacer()
            
        }
        .popup(isPresented: $showReminder) { // 3
            SettingsRemindeViewV2(settingsVM: settingsVM, showReminder: $showReminder)
        }
        .popup(isPresented: $showAwardView) { // 3
            AwardViews()
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear{
            // self.settingsVM.updateDrinkTypesList(drinkTypesList: self.waterTypesListManager.drinkTypesList)
        }
    }
    
    func toggleFocus(){
        if checkoutInFocus == .fullNameType {
            checkoutInFocus = .heightType
        } else if checkoutInFocus == .heightType {
            checkoutInFocus = .weightType
        } else if checkoutInFocus == .weightType {
            checkoutInFocus = .ageType
        }else if checkoutInFocus == .ageType {
            checkoutInFocus = .customTotalType
        }else{
            checkoutInFocus = .none
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View{
        let gr1 = Gradient(colors: bgWaweColors)
        WaveShape()
            .fill(gr1)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .overlay(alignment: .center){
                HStack(alignment: .center, spacing: 16.0){
                    Text("Settinngs")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.blue)
                    
                }
                .padding(.top,54)
                
            }
        
    }
    
    @ViewBuilder
    func CustomeToolbarItemGroup(completion: @escaping(CheckoutFocusable)->()) -> some View{
        
        HStack {
            Button("Close") {
                print("close Keybord")
                checkoutInFocus = .none
            }
            
            Spacer()
            
            Button(checkoutInFocus == .customTotalType ? "Done" : "Next") {
                print("Next Keybord")
                toggleFocus()
                print(self.checkoutInFocus!.rawValue)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let checkoutInFocus = self.checkoutInFocus {
                        completion(checkoutInFocus)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func AwardViews() -> some View{
        
        VStack{
            if selectedAward.active {
                AwardWinView(selectedAward: selectedAward)
            }else{
                
                ZStack(alignment: .bottom){
                    
                                    
                    Image(selectedAward.imageName)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100,height: 100)
                    
                    Text(selectedAward.awardName)
                        .frame(width: 100,height: 20,alignment: .center)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Text("To win this medal, you must consume **\(self.settingsVM.userPrivateinfo.customTotal) ml** continuously for an **additional \(self.awardListViewVM.moreDaysToAward) days!**")
                    .font(.headline)
                    .fontWeight(.regular)
                    .lineSpacing(10)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
        }
        
        
        .frame(width:300, height: 300)
        .background(Color("azureColor"))
        .cornerRadius(20).shadow(radius: 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear{
//            if selectedAward.active == false {
//                self.awardListViewVM.checkhowMoreDaysNeedToGetAward(numberOfDays: selectedAward.daysNumber)
//            }
//        }
    }

    
    
    
}

struct SettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(WaterTypesListManager())
            .environmentObject(NotificationCenterManager())
    }
}














