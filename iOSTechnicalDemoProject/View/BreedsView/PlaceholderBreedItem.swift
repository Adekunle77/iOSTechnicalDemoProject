//
//  PlaceholderBreedItem.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 26/03/2024.
//

import SwiftUI

struct PlaceholderBreedItem: View {
    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 100, height: 100, alignment: .center)
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .padding()
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Loading...")
                    .font(.system(size: 22))
                    .bold()
                    .padding(.bottom, 4)
                HStack {
                    Text("Origin:")
                        .font(.system(size: 10))
                    Text("Loading...")
                        .font(.system(size: 14))
                }
            }
            .frame(width: 200, alignment: .leading)
            .fixedSize()
        }
    }
}

struct PlaceholderBreedItem_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
            PlaceholderBreedItem()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
