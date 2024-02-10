//
//  MoviesListCoordinator.swift
//  Trending Movies
//
//  Created by Mohamed on 08/02/2024.
//

import UIKit
import CoreData
class MoviesListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MoviesListViewModel(movieService: OfflineMovieRepository(), genreService: OfflineGenreRepository(), searchMovieService: SearchMovieRepository())
        let viewController = MoviesListViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
  /*  func showMovieDetail(movie: MovieModel) {
        // Implement navigation to the movie detail view
    }*/
}
