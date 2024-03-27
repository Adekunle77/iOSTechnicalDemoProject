//
//  LaunchScreenViewModel.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 21/03/2024.
//

import Combine
import Foundation

class LaunchScreenViewModel: ObservableObject {
    var api: Networkable
    @Published var imageURL = ""

    init(api: Networkable = DIContainer.shared.resolve(type: Networkable.self)) {
        self.api = api
    }
    
    func fetchImage() async throws {
        do {
            let response: APISelectedBreedResponse = try await api.fetchData(endpoint: BreedsEndpoint.randomImage)
            guard let url = response.first?.url else { return }
            DispatchQueue.main.async { [weak self] in
                self?.imageURL = url
            }
        } catch {
            throw error
        }
    }
}
