//
//  CustomDropDown.swift
//  WatterApp
//
//  Created by IsraelBerezin on 17/01/2023.
//

import SwiftUI



struct CustomDropDownView: View {
    @State var selection: String = "low"
    var content = ["low","medime", "high"]
    
    var body: some View {
       VStack{
            CustomDropDown(content: content, selection: $selection, activeTint: Color.blue, inActiveTint: Color.gray, dynamic: false)
               .frame(width: 150)
           Spacer()

           CustomDropDown(content: content, selection: $selection, activeTint: Color.blue, inActiveTint: Color.gray, dynamic: true)
              .frame(width: 150)
           Spacer()

        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color.black.opacity(0.8).ignoresSafeArea()
            }
    }
}

struct CustomDropDown: View {
    var content: [String]
    @Binding var selection: String
    var activeTint: Color
    var inActiveTint: Color
    var dynamic: Bool = false
    
    @State var expandView: Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            let size  = geo.size
            VStack (spacing: 0){
                if !dynamic{
                    RowValue(selection, size)
                }
                    ForEach( content.filter{ dynamic ? true : $0 != selection},  id: \.self){ title in
                        RowValue(title, size)
                    }
                
            }
            .background{
                Rectangle()
                    .fill(inActiveTint)
            }
            .offset(y: dynamic ? (CGFloat (content.firstIndex(of: selection) ?? 0) * -55) : 0)
        }
        .frame(height: 55)
        .overlay(alignment: .trailing){
            Image(systemName: "chevron.up.chevron.down")
                .padding(.trailing, 10)
        }
        .mask(alignment: .top) {
            Rectangle()
                .frame(height:  expandView ? CGFloat(content.count) * 55 : 55)
                .offset(y: dynamic && expandView ? (CGFloat (content.firstIndex(of: selection) ?? 0) * -55) : 0)

        }
        
    }
    
    @ViewBuilder
    func RowValue(_ title:String, _ size: CGSize) -> some View{
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .frame(width: size.width, height: size.height, alignment: .leading)
            .background{
                if selection == title {
                    Rectangle()
                        .fill(activeTint)
                }
            }
            .containerShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                    if expandView{
                        expandView = false
                        if dynamic {
                            selection = title
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                                selection = title
                            }
                        }
                    }else{
                        if selection == title {
                            expandView = true
                        }
                    }
                }
            }
        
    }
}


struct CustomDropDownView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDropDownView()
    }
}
