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
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if status == "auth_request" {
            status = "auth_updated"
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Success
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Failure (error message)
    }
}
