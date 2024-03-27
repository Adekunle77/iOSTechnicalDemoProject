//
//  Endpoint.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 20/03/2024.
//

import Foundation

enum EndpointError: Error {
    case invalidURL
    case apiInstanceDeallocated
}

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var url: URL { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var url: URL {
        var urlStr = baseURL + "/" + path
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        var urlComponents = URLComponents(string: urlStr)!
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            fatalError("Failed to construct URL")
        }
        return url
    }
}
