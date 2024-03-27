//
//  SelectedBreedViewModel.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 24/03/2024.
//

import Foundation

class SelectedBreedViewModel {
    
    let repository: Repository
    
    init(repository: Repository =  DIContainer.shared.resolve(type: Repository.self)) {
        self.repository = repository
    }

    func getSelectBreed(with breedID: String) async throws -> [SelectedBreed]  {
        try await repository.getSelectedBreed(with: breedID)
      
    }
    
}
