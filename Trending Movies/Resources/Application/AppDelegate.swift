//
//  AppDelegate.swift
//  Trending Movies
//
//  Created by Mohamed on 05/02/2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator:AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = UINavigationController()
              
              // Create the app coordinator with the navigation controller
              appCoordinator = AppCoordinator(navigationController: navigationController)
              
              // Start the app coordinator
              appCoordinator?.start()
              
              // Set the root view controller of the window
              window = UIWindow(frame: UIScreen.main.bounds)
              window?.rootViewController = navigationController
              window?.makeKeyAndVisible()
        
        return true
    }

 

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStorage.shared.saveContext()
    }
}

