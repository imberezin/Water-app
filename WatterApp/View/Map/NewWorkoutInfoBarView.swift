//
//  NewWorkoutInfoBarView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 22/12/2022.
//

import SwiftUI

struct NewWorkoutInfoBarView: View {
    @Environment(\.colorScheme) var colourScheme
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
//    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack {
                    Text(newWorkoutManager.elapsedSecondsString)
                        .font(.headline)
                        .padding(.leading)
                        .animation(.none, value: newWorkoutManager.elapsedSecondsString)
                    Spacer()
                    Text(newWorkoutManager.totalDistanceString)
                        .font(.headline)
                        .padding(.trailing)
                        .animation(.none, value: newWorkoutManager.totalDistanceString)
                }
                
                HStack(spacing: 0) {
                    Button(action: {
                        newWorkoutManager.toggleWorkoutState()
                    }, label: {
                        Image(systemName: newWorkoutManager.toggleStateImageName)
                            .font(.title)
                            .frame(width: 48, height: 48)
                            .foregroundColor(colourScheme == .light ? .black : .white)
                            .animation(.none, value: newWorkoutManager.toggleStateImageName)
                    })
                    
                    Divider()
                        .frame(height: 48)
                    
                    EndButton()
                }
                .background(colourScheme == .light ? Color.white : Color.black)
                .cornerRadius(10)
            }
            .frame(height: 70)
            .background(.regularMaterial)
            .cornerRadius(10)
            .compositingGroup()
            .shadow(color: Color(UIColor.systemFill), radius: 5)
            .padding(10)
        }
    }
}

struct NewWorkoutInfoBarView_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutInfoBarView()
    }
}

struct EndButton: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    
    @State var showEndWorkoutAlert: Bool = false
    
    var body: some View {
        Button(action: {
            showEndWorkoutAlert = true
        }, label: {
            Image(systemName: "stop.fill")
                .font(.title)
                .frame(width: 48, height: 48)
                .foregroundColor(.red)
        })
        .alert(isPresented: $showEndWorkoutAlert) {
            Alert(
                title: Text("Finish Workout?"),
                primaryButton: .default(Text("Confirm")) {
                    newWorkoutManager.endWorkout()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
