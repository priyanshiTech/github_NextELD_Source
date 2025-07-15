//  LocationManager.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var isUpdatingLocation: Bool = false
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.7196, longitude: 75.8577),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var locationError: String?
    @Published var currentLocation: CLLocation? = nil //  ADD THIS
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        isUpdatingLocation = true
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        isUpdatingLocation = false
    }

    //  Update currentLocation and region on update
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.last else { return }

         DispatchQueue.main.async {
             self.currentLocation = location
             self.region.center = location.coordinate
         }
     }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                locationError = "Location access denied. Please enable in Settings."
            case .locationUnknown:
                locationError = "Unable to determine location."
            default:
                locationError = "Location error: \(error.localizedDescription)"
            }
        } else {
            locationError = "Location error: \(error.localizedDescription)"
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationError = "Location permission not determined"
        case .restricted:
            locationError = "Location access restricted"
        case .denied:
            locationError = "Location access denied. Please enable in Settings."
        case .authorizedAlways, .authorizedWhenInUse:
            locationError = nil
            startUpdatingLocation()
        @unknown default:
            locationError = "Unknown authorization status"
        }
    }
} 
