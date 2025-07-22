//
//  MovieListViewModel.swift
//  Move
//
//  Created by NadiaFarid on 21/07/2025.
//





import Foundation
import Combine
import Network

class MovieListViewModel {

    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()
//    private let apiService = APIService.shared
//    private let cacheManager = MovieCacheManager()
    private let apiService: MovieAPIServiceProtocol
    private let cacheManager: MovieCacheManagerProtocol

    init(apiService: MovieAPIServiceProtocol, cacheManager: MovieCacheManagerProtocol) {
            self.apiService = apiService
            self.cacheManager = cacheManager
        }

    // MARK: - Public Method
    func fetchMovies() {
        isLoading = true
        errorMessage = nil

        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")

        monitor.pathUpdateHandler = { [weak self] path in
            monitor.cancel()

            if path.status == .satisfied {
                // Connected to internet → Fetch from API
                self?.loadFromAPI()
            } else {
                // No internet → Load from cache
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    if let cached = self?.cacheManager.load() {
                        DispatchQueue.main.async {
                            self?.isLoading = false
                            self?.movies = cached
                            self?.errorMessage = nil
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.isLoading = false
                            self?.errorMessage = "No internet connection and no cached data available."
                        }
                    }
                }

            }
        }

        monitor.start(queue: queue)
    }

    // MARK: - Private Helper
    private func loadFromAPI() {
        apiService.fetchTopMovies()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("API Error:", error)
                    self?.errorMessage = "API failed. Trying cached data..."

                    if let cached = self?.cacheManager.load() {
                        self?.movies = cached
                        self?.errorMessage = nil
                    } else {
                        self?.errorMessage = "Failed to fetch data from both API and cache."
                    }

                case .finished:
                    break
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
                self?.cacheManager.save(movies: movies)
            })
            .store(in: &cancellables)
    }
}

