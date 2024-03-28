//
//  BreedsView.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 20/03/2024.
//

import SwiftUI

struct BreedsView: View {
    private var viewModel = BreedsViewModel()
    @State private var breeds = [Breed]()
    @State private var isLoading = true
    @State private var showError = false
    @State private var error: Error?
    @State private var selectedBreedItem: Breed?
    @State private var isSelectedBreedView = false
    @State private var isLaunchScreen = false
    @State private var randomBreedName = ""
    @State private var breedTemperament = ""
    
    var body: some View {
        Spacer()
        VStack {
            if isLoading {
                VStack {
                    Text("Did you know that \(randomBreedName) breed\n are\n\(breedTemperament)")
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .padding(.horizontal, 12)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .frame(width: 100, height: 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
                
            } else {
                Text("Select a cat")
                    .font(.system(size: 35, weight: .regular, design: .default))
                    .padding(.top, 50)

                List {
                    ForEach(breeds.indices, id: \.self) { index in
                        let breed = breeds[index]
                        BreedItem(breed: breed) { breed in
                            selectedBreedItem = breed
                            isSelectedBreedView = true
                        }
                        .padding(.vertical, 10)
                        .listRowSeparator(.visible)
                    }
                }
            }
            
            if let selectedBreedItem = selectedBreedItem {
                NavigationLink(destination: SelectedBreedView(breed: selectedBreedItem), isActive: $isSelectedBreedView) { EmptyView() }
            }
        }
        NavigationLink(destination: LaunchScreen().navigationBarHidden(true), isActive: $isLaunchScreen) { EmptyView() }
            .task {
                do {
                    async let breedInfo = viewModel.getRandomBreedInfo()
                    let (name, temperament) = try await breedInfo
                    randomBreedName = name
                    breedTemperament = temperament
                    breeds = try await viewModel.breedRepository.getBreedsWithImages().sorted { $0.name < $1.name }

                 
                    isLoading = false
                } catch {
                    self.error = error
                    showError = true
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("\(error?.localizedDescription ?? "Unknown error")"), dismissButton: .default(Text("OK"), action: {
                    isLaunchScreen.toggle()
                }))
            }
    }
}


struct SelectBreedView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
            BreedsView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

