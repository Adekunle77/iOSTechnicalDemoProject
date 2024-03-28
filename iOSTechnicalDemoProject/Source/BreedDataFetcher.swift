//
//  BreedDataFetcher.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 27/03/2024.
//

import Foundation

protocol BreedDataFetcherable {
    func fetchBreedsData() async throws -> [Breed]
    func fetchBreedsImageURL(with breeds: [Breed]) async -> ([Breed], [Error])
    func fetchImageAndAdd(to breeds: [Breed]) async -> ([Breed], [Error])
    func fetchSelectedBreed(with breedID: String, limit: String) async throws -> [SelectedBreed]
    func fetchImagesForSelectedBreed(to selectedBreeds: [SelectedBreed]) async throws -> [SelectedBreed]
}

class BreedDataFetcher: BreedDataFetcherable {
    
    private let api: Networkable
    private var downloadTasks: [URL: Task<Data, Error>] = [:]
    private var fetchTasks: [String: Task<String, Error>] = [:]
    
    init(api: Networkable = DIContainer.shared.resolve(type: Networkable.self)) {
        self.api = api
    }
    
    func fetchBreedsData() async throws -> [Breed] {
        let breeds: AllBreedsAPIResponse = try await api.fetchData(endpoint: BreedsEndpoint.allBreeds)
        return breeds
    }
    
    func fetchBreedsImageURL(with breeds: [Breed]) async -> ([Breed], [Error]) {
        var breedsArray = [Breed]()
        var errorsArray = [Error]()
        await withTaskGroup(of: (Breed, Error?).self) { group in
            for breed in breeds {
                group.addTask {
                    var breedCopy = breed
                    
                    guard let url = breedCopy.url else {
                        return (breedCopy, nil)
                    }
                    do {
                        let imageURL = try await self.getImageURL(with: url)
                        breedCopy.imageURL = imageURL
                        return (breedCopy, nil)
                    } catch {
                        print("Error while downloading \(url)", error)
                        return (breedCopy, error)
                    }
                }
            }
            
            for await (breed, error) in group {
                breedsArray.append(breed)
                if let error = error {
                    errorsArray.append(error)
                }
            }
        }
        return (breedsArray, errorsArray)
    }
    
    func fetchImageAndAdd(to breeds: [Breed]) async -> ([Breed], [Error]) {
        var breedsArray = [Breed]()
        var errorsArray = [Error]()
        await withTaskGroup(of: (Breed, Error?).self) { group in
            for breed in breeds {
                group.addTask {
                    var breedCopy = breed
                    
                    guard let url = breedCopy.imageURL else {
                        return (breedCopy, nil)
                    }
                    
                    do {
                        breedCopy.downloadedImageData = try await self.downloadImage(with: url)
                        return (breedCopy, nil)
                    } catch {
                        print("Error while downloading \(url)", error)
                        return (breedCopy, error)
                    }
                }
            }
            
            for await (breed, error) in group {
                breedsArray.append(breed)
                if let error = error {
                    errorsArray.append(error)
                }
            }
        }
        return (breedsArray, errorsArray)
    }
    
    func fetchImagesForSelectedBreed(to selectedBreeds: [SelectedBreed]) async throws -> [SelectedBreed] {
        var selectedBreedArray = [SelectedBreed]()
        try await withThrowingTaskGroup(of: SelectedBreed.self) { group in
            for selectedBreed in selectedBreeds {
                group.addTask {
                    var selectedBreedbreedCopy = selectedBreed
                    selectedBreedbreedCopy.downloadedImageData = try await self.downloadImage(with: selectedBreedbreedCopy.url)
                    return selectedBreedbreedCopy
                }
            }
            for try await selectedBreed in group {
                selectedBreedArray.append(selectedBreed)
            }
        }
        return selectedBreedArray
    }
    
    func fetchSelectedBreed(with breedID: String, limit: String) async throws -> [SelectedBreed]  {
        let selected: APISelectedBreedResponse = try await api.fetchData(endpoint: BreedsEndpoint.selectedBreed(limit: limit, breedIds: breedID))
        return selected
    }
    
    private func downloadImage(with imageUrl: String) async throws -> Data {
        guard let url = URL(string: imageUrl) else {
            throw EndpointError.invalidURL
        }
        
        if let existingTask = downloadTasks[url] {
            return try await existingTask.value
        } else {
            let downloadTask = Task { [weak self] () -> Data in
                guard let self = self else { throw EndpointError.apiInstanceDeallocated }
                let data: Data = try await self.api.downloadData(from: url)
                return data
            }
            
            downloadTasks[url] = downloadTask
            
            do {
                let data = try await downloadTask.value
                downloadTasks[url] = nil
                return data
            } catch {
                downloadTasks[url] = nil
                throw error
            }
        }
    }
    
    private func getImageURL(with url: String) async throws -> String {
        
        if let existingTask = fetchTasks[url] {
            return try await existingTask.value
        } else {
            let fetchTask = Task { [weak self] () -> String in
                guard let self = self else { throw EndpointError.apiInstanceDeallocated }
                let imageUrl: SelectedBreed = try await self.api.fetchData(endpoint: BreedsEndpoint.imageURL(url: url))
                return imageUrl.url
            }
            
            fetchTasks[url] = fetchTask
            
            do {
                let imageUrl = try await fetchTask.value
                fetchTasks[url] = nil
                return imageUrl
            } catch {
                fetchTasks[url] = nil
                throw error
            }
        }
    }
}
