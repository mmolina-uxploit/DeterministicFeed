//
//  ContentView.swift
//  DeterministicFeed
//
//  Created by m47145 on 04/01/2026.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: CharacterListViewModel
    
    var body: some View {
      CharacterListView(viewModel: viewModel)
    }
}

