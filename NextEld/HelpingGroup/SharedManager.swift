//
//  SharedManager.swift
//  NextEld
//
//  Created by priyanshi on 21/08/25.
//

import Foundation
class DutyStatusManager: ObservableObject {
    @Published var dutyStatus: String = DriverStatusConstants.offDuty
}
