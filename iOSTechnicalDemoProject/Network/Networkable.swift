//
//  Networkable.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 25/03/2024.
//

import Foundation

protocol Networkable: AnyObject {
    func fetchData<T: Decodable>(endpoint: Endpoint) async throws -> T
    func downloadData(from url: URL) async throws -> Data
}

class NetworkManager {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
}

extension NetworkManager: Networkable {
    func fetchData<T>(endpoint: Endpoint) async throws -> T where T : Decodable {
        let (data, _) = try await session.data(from: endpoint.url)
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.noData
        }
    }
    
    func downloadData(from url: URL) async throws -> Data {
         let (data, _) = try await session.data(from: url)
         return data
     }
}
