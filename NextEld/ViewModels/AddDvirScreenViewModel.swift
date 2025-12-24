//
//  AddDvirScreenViewModel.swift
//  NextEld
//
//  Created by Auto on 11/01/25.
//

import SwiftUI

@MainActor
class AddDvirScreenViewModel: ObservableObject {
    // MARK: - Text & Notes
    @Published var notesText: String = ""
    
    // MARK: - Signature
    @Published var showSignaturePopup = false
    @Published var signaturePath = Path()
    @Published var signaturePoints: [CGPoint] = []
   // @Published var signaturePoints: [[CGPoint]] = []

    @Published var signatureImage: UIImage? = nil
    @Published var showSignaturePad = false
    @Published var alertType: DvirAlertType? = nil

    // MARK: - Popups & Alerts
    @Published var Showpopup: Bool = false
    @Published var selectedTab = ""
    @Published var showValidationAlert = false
    @Published var showSuccessAlert = false
    @Published var successMessage = ""
    @Published var showPopup = false
    @Published var popupType: String = ""
    @Published var showCoDriverPopup = false
    
    // MARK: - Validation
    @Published var validationMessage: String = ""
    
    // MARK: - Driver Information
    @Published var driverName: String = ""
    @Published var odometer: Double = 0.0
    @Published var companyName: String = ""
    @Published var Location: String = ""
    @Published var driverID: String = ""
    @Published var driverDVIRId: Int = 0
    
    // MARK: - Time Information
    @Published var StartTime: String = ""
    @Published var Drivetime: String = ""
    
    // MARK: - Co-Driver
    @Published var selectedCoDriver: String? = nil
    
    
    @Published var isLoading: Bool = false
    
    
}



// Add this enum to your ViewModel or at the top of your view file
enum DvirAlertType: Identifiable {
    case validation(String)
    case success(String)
    
    var id: String {
        switch self {
        case .validation(let message): return "validation-\(message.hashValue)"
        case .success(let message): return "success-\(message.hashValue)"
        }
    }
}
