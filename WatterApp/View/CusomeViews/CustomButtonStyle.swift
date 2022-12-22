//
//  CustomButtonStyle.swift
//  ChitatApp
//
//  Created by IsraelBerezin on 24/11/2022.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var foreground: Color
    var background: Color
    
    init(foreground: SwiftUI.Color = Color.white, background: SwiftUI.Color = Color.blue) {
        self.foreground = foreground
        self.background = background
    }
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        MyButton(foreground: foreground, background: background, configuration: configuration)
    }
    
    struct MyButton: View {
        var foreground: Color
        var background: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .foregroundColor(isEnabled ? foreground : foreground.opacity(0.5))
                .padding()
                .frame(maxWidth: .infinity)
                .background(isEnabled ? background : background.opacity(0.5))
                .border(isEnabled ? background : background.opacity(0.5), width: 2)
                .cornerRadius(8)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }
}


