//  HalfScreenMapView.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import SwiftUI
import MapKit

struct HalfScreenMapView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.horizontal)
    }
} 