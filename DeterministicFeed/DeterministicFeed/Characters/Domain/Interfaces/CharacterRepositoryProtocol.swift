//
//  CharacterRepositoryProtocol.swift
//  DeterministicFeed
//
//  Created by m47145 on 04/01/2026.
//

import Foundation

struct PaginatedResponse {
    let characters: [Rick_and_Morty_Character]
    let hasMore: Bool
}

protocol CharacterRepositoryProtocol {
    func getCharacters(page: Int) async throws -> PaginatedResponse
}
