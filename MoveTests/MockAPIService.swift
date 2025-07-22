//
//  MockAPIService.swift
//  MoveTests
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation
import Combine
@testable import Move

class MockAPIService: MovieAPIServiceProtocol {
    var shouldFail = false
    var moviesToReturn: [Movie] = []

    func fetchTopMovies() -> AnyPublisher<[Movie], Error> {
        if shouldFail {
            return Fail(error: URLError(.notConnectedToInternet)).eraseToAnyPublisher()
        } else {
            return Just(moviesToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
