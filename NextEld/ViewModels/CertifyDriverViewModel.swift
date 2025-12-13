//
//  CertifyDriverViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 14/08/25.
//

import Foundation
import SwiftUI

@MainActor

class CertifyDriverViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var message: String?
    @Published var result: String?
    @Published var status: String?
    @Published var token: String?
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?
    
    
    func addCertifiedLog(
        driverId: Int,
        vehicleId: Int,
        coDriverId: Int,
        trailers: String,
        shippingDocs: String,
        certifiedDate: String,
        fileURL: URL,
        tokenNo: String,
        certifiedDateTime: String,
        certifiedAt: String,
        completion: @escaping (Result<String, Error>) -> Void   //  ADD THIS
    ) {
        isLoading = true

        guard let fileData = try? Data(contentsOf: fileURL) else {
            self.message = "Cannot read file data"
            self.isLoading = false
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot read file data"])))
            return
        }

        let fields: [String: Any] = [
            "driverId": driverId,
            "vehicleId": vehicleId,
            "coDriverId": coDriverId,
            "trailers": trailers,
            "shippingDocs": shippingDocs,
            "certifiedDate": certifiedDate,
            "tokenNo": tokenNo,
            "certifiedDateTime": certifiedDateTime,
            "certifiedAt": certifiedAt
        ]
        
        print("fields request############ data : \(fields)")

        let file = MultipartFile(
            name: "file",
            filename: fileURL.lastPathComponent,
            mimeType: "application/octet-stream",
            data: fileData
        )

        let url  = API.Endpoint.certifyDriver.url

        MultipartAPIService.shared.upload(url: url, fields: fields, files: [file]) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(CertifiedLogResponse.self, from: data)
                        self.message = response.message
                        self.result = response.result
                        self.status = response.status
                        self.token = response.token
                        
                        
                        if response.token.lowercased() == "false" {
                            SessionManagerClass.shared.clearToken()
                            self.isSessionExpired = true
                            // print(" Session expired detected during certify upload")
                            // print(" appRootManager is \(self.appRootManager != nil ? "set" : "nil")")
                            self.appRootManager?.currentRoot = .SessionExpireUIView
                            completion(.failure(NSError(domain: "SessionExpired", code: 401, userInfo: [NSLocalizedDescriptionKey: "Session expired"])))
                            return
                        }

                        completion(.success(response.message ?? "Success"))   //  call completion
                    } catch {
                        self.message = "Decoding error: \(error.localizedDescription)"
                        completion(.failure(error))
                    }
                case .failure(let error):
                    self.message = "Upload failed: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }
//MARK: -  update Certify Function (Simple JSON API)
    func updateCertifiedLog(
        driverId: String,
        certifiedDate: String,
        vehicleId: String,
        coDriverId: String,
        trailers: [String],
        shippingDocs: [String],
        fileURL: URL, // Not used in simple JSON API, but kept for compatibility
        tokenNo: String,
        certifiedDateTime: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        isLoading = true
        
        let requestBody = UpdateCertifiedLogRequest(
            driverId: driverId,
            certifiedDate: certifiedDate,
            vehicleId: vehicleId,
            coDriverId: coDriverId,
            trailers: trailers,
            shippingDocs: shippingDocs,
            tokenNo: tokenNo,
            certifiedDateTime: certifiedDateTime
        )
        print ("updated request****** \(requestBody)" )
        Task {
            do {
                let response: CertifiedLogResponse = try await NetworkManager.shared.post(
                    .updateCertifyDriver,
                    body: requestBody
                )
                
                await MainActor.run {
                    self.isLoading = false
                    self.message = response.message
                    self.result = response.result
                    self.status = response.status
                    self.token = response.token
                    
                    // Session expiration handling
                    if response.token.lowercased() == "false" {
                        SessionManagerClass.shared.clearToken()
                        self.isSessionExpired = true
                        self.appRootManager?.currentRoot = .SessionExpireUIView
                        completion(.failure(NSError(domain: "SessionExpired", code: 401, userInfo: [NSLocalizedDescriptionKey: "Session expired"])))
                        return
                    }
                    
                    completion(.success(response.message ?? "Updated successfully"))
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.message = "Update failed: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }


    
    
    
    
    
 
}

