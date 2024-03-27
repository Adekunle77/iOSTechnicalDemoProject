//
//  SelectedBreedEndpoint.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 25/03/2024.
//

import Foundation

enum BreedsEndpoint {
    case selectedBreed(limit: String, breedIds: String)
    case allBreeds
    case imageURL(url: String)
    case randomImage
}

extension BreedsEndpoint: Endpoint {
    var baseURL: String {
        switch self {
        case .selectedBreed(_, breedIds: _), .allBreeds:
            return AppConstants.baseURL
        case .imageURL(url: let url):
            return "\(url)"
        case .randomImage:
            return AppConstants.selectedBreeds
        }
        
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .selectedBreed(limit: let limit, breedIds: let breedIds):
            return [
                URLQueryItem(name: "api_key", value:  AppConstants.apiKey),
                URLQueryItem(name: "breed_ids", value: breedIds),
                URLQueryItem(name: "limit", value: limit)
            ]
        case .allBreeds, .imageURL, .randomImage:
            return []
        }
    }
    
    var path: String {
        switch self {
        case .selectedBreed(_, _):
            return "images/search"
        case .allBreeds:
            return "breeds"
        case .imageURL(_), .randomImage:
            return ""
        }
    }
}
