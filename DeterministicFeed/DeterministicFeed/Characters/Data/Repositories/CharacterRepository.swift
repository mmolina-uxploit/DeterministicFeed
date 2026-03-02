//
//  CharacterRepository.swift
//  DeterministicFeed
//
//  Created by m47145 on 05/01/2026.
//

import Foundation

/// Actor que gestiona la obtención de datos de personajes de forma paginada desde la API
actor CharacterRepository: CharacterRepositoryProtocol {
    private let networkClient: NetworkClient
    private let baseURL = "https://rickandmortyapi.com/api/character"

    init(networkClient: NetworkClient =  URLSessionNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getCharacters(page: Int) async throws -> PaginatedResponse {
        guard var components = URLComponents(string: baseURL) else {
            // En una app real, aquí se manejaría un error personalizado.
            fatalError("Invalid base URL")
        }
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = components.url else {
            fatalError("Could not construct paginated URL.")
        }
        
        let (data, _) = try await networkClient.data(from: url)
        
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        // La respuesta contiene los personajes y la información de si hay una página siguiente.
        return PaginatedResponse(
            characters: apiResponse.results,
            hasMore: apiResponse.info.next != nil
        )
    }
}
