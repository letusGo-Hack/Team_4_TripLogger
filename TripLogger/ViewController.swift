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
import Photos

class ViewController: UIViewController {
    
    private let presentArticleButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setTitle("presentArticle", for: .normal)
        return button
    }()
    
    
    
    private let pickerButton = {
        let button = UIButton()
        button.setTitle("앨범", for: .normal)
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
        
        pickerButton.addAction(.init { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            
            self.present(picker, animated: true)
            
        }, for: .touchUpInside
        )
        
        
        view.addSubview(pickerButton)
        pickerButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task {
            configureUI()
            let a = try await WeatherManager.shared.fetchWeatherInHour(location: .init(
                latitude: 37.546866198603475,
                longitude: 127.06629217839286
            ))
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("사진 라이브러리 접근 허용됨")
            case .denied, .restricted:
                print("사진 라이브러리 접근 거부됨")
            case .notDetermined:
                print("사진 라이브러리 접근 미결정")
            @unknown default:
                fatalError()
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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let locationInfo = info[.phAsset] as? PHAsset, let location = locationInfo.location {
            print("location: \(location)")
        }
    }
}
