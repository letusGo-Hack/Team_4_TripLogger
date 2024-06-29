//
//  ArticleRepository.swift
//  TripLogger
//
//  Created by LeeWanJae on 6/29/24.
//

import CoreLocation

final class ArticleRepository: MapViewControllerDelegate {
    let articleVC: ArticleViewController

    init(articleVC: ArticleViewController) {
        self.articleVC = articleVC
    }
    
    func add(location: CLLocation, onComplete: (Result<Void, any Error>) -> Void) {
        onComplete(.success(()))
    }
}
