//
//  DisclamerAPIModel.swift
//  NextEld
//
//  Created by priyanshi  on 15/11/25.
//

import Foundation
import SwiftUI

struct DisclaimerRequest: Codable {
    let driverId: Int

}

struct DisclaimerResponse: Codable {
    let result: String
    let arrayData: [String]?
    let status: String
    let message: String
    let token: String?
}

