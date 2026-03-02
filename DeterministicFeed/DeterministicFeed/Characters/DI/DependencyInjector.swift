//
//  DependencyInjector.swift
//  DeterministicFeed
//
//  Created by m47145 on 05/01/2026.
//

import Foundation

enum DependencyInjector {
    
    @MainActor static func makeCharacterListViewModel() -> CharacterListViewModel {
        
        let repository = CharacterRepository(networkClient: URLSessionNetworkClient())
        
        return CharacterListViewModel(repository: repository)
    }
}
