//
//  ChartsView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 01/12/2022.
//

import SwiftUI
import Charts

struct ChartsView: View {
    
    var days: [DayItem]
    
    @State var fullDays: [DayItem] = [DayItem]()
        
    var body: some View {
        VStack{
            if fullDays.count > 0{
                Chart {
                    ForEach(fullDays, id: \.id) { item in
                        BarMark(
                            x: .value("Date", item.date.getGregorianDate(dateFormat: "d.MM")),
                            y: .value("Value", item.total)
                        )
                        .cornerRadius(10, style: .continuous)
                        .annotation(position: .top) {
                            if item.total > 0{
                                Image(systemName: "drop")
                                    .imageScale(.large)
                                    .foregroundColor(.indigo)
                            }else{
                                EmptyView()
                            }
                        }
                    }
                    
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        //                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                        //                        .foregroundStyle(Color.cyan)
                        //                    AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
                        //                        .foregroundStyle(Color.red)
                        AxisValueLabel() {
                            if let dateValue = value.as(String.self) { // HERE
                                Text(dateValue)//.formatted(date: .abbreviated, time: .omitted))
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(maxWidth:50)
                            }
                        }
                    }
                }
                .frame(height: 300)
                .padding()
            }else{
                EmptyView()
            }
        }
        .onAppear{
            self.buildFullWeek()
        }
        
    }
    
    func buildFullWeek(){
        var tempItems = [DayItem]()

        let date = Date().startOfWeek()
        for index in 0 ..< 7{
            let a = DayItem(date: date.daysAfter(number: index), drink: nil)
            tempItems.append(a)

        }
        
        for day in days {
            let dayInWeek = (day.date.dayNumberInTheWeek() ?? 1) - 1
            if dayInWeek < tempItems.count{
                tempItems[dayInWeek] = day
            }
            
        }

        DispatchQueue.main.async {
            self.fullDays = tempItems
        }
    }
}

struct ChartsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        StatisticsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}



//                self.fullDays = tempItem
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                //   self.show = true
//
//                for (index, _) in tempItems.enumerated(){
//                    //                        withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index)*0.05)){
//                    ////                            self.fullDays[index].animation = true
//                    //                            self.fullDays.append(tempItems[index])
//                    //
//                    //                        }
//                    withAnimation(.linear(duration: 0.3).delay(Double(index)*0.05)){
//                        //                            self.fullDays[index].animation = true
//                        self.fullDays.append(tempItems[index])
//
//                    }
//
//                }
//            }
