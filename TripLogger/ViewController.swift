//
//  ViewController.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit

import WeatherKit
import CoreLocation

import SnapKit

class ViewController: UIViewController {
    
    private let presentArticleButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setTitle("presentArticle", for: .normal)
        return button
    }()
    
    private func configureUI() {
        view.backgroundColor = .yellow
        
        presentArticleButton.addAction(
            .init { [weak self] _ in
                let viewController = ArticleViewController()
                self?.presentPanModal(viewController)
            }, 
            for: .touchUpInside
        )
        view.addSubview(presentArticleButton)
        presentArticleButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(12)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task {
            await configureUI()
            let a = try await WeatherManager.shared.fetchWeatherInHour(location: .init(
                latitude: 37.546866198603475,
                longitude: 127.06629217839286
            ))
            
        }
    }
}

struct WeatherInfo {
    var weather: CurrentWeather
    
    var image: UIImage? {
        return UIImage(named: weather.symbolName)
    }
    
    
    
}
