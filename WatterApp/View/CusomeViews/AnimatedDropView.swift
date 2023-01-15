//
//  AnimatedDropView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 15/01/2023.
//

import SwiftUI

struct AnimatedDropView: View {
    @State var progress: CGFloat = 0.1
    @State var startAnimation: CGFloat = 0
    
    @Binding var showView: Bool
    
    var body: some View {
        GeometryReader{ proxy in
           
            let size = proxy.size
            
            ZStack{
                Image(systemName: "drop.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .scaleEffect(x:1.1, y:1)
                    .offset(y: -1)
                
                WaterWave(progress: progress, waveHeight: 0.1, offset: startAnimation)
                    .foregroundColor(.blue)
                    .overlay(content: {
                        ZStack{
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 15,height: 15)
                                .offset(x:-20)
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 15,height: 15)
                                .offset(x:40, y:30)
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 25,height: 25)
                                .offset(x:-30, y:80)
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 25,height: 25)
                                .offset(x:50, y:70)
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width:10 ,height: 100)
                                .offset(x:40, y:100)

                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 10,height: 10)
                                .offset(x:-40, y:50)

                        }
                    })
                    .mask{
                        Image(systemName: "drop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                    }
                
            }
            .frame(width: size.width, height: size.height, alignment: .center)
            .onAppear{
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)){
                    startAnimation = size.width
                }
                Task{

                    for value in stride(from: 0, to: 1, by: 0.05){
                                            // Delay the task by 1 second:

                        try await Task.sleep(seconds: 0.25)
                        progress += value

                        if progress > 0.95{
                            withAnimation(.default.delay(0.5).speed(0.5)) {
                                
                                showView = false
                            }
                        }
                    }
                }
            }
        }.frame(height: 350)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color("azureColor"))
            .transition(showView ? .move(edge: .bottom) : .move(edge: .top))

           
    }
}

struct AnimatedDropView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedDropView(showView: .constant(true))
        
    }
}


struct WaterWave: Shape {
    
    var progress : CGFloat
    var waveHeight: CGFloat
    
    var offset: CGFloat
    
    
    var animatableData: CGFloat{
        get {offset}
        set {offset = newValue}
    }
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            path.move(to: .zero)
            
            let progressHeight: CGFloat = (1-progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2){
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees:value + offset).radians)
                let y: CGFloat = progressHeight + (height*sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
                
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
