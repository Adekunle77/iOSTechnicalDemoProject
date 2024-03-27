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
    
    var body: some View {
        Spacer()
        VStack {
            Text("Select a cat")
                .font(.system(size: 35, weight: .regular, design: .default))
                .padding(.top, 50)
            if isLoading {
                List {
                    ForEach(0..<10) { _ in
                        PlaceholderBreedItem()
                    }
                }
                
            } else {
                
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
                    breeds = try await viewModel.fetchBreeCollection()
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


//struct SelectBreedView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
//            BreedsView()
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//        }
//    }
//}


