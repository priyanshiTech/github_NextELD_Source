//
//  SignatureViewModel.swift
//  NextEld
//
//  Created by priyanshi on 17/01/26.
//

import Foundation
import SwiftUI

final class SignatureViewModel: ObservableObject {

    @Published var signatureImage: UIImage? {
        didSet {
            saveSignature()
        }
    }

    private let signatureKey = "savedDriverSignature"

    init() {
        loadSignature()
    }

    // MARK: - Save
    private func saveSignature() {
        guard let image = signatureImage,
              let data = image.pngData() else { return }

        UserDefaults.standard.set(data, forKey: signatureKey)
    }

    // MARK: - Load
    private func loadSignature() {
        guard let data = UserDefaults.standard.data(forKey: signatureKey),
              let image = UIImage(data: data) else { return }

        signatureImage = image
    }

    // MARK: - Clear
    func clearSignature() {
        signatureImage = nil
        UserDefaults.standard.removeObject(forKey: signatureKey)
    }
}
