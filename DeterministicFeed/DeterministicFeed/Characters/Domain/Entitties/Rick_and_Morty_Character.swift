//
//  Rick_and_Morty_Character.swift
//  DeterministicFeed
//
//  Created by m47145 on 04/01/2026.
//

import Foundation

struct Rick_and_Morty_Character: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let status: String
    let image: URL
}

struct APIResponse: Codable {
    struct Info: Codable {
        let next: URL?
    }
    
    let info: Info
    let results: [Rick_and_Morty_Character]
}
