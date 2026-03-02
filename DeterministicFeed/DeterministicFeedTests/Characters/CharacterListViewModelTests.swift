//
//  CharacterListViewModelTests.swift
//  DeterministicFeedUITests
//
//  Created by m47145 on 04/01/2026.
//

import XCTest
@testable import DeterministicFeed

@MainActor
final class CharacterListViewModelTests: XCTestCase {

    func test_initialLoad_success_transitionsToLoadedState() async {
        // Arrange
        let initialCharacters = [
            Rick_and_Morty_Character(
                id: 1,
                name: "Rick",
                status: "Alive",
                image: URL(string: "https://example.com")!
            )
        ]

        let mockRepository = MockCharacterRepository()
        mockRepository.responses = [
            Result.success(
                PaginatedResponse(
                    characters: initialCharacters,
                    hasMore: true
                )
            )
        ]

        let viewModel = CharacterListViewModel(repository: mockRepository)

        // Act
        await viewModel.loadCharacters()

        // Assert
        XCTAssertEqual(
            viewModel.state.initialLoad,
            CharacterListViewModel.ViewState.LoadState.loaded
        )

        XCTAssertEqual(viewModel.state.characters, initialCharacters)
        XCTAssertTrue(viewModel.state.canLoadMore)
    }
}
