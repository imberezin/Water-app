//
//  SlideMenuView.swift
//  MacApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import SwiftUI

struct SlideMenuView: View {
    @Binding var currentTab: Tab
    
    @Namespace var animation
    
    var body: some View {
        
        VStack{
          
            Image("mainAppicon")
                .resizable()
                .clipShape(Circle())
                .frame(width: 125 , height: 125)
                .padding(.bottom,50)
            
            ForEach(Tab.allCases, id: \.rawValue){ tab in
                TabButtonView(tab: tab, currentTab: $currentTab, animation: animation)
                    .padding(.leading, 20)
                    .offset(x: 15)
            }
          
            Spacer()
        }
        .padding(.top,50)
        .frame(width: 250)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(LinearGradient(colors: bgWaweColors, startPoint: .bottom, endPoint:.topTrailing))
    }
}



struct SlideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WaterTypesListManager())

    }
}



struct TabButtonView: View {
 
    var tab: Tab
    @Binding var currentTab: Tab
    var animation: Namespace.ID
    
    var body: some View{
        Button {
            withAnimation {
                self.currentTab = tab

            }
        } label: {
            HStack(spacing: 15){
                Image(systemName: tab.rawValue)
                    .font(.title2)
                    .foregroundColor(currentTab.rawValue == tab.rawValue ? Color.blue : Color.gray.opacity(0.8))
                
                Text(tab.title)
                    .foregroundColor(.black.opacity(0.8))
                    .kerning(1.2)
            }
            .padding(.vertical, 24)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background{
                ZStack{
                    if currentTab.rawValue == tab.rawValue {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }else{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.clear)
                    }
                }
            }
            .contentShape(Rectangle())
            
        }

    }
    
}
