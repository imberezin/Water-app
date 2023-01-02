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
                            .onTapGesture {
                                self.selectedItem = waterItem
                                self.showEditPopup.toggle()
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .scrollContentBackground(.hidden)
                .padding(.horizontal,-16)
                
                HStack{
                    CustomButton(text: "Close") {
                        self.waterTypesListManager.needToUpdateListWaterList = false
                        dismiss()
                    }
                    
                    CustomButton(text: "Save") {
                        self.waterTypesListManager.needToUpdateListWaterList = true
                        dismiss()
                    }
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
            
        }
        .popup(isPresented: $showEditPopup, view: {
            WaterTypeEditPopupView()
        }, onClose:{
            self.checkoutInFocus.wrappedValue = .none
            self.updateWaterList()
        })
        .ignoresSafeArea(.container, edges: .bottom)

        .onAppear{
            Task{
                await self.waterTypesListManager.buildDrinkList()
            }
        }
    }
    
    
    func updateWaterList(){

        if let index = self.waterTypesListManager.drinkTypesList.firstIndex(where: {type in type.id == selectedItem.id}){
            self.waterTypesListManager.drinkTypesList[index].name = selectedItem.name
            self.waterTypesListManager.drinkTypesList[index].amount = selectedItem.amount
            self.waterTypesListManager.drinkTypesList[index].imageName = selectedItem.imageName

        }
        selectedItem = DrinkType(name: "fake", amount: 0, imageMame: "fake")

    }
    
    
    @ViewBuilder
    func WaterTypeEditPopupView() -> some View{
        VStack(alignment: .leading, spacing: 16.0){
            VStack(alignment: .center, spacing:8.0) {
                    Text("**\(self.selectedItem.name)** Drink Type")
                        .font(.headline)
                        .fontWeight(.semibold)
                                        Spacer()
                    Text("Edit and update properties")
                        .font(.subheadline)
                        .fontWeight(.regular)
            }
            
            .frame(maxWidth: .infinity, alignment: .center)
            
            HStackDropDown(title: "Drink Name", systemName: "mug", data: waterTypesListManager.drinkTypesList.map({$0.name}), selected: $selectedItem.name)
                .padding(.top,8)
                .padding(.trailing,-8)

            
            CustomHStackNumberFiled(title: "Amount", systemName: "sum", keyboardType: .numberPad, checkoutFocusableId: CheckoutFocusable.amountType, value: $selectedItem.amount)
                .focused(checkoutInFocus, equals: .amountType)
            
            DisclosureGroup(isExpanded: $disclosureGroupIsExpanded) {
                GroupImagesGroupView()
                
                
            } label: {
                HStack(alignment: .center){
                    WaterTypeImageView(imageName: self.selectedItem.imageName, frame: CGSize(width: 40, height: 40))
                    Spacer()
                    Text("Image name")
                }
                
            }
            Spacer()
        }
        .padding(.vertical)
        .padding()
        .frame(width:300, height: 350)
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
                Spacer(minLength: 30)

            }
            .frame(height: 180)
            
        }
    }
    
    
    @ViewBuilder
    func WatterCellView(for waterItem: DrinkType) -> some View{
        HStack{
            VStack(alignment: .leading, spacing: 8.0){
                Text(waterItem.name)
                Text("\(waterItem.amount)")
            }
            Spacer()
            WaterTypeImageView(imageName: waterItem.imageName, frame: CGSize(width: 50, height: 50))
            
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
    
    
    private func addItem() {
        //        withAnimation {
        //            let newItem = Day(context: viewContext)
        //            newItem.date = Date()
        //
        //            do {
        //                try viewContext.save()
        //            } catch {
        //                // Replace this implementation with code to handle the error appropriately.
        //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //                let nsError = error as NSError
        //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        //            }
        //        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        
        //        withAnimation {
        //            offsets.map { items[$0] }.forEach(viewContext.delete)
        //
        //            do {
        //                try viewContext.save()
        //            } catch {
        //                // Replace this implementation with code to handle the error appropriately.
        //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //                let nsError = error as NSError
        //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        //            }
        //        }
    }
    
}

struct WaterTypesListView_Previews: PreviewProvider {
    
    @FocusState static var checkoutInFocus: CheckoutFocusable?

    static var previews: some View {
        
        WaterTypesListView(checkoutInFocus: $checkoutInFocus)
            .environmentObject(WaterTypesListManager())
    }
}


