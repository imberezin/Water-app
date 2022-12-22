//
//  CustomButton.swift
//  ChitatApp
//
//  Created by IsraelBerezin on 24/11/2022.
//

import SwiftUI

struct CustomButton: View {
  var text: String
  var clicked: (() -> Void)

  var body: some View {
    Button(action: clicked) {
      HStack {
        Spacer()
        Text(text)
        Spacer()
      }
    }
    .buttonStyle(CustomButtonStyle())
    .padding()
  }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(text: "test", clicked: {})
    }
}
