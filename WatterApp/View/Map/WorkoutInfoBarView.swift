//
//  WorkoutInfoBarView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 22/12/2022.
//

import SwiftUI
import MapKit
import HealthKit

struct WorkoutInfoBarView: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var mapManager: MapManager
    
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {

                
                HStack {
                    Spacer()
                    StartButton()
                    Spacer()
                }
            }
            .frame(width: 70 ,height: 70)
            .background(.regularMaterial)
            .cornerRadius(10)
            .compositingGroup()
            .shadow(color: Color(UIColor.systemFill), radius: 5)
            .padding(10)
            .clipShape(Circle())
            .containerShape(Circle())
            .onTapGesture {
            }
        }
    }
}

struct WorkoutInfoBarView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutInfoBarView()
    }
}


struct StartButton: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var mapManager: MapManager
    
    @State var showActionSheet: Bool = false
    
    var body: some View {
        Button(action: {
            showActionSheet = true
        }, label: {
            Image(systemName: "record.circle")
                .font(.largeTitle)
                .padding(5)
        })
        .foregroundColor(.white)
        .background(Color(UIColor.systemRed))
        .clipShape(Circle())
        .compositingGroup()
        .shadow(color: Color(UIColor.systemFill), radius: 5)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Record a Workout"),
                buttons: [
                    .default(Text("Walk")) {
                        recordWorkout(workoutType: .walking)
                    },
                    .default(Text("Run")) {
                        recordWorkout(workoutType: .running)
                    },
                    .default(Text("Cycle")) {
                        recordWorkout(workoutType: .cycling)
                    },
                    .default(Text("Other")) {
                        recordWorkout(workoutType: .other)
                    },
                    .cancel()
                ]
            )
        }
        .alert(isPresented: $newWorkoutManager.showAlert) {
            Alert(
                title: Text("Recording Failed"),
                message: Text("MyMap needs access to your workout routes to show them on the map. Allow access in the Health App. MyMap needs access to your location to record workout routes. Allow access in the Settings App."),
                dismissButton: .cancel(Text("Ok"))
            )
        }
    }
    
    func recordWorkout(workoutType: HKWorkoutActivityType) {
        newWorkoutManager.startWorkout(workoutType: workoutType)
        if newWorkoutManager.workoutState == .running {
            mapManager.userTrackingMode = .followWithHeading
        }
    }
}
