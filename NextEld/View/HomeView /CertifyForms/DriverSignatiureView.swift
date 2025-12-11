//
//  DriverSignatiureView.swift
//  NextEld
//
//  Created by priyanshi   on 26/05/25.
//


import Foundation
import SwiftUI

struct SignatureCertifyView: View {
    // Inputs
    @Binding var signaturePath: Path

    var skipFormValidation: Bool = false
    var selectedVehicle: String = "none"
       var selectedTrailer: String = "None"
       var selectedShippingDoc: String = "None"
       var selectedCoDriver: String? = nil
       var selectedCoDriverID: Int? = nil
       var certifiedDate: String = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
       var onCertified: (() -> Void)? = nil
        var onDismiss: (() -> Void)? = nil

    // Env
    @EnvironmentObject var trailerVM: TrailerViewModel
    @EnvironmentObject var shippingVM: ShippingDocViewModel
    @EnvironmentObject var appRootManager: AppRootManager
    @StateObject private var networkMonitor = InternateNetworkConnectivity.shared
    @StateObject private var certifyVM = CertifyDriverViewModel()

    // UI state
    @State private var showAlert = false
    @State private var alertTitle = "Alert"
    @State private var alertMessage = ""
    @State private var isLoading = false

    private var isFormValid: Bool {
        let vehOK = !selectedVehicle.isEmpty && selectedVehicle != "None"
        let trlOK = !selectedTrailer.isEmpty && selectedTrailer != "None"
        let docOK = !selectedShippingDoc.isEmpty && selectedShippingDoc != "None"

        // --- Co-driver logic updated ---
        let coOK: Bool = {
            if (selectedCoDriver?.lowercased().trimmingCharacters(in: .whitespaces)) != nil {
                return true    // Always true → “None” allowed
            }
            return true
        }()

        // ID also allowed to be nil (None case)
        let coIDOK = true

        return vehOK && trlOK && docOK && coOK && coIDOK
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()

            Text("Driver Signature")
                .font(.headline)
                .padding(.leading)

            SignaturePad(path: $signaturePath)
                .frame(height: 250)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding(.horizontal)

            Text("I hereby certify that my data entries and my record of duty status for this 24 hour period are true and correct")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            HStack(spacing: 16) {
                Button("Clear Signature") {
                    signaturePath = Path()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .bold()
                .lineLimit(1)
                .font(.footnote)
                .background(Color.white)
                .foregroundColor(Color(uiColor: .wine))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(uiColor: .wine), lineWidth: 1)
                )
                Button(action: {
                    
                    // 1) Form validation (skip if flag is true)
                    if !skipFormValidation {
                        guard isFormValid else {
                            alertTitle = "Incomplete Form"
                            alertMessage = "Please fill the form first."
                            showAlert = true
                            return
                        }
                    }
                    
                    // 2) Signature validation
                    guard !signaturePath.isEmpty else {
                        alertTitle = "Signature Required"
                        alertMessage = "Please provide a signature."
                        showAlert = true
                        return
                    }
                    
                    // 3) Render signature to image
                    let size = CGSize(width: 300, height: 250)
                    let image = renderSignatureAsImage(path: signaturePath, size: size)
                    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                        alertTitle = "Error"
                        alertMessage = "Failed to convert signature."
                        showAlert = true
                        return
                    }
                    
                    // 4) Save temp file
                    guard let driverId = AppStorageHandler.shared.driverId else {
                        alertTitle = "Error"
                        alertMessage = "Missing driverId."
                        showAlert = true
                        return
                    }
                    
                    let tokenNo = AppStorageHandler.shared.authToken
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let fileURL = tempDirectory.appendingPathComponent("\(driverId)_sign_1.jpg")
                    
                    do {
                        try imageData.write(to: fileURL)
                    } catch {
                        alertTitle = "Error"
                        alertMessage = "Failed to save signature file."
                        showAlert = true
                        return
                    }
                    
                    // --- Mark record as Certified, but syncStatus = 0 initially
//                    CertifyDatabaseManager.shared.updateCertifyStatus(
//                        for: certifiedDate,
//                        isCertify: "Yes",
//                        syncStatus: 0
//                    )
                    
                    //  5) Check Internet before API
                    guard networkMonitor.isConnected else {
                        alertTitle = "No Internet"
                        alertMessage = "Please check your connection and try again."
                        showAlert = true
                        return
                    }

                    //  6) Call API with completion
                    isLoading = true
                    certifyVM.appRootManager = appRootManager
                    
                    // Check if record already exists for this date
                    // Agar record exist karta hai (same date) → UPDATE API (kyunki update karna hai)
                    // Agar record exist nahi karta → ADD API (naya record banana hai)
                    let existingRecord = CertifyDatabaseManager.shared.fetchAllRecords()
                        .first { $0.date == certifiedDate &&  $0.syncStatus == 1 }
                    let isAlreadyCertified = existingRecord != nil
                    
                    var certifyTimeStamp  = currentTimestampMillis()
                                        if DateTimeHelper.currentDate() != certifiedDate {
                                            // time required always in format certifyDate+" 23:59:59"
                                            let certifiedDateTime = DateTimeHelper.endOfDay(for: certifiedDate.asDate(format: .dateOnlyFormat) ?? Date())?.addingTimeInterval(-1)
                                            certifyTimeStamp = String((certifiedDateTime?.timeIntervalSince1970 ?? 0) * 1000)
                                        }
                    
                    
                    if isAlreadyCertified {
                        // UPDATE API - Agar pehle se green/certified hai
                        print("UPDATE API called - Already certified (Green)")
                        certifyVM.updateCertifiedLog(
                            driverId: "\(driverId)",
                            certifiedDate: certifiedDate,
                            vehicleId: "\(AppStorageHandler.shared.vehicleId ?? 0)",
                            coDriverId: "\(AppStorageHandler.shared.coDriverId ?? 0)",
                            trailers: trailerVM.trailers,
                            shippingDocs: shippingVM.ShippingDoc,
                            fileURL: fileURL,
                            tokenNo: tokenNo ?? "not Found",
                            certifiedDateTime: "\(certifyTimeStamp)"
                        ) { result in
                            DispatchQueue.main.async {
                                isLoading = false
                                if certifyVM.isSessionExpired {
                                    return
                                }
                                switch result {
                                case .success(let apiMessage):
                                    alertTitle = "Success"
                                    alertMessage = apiMessage.isEmpty ? "Certification updated successfully." : apiMessage
                                    CertifyDatabaseManager.shared.updateCertifyStatus(
                                        for: certifiedDate,
                                        isCertify: "Yes",
                                        syncStatus: 1
                                    )
                                    NotificationCenter.default.post(name: .certifyUpdated, object: certifiedDate)
                                    onCertified?()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        onDismiss?()
                                    }
                                case .failure(let err):
                                    alertTitle = "Error"
                                    alertMessage = err.localizedDescription
                                    CertifyDatabaseManager.shared.updateCertifyStatus(
                                        for: certifiedDate,
                                        isCertify: "Yes",
                                        syncStatus: 0
                                    )
                                }
                                showAlert = true
                            }
                        }
                    } else {
                        // ADD API - Agar red/uncertified hai
                        print("ADD API called - Not certified yet (Red)")
                        // Convert arrays to comma-separated strings for addCertifiedLog
                        let trailersString = trailerVM.trailers.isEmpty ? "None" : trailerVM.trailers.joined(separator: ", ")
                        let shippingDocsString = shippingVM.ShippingDoc.isEmpty ? "None" : shippingVM.ShippingDoc.joined(separator: ", ")
                        
                        certifyVM.addCertifiedLog(
                            driverId: driverId,
                            vehicleId: AppStorageHandler.shared.vehicleId ?? 0,
                            coDriverId: AppStorageHandler.shared.coDriverId ?? 0,
                            trailers: trailersString,
                            shippingDocs: shippingDocsString,
                            certifiedDate: certifiedDate,
                            fileURL: fileURL,
                            tokenNo: tokenNo ?? "not Found",
                            certifiedDateTime: "\(certifyTimeStamp)",
                            certifiedAt: String(CurrentTimeHelperStamp.currentTimestamp / 1000)
                        ) { result in
                            DispatchQueue.main.async {
                                isLoading = false
                                if certifyVM.isSessionExpired {
                                    return
                                }
                                switch result {
                                case .success(let apiMessage):
                                    alertTitle = "Success"
                                    alertMessage = apiMessage.isEmpty ? "Certified successfully." : apiMessage
                                    CertifyDatabaseManager.shared.updateCertifyStatus(
                                        for: certifiedDate,
                                        isCertify: "Yes",
                                        syncStatus: 1
                                    )
                                    NotificationCenter.default.post(name: .certifyUpdated, object: certifiedDate)
                                    onCertified?()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        onDismiss?()
                                    }
                                case .failure(let err):
                                    alertTitle = "Error"
                                    alertMessage = err.localizedDescription
                                    CertifyDatabaseManager.shared.updateCertifyStatus(
                                        for: certifiedDate,
                                        isCertify: "Yes",
                                        syncStatus: 0
                                    )
                                }
                                showAlert = true
                            }
                        }
                    }
//
                    
                   

                }) {
                    Text(isLoading ? "Please wait..." : "Agree")
                }
                .disabled(isLoading)
                .frame(maxWidth: .infinity)
                .padding()
                .bold()
                .font(.footnote)
                .background(Color(uiColor: .wine))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .transition(.slide)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}


//MARK: -  create a popup for resuable in app

struct PopupContainer<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        if isPresented {
            ZStack {
                Color(uiColor:.black).opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ZStack(alignment: .topTrailing) {
                        VStack {
                            content
                        }

                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .frame(maxWidth: 280)
                        .fixedSize(horizontal: false, vertical: true)

                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                                .padding(12)
                        }
                    }
                }
            }
            .zIndex(10)
        }
    }
}

//MARK: -  to save a  signature path into DB

func renderSignatureAsImage(path: Path, size: CGSize) -> UIImage {
    let controller = UIHostingController(rootView: SignaturePad(path: .constant(path)))
    controller.view.bounds = CGRect(origin: .zero, size: size)

    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
        controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
}

extension Notification.Name {
    static let certifyUpdated = Notification.Name("certifyUpdated")
}





// 1) Form validation
//                    guard isFormValid else {
//                        alertTitle = "Incomplete Form"
//                        alertMessage = "Please fill the form first."
//                        showAlert = true
//                        return
//                    }
//















