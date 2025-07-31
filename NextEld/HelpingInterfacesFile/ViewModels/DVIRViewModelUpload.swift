//
//  DVIRViewModelUpload.swift
//  NextEld
//
//  Created by Priyanshi   on 31/07/25.
//

import Foundation
import SwiftUI


class DvirViewModel: ObservableObject {
    @Published var uploadSuccess = false
    @Published var errorMessage: String?

    func uploadRecord(_ record: DvirRecord) {
        DvirAPIService.shared.uploadDvirRecord(record: record) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.uploadSuccess = true
                    self.errorMessage = nil
                case .failure(let error):
                    self.uploadSuccess = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}





