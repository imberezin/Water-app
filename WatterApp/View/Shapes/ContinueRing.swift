//
//  ContinueRing.swift
//  WatterApp
//
//  Created by IsraelBerezin on 04/12/2022.
//

import Foundation
import SwiftUI



struct ContinueRing: View{
    
    var cureentNumber: Int
    let total: Float
    
    let colors = [Color("azureColor").opacity(0.55),Color("azureColor").opacity(0.70),Color("azureColor").opacity(0.85),Color("azureColor").opacity(1.0)]
    
    
    let colors1 = [Color.blue.opacity(0.25),Color.blue.opacity(1.0)]//,Color.blue.opacity(0.60),Color.blue.opacity(0.80)]

    let ringFrame: CGSize
    
    var body: some View {
        
        let progressValue:Double = Double(cureentNumber) / Double(total)
        
        VStack {
            
            GeometryReader{ geo in
                ActivityRing(progress: progressValue, lineWidth: geo.size.width/10, gradient: Gradient(colors: colors1))
            }
//                .frame(width: 250.0, height: 250.0)
            .frame(width: ringFrame.width, height: ringFrame.height)
                .padding(40.0)
            VStack(alignment: .center, spacing: 8.0){
                Text("You drank")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.blue)
                
                Text("\(cureentNumber)ml")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)

                Text("of a \(Int(total))ml today")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.blue)

            }
            
            
        }
    }
}



/// Base activity ring
struct ActivityRing: View {
    var progress: Double
    var lineWidth: CGFloat
    var gradient: Gradient
    
    @State private var waveOffset = Angle(degrees: 0)

    var body: some View {
        
        
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    gradient.stops.last!.color,
                    style: .init(lineWidth: lineWidth)
                )
                .opacity(0.1)
            // Main ring
            Circle()
                .rotation(.degrees(-90))
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    angularGradient(),
                    style: .init(lineWidth: lineWidth, lineCap: .round)
                )
                .overlay(
                    GeometryReader { geometry in
                        // End round butt and shadow
                        Circle()
                            .fill(endButtColor())
                            .frame(width: self.lineWidth, height: self.lineWidth)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            .offset(x: min(geometry.size.width, geometry.size.height)/2)
                            .rotationEffect(.degrees(self.progress * 360 - 90))
                            .shadow(color: .black, radius: self.lineWidth/4, x: 0, y: 0)
                    }
                    .clipShape(
                        // Clip end round line cap and shadow to front
                        Circle()
                            .rotation(.degrees(-90 + self.progress * 360 - 0.5))
                            .trim(from: 0, to: 0.25)
                            .stroke(style: .init(lineWidth: self.lineWidth))
                    )
                )
                .animation(.linear, value: self.progress)

            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()

        }
//        .overlay(
//            Wave1(offset: Angle(degrees: self.waveOffset.degrees), percent: Double(self.progress))
//                .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
//                .clipShape(Circle().scale(0.92))
//                .animation(Animation.linear(duration: 3), value: self.progress)
//        )
//        .onAppear {
//            withAnimation(Animation.linear(duration: 3)){//.repeatForever(autoreverses: false)) {
//                        self.waveOffset = Angle(degrees: 360)
//                    }
//                }
        


//        .scaledToFit()
        .padding(lineWidth/2)
    }
    
    func angularGradient() -> AngularGradient {
        return AngularGradient(gradient: gradient, center: .center, startAngle: .degrees(-90), endAngle: .degrees((progress > 0.5 ? progress : 0.5) * 360 - 90))
    }
    
    func endButtColor() -> Color {
        let color = progress > 0.5 ? gradient.stops.last!.color : gradient.stops.first!.color.interpolateTo(color: gradient.stops.last!.color, fraction: 2 * progress)
        return color
    }
    
    
}


extension Color {
    var components: (r: Double, g: Double, b: Double, o: Double)? {
        let uiColor: UIColor
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        if self.description.contains("NamedColor") {
            let lowerBound = self.description.range(of: "name: \"")!.upperBound
            let upperBound = self.description.range(of: "\", bundle")!.lowerBound
            let assetsName = String(self.description[lowerBound..<upperBound])
            
            uiColor = UIColor(named: assetsName)!
        } else {
            uiColor = UIColor(self)
        }

        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &o) else { return nil }
        
        return (Double(r), Double(g), Double(b), Double(o))
    }
    
    func interpolateTo(color: Color, fraction: Double) -> Color {
        let s = self.components!
        let t = color.components!
        
        let r: Double = s.r + (t.r - s.r) * fraction
        let g: Double = s.g + (t.g - s.g) * fraction
        let b: Double = s.b + (t.b - s.b) * fraction
        let o: Double = s.o + (t.o - s.o) * fraction
        
        return Color(red: r, green: g, blue: b, opacity: o)
    }
}




struct ProgressBar: View {
    var progress: Float
    
    let colors = [Color("azureColor").opacity(0.55),Color("azureColor").opacity(0.70),Color("azureColor").opacity(0.85),Color("azureColor").opacity(1.0)]
    
    
    let colors1 = [Color.blue.opacity(0.20),Color.blue.opacity(0.40),Color.blue.opacity(0.60),Color.blue.opacity(0.80)]
    
//    let colors1 = [Color("ColorBlue1"),Color("ColorBlue2"),Color("ColorBlue3")]

    
    func angularGradient() -> AngularGradient {
        return AngularGradient(
            gradient: Gradient(colors: colors1),
            center: .center,
            startAngle: .degrees(-90),
            endAngle: Angle(degrees: 360 * Double(progress)) //.degrees((progress > 0.5 ? Double(progress) : 0.5) * 360 - 90)
        )
    }

    var body: some View {
        
        
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.4)
                .foregroundColor(Color("azureColor"))
                .shadow(color: Color("azureColor"), radius: 5, x: 0, y: 3)
            
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(
                    angularGradient(),
                    style: StrokeStyle(lineWidth: 20.0,
                                       lineCap: .round,
                                       lineJoin: .round))
            
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: self.progress)
            
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
            
        }
    }
}
