//
//  BreedsViewModel.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 20/03/2024.
//

import Foundation

class BreedsViewModel {
    let breedRepository: Repository

    init(repository: Repository =  DIContainer.shared.resolve(type: Repository.self)) {
        self.breedRepository = repository
    }

    func fetchBreeCollection() async throws -> [Breed] {
        let breeds = try await breedRepository.getBreedsWithImages()
        return breeds.sorted { $0.name < $1.name }
       
    }
}
