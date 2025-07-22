//
//  FavoriteManager.swift
//  Move
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation
class FavoriteManager {
    static let shared = FavoriteManager()
    private let key = "favorite_movies"

    private var favorites: Set<Int> {
        get {
            Set(UserDefaults.standard.array(forKey: key) as? [Int] ?? [])
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: key)
        }
    }

    func isFavorite(movieID: Int) -> Bool {
        favorites.contains(movieID)
    }

    func toggleFavorite(movieID: Int) {
        var set = favorites
        if set.contains(movieID) {
            set.remove(movieID)
        } else {
            set.insert(movieID)
        }
        favorites = set
    }
}
