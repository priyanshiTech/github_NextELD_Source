//
//  TrailerViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 26/07/25.
//

import Foundation
import SwiftUI

//class TrailerViewModel: ObservableObject {
//    @Published var trailers: [String] = []
//}


class TrailerViewModel: ObservableObject {
    @Published  var selectedTrailer = ""
    @Published  var truckDefectSelection: String? = nil
    @Published  var trailerDefectSelection: String? = nil
    @Published var trailers: [String] = [] {
        didSet {
            saveTrailers()
        }
    }
    
    private let trailersKey = "savedTrailers"

    init() {
        loadTrailers()
    }

    // MARK: - Add Trailer
    func addTrailer(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        trailers.append(trimmed)
    }

    // MARK: - Remove Trailer
    func removeTrailer(_ name: String) {
        trailers.removeAll { $0 == name }
    }

    // MARK: - Save Trailers to UserDefaults
    private func saveTrailers() {
        UserDefaults.standard.set(trailers, forKey: trailersKey)
    }

    // MARK: - Load Trailers from UserDefaults
    private func loadTrailers() {
        if let saved = UserDefaults.standard.array(forKey: trailersKey) as? [String] {
            trailers = saved
        }
    }
    
    // MARK: - Get Trailer Value (from AppStorage or Database)
    func getTrailerValue() -> String {
        // First try to get from AppStorageHandler
        if let trailerInput = AppStorageHandler.shared.TrailerInput,
           !trailerInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return trailerInput
        }
        
        // If not found in AppStorage, fetch from database
        if let recentTrailer = DatabaseManager.shared.getMostRecentTrailer(),
           !recentTrailer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return recentTrailer
        }
        
        // Default fallback
        return "Upcoming"
    }
}


class ShippingDocViewModel: ObservableObject {
    @Published var ShippingDoc: [String] = []
}

import SwiftUI

final class VehicleViewModel: ObservableObject {
    @Published var vehicle: [String] = []
}

import SwiftUI

class VehicleConditionViewModel: ObservableObject {
    @Published var selectedCondition: String? = nil
    @Published var selectedVehicleNumber: String = ""
    @Published var vehicleID: Int = 0
    @Published var showPopupVechicle = false
}
