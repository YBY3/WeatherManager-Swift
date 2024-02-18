//
//  LocationManager.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var status = "idle"
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
        status = "auth_request"
        
    }
        
    
    //Gets Current Location
    func updateCurrentLocation() async {
        locationManager.startUpdatingLocation()
        status = "location_request"
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if status == "auth_request" {
            status = "auth_updated"
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locationManager.location?.coordinate
        if status == "location_request" {
            status = "location_updated"
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: ", error)
        //Failure (error message)
    }
}
