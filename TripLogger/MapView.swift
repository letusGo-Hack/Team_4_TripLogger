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
}
