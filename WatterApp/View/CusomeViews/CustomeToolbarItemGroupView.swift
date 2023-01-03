//
//  CustomeToolbarItemGroupView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 03/01/2023.
//

import SwiftUI

struct CustomeToolbarItemGroupView: View {
    
    var checkoutInFocus: FocusState<CheckoutFocusable?>.Binding
    var completion: (CheckoutFocusable)->Void
    
    init(checkoutInFocus: FocusState<CheckoutFocusable?>.Binding, completion: @escaping  (CheckoutFocusable)->Void) {
        self.completion = completion
        self.checkoutInFocus = checkoutInFocus
    }

    var body: some View {
       // let _ = print("self.checkoutInFocus = \(self.checkoutInFocus)")
        if self.checkoutInFocus.wrappedValue == nil || self.checkoutInFocus.wrappedValue == .amountType{
                Spacer()

                Button("Close") {
                    print("close Keybord")
                    checkoutInFocus.wrappedValue = .none
                }
                
            }else{
                Button("Close") {
                    print("close Keybord")
                    checkoutInFocus.wrappedValue = .none
                }
                
                Spacer()
                
                Button(checkoutInFocus.wrappedValue == .customTotalType ? "Done" : "Next") {
                    print("Next Keybord")
                    toggleFocus()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let checkoutInFocus = self.checkoutInFocus.wrappedValue {
                            // print(self.checkoutInFocus!.rawValue)
                            completion(checkoutInFocus)
                        }
                        
                    }
                }
            }
        }
    
    
    func toggleFocus(){
        if checkoutInFocus.wrappedValue == .fullNameType {
            checkoutInFocus.wrappedValue = .heightType
        } else if checkoutInFocus.wrappedValue == .heightType {
            checkoutInFocus.wrappedValue = .weightType
        } else if checkoutInFocus.wrappedValue == .weightType {
            checkoutInFocus.wrappedValue = .ageType
        }else if checkoutInFocus.wrappedValue == .ageType {
            checkoutInFocus.wrappedValue = .customTotalType
        }else{
            checkoutInFocus.wrappedValue = .none
        }
    }
}

//struct CustomeToolbarItemGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomeToolbarItemGroupView()
//    }
//}
