//
//  ImageView.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 27/03/2024.
//

import SwiftUI

struct ImageView: View {
    let imageURL: String
    var backUpImage: String?
    @Binding var isImageVisible: Bool
    init(imageURL: String, backUpImage: String? = nil, isImageVisible: Binding<Bool>) {
        self.imageURL = imageURL
        self.backUpImage = backUpImage
        self._isImageVisible = isImageVisible
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .opacity(isImageVisible ? 1 : 0)
                                .onAppear {
                                    withAnimation(.easeIn(duration: 1)) {
                                        isImageVisible = true
                                    }
                                }
                        case .failure:
                            if let backUpImage = backUpImage {
                                Image(backUpImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .clipped()
                                    .opacity(isImageVisible ? 1 : 0)
                                    .onAppear {
                                        withAnimation(.easeIn(duration: 1)) {
                                            isImageVisible = true
                                        }
                                    }
                            }
                        default:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
            ImageView(imageURL: "www.catImage.com", backUpImage: "catOnTree", isImageVisible: .constant(true))
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
