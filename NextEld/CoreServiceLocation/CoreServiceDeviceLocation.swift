//
//  CoreServiceDeviceLocation.swift
//  NextEld
//
//  Created by priyanshi  on 02/09/25.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

class DeviceLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var fullAddress: String?   //  add this

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        // Reverse Geocoding
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let placemark = placemarks?.first {
                
                var address = ""
                // if let subLocality = placemark.subLocality { address += ", \(subLocality)" }
                //  if let subAdministrativeArea = placemark.subAdministrativeArea { address += ", \(subAdministrativeArea)" }
                if let name = placemark.name { address += name }
                if let locality = placemark.locality { address += ", \(locality)" }
                if let administrativeArea = placemark.administrativeArea { address += ", \(administrativeArea)" }
                if let postalCode = placemark.postalCode { address += " \(postalCode)" }
                if let country = placemark.country { address += ", \(country)" }
                
                DispatchQueue.main.async {
                    self?.fullAddress = address
                }
            }
        }
    }
}
