//
//  MainView.swift
//  MacApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import SwiftUI

struct MainView: View {
    
    @State var currentTab: Tab = .home

    var body: some View {
        HStack{
         
            SlideMenuView(currentTab: $currentTab)
            
            MainContentView(currentTab: $currentTab)
     
        }
        .frame(width: getRect().width  / 1.5,  height: getRect().height - 100,  alignment: .leading)
        .background(Color.white.ignoresSafeArea())
        .buttonStyle(PlainButtonStyle())
    }
    


}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WaterTypesListManager())

    }
}

