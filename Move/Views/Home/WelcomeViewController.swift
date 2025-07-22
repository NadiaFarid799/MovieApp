//
//  WelcomeViewController.swift
//  Move
//
//  Created by NadiaFarid on 22/07/2025.
//



import Foundation
import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let bannerImages = ["poster_1917move", "insteller_poster", "kpop_poster"]
    private var timer: Timer?
    private var currentPage = 0

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi, Nadia 👋"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's watch a movie"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "nophoto"))
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let recommendedLabel = UILabel()
    private let topSearchesLabel = UILabel()
    private let recommendedScroll = UIScrollView()
    private let topSearchesScroll = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHeader()
        setupBannerSlider()
        setupPageControl()
        setupSections()
        startTimer()
    }

    // MARK: - Header

    private func setupHeader() {
        let header = UIStackView()
        header.axis = .horizontal
        header.spacing = 16
        header.alignment = .center

        avatarImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        let labels = UIStackView(arrangedSubviews: [greetingLabel, subtitleLabel])
        labels.axis = .vertical
        labels.spacing = 4

        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        let bellIcon = UIImageView(image: UIImage(systemName: "bell.badge"))
        searchIcon.tintColor = .black
        bellIcon.tintColor = .black

        let icons = UIStackView(arrangedSubviews: [searchIcon, bellIcon])
        icons.axis = .horizontal
        icons.spacing = 12

        header.addArrangedSubview(avatarImageView)
        header.addArrangedSubview(labels)
        header.addArrangedSubview(UIView())
        header.addArrangedSubview(icons)

        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Banner Slider

    private func setupBannerSlider() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.heightAnchor.constraint(equalToConstant: 180)
        ])

        for (index, imageName) in bannerImages.enumerated() {
            let bannerView = UIView()
            bannerView.frame = CGRect(x: CGFloat(index) * (view.frame.width - 32), y: 0, width: view.frame.width - 32, height: 180)

            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 16
            imageView.frame = bannerView.bounds

            // Full overlay background
            let labelBackground = UIView()
            labelBackground.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            labelBackground.layer.cornerRadius = 16
            labelBackground.clipsToBounds = true
            labelBackground.translatesAutoresizingMaskIntoConstraints = false

            // Title Label
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 2
            titleLabel.text = "Watch Top\nMovies 🎬"
            titleLabel.font = .boldSystemFont(ofSize: 22)
            titleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            // Button
            let button = UIButton(type: .system)
            button.setTitle("Watch Now", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 16
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(watchNowTapped), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false

            // Add views
            bannerView.addSubview(imageView)
            bannerView.addSubview(labelBackground)
            bannerView.addSubview(titleLabel)
            bannerView.addSubview(button)
            scrollView.addSubview(bannerView)

            // Constraints
            NSLayoutConstraint.activate([
                labelBackground.topAnchor.constraint(equalTo: bannerView.topAnchor),
                labelBackground.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor),
                labelBackground.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
                labelBackground.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),

                titleLabel.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: bannerView.topAnchor, constant: 28),

                button.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor, constant: 16),
                button.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: -16),
                button.widthAnchor.constraint(equalToConstant: 120),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
        }

        scrollView.contentSize = CGSize(width: CGFloat(bannerImages.count) * (view.frame.width - 32), height: 180)
    }

    private func setupPageControl() {
        pageControl.numberOfPages = bannerImages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        currentPage = Int(pageIndex)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }

    @objc private func autoScroll() {
        currentPage = (currentPage + 1) % bannerImages.count
        let xOffset = CGFloat(currentPage) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }

    @objc private func watchNowTapped() {
        let movieVC = MovieListViewController()
        navigationController?.pushViewController(movieVC, animated: true)
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Recommended & Top Searches

    private func setupSections() {
        recommendedLabel.text = "Recommended for you"
        recommendedLabel.font = .boldSystemFont(ofSize: 20)
        recommendedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recommendedLabel)

        NSLayoutConstraint.activate([
            recommendedLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            recommendedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        let seeAll1 = UILabel()
        seeAll1.text = "See All"
        seeAll1.textColor = .systemBlue
        seeAll1.font = .systemFont(ofSize: 16)
        seeAll1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(seeAll1)

        NSLayoutConstraint.activate([
            seeAll1.centerYAnchor.constraint(equalTo: recommendedLabel.centerYAnchor),
            seeAll1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        setupHorizontalScroll(below: recommendedLabel, scroll: recommendedScroll, yOffset: 8)

        topSearchesLabel.text = "Top Searches"
        topSearchesLabel.font = .boldSystemFont(ofSize: 20)
        topSearchesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topSearchesLabel)

        NSLayoutConstraint.activate([
            topSearchesLabel.topAnchor.constraint(equalTo: recommendedScroll.bottomAnchor, constant: 32),
            topSearchesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        let seeAll2 = UILabel()
        seeAll2.text = "See All"
        seeAll2.textColor = .systemBlue
        seeAll2.font = .systemFont(ofSize: 16)
        seeAll2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(seeAll2)

        NSLayoutConstraint.activate([
            seeAll2.centerYAnchor.constraint(equalTo: topSearchesLabel.centerYAnchor),
            seeAll2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        setupHorizontalScroll(below: topSearchesLabel, scroll: topSearchesScroll, yOffset: 8)
    }

    private func setupHorizontalScroll(below anchor: UIView, scroll: UIScrollView, yOffset: CGFloat) {
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: anchor.bottomAnchor, constant: yOffset),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.heightAnchor.constraint(equalToConstant: 180)
        ])

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -16)
        ])

        for name in ["Godfatherposter", "kpop", "spirited_away_poster"] {
            let image = UIImageView(image: UIImage(named: name))
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.layer.cornerRadius = 10
            image.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: 120),
                image.heightAnchor.constraint(equalToConstant: 170)
            ])
            stack.addArrangedSubview(image)
        }
    }
}
