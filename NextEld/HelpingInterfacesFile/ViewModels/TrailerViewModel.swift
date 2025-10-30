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
}
