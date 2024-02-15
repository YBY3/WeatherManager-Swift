//
//  LocationManager.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var status = "loading"
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
    func checkAuthorization() {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            status = "authorized"
        } else { status = "nil" }
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    //Gets Current Location (WIP)
    func updateCurrentLocation() async throws {
        locationManager.startUpdatingLocation()
        
        if let location = locationManager.location?.coordinate {
            locationManager.stopUpdatingLocation()
            self.location = location
            status = "complete"
        }
        
        else {
            print("Location Problem") //WIP
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Success
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Failure (error message)
    }
}
