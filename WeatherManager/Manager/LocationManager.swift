//
//  LocationManager.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import CoreLocation

enum LocationManagerStatus {
    case idle
    case authRequest
    case authUpdated
    case locationRequest
    case locationUpdated
}


class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var status = LocationManagerStatus.idle
    @Published var location: CLLocationCoordinate2D?

    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
       
    
    //Checks Authorization
    func checkAuthorization() -> Bool {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    
    //Requests WhenInUseAuthorization
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        status = .authRequest
    }
        
    
    //Gets Current Location
    func updateCurrentLocation() async {
        locationManager.startUpdatingLocation()
        status = .locationRequest
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if status == .authRequest {
            status = .authUpdated
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if status == .locationRequest {
            self.location = locationManager.location?.coordinate
            status = .locationUpdated
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: ", error)
        //Failure (error message)
    }
}
