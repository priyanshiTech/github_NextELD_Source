//
//  OfflineSavingData.swift
//  NextEld
//
//  Created by Priyanshi  on 17/07/25.
//

import Foundation
import SwiftUI


struct SyncResponse: Codable {
    let message: String?
    let result: [SyncResult]?
    let token: String?
}

struct SyncResult: Codable {
    let localId: String
    let serverId: String
}
