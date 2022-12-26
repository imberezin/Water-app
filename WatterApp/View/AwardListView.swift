//
//  AwardListView.swift
//  WatterApp
//
//  Created by IsraelBerezin on 25/12/2022.
//

import SwiftUI


struct AwardListView: View {
    
    
    @StateObject var awardListViewVM = AwardListViewVM()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Image(systemName: "medal")
                Text("Awards")
            }
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(Array(zip(self.awardListViewVM.awardslist.indices, self.awardListViewVM.awardslist)), id: \.0) { index, item in

                        ListItemView(awardItem: item, index:index)
                        
                        
                    }
                }
            }
        }
        .onAppear{
            self.awardListViewVM.updateAwardslist()
        }
    }
    
    @ViewBuilder
    func ListItemView(awardItem: AwardItem, index: Int)-> some View{
        ZStack(alignment: .bottom){
            
            let oldImage = UIImage(named: awardItem.imageName)
            
            let newImage = awardListViewVM.awardsIndexs[index] ? oldImage!.maskWithColor(color: .red) : oldImage

            Image(uiImage: newImage!)
                .resizable()
                .clipShape(Circle())
                .frame(width: 90,height: 90)
            
            Text(awardItem.awardName)
                .frame(width: 90,height: 25,alignment: .center)
                .background(Color("azureColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}




struct AwardListView_Previews: PreviewProvider {
    static var previews: some View {
//        AwardListView()
//            .frame(height: 100)
        
        SettingsView()

    }
}


struct AwardItem: Identifiable{
    let id: String = UUID().uuidString
    let imageName: String
    let awardName: String
    var active: Bool = false
    
    init(imageName: String, awardName: String, active: Bool = false) {
        self.imageName = imageName
        self.awardName = awardName
        self.active = active
    }
}




//https://stackoverflow.com/a/48276943/1571228
extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
