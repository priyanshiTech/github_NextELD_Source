//
//  TrailerViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 26/07/25.
//

import Foundation
import SwiftUI

class TrailerViewModel: ObservableObject {
    @Published var trailers: [String] = []
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
