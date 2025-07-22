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
    // i used it before use dependancy injection
    
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

        // 1. try loading cached data first
        let cachedMovies = cacheManager.load()
        if !cachedMovies.isEmpty {
            self.movies = cachedMovies
            self.isLoading = false
            return // no need to go online
        }

        // 2. no cache → check for internet connection
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")

        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            monitor.cancel()

            if path.status == .satisfied {
                //  has internet, fetch from API
                self.apiService.fetchTopMovies()
                    .sink(receiveCompletion: { completion in
                        self.isLoading = false
                        switch completion {
                        case .failure(let error):
                            print("API error:", error)
                            self.errorMessage = "No internet connection.\nPlease turn on Wi-Fi or Mobile Data."
                        case .finished:
                            break
                        }
                    }, receiveValue: { movies in
                        self.movies = movies
                        self.cacheManager.save(movies: movies)
                        self.errorMessage = nil
                    })
                    .store(in: &self.cancellables)

            } else {
                //  no internet and no cache
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "No internet connection"
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

