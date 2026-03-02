//
//  DeterministicFeedApp.swift
//  DeterministicFeed
//
//  Created by m47145 on 04/01/2026.
//

import SwiftUI

@main
struct DeterministicFeedApp: App {
    
    @StateObject private var viewModel: CharacterListViewModel
    
    init() {

        _viewModel = StateObject(wrappedValue: DependencyInjector.makeCharacterListViewModel())
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
