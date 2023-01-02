//
//  WaterTypeImageView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 02/01/2023.
//

import SwiftUI

struct WaterTypeImageView: View {
    
    let imageName: String
    let frame: CGSize
    
    var body: some View {
        Image(imageName)
            .resizable()
            .padding(8)
            .foregroundColor(.white)
            .frame(width: frame.width, height: frame.height)
            .background(Color("azureColor").opacity(0.9))
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: 3)
            )
            .clipShape(Circle())
    }
}

struct WaterTypeImageView_Previews: PreviewProvider {
    static var previews: some View {
        WaterTypeImageView(imageName: "watter", frame: CGSize(width: 50, height: 50))
    }
}
