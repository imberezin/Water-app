//
//  SettingsReminderView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/12/2022.
//

import SwiftUI

struct SettingsReminderView: View {
    
    @EnvironmentObject var notificationCenterManager: NotificationCenterManager
    
    @StateObject var settingsVM: SettingsVM
    @Binding var showReminder: Bool
    
    @State var slectedRimniderHour: Int =  3
    @State var enabledReminde: Bool =  false
    @State var isActive:Bool = false

    
    @State private var wakeUpTime = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!

    @State private var sleepTime = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!


    let array:[Int] = [1,2,3,5,6]
        
    var body: some View {
        
        
        VStack(alignment: .center, spacing: 10.0){
            VStack {
                Text("Reminder")
                    .font(.title3)
                .fontWeight(.bold)
            }.padding(.top)
            Text("Remind yourself to drink water")
                .font(.headline)
            
            Form {
                Section{
                    
                    Toggle("Enabels", isOn: $enabledReminde)
                }
                
                Section{
                    DatePicker("wakeUp time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    DatePicker("Sleep time", selection: $sleepTime, displayedComponents: .hourAndMinute)

                    
                    Picker("Set a frequency", selection: $slectedRimniderHour) {
                        ForEach(array, id: \.self) { flavor in
                            Text("\(flavor) hours")
                        }
                    }.pickerStyle(.automatic)
                }
                
                Section{
                    CustomButton(text: "Save"){
                        print("Save")
                        self.settingsVM.didSave(startTime: wakeUpTime, endTime: sleepTime, slectedRimniderHour: self.slectedRimniderHour, enabledReminder: self.enabledReminde)
                        withAnimation(.easeOut){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                if notificationCenterManager.isAllowedToSendPush{
                                    self.showReminder = false

                                }
                            }
                        }
                    }
                }
                
                
            }
            .frame(height: 400)
            .cornerRadius(20)
            .padding()
            
        }
        .frame(width: 350, height: 520)
        .background(Color("azureColor"))
        .cornerRadius(20).shadow(radius: 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.black.opacity(0.25)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        self.showReminder.toggle()
                    }
                }
        )
        
        .overlay(alignment: .center){
            if !notificationCenterManager.isAllowedToSendPush{
                VStack(alignment: .center, spacing: 10.0){
                    Spacer()
                    VStack(alignment: .center, spacing: 30){
                        
                        Text("You not allowed Notfications")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("please allowed to get reminder")
                            .font(.title3)
                    }
                    Spacer()
                    VStack{
                    
                        CustomButton(text: "Go to Settings"){
                            Task{
                                    let _ = await UIApplication.shared.openAppNotificationSettings()
                            }

                        }
                        
                        Divider().padding(.horizontal)
                        
                        CustomButton(text: "Close"){
                            self.notificationCenterManager.isAllowedToSendPush.toggle()
                            withAnimation{
                                self.showReminder = false
                            }
                        }
                    }
                    
        }
                .frame(width: 350, height: 440)
                .background(Color("azureColor").gradient)
                .cornerRadius(20).shadow(radius: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(
//                    Color.black.opacity(0.25)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            withAnimation(.easeOut) {
//                                self.notificationCenterManager.isAllowedToSendPush.toggle()
//                            }
//                        }
//                )
            }else{
                EmptyView()
            }
        }
        .onAppear{
            DispatchQueue.main.async {
                
                self.enabledReminde = settingsVM.userPrivateinfo.enabledReminde
                self.slectedRimniderHour = settingsVM.userPrivateinfo.slectedRimniderHour
            }
        }

        
        
    }
}

struct SettingsReminderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsReminderView(settingsVM: SettingsVM(), showReminder: .constant(true))
            .environmentObject(NotificationCenterManager())
    }
}
