//
//  PieSliceView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 08/12/2022.
//

import Foundation
import SwiftUI

struct PieSliceView: View {
    
    let piece: PieDateUnit
    
    var midRadians: Double {
        let start = Angle(degrees: piece.start)
        let end  = Angle(degrees: piece.end)
        return Double.pi / 2.0 - (start + end).radians / 2.0
    }
    
    var body: some View {
        
        let degrees = String(format: "%.1f", piece.percent)
        
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    
                    let center = CGPoint(x: width * 0.5, y: height * 0.5)
                    
                    path.move(to: center)
                    
                    path.addArc(
                        center: center,
                        radius: width * 0.45,
                        startAngle: Angle(degrees: -90.0) + Angle(degrees: piece.start),
                        endAngle: Angle(degrees: -90.0) + Angle(degrees: piece.end)
                        ,
                        clockwise: false)
                    
                }
                .fill(piece.color)
                
                Text("\(degrees)%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .position(
                        x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.65 * cos(self.midRadians)),
                        y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.75 * sin(self.midRadians))
                    )
                    .foregroundColor(Color.white)
            }

        }
        .aspectRatio(1, contentMode: .fit)
    }
        
}
