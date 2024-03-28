//
//  HomeScreen.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 21/03/2024.
//

import SwiftUI


struct LaunchScreen: View {
    
    @StateObject private var viewModel = LaunchScreenViewModel()
    @State private var isImageVisible = false
    @State private var error: Error?
    @State private var showError = false
    @State private var shouldNavigateToBreedsView = false
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 0) {
                ImageView(imageURL: viewModel.imageURL, backUpImage: "catOnTree", isImageVisible: $isImageVisible)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
                    .padding(.top, 100)
                NavigationLink(destination: BreedsView(), isActive: $shouldNavigateToBreedsView) { EmptyView() }
                
                VStack {
                    Text("Welcome to the world of cats!")
                        .font(.system(size: 25, weight: .regular, design: .default))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding(.top, 25)
                    if isImageVisible {
                        WideButton(backgroundColor: .clear,title: "Explore", borderSytle: BorderSytle(Color.black, width: 2.0)) {
                            shouldNavigateToBreedsView.toggle()
                        }.padding(.top, 50)
                        
                    }
                }
                Spacer()
            }
            .task {
                do {
                    try await viewModel.fetchImage()
                } catch {
                    self.error = error
                    showError = true
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("\(error?.localizedDescription ?? "Unknown error")"), dismissButton: .default(Text("OK")))
            }
            .navigationBarHidden(true)
        }
    }
}
