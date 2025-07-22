//
//  MovieCell.swift
//  Move
//
//  Created by NadiaFarid on 21/07/2025.
//

import Foundation
import UIKit
import Kingfisher

class MovieCell: UITableViewCell {
    
    private var isFavorited = false
    private var onFavoriteToggle: (() -> Void)?
    
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemYellow
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .systemYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let infoStack = UIStackView()
    private let ratingStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        infoStack.axis = .vertical
        infoStack.spacing = 6
        
        ratingStack.axis = .horizontal
        ratingStack.spacing = 4
        ratingStack.alignment = .center
        ratingStack.addArrangedSubview(starImageView)
        ratingStack.addArrangedSubview(ratingLabel)
        
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(releaseDateLabel)
        infoStack.addArrangedSubview(ratingStack)
        
        let mainStack = UIStackView(arrangedSubviews: [posterImageView, infoStack, favoriteButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func favoriteButtonTapped() {
        isFavorited.toggle()
        updateFavoriteButton()
        onFavoriteToggle?()
    }
    
    
    func configure(with movie: Movie, isFavorited: Bool, onFavoriteToggle: @escaping () -> Void) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release: \(movie.releaseDate)"
        ratingLabel.text = String(format: "%.1f", movie.voteAverage)
        
        if let posterPath = movie.posterPath {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.kf.setImage(with: imageUrl)
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
        
        self.isFavorited = isFavorited
        self.onFavoriteToggle = onFavoriteToggle
        updateFavoriteButton()
    }
    private func updateFavoriteButton() {
        let imageName = isFavorited ? "bookmark.fill" : "bookmark"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
}
