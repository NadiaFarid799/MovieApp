//
//  MovieListViewModelTests.swift
//  MoveTests
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation
import XCTest
import Combine
@testable import Move

class MovieListViewModelTests: XCTestCase {

    var viewModel: MovieListViewModel!
    var apiMock: MockAPIService!
    var cacheMock: MockCacheManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        apiMock = MockAPIService()
        cacheMock = MockCacheManager()
        cancellables = []
        viewModel = MovieListViewModel(apiService: apiMock, cacheManager: cacheMock)
    }

    // Test successful API call
    func testFetchMoviesSuccess() {
        let expectation = XCTestExpectation(description: "Movies fetched successfully")
        let dummyMovie = Movie(id: 1, title: "Test Movie", overview: "2025-01-01", posterPath: "8.5", releaseDate: "", voteAverage: 2.0, originalLanguage: "en")

        apiMock.moviesToReturn = [dummyMovie]

        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "Test Movie")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchMovies()
        wait(for: [expectation], timeout: 2)
    }

    //  Test API failure but cache is used
    func testFetchMoviesFailsUsesCache() {
        let expectation = XCTestExpectation(description: "Fallback to cache")

        apiMock.shouldFail = true
        cacheMock.cachedMovies = [Movie(id: 2, title: "Cached Movie", overview: "2024-12-31", posterPath:" 7.0", releaseDate: "", voteAverage: 0.0, originalLanguage: "en")]

        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "Cached Movie")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchMovies()
        wait(for: [expectation], timeout: 2)
    }



}
