//
//  BreedItem.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 23/03/2024.
//

import SwiftUI

struct BreedItem: View {
    
    @State private var breedImage: Image? = nil
    var didTapMoreInfo: (Breed) -> ()
    var breed: Breed
    
    init(breed: Breed, didTapMoreInfo: @escaping (Breed) -> ()) {
        self.didTapMoreInfo = didTapMoreInfo
        self.breed = breed
    }
    
    var body: some View {
        HStack {
            if let breedImage = breedImage {
                breedImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipped()
                
            } else {
                Image("catVector")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipped()
                
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(breed.name)
                    .font(.system(size: 22))
                    .bold()
                    .padding(.bottom, 4)
                HStack {
                    Text("Origin:")
                        .font(.system(size: 10))
                    Text(breed.origin)
                        .font(.system(size: 14))
                }
            }
            .frame(width: 190, alignment: .leading)
            .fixedSize()
            Button(action: { self.didTapMoreInfo(self.breed) }) {
                Image(systemName: "chevron.right")
                
                
            }
        } .onAppear {
            if let imageData = breed.downloadedImageData, let uiImage = UIImage(data: imageData) {
                breedImage = Image(uiImage: uiImage)
            }
        }
    }
}

//struct BreedItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
//            BreedItem(breed: dummyBreed(), didTapMoreInfo: {_ in
//                print("Did tap more info button")
//            })
//            .previewDevice(PreviewDevice(rawValue: deviceName))
//            .previewDisplayName(deviceName)
//        }
//    }
//}


func dummyBreed() -> Breed {
    Breed(weight: Weight(imperial: "", metric: ""), id: "", name: "Breed Name", cfaURL: "", vetstreetURL: "", vcahospitalsURL: "", temperament: "", origin: "Country", countryCodes: "", countryCode: "", description: "", lifeSpan: "", indoor: 1, lap: 1, altNames: "", adaptability: 1, affectionLevel: 1, childFriendly: 1, dogFriendly: 1, energyLevel: 1, grooming: 1, healthIssues: 1, intelligence: 1, sheddingLevel: 1, socialNeeds: 1, strangerFriendly: 1, vocalisation: 1, experimental: 1, hairless: 1, natural: 1, rare: 1, rex: 1, suppressedTail: 1, shortLegs: 1, wikipediaURL: "", hypoallergenic: 1, referenceImageID: "", catFriendly: 1, bidability: 1)
}
