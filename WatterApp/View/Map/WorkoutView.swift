//
//  WorkoutView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 22/12/2022.
//

import SwiftUI

import CoreLocation


struct WorkoutView: View {
    
    @StateObject var newWorkoutManager = NewWorkoutManager()
    @StateObject var mapManager = MapManager()
    
    // Map centre coordinate
    @State var centreCoordinate = CLLocationCoordinate2D()

    var body: some View {
        ZStack {
            MapView(centreCoordinate: $centreCoordinate)
                .ignoresSafeArea()
            if newWorkoutManager.workoutState == .notStarted {
                WorkoutInfoBarView()
                    .animation(.none, value: newWorkoutManager.workoutState)
                    .transition(.move(edge: .bottom))
            } else {
                NewWorkoutInfoBarView()
                    .transition(.move(edge: .bottom))
            }

        }
        //.animation(.default)
        .environmentObject(newWorkoutManager)
        .environmentObject(mapManager)

    }

}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
