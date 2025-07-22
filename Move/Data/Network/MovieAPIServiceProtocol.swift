//
//  MovieAPIServiceProtocol.swift
//  Move
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation
import Combine
protocol MovieAPIServiceProtocol {
    func fetchTopMovies() -> AnyPublisher<[Movie], Error>
}
