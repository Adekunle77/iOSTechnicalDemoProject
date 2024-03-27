//
//  SelectedBreedItem.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 25/03/2024.
//

import SwiftUI

struct SelectedBreedItem: View {
    
    var breedImage: Image
    
    init(breedImage: Image) {
        self.breedImage = breedImage
    }
    
    var body: some View {
        breedImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.7, alignment: .center)
            .clipped()
            .padding(.leading, UIScreen.main.bounds.width * 0.05)
            

    }
}

//struct SelectedBreedItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
//            SelectedBreedItem(breedImage: Image("catOnTree"))
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//        }
//    }
//}
