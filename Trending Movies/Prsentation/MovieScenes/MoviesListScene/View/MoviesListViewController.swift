//
//  MoviesListViewController.swift
//  Trending Movies
//
//  Created by Mohamed on 08/02/2024.
//

import UIKit
import RxSwift
// MARK: - View Controller: MoviesListViewController

class MoviesListViewController: UIViewController {
    private var moviesCollectionView: UICollectionView!
    private var genreCollectionView: UICollectionView!
    private let viewModel: MoviesListViewModelProtocol
    private let disposeBag = DisposeBag()

    init(viewModel: MoviesListViewModelProtocol) {
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
    }

    private func setupUI() {
        view.backgroundColor = .black
        // Setup genre collection view
        let genreLayout = UICollectionViewFlowLayout()
        genreLayout.scrollDirection = .horizontal
        genreLayout.itemSize = CGSize(width: 100, height: 30)
        genreCollectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 50), collectionViewLayout: genreLayout)
        genreCollectionView.backgroundColor = .black
        genreCollectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(genreCollectionView)

        // Set constraints for genre collection view
           genreCollectionView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               genreCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // Position at the top of the view
               genreCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               genreCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               genreCollectionView.heightAnchor.constraint(equalToConstant: 60) // Set a fixed height
           ])

        // Setup main collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .zero
        moviesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        moviesCollectionView.backgroundColor = .black
        view.addSubview(moviesCollectionView)
        
        // Set constraints for movie collection view
          moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor, constant: 40), // Position below the genre collection view
              moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
          ])

        // Set delegates
        genreCollectionView.delegate = self
        moviesCollectionView.delegate = self
    
        
        // Register cells
        genreCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: "GenreCell")
        moviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        
      
   
    }

    private func bindViewModel() {
        viewModel.fetchGenres()
        viewModel.fetchMovies(page: 1)
        
        viewModel.genres
            .bind(to: genreCollectionView.rx.items(cellIdentifier: "GenreCell", cellType: GenreCell.self)) { row, genre, cell in
                let genreViewModel = GenreCellViewModel(genre: genre)
                cell.bind(viewModel: genreViewModel) 
            }
            .disposed(by: disposeBag)

        viewModel.movies
            .bind(to: moviesCollectionView.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { row, movie, cell in
                let movieViewModel = MovieCellViewModel(movie: movie, imageRepository: ImageRepository())
                cell.viewModel = movieViewModel
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView Delegate: MoviesListViewController

extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            // Load more movies when scrolled to the bottom
            viewModel.fetchMovies(page: viewModel.currentPage + 1)
        }
    }
}

// MARK: - CollectionView FlowLayout Delegate: MoviesListViewController

extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genreCollectionView {
            return CGSize(width: 150, height: 30)
        } else {
            // Adjust item size based on your requirements
            return CGSize(width: collectionView.frame.width / 2 - 5, height: 250)
        }
    }
}
