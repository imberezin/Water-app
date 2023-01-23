//
//  WaterTypesListView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 01/01/2023.
//

import SwiftUI

struct WaterTypesListView: View {
    @EnvironmentObject var waterTypesListManager : WaterTypesListManager
    @Environment(\.dismiss) var dismiss
    
    @State var selectedItem: DrinkType = DrinkType(name: "fake", amount: 0, imageMame: "fake")
    @State var showEditPopup: Bool = false
    @State var disclosureGroupIsExpanded: Bool = false
#if !os(iOS)
    @Binding var editWaterList: Bool
#endif
    
    //Based: https://onmyway133.com/posts/how-to-pass-focusstate-binding-in-swiftui/
    var checkoutInFocus: FocusState<CheckoutFocusable?>.Binding
    
    var items: [GridItem] {
        return Array(repeating: .init(.adaptive(minimum: 50)), count: 4)
    }
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                Text("Edit Drink List")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                
                List{
                    ForEach ( waterTypesListManager.drinkTypesList, id: \.id){ waterItem in
                        WatterCellView(for: waterItem)
                            .padding(.bottom, TargetDevice.currentDevice == .nativeMac ? 8 : 0)
                            .onTapGesture {
                                self.selectedItem = waterItem
                                self.showEditPopup.toggle()
                            }
                    }
                    .onDelete(perform: deleteItems)
                    .onMove(perform: moveItem)
                    
                }
                .scrollContentBackground(.hidden)
                .padding(.horizontal,-16)
                
                HStack{
                    Spacer()
                    
                    CustomButton(text: "Close") {
                        self.waterTypesListManager.needToUpdateListWaterList = false
                        dismissView()
                    }
                    Spacer()
                    CustomButton(text: "Save") {
                        self.waterTypesListManager.needToUpdateListWaterList = true
                        dismissView()
                    }
                    Spacer()
                    
                }
                
                .toolbar {
#if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
#endif
                }
                
                
            }
            
            .popup(isPresented: $showEditPopup, view: {
                WaterTypeEditPopupView()
            }, onClose:{
                self.checkoutInFocus.wrappedValue = .none
                self.selectedItem = DrinkType(name: "fake", amount: 0, imageMame: "fake")
                //  self.updateWaterList()
            })
#if os(iOS)

            .ignoresSafeArea(.container, edges: .bottom)
#endif
            .onAppear{
                Task{
                    // await self.waterTypesListManager.buildDrinkList()
                    self.waterTypesListManager.loadPropertyList()
                }
            }
        }
    }
    
    func dismissView(){
        withAnimation{
#if os(iOS)
            dismiss()
#else
            self.editWaterList = false
#endif
        }
    }
    
    func updateWaterList() {

        if let index = self.waterTypesListManager.drinkTypesList.firstIndex(where: {type in type.id == selectedItem.id}){
            self.waterTypesListManager.drinkTypesList[index].name = selectedItem.name
            self.waterTypesListManager.drinkTypesList[index].amount = selectedItem.amount
            self.waterTypesListManager.drinkTypesList[index].imageName = selectedItem.imageName

        }else{
            self.waterTypesListManager.drinkTypesList.append(selectedItem)
        }
        selectedItem = DrinkType(name: "fake", amount: 0, imageMame: "fake")

    }
    
    
    @ViewBuilder
    func WaterTypeEditPopupView() -> some View{
        
        GroupBox("**\(self.selectedItem.name.capitalizedSentence)** Drink Type") {
            GeometryReader{ proxy in
                VStack(alignment: .leading){
                  
                    Text("Edit and update drink properties")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStackDropDown(title: "Drink Name", systemName: "mug", data: waterTypesListManager.drinkNameList, selected: $selectedItem.name, proxy: proxy)
                        .padding(.top,8)
#if os(iOS)

                    CustomHStackNumberFiled(title: "Amount", systemName: "sum", keyboardType: .numberPad, checkoutFocusableId: CheckoutFocusable.amountType, value: $selectedItem.amount, proxy: proxy)
                        .focused(checkoutInFocus, equals: .amountType)

                        .padding(.trailing,-4)
#else
                    CustomHStackNumberFiled(title: "Amount", systemName: "sum",  checkoutFocusableId: CheckoutFocusable.amountType, value: $selectedItem.amount, proxy: proxy)
                        .focused(checkoutInFocus, equals: .amountType)

                        .padding(.trailing,-4)

#endif
                    DisclosureGroup(isExpanded: $disclosureGroupIsExpanded) {
                        GroupImagesGroupView()
                    } label: {
                        HStack(alignment: .center){
                            Image(systemName: "photo")
                                .foregroundColor(.black)
                            Text("Image")
                                .foregroundColor(.black)
                            Spacer()
                            WaterTypeImageView(imageName: self.selectedItem.imageName, frame: CGSize(width: 40, height: 40))
                        }
                    }
                    
                    CustomButton(text: "Close") {
                        self.checkoutInFocus.wrappedValue = .none
                        self.updateWaterList()
                        withAnimation{
                            self.showEditPopup = false
                        }
                    }

                }
            }
        }
        .groupBoxStyle(CardGroupBoxStyle())
        .padding(.vertical)
        .padding()
        .frame(width:300, height: 400, alignment: .center)
        .background(Color("azureColor"))
        .cornerRadius(20).shadow(radius: 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    @ViewBuilder
    func GroupImagesGroupView() -> some View{
        VStack(alignment: .center){
            ScrollView{
                Spacer(minLength: 10)
                LazyVGrid(columns: items, spacing: 10) {
                    
                    ForEach(  0 ..< watterIconNumber, id: \.self) { index in
                        let imageName = watterIconPrefix + "\(index)"
                        Button {
                            print("index = \(index), imageName =\(imageName)")
                            self.selectedItem.imageName = imageName
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                                withAnimation{
                                    self.disclosureGroupIsExpanded.toggle()
                                }
                            }
                        } label: {
                            WaterTypeImageView(imageName: imageName, frame: CGSize(width: 50, height: 50))

                        }
                    }
                }
                Spacer(minLength: 100)

            }
            .frame(height: 180)
            
        }
    }
    
    
    @ViewBuilder
    func WatterCellView(for waterItem: DrinkType) -> some View{
        HStack{
            VStack(alignment: .leading, spacing: 8.0){
                Text(waterItem.name.capitalizedSentence)
                Text("\(waterItem.amount)")
            }
            Spacer()
            WaterTypeImageView(imageName: waterItem.imageName, frame: CGSize(width: 50, height: 50))
            
        }
        .padding(.horizontal, TargetDevice.currentDevice == .nativeMac ? 16 : 0)
//        .background(TargetDevice.currentDevice == .nativeMac ? .white : .clear)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
    
    
    private func addItem() {
        self.selectedItem = DrinkType(name: "Water", amount: 0, imageMame: "other")
        withAnimation {
            self.showEditPopup.toggle()
        }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        
        withAnimation{
            self.waterTypesListManager.drinkTypesList.remove(atOffsets: offsets)
        }
    }
    
    private func moveItem(indexSet: IndexSet, destination: Int) {
        let source = indexSet.first!
        self.waterTypesListManager.drinkTypesList.swapAt(source, destination)
    }

    
}

#if os(iOS)

struct WaterTypesListView_Previews: PreviewProvider {
    
    @FocusState static var checkoutInFocus: CheckoutFocusable?

    static var previews: some View {
        
        WaterTypesListView(checkoutInFocus: $checkoutInFocus)
            .environmentObject(WaterTypesListManager())
    }
}
#endif



struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center) {
            configuration.label
                .font(.title3)
            configuration.content
        }
        .padding()
#if os(iOS)
        .background(Color(.systemGroupedBackground))
#else
        .background(Color(.gray))
#endif
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
