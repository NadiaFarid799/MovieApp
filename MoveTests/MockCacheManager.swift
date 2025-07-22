//
//  MockCacheManager.swift
//  MoveTests
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation
@testable import Move

class MockCacheManager: MovieCacheManagerProtocol {
    var cachedMovies: [Movie] = []

    func save(movies: [Movie]) {
        cachedMovies = movies
    }

    func load() -> [Movie] {
        return cachedMovies
    }
}
