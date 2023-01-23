//
//  ViewExtensions.swift
//  WatterApp
//
//  Created by IsraelBerezin on 26/12/2022.
//

import Foundation
import SwiftUI



extension View {
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }

    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        view: @escaping () -> PopupContent, onClose:  @escaping ()->Void = {}) -> some View {
        self.modifier(
            Popup(
                isPresented: isPresented,
                view: view, onClose: onClose)
        )
    }
        
    func backgroundCaption() -> some View {
        modifier(BackgroundGroupCaption())
    }
    
    func backgroundPopupCaption() -> some View {
        modifier(BackgroundPopupCaption())
    }

}


struct FrameGetter: ViewModifier {
  
    @Binding var frame: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.frame = rect
                        }
                    }
                return AnyView(EmptyView())
            })
    }
}
