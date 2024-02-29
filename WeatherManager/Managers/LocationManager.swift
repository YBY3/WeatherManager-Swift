//
//  LocationManager.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import CoreLocation

enum LocationManagerState {
    case idle
    case authRequest
    case authUpdated
    case locationRequest
    case locationUpdated
}


protocol LocationManagerProtocol: ObservableObject {
    var status: LocationManagerState { get }
    var location: CLLocationCoordinate2D? { get }
    
    func checkAuthorization() -> Bool
    func requestAuthorization()
    func updateCurrentLocation()
}


class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {
    @Published var status = LocationManagerState.idle
    @Published var location: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()

    
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
    func updateCurrentLocation() {
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
