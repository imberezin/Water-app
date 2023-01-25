//
//  ContentView.swift
//  MacApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import SwiftUI

struct MainContentView: View {
    
    @StateObject var homeVM = HomeVM()
    @StateObject var settingsVM = SettingsVM()

    @State var todayInfo: Day? = nil
    @State var showReminderView: Bool = false
    @State var editWaterList: Bool = false

    @Binding var currentTab: Tab

    
    var body: some View {
        VStack {
            WaveBGHeaderView(){
                HeaderView()
                    .padding(.top, -16)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            VStack {
                switch currentTab{
                case .home:
                    AddDrinkView(homeVM: homeVM)
                case .folder:
                    StatisticsMacView()
                        .padding(.top, 100)
                    
                default:
                    SettingsMacView()
                }
                Spacer()
            }
            .padding()

        }
        .popup(isPresented: $showReminderView) { // 3
            SettingsRemindeViewV2(settingsVM: settingsVM, showReminder: $showReminderView)
        }
        .ignoresSafeArea()
        .padding(.leading, -8)
    }
    
    
    func HeaderView()-> some View{
        
        VStack(alignment: .center, spacing: 0) {
            HStack{
                Text("Welcome **\(homeVM.userPrivateinfoSaved?.fullName ?? "Berezin Miri")**")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
                Button {
                    withAnimation{
                        self.showReminderView.toggle()
                    }
                } label: {
                    Image(systemName: "bell.badge")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .blue)
                        .rotationEffect(.degrees(self.showReminderView ? -15 : 30), anchor: .top)
                        .animation(.interpolatingSpring(mass: 0.5, stiffness: 150, damping: 2.5), value: self.showReminderView)
                        .padding(8)
                        .padding(.top, -8)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal)
            Text(Date().getGregorianDate())
                .font(.title)
            
        }
        .fontWeight(.semibold)
        .foregroundColor(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WaterTypesListManager())

    }
}
