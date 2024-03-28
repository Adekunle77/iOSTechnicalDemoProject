//
//  PlaceHolderSelectedBreedItem.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 27/03/2024.
//

import SwiftUI

struct PlaceHolderSelectedBreedItem: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.7, alignment: .center)
                .padding(.leading, UIScreen.main.bounds.width * 0.05)
            ProgressView()
                .scaleEffect(1.5, anchor: .center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .padding(.bottom, 20)
        }
    }
}

struct PlaceHolderSelectedBreedItem_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
            PlaceHolderSelectedBreedItem()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
