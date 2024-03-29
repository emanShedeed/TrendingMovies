//
//  MovieDetailsCoordinator.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 11/02/2024.
//

import UIKit
class MovieDetailsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
 
    var movieId: Int
    
    init(navigationController: UINavigationController, movieId: Int) {
        self.navigationController = navigationController
        self.movieId = movieId
    }
    
    func start() {
        let viewModel = MovieDetailsViewModel(movieId: movieId, movieDetailsRepository: OfflineMovieDetailsRepository(), imageRepository: ImageRepository())
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
