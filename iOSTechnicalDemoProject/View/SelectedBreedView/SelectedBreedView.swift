//
//  SelectedBreedView.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 24/03/2024.
//

import SwiftUI

struct SelectedBreedView: View {
    private var viewModel = SelectedBreedViewModel()
    @State private var selectedBreed = [SelectedBreed]()
    @State private var isLoading = true
    @State private var showError = false
    @State private var isBreedsView = false
    @State private var error: Error?
    
    let breed: Breed
    
    init(breed: Breed) {
        self.breed = breed
    }
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Loading...")
                    .font(.system(size: 25, weight: .regular, design: .default))
                    .padding(.bottom, 10)
                Text("Loading...")
                    .padding(.horizontal, 15)
                
                HStack {
                    Text("Origin:")
                        .font(.system(size: 10))
                    Text("Loading...")
                        .font(.system(size: 14))
                }.padding(.top, 10)
                
                List {
                    ForEach(0..<10) { _ in
                        PlaceHolderSelectedBreedItem()
                    }
                }
            } else {
                if let breedInfo = selectedBreed.first?.breeds?.first {
                    Text(breedInfo.name)
                        .font(.system(size: 25, weight: .regular, design: .default))
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    Text(breedInfo.description)
                        .padding(.horizontal, 15)
                    
                    HStack {
                        Text("Origin:")
                            .font(.system(size: 10))
                        Text(breedInfo.origin)
                            .font(.system(size: 14))
                    }.padding(.top, 10)
                    
                }
                List {
                    ForEach(selectedBreed.indices, id: \.self) { index in
                        let breed = selectedBreed[index]
                        
                        if let imageData = breed.downloadedImageData, let uiImage = UIImage(data: imageData) {
                            SelectedBreedItem(breedImage: Image(uiImage: uiImage))
                                .padding(.vertical, 10)
                                .listRowSeparator(.visible)
                        }
                    }
                }
            }
            WideButton(backgroundColor: .clear,title: "Select another cat", borderSytle: BorderSytle(Color.black, width: 2.0)) {
                isBreedsView.toggle()
            }.padding(.bottom, 20)
        }.task {
            do {
                selectedBreed = try await viewModel.getSelectBreed(with: breed.id)
                isLoading = false
            } catch {
                self.error = error
                showError = true
            }
        }
        NavigationLink(destination: BreedsView().navigationBarHidden(true), isActive: $isBreedsView) { EmptyView() }
            .navigationBarHidden(true)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("\(error?.localizedDescription ?? "Unknown error")"), dismissButton: .default(Text("OK")))
            }
    }
}

struct SelectedBreedView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
            SelectedBreedView(breed: dummyBreed())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
