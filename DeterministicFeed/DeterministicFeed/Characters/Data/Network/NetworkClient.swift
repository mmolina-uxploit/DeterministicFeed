//
//  NetworkClient.swift
//  DeterministicFeed
//
//  Created by m47145 on 04/01/2026.
//

import Foundation

protocol NetworkClient {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

struct URLSessionNetworkClient: NetworkClient {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(from: url)
    }
}
