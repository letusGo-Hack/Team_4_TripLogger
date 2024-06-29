//
//  MapView.swift
//  TripLogger
//
//  Created by LeeWanJae on 6/29/24.
//

import MapKit
import UIKit
import SnapKit
import CoreLocation

class MapView: UIViewController {
    private lazy var mapView = MKMapView()
    private lazy var locationManager = CLLocationManager()
    private lazy var pin = MKPointAnnotation()
    private var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        DispatchQueue.global().async {
            self.checkLocationServices()
        }
    }
}

extension MapView {
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
}

extension MapView: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location
    }
}

// 핀: 차후 글이 추가 완료 버튼에 추가
// pin.coordinate = currentLocation.coordinate
// mapView.addAnnotation(pin)
