//
//  DriverSignatiureView.swift
//  NextEld
//
//  Created by Inurum   on 26/05/25.
//

import Foundation
import SwiftUI

struct SignatureCertifyView: View {
    @Binding var signaturePath: Path
    @State private var showAlert = false


    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()

            Text("Driver Signature")
                .font(.headline)
                .padding(.leading)
            
            SignaturePad(path: $signaturePath)
                .frame(height: 250)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10)) // restrict drawing to shape
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

                
                Button("Agree") {
                    // 1. Verify there's actually a signature
                    guard !signaturePath.isEmpty else {
                        showAlert = true
                        return
                    }

                    // 2. Render the signature as image
                    let size = CGSize(width: 300, height: 250)
                    let image = renderSignatureAsImage(path: signaturePath, size: size)

                    // 3. Convert to JPEG data (matches .jpg filename)
                    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                        print("Failed to convert signature to JPEG data")
                        return
                    }

                    // 4. Save signature JPEG to a temporary file with dynamic filename
                    let driverId = "17"
                    let TokenNo = UserDefaults.standard.string(forKey: "authToken") ?? ""
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let fileURL = tempDirectory.appendingPathComponent("\(driverId)_sign_1.jpg")
                    print("here is your File URL Bro*******\(fileURL)")

                    do {
                        try imageData.write(to: fileURL)
                    } catch {
                        print("Failed to write signature to file: \(error)")
                        return
                    }

                    // 5. Call the CertifyDriver API
                    let viewModel = CertifyDriverViewModel()
                    viewModel.uploadCertifiedLog(
                        driverId: "17",
                        vehicleId: "2",
                        coDriverId: "0",
                        trailers: "aaa,zzz",
                        shippingDocs: "aaa,bbb,ccc",
                        certifiedDate: "2025-08-13",
                        fileURL: fileURL,
                        tokenNo: TokenNo,
                        certifiedDateTime: "1755129599000", // <- numeric timestamp
                        certifiedAt: "1755150649"        // <- numeric timestamp
                    )


                    // 6. Save to local database
                    let record = DvirRecord(
                        driver: "Driver Name",
                        time: "Current Time",
                        date: "Current Date",
                        odometer: "Odometer Reading",
                        company: "Company Name",
                        location: "Location",
                        vehicle: "Vehicle Number",
                        trailer: "Trailer Number",
                        truckDefect: "Truck Defects",
                        trailerDefect: "Trailer Defects",
                        vehicleCondition: "Vehicle Condition",
                        notes: "Additional Notes",
                        signature: imageData
                    )

                    DvirDatabaseManager.shared.insertRecord(record)
                    print("Save DVIR Data Re4cord Successfully \(record)")

                    // 7. Show alert to user
                    showAlert = true
                }


            
                .alert("Image Saved", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Signature image saved successfully.")
                }
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
    }
    
    
}

#Preview {
    SignatureCertifyPreviewWrapper()
}


//MARK:  popup view Resuable
struct SignatureCertifyPreviewWrapper: View {
    @State private var path = Path()
    
    var body: some View {
        SignatureCertifyView(signaturePath: $path)
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
                Color.black.opacity(0.4)
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
                        .frame(maxWidth: 250)
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
