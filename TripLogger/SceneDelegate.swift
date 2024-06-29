//
//  SceneDelegate.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let repository: ArticleRepository = try! ArticleRepositoryImpl()
    var viewController: MapViewController!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = ViewController()
        viewController = try! MapViewController(
            locations: repository.locations()?
                .compactMap { CLLocation(latitude: $0.latitude, longitude: $0.longitude)} ?? []
        )
        viewController.delegate = self
        window?.rootViewController = viewController
        
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate: MapViewControllerDelegate {
    func add(location: CLLocation) {
        let location = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let articleViewController = ArticleViewController(location: location, repository: repository)
        articleViewController.delegate = self
        viewController.presentPanModal(articleViewController)
    }
}

extension SceneDelegate: ArticleViewControllerDelegate {
    func addPin(location: Location) {
        viewController.addPin(locations: [CLLocation(latitude: location.latitude, longitude: location.longitude)])
    }
}
