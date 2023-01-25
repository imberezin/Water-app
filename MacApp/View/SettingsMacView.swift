//
//  SettingsMacView.swift
//  MacApp
//
//  Created by IsraelBerezin on 23/01/2023.
//

import SwiftUI

struct SettingsMacView: View {
    
    @EnvironmentObject var waterTypesListManager: WaterTypesListManager
    
    @StateObject var settingsVM = SettingsVM()
    
    @FocusState private var checkoutInFocus: CheckoutFocusable?
    
    @State var showReminder: Bool = false
    
    @State var editWaterList: Bool = false
    
    @StateObject var awardListViewVM = AwardListViewVM()
    
    let genderArray: [String] = ["Male", "Fmale", "Other"]
    
    @State var selectedAward: AwardItem = AwardItem(imageName: "award0", awardName: "fake", daysNumber:-1)
    @State var showAwardView: Bool = false

    
    var body: some View {
        
        ZStack {
        
            ScrollViewReader { value in
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 8.0) {
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
                        
                        CustomTextTapView(title: "Drink List", systemName: "list.bullet", subTitleLeading: "", subTitleTrailing: "Show & Edit "){
                            self.editWaterList.toggle()
                        }
                        .padding(.vertical,8)
                                                
                        CustomTextStringFiled(title: "Full Name", systemName: "person", value: $settingsVM.userPrivateinfo.fullName)
                            .focused($checkoutInFocus, equals: .fullNameType)
                        
                        CustomNumberFiled(title: "Height", systemName: "arrow.up.to.line", checkoutFocusableId: CheckoutFocusable.heightType, value: $settingsVM.userPrivateinfo.height)
                            .focused($checkoutInFocus, equals: .heightType)
                        
                        CustomNumberFiled(title: "Weight", systemName: "scalemass",  checkoutFocusableId: CheckoutFocusable.weightType, value: $settingsVM.userPrivateinfo.weight)
                            .focused($checkoutInFocus, equals: .weightType)
                        
                        CustomNumberFiled(title: "Age", systemName: "hourglass",  checkoutFocusableId: CheckoutFocusable.weightType, value: $settingsVM.userPrivateinfo.age)
                            .focused($checkoutInFocus, equals: .ageType)
                        
                        CustomNumberFiled(title: "Amount Of water per day (ML)", systemName: "takeoutbag.and.cup.and.straw",  checkoutFocusableId: CheckoutFocusable.customTotalType, value: $settingsVM.userPrivateinfo.customTotal)
                            .focused($checkoutInFocus, equals: .customTotalType)
                        
                        
                        DropDown(title: "Gender", systemName: "figure.dress.line.vertical.figure", data: Gander.allCases.map({$0.rawValue}), selected: $settingsVM.userPrivateinfo.gender)
                            .padding(.top,8)
                            .id(CheckoutFocusable.amountType.rawValue)
                    }
                    
                    
                    Spacer(minLength: 100)
                    
                    
                }
            }
            .padding(.horizontal,24)
        .padding(.top,64)
        .popup(isPresented: $showReminder) { // 3
            SettingsRemindeViewV2(settingsVM: settingsVM, showReminder: $showReminder)
        }
            if editWaterList {
                WaterTypesListView(editWaterList: $editWaterList, checkoutInFocus: $checkoutInFocus).transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .onChange(of: editWaterList){ newValue in
                        print("editWaterList = \(newValue)")
                        if !newValue {
                                self.waterTypesListManager.saveListIfNeded(isNeded: self.waterTypesListManager.needToUpdateListWaterList)

                        }
                    }
            }
            
        }
        
    }
    

    
}

struct SettingsMacView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMacView()
            .frame(width: 1000,  height: 800,  alignment: .leading)

    }
}
