//
//  testView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 07/12/2022.
//

import SwiftUI

struct testView: View {
    @EnvironmentObject var waterTypesListManager: WaterTypesListManager
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack(spacing: 16.0){
                    
                    ForEach( waterTypesListManager.drinkTypesList, id: \.id){ type in
                        
                        AddWaterButton(waterType: type){ number in
                            //                            self.numberOfWoter += number.amount
                            //                            self.homeVM.addWaterToCureentDay(waterType: type, daysItems: self.daysItems)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
        }.onAppear{
            self.waterTypesListManager.loadPropertyList()
        }
        
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
            .environmentObject(WaterTypesListManager())
    }
}


