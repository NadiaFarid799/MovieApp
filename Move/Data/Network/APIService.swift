//
//  APIService.swift
//  Move
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private let apiKey = "908da20728829124674a4b28c563c160"
   
    func fetchTopMovies() -> AnyPublisher<[Movie], Error> {
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
extension APIService: MovieAPIServiceProtocol {}
