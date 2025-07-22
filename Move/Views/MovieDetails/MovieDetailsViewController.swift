//
//  MovieDetailsViewController.swift
//  Move
//
//  Created by NadiaFarid on 21/07/2025.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {

    // MARK: - Properties

    private let movie: Movie

    private var isFavorited: Bool {
        FavoriteManager.shared.isFavorite(movieID: movie.id)
    }

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseLabel = UILabel()
    private let ratingLabel = UILabel()
    private let voteAverageLabel = UILabel()

    private let languageLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    // MARK: - Initializer

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details"
        view.backgroundColor = .systemBackground
        setupUI()
        configureContent()
    }

    // MARK: - Setup UI

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        // Poster
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        posterImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        // Labels
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0

        releaseLabel.font = .systemFont(ofSize: 16)
        releaseLabel.textColor = .gray
        voteAverageLabel.font = .systemFont(ofSize: 16)
        voteAverageLabel.textColor = .label

        ratingLabel.font = .systemFont(ofSize: 16)
        languageLabel.font = .systemFont(ofSize: 16)
        overviewLabel.font = .systemFont(ofSize: 14)
        overviewLabel.numberOfLines = 0

        // Favorite Button
        favoriteButton.setTitleColor(.systemRed, for: .normal)
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 16)
        favoriteButton.tintColor = .systemRed
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        // Stack: Title + Favorite Button
        let titleFavStack = UIStackView(arrangedSubviews: [titleLabel, favoriteButton])
        titleFavStack.axis = .horizontal
        titleFavStack.alignment = .center
        titleFavStack.distribution = .equalSpacing

   let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        languageLabel.font = .systemFont(ofSize: 15)
      
        let ratingLangStack = UIStackView(arrangedSubviews: [ ratingLabel,voteAverageLabel, languageLabel])
        ratingLangStack.axis = .horizontal
        ratingLangStack.spacing = 0
        ratingLangStack.alignment = .center
        let overviewTitleLabel = UILabel()
        overviewTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        overviewTitleLabel.text = "Overview:"
        overviewTitleLabel.textColor = .label

        overviewLabel.font = UIFont.systemFont(ofSize: 15)
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .label

        let overviewStack = UIStackView(arrangedSubviews: [overviewTitleLabel, overviewLabel])
        overviewStack.axis = .vertical
        overviewStack.spacing = 4

        // Add to Content Stack
        contentView.addArrangedSubview(posterImageView)
        contentView.addArrangedSubview(titleFavStack)
        contentView.addArrangedSubview(releaseLabel)
        contentView.addArrangedSubview(ratingLangStack)
        contentView.addArrangedSubview(overviewStack)
    }


    // MARK: - Configure Content

    private func configureContent() {
        if let posterPath = movie.posterPath {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.kf.setImage(with: imageUrl)
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }

        titleLabel.text = movie.title
        releaseLabel.text = "Release Date: \(movie.releaseDate)"

        ratingLabel.text = "Rating: ⭐️ \(String(format: "%.1f/10", movie.voteAverage))"


        languageLabel.text = "              Language: \(movie.originalLanguage.uppercased())"
        overviewLabel.text = movie.overview

        updateFavoriteButton()
    }

    // MARK: - Favorite Logic

    private func updateFavoriteButton() {
        let title = isFavorited ? "" : ""
        let icon = isFavorited ? "bookmark.fill" : "bookmark"
        favoriteButton.setTitle("  \(title)", for: .normal)
        favoriteButton.setImage(UIImage(systemName: icon), for: .normal)
    }

    
    @objc private func favoriteTapped() {
        if isFavorited {
            let alert = UIAlertController(
                title: "Remove Favorite",
                message: "Are you sure you want to remove this movie from favorites?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                FavoriteManager.shared.toggleFavorite(movieID: self.movie.id)
                self.updateFavoriteButton()
            })
            present(alert, animated: true, completion: nil)
        } else {
            FavoriteManager.shared.toggleFavorite(movieID: movie.id)
            updateFavoriteButton()
            showToast(message: "Added to Favorites")
        }
    }
    private func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.7) 
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let textSize = toastLabel.intrinsicContentSize
        let padding: CGFloat = 16
        let labelWidth = min(view.frame.width - 2 * padding, textSize.width + 2 * padding)
        let labelHeight = textSize.height + padding

        toastLabel.frame = CGRect(
            x: (view.frame.width - labelWidth) / 2,
            y: view.frame.height - labelHeight - 80,
            width: labelWidth,
            height: labelHeight
        )

        view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }


}


