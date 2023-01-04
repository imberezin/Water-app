//
//  WaveHeaderView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/01/2023.
//

import SwiftUI

struct WaveBGHeaderView<Content: View>: View {
    
    @ViewBuilder var content: Content
    
    var body: some View {
    
            let gr1 = Gradient(colors: bgWaweColors)
            WaveShape()
                .fill(gr1)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .overlay(alignment: .center){
                    content
                    .padding(.top,54)
                    
                }
        }
}

struct WaveHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        WaveBGHeaderView(){
            TitleHeaderView(title: "Test Wave")
        }
            .frame(maxWidth: .infinity,maxHeight: 110,alignment: .top)
            .ignoresSafeArea()
    }
}

struct TitleHeaderView: View{
    
    let title: String
    
    var body: some View{
        HStack(alignment: .center, spacing: 16.0){
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
        }
    }
}
