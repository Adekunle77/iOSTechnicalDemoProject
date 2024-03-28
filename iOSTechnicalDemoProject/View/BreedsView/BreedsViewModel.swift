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

    func getBreedsWithImages() async throws -> [Breed] {
        let breeds = try await breedRepository.getBreedsWithImages()
        return breeds     
    }

    func getRandomBreedInfo() async throws -> (String, String) {
        let breeds = try await breedRepository.getBreedsData()
        if let randomBreed = breeds.randomElement() {
            let breedName = randomBreed.name
            let breedInfo = addAndBeforeLastWord(in: randomBreed.temperament)
            return (breedName, breedInfo)
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No breed found"])
    }

    private func addAndBeforeLastWord(in string: String) -> String {
        var words = string.components(separatedBy: ", ")
        if let last = words.last, words.count > 1 {
            words.removeLast()
            words.append("and \(last)")
        }
        return words.joined(separator: ", ")
    }
}
