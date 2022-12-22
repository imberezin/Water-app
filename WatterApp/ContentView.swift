//
//  ContentView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 30/11/2022.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let bottomEdge = geo.safeAreaInsets.bottom

            MainView(size: size, bottomEdge: bottomEdge)
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
}


