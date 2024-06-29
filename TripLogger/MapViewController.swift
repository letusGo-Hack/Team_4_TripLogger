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
    func add(location: CLLocation)
}

class MapViewController: UIViewController {
    weak var delegate: MapViewControllerDelegate?
    
    private lazy var mapView = MKMapView()
    private lazy var locationManager = CLLocationManager()
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
    
    private let weatherView = UIView()
    private let weatherImage = UIImageView()
    private let weatherTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    private lazy var weatherButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(weatherButtonTouchUpInside), for: .touchUpInside)
        return button
    }()
    
    
    init(locations: [CLLocation]) {
            super.init(nibName: nil, bundle: nil)
            self.addPin(locations: locations)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        DispatchQueue.global().async {
            self.checkLocationServices()
        }
        
        Task {
            let info = try await WeatherManager.shared.fetchWeatherInHour(location: currentLocation)
            weatherImage.image = UIImage(systemName: info?.condition.sfsymbol ?? "")
            if let futureDate = info?.date, let diffTime = calculateTimeDifference(from: futureDate) {
                weatherTimeLabel.text = "\(diffTime.hours):\(diffTime.minutes) 후"
            }
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
        
        view.addSubview(weatherView)
        weatherView.backgroundColor = .white
        weatherView.addSubview(weatherImage)
        weatherView.addSubview(weatherTimeLabel)
        weatherView.addSubview(weatherButton)
        
        weatherView.snp.makeConstraints {
            $0.size.equalTo(62)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
        weatherView.layer.cornerRadius = 30
        
        weatherImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(30)
            $0.top.equalToSuperview().offset(10)
        }
        
        weatherTimeLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        weatherButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        delegate?.add(location: location)
    }
    
    func addPin(locations: [CLLocation]) {
        // pin
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    private func calculateTimeDifference(from date: Date) -> (hours: Int, minutes: Int)? {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: currentDate, to: date)
        
        guard let hours = components.hour, let minutes = components.minute else {
            return nil
        }
        
        return (hours, minutes)
    }
    
    @objc
    private func weatherButtonTouchUpInside() {
        UIApplication.shared.open(URL(string: "weather:weather://")!)
    }
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let location = view.annotation?.coordinate else { return }
        delegate?.add(location: CLLocation(latitude: location.latitude, longitude: location.longitude))
    }
}

// 핀: 차후 글이 추가 완료 버튼에 추가
// pin.coordinate = currentLocation.coordinate
// mapView.addAnnotation(pin)
