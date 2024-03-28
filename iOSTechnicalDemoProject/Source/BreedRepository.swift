//
//  BreedRepository.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 23/03/2024.
//

import Foundation

protocol Repository {
    func getSelectedBreed(with breedID: String) async throws -> [SelectedBreed]
    func getBreedsWithImages() async throws -> [Breed]
    func getBreedsData() async throws -> [Breed]
}

class BreedRepository: Repository {
    
    private let breedDataFetcher: BreedDataFetcherable
    private var allBreedCache: Cache<String, AllBreedsAPIResponse>
    private var selectedBreedCache: Cache<String, APISelectedBreedResponse>
 
    init(dataFetcher: BreedDataFetcherable = DIContainer.shared.resolve(type: BreedDataFetcherable.self)) {
        self.breedDataFetcher = dataFetcher
        self.allBreedCache = Cache<String, AllBreedsAPIResponse>()
        self.selectedBreedCache = Cache<String, APISelectedBreedResponse>()
    }
    
    func getBreedsData() async throws -> [Breed] {
        if let cachedBreeds = allBreedCache[AppConstants.cacheAllBreedsKey] {
            return cachedBreeds
        }
        
        let breedsData = try await breedDataFetcher.fetchBreedsData()
        return breedsData
    }
 
    func getBreedsWithImages() async throws -> [Breed] {
        let breeds = try await  getBreedsData() // At this point all data needed to populate the listView is been retrieved
        
        // Errors are ignored as there is a placeholder image that will be used. 
        let (breedsWithImageUrl, _) = await breedDataFetcher.fetchBreedsImageURL(with: breeds)
        let (breedsWithImage, _) =  await breedDataFetcher.fetchImageAndAdd(to: breedsWithImageUrl)

        allBreedCache.insert(breedsWithImage, forKey: AppConstants.cacheAllBreedsKey)
        return breedsWithImage
    }
    
    
    func getSelectedBreed(with breedID: String) async throws -> [SelectedBreed] {
        if let selectBreed = selectedBreedCache[breedID] {
            return selectBreed
        }

        let response = try await breedDataFetcher.fetchSelectedBreed(with: breedID, limit: "10")
        let addImagesRessponse = try await breedDataFetcher.fetchImagesForSelectedBreed(to: response)
        selectedBreedCache.insert(addImagesRessponse, forKey: breedID)
        return addImagesRessponse

    }
}
