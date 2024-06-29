//
//  MapViewController.swift
//  TripLogger
//
//  Created by LeeWanJae on 6/29/24.
//

import MapKit
import UIKit
import SnapKit
import CoreLocation

protocol MapViewControllerDelegate: AnyObject {
    func add(location: CLLocation, onComplete: (Result<Void, Error>) -> Void)
}

class MapViewController: UIViewController {
    weak var delegate: MapViewControllerDelegate?
    
    private lazy var mapView = MKMapView()
    private lazy var locationManager = CLLocationManager()
    private lazy var pin = MKPointAnnotation()
    private var currentLocation: CLLocation!
    private lazy var plusBtn = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("✚", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.btnBG
        button.layer.cornerRadius = 31
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        DispatchQueue.global().async {
            self.checkLocationServices()
        }
    }
}

extension MapViewController {
    private func configureUI() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(plusBtn)
        plusBtn.snp.makeConstraints { make in
            make.width.height.equalTo(62)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            print("error: 위치권한 확인불가")
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        default:
            break
        }
    }
    
    @objc private func plusBtnTapped() {
        guard let location = currentLocation else {
            print("현재 위치정보 없음")
            return
        }
        delegate?.add(location: location, onComplete: { result in
            switch result {
            case .success:
                print("location: \(location)")
            case .failure(let error):
                print("에러: \(error)")
            }
        })
    }
    
    func configure(locations: [CLLocation]) {
        // pin
        for location in locations {
            mapView.addAnnotation(location as! MKAnnotation)
        }
    }
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location
    }
}

// 핀: 차후 글이 추가 완료 버튼에 추가
// pin.coordinate = currentLocation.coordinate
// mapView.addAnnotation(pin)
