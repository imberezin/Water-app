//
//  ContentView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 30/11/2022.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    
    @State var showPreviewPage: Bool = true

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let bottomEdge = geo.safeAreaInsets.bottom
                MainView(size: size, bottomEdge: bottomEdge)
              //  .overlay(self.showPreviewPage ? AnimatedDropView(showView: $showPreviewPage) : nil)
                    .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
}


