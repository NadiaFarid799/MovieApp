//
//  MovieCacheManager.swift
//  Move
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation

class MovieCacheManager: MovieCacheManagerProtocol {

    private let cacheFileName = "MovieCache.json"

    private var cacheURL: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(cacheFileName)
    }

    func save(movies: [Movie]) {
        guard let url = cacheURL else { return }

        do {
            let data = try JSONEncoder().encode(movies)
            try data.write(to: url)
        } catch {
            print(" Failed to save movie cache:", error)
        }
    }

    func load() -> [Movie] {
        guard let url = cacheURL else { return [] }

        do {
            let data = try Data(contentsOf: url)
            let movies = try JSONDecoder().decode([Movie].self, from: data)
            return movies
        } catch {
            print(" Failed to load movie cache:", error)
            return []
        }
    }
}
