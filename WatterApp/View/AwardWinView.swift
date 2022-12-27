//
//  AwardView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 27/12/2022.
//

import Foundation
import SwiftUI

struct AwardWinView: View {
    
    let selectedAward: AwardItem?
    
    var body: some View{
        VStack{
            if let selectedAward = selectedAward{
                selectedAward.photo.image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 150,height: 150)
                
                Text(selectedAward.awardName)
                    .frame(width: 140,height: 30,alignment: .center)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                ShareLink(item: selectedAward.photo, preview: SharePreview(selectedAward.photo.caption, image: selectedAward.photo.image),label: {
                    Label("Share with your friends", systemImage:  "square.and.arrow.up")
                        .font(.headline).fontWeight(.bold)
                        .foregroundColor(.black)
                    
                })
                .padding(.top)
            }else{
                EmptyView()
            }
        }
        .frame(width:300, height: 300)
        .background(Color("azureColor"))
        .cornerRadius(20).shadow(radius: 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    
    
}
