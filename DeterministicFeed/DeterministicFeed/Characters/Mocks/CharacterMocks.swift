//
//  CharacterMocks.swift
//  DeterministicFeed
//
//  Created by m47145 on 04/01/2026.
//

import Foundation

#if DEBUG

// MARK: - Mock Objects for Previews and Tests

enum TestError: Error {
    case networkError
}

struct MockNetworkClient: NetworkClient {
    var result: Result<(Data, URLResponse), Error>
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}



class MockCharacterRepository: CharacterRepositoryProtocol {
    var responses: [Result<PaginatedResponse, Error>] = []
    private var callCount = 0
    
    func getCharacters(page: Int) async throws -> PaginatedResponse {
        guard !responses.isEmpty else {
            fatalError("MockCharacterRepository no tiene respuestas configuradas.")
        }
        
        let response = responses[min(callCount, responses.count - 1)]
        callCount += 1
        
        switch response {
        case .success(let paginatedResponse):
            return paginatedResponse
        case .failure(let error):
            throw error
        }
    }
}

#endif
