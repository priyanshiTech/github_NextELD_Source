//  HalfScreenMapView.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import SwiftUI
import MapKit
import CoreLocation

struct HalfScreenMapView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: false)
                .frame(height: 250)
                .cornerRadius(10)
                .padding(.horizontal)

            if let coordinate = locationManager.currentLocation?.coordinate {
                GeometryReader { geo in
                    let mapWidth = geo.size.width
                    let mapHeight = geo.size.height

                    // Convert GPS to map point (approximate logic)
                    let xOffset = CGFloat((coordinate.longitude - locationManager.region.center.longitude) / locationManager.region.span.longitudeDelta)
                    let yOffset = CGFloat((locationManager.region.center.latitude - coordinate.latitude) / locationManager.region.span.latitudeDelta)

                    let xPos = mapWidth / 2 + xOffset * mapWidth
                    let yPos = mapHeight / 2 + yOffset * mapHeight

                    CarWithLocationBadge(isTracking: locationManager.isUpdatingLocation)
                        .frame(width: 40, height: 40)
                        .position(x: xPos, y: yPos)
                }
                .frame(height: 250)
            }
        }.frame(maxWidth: .infinity) // Ensure full width in parent
    }
}

struct CarWithLocationBadge: View {
    var isTracking: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image("CarIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(radius: 2)

        }
    }
}


