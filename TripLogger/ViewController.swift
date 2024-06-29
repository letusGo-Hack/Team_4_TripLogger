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
    
    private var weatherIcon: UIImageView = .init()
    
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
    
    func configureUI() async {
        Task {
            let currentWeatehr = try await WeatherManager.shared.fetchCurrentWeather(
                location: .init(
                    latitude: 37.546866198603475,
                    longitude: 127.06629217839286
                )
            )
            view.backgroundColor = .yellow
            view.addSubview(weatherIcon)
            weatherIcon.image = UIImage(systemName: currentWeatehr.symbolName)
            weatherIcon.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(300)
            }
        }
    }
}

struct WeatherInfo {
    var weather: CurrentWeather
    
    var image: UIImage? {
        return UIImage(named: weather.symbolName)
    }
    
    
    
}
