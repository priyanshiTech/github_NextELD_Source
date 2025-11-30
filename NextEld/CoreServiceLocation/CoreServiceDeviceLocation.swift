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
    private let geocoder = CLGeocoder()
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var fullAddress: String?   //  add this
    
    // Throttling properties to prevent excessive reverse geocoding requests
    private var lastGeocodeTime: Date?
    private var lastGeocodeLocation: CLLocation?
    private var isGeocodingInProgress = false
    private let minGeocodeInterval: TimeInterval = 30.0 // Minimum 30 seconds between geocoding requests
    private let minDistanceForGeocode: CLLocationDistance = 100.0 // Minimum 100 meters distance change
    private var pendingGeocodeWorkItem: DispatchWorkItem?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10 // Only update when moved 10 meters
        manager.requestWhenInUseAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectionChange), name: .deviceConnectionChanged, object: nil)
        updateTrackingState()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard AppStorageHandler.shared.isDeviceConnected else { return }
        guard let location = locations.last else { return }
        
        // Always update coordinates and persist for log saves
        let coordinate = location.coordinate
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        
        // Throttled Reverse Geocoding - only geocode if:
        // 1. Enough time has passed since last geocode (30 seconds)
        // 2. Location has changed significantly (100 meters)
        // 3. No geocoding is currently in progress
        
        let shouldGeocode: Bool = {
            // Check if geocoding is already in progress
            if isGeocodingInProgress {
                return false
            }
            
            // Check time interval
            if let lastTime = lastGeocodeTime {
                let timeSinceLastGeocode = Date().timeIntervalSince(lastTime)
                if timeSinceLastGeocode < minGeocodeInterval {
                    return false
                }
            }
            
            // Check distance change
            if let lastLocation = lastGeocodeLocation {
                let distance = location.distance(from: lastLocation)
                if distance < minDistanceForGeocode {
                    return false
                }
            }
            
            return true
        }()
        
        if shouldGeocode {
            performReverseGeocoding(location: location)
        }
    }

    @objc private func handleConnectionChange() {
        updateTrackingState()
    }

    private func updateTrackingState() {
        if AppStorageHandler.shared.isDeviceConnected {
            manager.startUpdatingLocation()
        } else {
            manager.stopUpdatingLocation()
            DispatchQueue.main.async {
                self.latitude = nil
                self.longitude = nil
                self.fullAddress = nil
            }
        }
    }
    
    private func performReverseGeocoding(location: CLLocation) {
        // Cancel any pending geocode work
        pendingGeocodeWorkItem?.cancel()
        
        // Create new work item
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            self.isGeocodingInProgress = true
            
            self.geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                guard let self = self else { return }
                
                self.isGeocodingInProgress = false
                
                if let error = error {
                    // Don't log throttling errors - they're expected
                    if (error as NSError).domain != "GEOErrorDomain" || (error as NSError).code != -3 {
                        print(" Reverse geocoding error: \(error.localizedDescription)")
                    }
                    return
                }
                
                if let placemark = placemarks?.first {
                    var address = ""
                    if let name = placemark.name { address += name }
                    if let locality = placemark.locality { address += ", \(locality)" }
                    if let administrativeArea = placemark.administrativeArea { address += ", \(administrativeArea)" }
                    if let postalCode = placemark.postalCode { address += " \(postalCode)" }
                    if let country = placemark.country { address += ", \(country)" }
                    
                    DispatchQueue.main.async {
                        self.fullAddress = address
                        self.lastGeocodeTime = Date()
                        self.lastGeocodeLocation = location
                    }
                }
            }
        }
        
        pendingGeocodeWorkItem = workItem
        
        // Execute with a small delay to batch rapid updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        pendingGeocodeWorkItem?.cancel()
        geocoder.cancelGeocode()
    }
}
