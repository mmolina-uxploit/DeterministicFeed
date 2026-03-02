//
//  CharacterListViewModel.swift
//  DeterministicFeed
//
//  Created by m47145 on 04/01/2026.
//

import Foundation
import Combine

@MainActor
final class CharacterListViewModel: ObservableObject {
    // MARK: - Estado
    
    struct ViewState: Equatable {
        var initialLoad: LoadState = .loading
        var characters: [Rick_and_Morty_Character] = []
        var paginationState: PaginationState = .idle
        var canLoadMore: Bool = true
        
        enum LoadState: Equatable {
            case loading
            case loaded
            case error(Error)
            
            
            static func == (lhs: LoadState, rhs: LoadState) -> Bool {
                switch (lhs, rhs) {
                case (.loading, .loading): return true
                case (.loaded, .loaded): return true
                case (.error(_), .error(_)): return true // Compara sólo casos, no errores reales (simplificación)
                default: return false
                }
            }
        }
    
    enum PaginationState: Equatable {
        case idle
        case loading
        case error(Error)
        
        static func == (lhs: PaginationState, rhs: PaginationState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle): return true
            case (.loading, .loading): return true
            case (.error(_), .error(_)): return true // Compara sólo casos, no errores reales (simplificación)
            default: return false
                }
            }
        }
    }
    
    @Published var state = ViewState()
    
    private let repository: CharacterRepositoryProtocol
    private var currentPage = 1
    
    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }
    
    // Carga la página inicial de personajes.
    func loadCharacters() async {
        print("ViewModel: loadCharacters() called. initialLoad: \(state.initialLoad)")
        
        guard state.initialLoad == .loading else {
            print("ViewModel: loadCharacter() guarded. Not in .loading state")
            return
        }
        
        do {
            print("ViewModel: Calling repository.getCharacters(page: 1)")
            let response = try await repository.getCharacters(page: 1)
            state.characters = response.characters
            state.canLoadMore = response.hasMore
            state.initialLoad = .loaded
            currentPage = 1
            print("ViewModel: loadCharacters() succeeded. Characters count: \(state.characters.count), canLoadMore: \(state.canLoadMore) ")
        } catch {
            state.initialLoad = .error(error)
            print("ViewModel: loadCharacters() failed with error: \(error.localizedDescription)")
        }
    }
    
    // Carga la siguiente página de personajes si es posible
    func loadNextPage() async {
        print("ViewModel: LoadNextPage() called. canLoadMore: \(state.canLoadMore), paginationState: \(state.paginationState)")
        
        // Pre-condiciones: no cargar más si se ha llegado al final o si ya hay una paginación en curso.
        guard state.canLoadMore, state.paginationState == .idle else {
            print("ViewModel: loadNextPage() guarded. Preconditions not met.")
            return
        }
        
        state.paginationState = .loading
        print("ViewModel: loadnextPage() - PaginationState set to .loading")
        
        do {
            let nextPage = currentPage + 1
            print("ViewModel: Calling repository.getCharacters(page\(nextPage)")
            let response = try await repository.getCharacters(page: nextPage)
            
            state.characters.append(contentsOf: response.characters)
            state.canLoadMore = response.hasMore
            state.paginationState = .idle
            currentPage = nextPage
            print("ViewModel: loadNextPage() succeeded. Characters count: \(state.characters.count), canLoadMore: \(state.canLoadMore), currentPage: \(currentPage)")
        } catch {
            state.paginationState = .error(error)
            print("ViewModel: loadNextPage() failed with erorr: \(error.localizedDescription)")
        }
    }
}
