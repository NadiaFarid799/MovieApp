//
//  MovieCacheManagerProtocol.swift
//  Move
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation
protocol MovieCacheManagerProtocol {
    func save(movies: [Movie])
    func load() -> [Movie]
}
