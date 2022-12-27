//
//  Pie.swift
//  WatterApp
//
//  Created by IsraelBerezin on 06/12/2022.
// https://betterprogramming.pub/build-pie-charts-in-swiftui-822651fbf3f2
// https://betterprogramming.pub/create-a-segmented-pie-chart-using-swiftui-7b0adbbc4ef6


import Foundation
import SwiftUI



struct Pie : View {
    
    @StateObject var pieDateVM :PieDateVM
    
    // let viewWigth: CGFloat
    
    var items: [GridItem] {
        return Array(repeating: .init(.fixed(110)), count: 3)
    }
    
    let innerRadiusFraction = 0.3
    var body: some View{
        
        VStack {
            GeometryReader { geometry in
                
                ZStack(alignment: .center) {
                    
                    ForEach(pieDateVM.data, id: \.id) { piece in
                        
                        PieSliceView( piece: piece)
                        
                    }
                    
                    Circle()
                        .fill(Color("azureColor"))
                        .frame(width: geometry.size.width * innerRadiusFraction, height: geometry.size.width * innerRadiusFraction)
                    
                    VStack(alignment: .center, spacing: 4.0) {
                        Text(pieDateVM.progress.round(to: 2).formatted(.percent))
                        Text("From")
                        Text("\(pieDateVM.userPrivateinfoSaved?.customTotal ?? 3000) Ml")
                    }
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    
                }  .frame(maxWidth: .infinity, alignment: .center)
            }
            .rotationEffect(Angle(degrees: 360))

            VStack(alignment: .center){
                LazyVGrid(columns: items, spacing: 10) {
                    ForEach(  pieDateVM.data.indices, id: \.self) { index in
                        
                        SlinseInfoView(index: index)
                        
                    }
                }
            }
            .padding(.top, 8)
        }
    }
    
    @ViewBuilder
    func SlinseInfoView(index: Int) -> some View{
        HStack(alignment: .center, spacing: 8.0){
            if ((index + 1) % 3) != 1 {
                Spacer()
            }
            Circle().fill(pieDateVM.data[index].color)
                .frame(width: 12)
            Text(pieDateVM.data[index].name)
                .foregroundColor(Color.black)
            if ((index + 1) % 3) !=  0{
                Spacer()
            }
        }.padding(.trailing, ((index + 1) % 3) == 0 ? 16 : 0)
            .frame(height: 20)
        
    }
}




let tempDrinks: [DrinkItem] = [DrinkItem(name: "water", amount:  200),
                               DrinkItem(name: "bigWater", amount:  300),
                               DrinkItem(name: "bigWater", amount:  300),
                               DrinkItem(name: "coffee", amount:  180),
                               DrinkItem(name: "water", amount:  200),
                               DrinkItem(name: "tee", amount:  220),
                               DrinkItem(name: "water", amount:  200),
                               DrinkItem(name: "bigWater", amount:  300),
                               DrinkItem(name: "water", amount:  200),
                               DrinkItem(name: "coffee", amount:  180),
                               DrinkItem(name: "water", amount:  200),
                               DrinkItem(name: "soda", amount:  200),
                               DrinkItem(name: "water", amount:  200)]
struct PieView : View {
    
    @StateObject var dayInfoVM = PieDateVM(dayInfo: DayItem(date: Date(), drinkItems: tempDrinks))
    
    var body: some View{
        VStack{
            Pie(pieDateVM: dayInfoVM)
                .frame(width: 390,height: 300)
        }
    }
}


struct PieView_Previews: PreviewProvider {
    static var previews: some View {
        PieView()
    }
}

