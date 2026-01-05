//
//  CharacterListView.swift
//  DeterministicFeed
//
//  Created by m47145 on 05/01/2026.
//

import SwiftUI

struct CharacterListView: View {
    
    @ObservedObject var viewModel: CharacterListViewModel
    
    var body: some View {
        NavigationView {
            viewContent
                .navigationTitle("Rick and Morty")
        }
        .task {
            // Carga inicial de personajes si aún no se ha hecho.
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1",
               viewModel.state.initialLoad == .loading {
                await viewModel.loadCharacters()
            }
        }
    }
    
    // MARK: -  View Content Builders
    
    /// Construye el contenido principal de la vista basado en el estado de carga inical.
    @ViewBuilder
    private var viewContent: some View {
        switch viewModel.state.initialLoad {
        case .loading:
            ProgressView("Cargando Personajes...")
        case .loaded:
            listContent
        case .error(let error):
            ErrorView(error: error) {
                Task { await viewModel.loadCharacters()}
            }
        }
    }
    
    /// Construye la lista de personajes y los indicadores de estado de paginación.
    private var listContent: some View {
        List {
            ForEach(viewModel.state.characters) { character in
                CharacterRowView(character: character)
                    .onAppear {
                        // Si este es el último personaje visible, intentar cargar la página siguiente.
                        if character.id == viewModel.state.characters.last?.id {
                            loadMoreIfNeeded()
                        }
                    }
            }
            // Muestra los indicadores de estado en el pie de la lista.
            listFooter
        }
    }
    
    /// Construye el pie de la lista, mostrando el estado de paginación
    @ViewBuilder
    private var listFooter: some View {
        if viewModel.state.paginationState == .loading {
            paginationLoadingView
        }
        
        if case .error(let error) = viewModel.state.paginationState {
            paginationErrorView(error)
        }
        
        // Se muestra si no hay más peronajes por cargar y la lista no está vacía.
        if !viewModel.state.canLoadMore && !viewModel.state.characters.isEmpty {
            noMoreCharactersView
        }
    }
    
    // MARK: - Helpers Methods
    private func loadMoreIfNeeded() {
        // Asegura que solo se intente cargar más si se cumplen las condiciones.
        guard viewModel.state.canLoadMore, viewModel.state.paginationState == .idle else {
            return
        }
        
        Task {
            await viewModel.loadNextPage()
            print("UI: Last character appeared, attempting to load next page.")
        }
    }
    
    // MARK: -  Pagination State Views
    
    private var paginationLoadingView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .listRowSeparator(.hidden)
        .listRowBackground(EmptyView())
    }
    
    /// Vista para el error de paginación
    private func paginationErrorView(_ error: Error) -> some View {
        ErrorView(error: error) {
            Task { await viewModel.loadNextPage() }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(EmptyView())
    }
    /// Vista que informa al usuario que no hay más personajes para mostrar.
    private var noMoreCharactersView: some View {
        Text("No hay más personajes.")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowSeparator(.hidden)
            .listRowBackground(EmptyView())
    }
}
    
    // MARK: - Subvistas
    
    private struct CharacterRowView: View {
        let character: Rick_and_Morty_Character
        
        var body: some View {
            HStack(spacing: 16) {
                AsyncImage(url: character.image) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(character.name).font(.headline)
                    Text("Status: \(character.status)").font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private struct ErrorView: View {
        let error: Error
        let retryAction: () -> Void
        
        var body: some View {
            VStack(spacing: 10) {
                Image(systemName: "wifi.exclamationmark").font(.largeTitle)
                Text("Ocurrió un Error").font(.headline)
                Text(error.localizedDescription).font(.caption).multilineTextAlignment(.center)
                Button("Reintentar", action: retryAction).buttonStyle(.bordered).padding(.top)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            }
        }
 

// MARK: - Previews

@MainActor
struct CharacterListView_Previews: PreviewProvider {
    
    private struct PreviewError: Error, LocalizedError {
        var errorDescription: String?
        init(_ description: String) { self.errorDescription = description }
    }
    
    static var mockCharacters: [Rick_and_Morty_Character] = [
        .init(id: 1, name: "Rick Sanchez", status: "Alive", image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!),
        .init(id: 2, name: "Morty Smith", status: "Alive", image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")!)
    ]
    
    // Helper para crear un viewModel en un estado específico
    private static func createViewModel(
        initialLoad: CharacterListViewModel.ViewState.LoadState = .loading,
        paginationState: CharacterListViewModel.ViewState.PaginationState = .idle,
        characters: [Rick_and_Morty_Character] = [],
        canLoadMore: Bool = true
    ) -> CharacterListViewModel {
        let viewModel = CharacterListViewModel(repository: MockCharacterRepository())
        viewModel.state = .init(
            initialLoad: initialLoad,
            characters: characters,
            paginationState: paginationState,
            canLoadMore: canLoadMore
        )
        return viewModel
    }

    static var previews: some View {
        // 1. Carga Inicial
        CharacterListView(viewModel: createViewModel())
            .previewDisplayName("1. Initial Loading")

        // 2. Error Inicial
        CharacterListView(viewModel: createViewModel(initialLoad: .error(PreviewError("No se pudo conectar."))))
            .previewDisplayName("2. Initial Error")

        // 3. Carga Exitosa (Idle)
        CharacterListView(viewModel: createViewModel(initialLoad: .loaded, characters: mockCharacters))
            .previewDisplayName("3. Success (Idle)")
        
        // 4. Cargando Siguiente Página
        CharacterListView(viewModel: createViewModel(initialLoad: .loaded, paginationState: .loading, characters: mockCharacters))
            .previewDisplayName("4. Pagination Loading")

        // 5. Error en Paginación
        CharacterListView(viewModel: createViewModel(initialLoad: .loaded, paginationState: .error(PreviewError("Error al paginar.")), characters: mockCharacters))
            .previewDisplayName("5. Pagination Error")

        // 6. Fin de la Lista
        CharacterListView(viewModel: createViewModel(initialLoad: .loaded, characters: mockCharacters, canLoadMore: false))
            .previewDisplayName("6. No More Characters")
    }
}
