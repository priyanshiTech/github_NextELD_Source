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

    func uploadCertifiedLog(
        driverId: Int,
        vehicleId: String,
        coDriverId: String,
        trailers: String,
        shippingDocs: String,
        certifiedDate: String,
        fileURL: URL,
        tokenNo: String,
        certifiedDateTime: String,
        certifiedAt: String
    ) {

        isLoading = true

        guard let fileData = try? Data(contentsOf: fileURL) else {
            self.message = "Cannot read file data"
            self.isLoading = false
            return
        }

        let fields: [String: String] = [
            "driverId": String(driverId),
            "vehicleId": String(vehicleId),
            "coDriverId": String(coDriverId),
            "trailers": trailers,
            "shippingDocs": shippingDocs,
            "certifiedDate": certifiedDate,
            "tokenNo": tokenNo,
            "certifiedDateTime": certifiedDateTime,
            "certifiedAt": certifiedAt
        ]



        
        let file = MultipartFile(
            name: "file",
            filename: fileURL.lastPathComponent,
            mimeType: "application/octet-stream",
            data: fileData
        )

        let url  = API.Endpoint.certifyDriver.url
        
        MultipartAPIService.shared.upload(url: url, fields: fields, files: [file]) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(CertifiedLogResponse.self, from: data)
                        self?.message = response.message
                        self?.result = response.result
                        self?.status = response.status
                        self?.token = response.token
                    } catch {
                        self?.message = "Decoding error: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    self?.message = "Upload failed: \(error.localizedDescription)"
                }
            }

        }
    }
}

