//
//  MainView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 30/11/2022.
//

import SwiftUI

struct MainView: View {
    
    @State var currentTab: Tab = .home
    @Namespace var animation
    
    var size: CGSize
    var bottomEdge: CGFloat

    
    var body: some View {
        ZStack (alignment: .bottom){
            TabView(selection: $currentTab){
                Home()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.ignoresSafeArea())
                    .tag(Tab.home)
              //  WorkoutView()//Text("")
                CustomDropDownView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.ignoresSafeArea())
                    .tag(Tab.scan)
                StatisticsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.ignoresSafeArea())
                    .tag(Tab.folder)
                SettingsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.ignoresSafeArea())
                    .tag(Tab.cart)
            }
            CustomTabBarView(anumation: animation, size: size, bottomEdge: bottomEdge, currenTab: $currentTab)
            .background(Color("azureColor"))
        }
    }
    



}



enum Tab: String, CaseIterable{
    
    case home = "mug"
    case scan = "figure.walk"
    case folder = "list.bullet.clipboard"
    case cart = "gearshape"
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct CustomTabBarView: View {
    
    
    var anumation: Namespace.ID
    
    var size: CGSize
    var bottomEdge: CGFloat
    
    @Binding var currenTab: Tab
    
    @State var startAnimation: Bool = false
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(Tab.allCases, id: \.rawValue){ tab in
                TabButton(tab: tab, anumation: anumation, currenTab: $currenTab) { pressedTab in
                    withAnimation(.spring()){
                        self.startAnimation = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                        withAnimation(.spring()){
                            currenTab = pressedTab
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45){
                        withAnimation(.spring()){
                            self.startAnimation = false
                        }
                    }

                }
            }
        }
        .background(
            ZStack{
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 45, height: 45)
                    .offset(y: 40)
                
                Circle()
                    .fill(Color("azureColor"))
                    .frame(width: 45, height: 45)
                    .scaleEffect(bottomEdge == 0 ? 0.8: 1)
                    .offset(x: (startAnimation ? 18 : 27), y:36)
                
                Circle()
                    .fill(Color("azureColor"))
                    .frame(width: 45, height: 45)
                    .scaleEffect(bottomEdge == 0 ? 0.8: 1)
                    .offset(x: -(startAnimation ? 18 : 27), y:36)
            }
                .offset(x: getStartOffset())
                .offset(x: getOfsett())
            ,alignment: .leading
        )
        .padding(.horizontal,15)
        .padding(.top,7)
        .padding(.bottom, bottomEdge == 0 ? 23 : bottomEdge)
    }
    
    
    func getStartOffset()-> CGFloat{
        let reduce = (size.width - 30) / 4
        let center = (reduce - 40) / 2
        
        return center - 2
        
    }
    
    func getOfsett() -> CGFloat{
        let reduce = (size.width - 30) / 4

        let index = Tab.allCases.firstIndex{checkTab in
            return checkTab == currenTab
        } ?? 0
        
        return reduce * CGFloat(index)
    }
    
}

struct TabButton: View{
    
    var tab: Tab
    var anumation: Namespace.ID
    @Binding var currenTab: Tab
    var onTap: (Tab)->()
    
    var body: some View {
        Image(systemName: tab.rawValue)
            .imageScale(.large)
            .foregroundColor(currenTab == tab ? .white : .gray)
            .frame(width: 45, height: 45)
            .background(
                ZStack{
                    if tab == currenTab {
                        Circle()
                            .fill(Color.blue)
                            .matchedGeometryEffect(id: "TAB", in: anumation)
                    }
                }
            )
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                if currenTab != tab{
                    onTap(tab)
                }
            }
        
    }

}









/*
 
 @ViewBuilder
 func TabBar()->some View{
     HStack(spacing:0){
         ForEach(Tab.allCases, id: \.rawValue){ tab in
             Image(systemName: tab.rawValue)
                 .font(.system(size: 24, weight: currentTab == tab ? .bold : .semibold))
                 .foregroundColor(currentTab == tab ? .white: .gray.opacity(0.5))
                 .offset(y: currentTab == tab ? -25: 0)
                 .background(content:{
                     if currentTab == tab{
                         Circle()
                             .fill(.black)
                             .scaleEffect(2.0)
                             .shadow(color: .black.opacity(0.3), radius: 8, x: 5, y: 10)
                             .matchedGeometryEffect(id: "TAB", in: animation)
                             .offset(y: currentTab == tab ? -25: 0)

                     }
                 })
                 .frame(maxWidth: .infinity)
                 .padding(.top,20)
                 .padding(.bottom,0)
                 .containerShape(Rectangle())
                 .onTapGesture {
                     currentTab = tab
                 }

             

         }
     }.padding(.horizontal,15)
         .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.65),value: currentTab)
         .background{
//                CustomCorner(corners: [.topLeft,.topRight], radius: 25).fill(Color("BarBGColor")).ignoresSafeArea()
         }
 }
 */
