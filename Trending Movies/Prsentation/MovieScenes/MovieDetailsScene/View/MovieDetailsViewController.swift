//
//  MovieDetailsViewController.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 11/02/2024.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let movieNameLabel = UILabel()
    private let movieDateLabel = UILabel()
    private let overviewTextView = UITextView()
    private let homepageLabel = UILabel()
    private let languagesLabel = UILabel()
    private let statusLabel = UILabel()
    private let budgetLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let revenueLabel = UILabel()
    
    private let viewModel: MovieDetailsViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchMovieDetails()
    }
    
    
    
    private func setupUI() {
       // setup nav bar
        
             // Remove the back button's text
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
             
             // Change the color of the back arrow (<-) to white
             navigationController?.navigationBar.tintColor = .white
        // Set up scrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        // Set up contentView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add subviews to stackView
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(movieDateLabel)
        stackView.addArrangedSubview(overviewTextView)
        stackView.addArrangedSubview(homepageLabel)
        stackView.addArrangedSubview(languagesLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(budgetLabel)
        stackView.addArrangedSubview(runtimeLabel)
        stackView.addArrangedSubview(revenueLabel)
        
        // Set up constraints for imageView
        imageView.contentMode = .scaleToFill
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        // Configure text colors
        let labels: [UILabel] = [movieNameLabel, movieDateLabel, homepageLabel, languagesLabel, statusLabel, budgetLabel, runtimeLabel, revenueLabel]
        labels.forEach { $0.textColor = .white }
        
        // Configure overviewTextView
        overviewTextView.backgroundColor = .black
        overviewTextView.textColor = .white
        overviewTextView.isEditable = false
        overviewTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
    
    
    private func bindViewModel() {
        viewModel.movie
            .subscribe(onNext: { [weak self] movie in
                guard let movie = movie else { return }
                self?.updateUI(with: movie)
            })
            .disposed(by: disposeBag)
        
        viewModel.imageData
            .subscribe(onNext: { [weak self] data in
                if let data = data {
                    self?.imageView.image = UIImage(data: data)
                } else {
                    // Handle the case where image data is nil or loading fails
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func updateUI(with movie: MovieDetailsDTO) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self  else { return }
            
            // Bind movie data to UI elements
            self.movieNameLabel.text = movie.title
            self.movieDateLabel.text = MovieDetailsDTO.formatReleaseDate(movie.releaseDate)
            self.overviewTextView.text = movie.overview
           // self.homepageLabel.text = "HomePage: \((movie.homepage) ?? "")"
            self.languagesLabel.text = "Languages: \(MovieDetailsDTO.formatSpokenLanguages(movie.spokenLanguages))"
            self.statusLabel.text = "Status: \(movie.status ?? "")"
            self.budgetLabel.text = "Budget: \(movie.budget ?? 0)"
            self.runtimeLabel.text = "Runtime: \(movie.runtime ?? 0) minutes"
            self.revenueLabel.text = "Revenue: \(movie.revenue ?? 0) $"
            
            if let urlString = movie.homepage {
                
                // Add the prefix "HomePage:" to the URL string
                let homePageString = NSAttributedString(string: "HomePage: ", attributes: [.foregroundColor: UIColor.white])
                let urlString = NSAttributedString(string: urlString, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.blue])
                       
                      
                // Combine the attributed strings
                        let attributedString = NSMutableAttributedString()
                        attributedString.append(homePageString)
                        attributedString.append(urlString)
                      
                      // Set the attributed string to the label
                      homepageLabel.attributedText = attributedString
                
                
                // Set the attributed string to the label
                homepageLabel.attributedText = attributedString
                
                // Enable user interaction to make the label clickable
                homepageLabel.isUserInteractionEnabled = true
                
                // Add a tap gesture recognizer to handle the tap event
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openURL))
                homepageLabel.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc func openURL() {
        if let urlString = homepageLabel.text?.replacingOccurrences(of: "HomePage: ", with: ""), let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
}
