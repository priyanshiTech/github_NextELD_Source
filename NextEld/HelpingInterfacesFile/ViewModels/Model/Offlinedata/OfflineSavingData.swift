//
//  OfflineSavingData.swift
//  NextEld
//
//  Created by Priyanshi  on 17/07/25.
//

import Foundation
import SwiftUI


// MARK: - Main Response Model
struct SyncResponse: Codable {
    let result: [SyncResult]
    let arrayData: String?
    let status: String
    let message: String
    let token: String
}

// MARK: - Result Array (localId <-> serverId mapping)
struct SyncResult: Codable {
    let localId: String
    let serverId: String
}
