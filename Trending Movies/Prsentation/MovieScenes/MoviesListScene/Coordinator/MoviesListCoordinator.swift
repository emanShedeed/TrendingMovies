//
//  MoviesListCoordinator.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 08/02/2024.
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
        let viewModel = MoviesListViewModel(movieService: OfflineMoviesRepository(), genreService: OfflineGenreRepository(), searchMovieService: SearchMovieRepository())
        let viewController = MoviesListViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
   func showMovieDetail(id: Int) {
       // Navigate to the movie detail view controller
              let movieDetailsCoordinator = MovieDetailsCoordinator(navigationController: navigationController, movieId: id)
              // Add the movie details coordinator to the child coordinators array
              childCoordinators.append(movieDetailsCoordinator)
              // Start the coordinator and show the movie details
              movieDetailsCoordinator.start()
    }
}
