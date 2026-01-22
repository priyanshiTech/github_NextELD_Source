//
//  TrailerViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 26/07/25.
//

import Foundation
import SwiftUI

class TrailerViewModel: ObservableObject, Hashable, Equatable {
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
        // If not found in AppStorage, fetch from database
        if let recentTrailer = DatabaseManager.shared.getMostRecentTrailer(),
           !recentTrailer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return recentTrailer
        }
        
        // Default fallback
        return "None"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trailers)
    }
    
    static func == (lhs: TrailerViewModel, rhs: TrailerViewModel) -> Bool {
        lhs.trailers == rhs.trailers
    }
}

class ShippingDocViewModel: ObservableObject, Hashable, Equatable {
    @Published  var selectedTrailer = ""
    @Published  var truckDefectSelection: String? = nil
    @Published  var trailerDefectSelection: String? = nil
    @Published var ShippingDoc: [String] = [] {
        didSet {
            saveshipping()
        }
    }
    
    private let shippingKey = "savedshipping"
    
    init() {
        loadshippings()
    }
    
    // MARK: - Add shipping
    func addShpping(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        ShippingDoc.append(trimmed)
    }
    
    // MARK: - Remove shipping
    func removeshipping(_ name: String) {
        ShippingDoc.removeAll { $0 == name }
    }
    
    // MARK: - Save shipping to UserDefaults
    private func saveshipping() {
        UserDefaults.standard.set(ShippingDoc, forKey: shippingKey)
    }
    
    // MARK: - Load shipping from UserDefaults
    private func loadshippings() {
        if let saved = UserDefaults.standard.array(forKey: shippingKey) as? [String] {
            ShippingDoc = saved
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ShippingDoc)
    }
    
    static func == (lhs: ShippingDocViewModel, rhs: ShippingDocViewModel) -> Bool {
        return lhs.ShippingDoc == rhs.ShippingDoc
    }
}

//class ShippingDocViewModel: ObservableObject, Equatable, Hashable {
//    @Published var ShippingDoc: [String] = []
//    @Published private var inputText = ""
//    @Published  var showError = false
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(ShippingDoc)
//    }
//    
//    static func == (lhs: ShippingDocViewModel, rhs: ShippingDocViewModel) -> Bool {
//        return lhs.ShippingDoc == rhs.ShippingDoc
//    }
//}

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
