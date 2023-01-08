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
    let isDallyPrize: Bool
    
    init(selectedAward: AwardItem?, isDallyPrize: Bool = false) {
        self.selectedAward = selectedAward
        self.isDallyPrize = isDallyPrize
    }
    
    var body: some View{
        VStack(spacing: 10.0){
            if let selectedAward = selectedAward{
                
                Text("Congratulations!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("You won a prize!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if !isDallyPrize{
                    Text(selectedAward.awardName)
                        .frame(height: 30,alignment: .center)
                        .padding(.horizontal)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                selectedAward.photo.image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 130,height: 130)

                if !isDallyPrize{
                    ShareLink(item: selectedAward.photo, preview: SharePreview(selectedAward.photo.caption, image: selectedAward.photo.image),label: {
                        Label("Share with your friends", systemImage:  "square.and.arrow.up")
                            .font(.headline).fontWeight(.bold)
                            .foregroundColor(.black)
                        
                    })
                }else{
                    VStack(alignment: .center, spacing: 10.0){
                        Text("You drank your daily\n norm for today!")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        Text("Keep it up!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }.padding(.top,-16)
                }
              //  .padding(.top)
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


struct AwardWinView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            AwardWinView(selectedAward: AwardItem(imageName: "award4", awardName: "First Day", daysNumber: 1))
            AwardWinView(selectedAward: AwardItem(imageName: "award9", awardName: "First Day", daysNumber: 1), isDallyPrize: true)
        }
    }
}

