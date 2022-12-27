//
//  AwardListView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 25/12/2022.
//

import SwiftUI


struct AwardListView: View {
    
    
    @StateObject var awardListViewVM = AwardListViewVM()
        
    @Binding var selectedAward: AwardItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Image(systemName: "medal")
                Text("Awards")
            }
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(Array(zip(self.awardListViewVM.awardslist.indices, self.awardListViewVM.awardslist)), id: \.0) { index, item in
                        
                        ListItemView(awardItem: item, index:index)
                        
                    }
                }
            }
        }

        .onAppear{
            self.awardListViewVM.updateAwardslist()
        }
        
    }
    
    @ViewBuilder
    func ListItemView(awardItem: AwardItem, index: Int)-> some View{
        
        Button(action:{
            self.selectedAward = awardItem
        }){
            
            ZStack(alignment: .bottom){
                
                let oldImage = UIImage(named: awardItem.imageName)
                
                let newImage = awardItem.active ? oldImage!.maskWithColor(color: .red) : oldImage
                                
                Image(uiImage: newImage!)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 90,height: 90)
                
                Text(awardItem.awardName)
                    .frame(width: 90,height: 25,alignment: .center)
                    .background(Color("azureColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}




struct AwardListView_Previews: PreviewProvider {
    static var previews: some View {
        //        AwardListView()
        //            .frame(height: 100)
        
        SettingsView()
            .environmentObject(WaterTypesListManager())
            .environmentObject(NotificationCenterManager())


        
    }
}



/*
 .overlay(alignment: .center){
     if showAwardView && selectedAwardIndex > -1{
         let selectedAward = self.awardListViewVM.awardslist[selectedAwardIndex]
         let oldImage = UIImage(named: selectedAward.imageName)
         
         let newImage = oldImage!.maskWithColor(color: .red)
         
         let photo = Photo(image: Image(uiImage: newImage!), caption: selectedAward.awardName, description: "")


         VStack{
             ZStack(alignment: .bottom){
                 
                 
                 Image(uiImage: newImage!)
                     .resizable()
                     .clipShape(Circle())
                     .frame(width: 150,height: 150)
                 
                 Text(selectedAward.awardName)
                     .frame(width: 90,height: 25,alignment: .center)
                     .background(Color("azureColor"))
                     .clipShape(RoundedRectangle(cornerRadius: 10))
             }
             

         }
         .frame(width:200, height: 200)
         
         .background(
             Color("azureColor")
         )
         .onTapGesture {
             withAnimation(.easeOut) {
                 self.showAwardView = false
             }
         }

     }
 }
 */
