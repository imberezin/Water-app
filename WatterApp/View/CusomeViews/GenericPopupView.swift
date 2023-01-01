//
//  GenericPopupView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 26/12/2022.
//
// based on: https://exyte.com/blog/swiftui-tutorial-popupview-library


import SwiftUI

public struct Popup<PopupContent>: ViewModifier where PopupContent: View {
    
    init(isPresented: Binding<Bool>,
         view: @escaping () -> PopupContent, onClose: @escaping  ()->Void = {}) {
        self._isPresented = isPresented
        self.onClose = onClose
        self.view = view
    }
    
    /// Controls if the sheet should be presented or not
    @Binding var isPresented: Bool
    
    /// The content to present
    var view: () -> PopupContent
    
    var onClose: ()->Void
    // MARK: - Private Properties
    /// The rect of the hosting controller
    @State private var presenterContentRect: CGRect = .zero

    /// The rect of popup content
    @State private var sheetContentRect: CGRect = .zero

    /// The offset when the popup is displayed
    private var displayedOffset: CGFloat {
        -presenterContentRect.midY + screenHeight/2
    }

    /// The offset when the popup is hidden
    private var hiddenOffset: CGFloat {
        if presenterContentRect.isEmpty {
            return 1000
        }
        return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
    }

    /// The current offset, based on the "presented" property
    private var currentOffset: CGFloat {
        return isPresented ? displayedOffset : hiddenOffset
    }
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }

    private var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect)
                ZStack {
                
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            dismiss()
                        }
                    }
                
                    .frame(width: screenWidth)
                    self.view()
                        .animation(Animation.easeOut(duration: 0.3), value: currentOffset)
                
            }
            .offset(x: 0, y: isPresented ?  displayedOffset : 1000)
        }

    }

    private func dismiss() {
        isPresented = false
        onClose()
    }
    
}

//struct GenericPopupView_Previews: PreviewProvider {
//    static var previews: some View {
//        GenericPopupView()
//    }
//}
