//
//  PT30DataViewModel.swift
//  NextEld
//
//  Created by Priyanshi   on 17/06/25.
//
//

/*import Foundation
import PacificTrack

class PT30DataViewModel: NSObject, ObservableObject, TrackerServiceDelegate {

   // static let shared = PT30DataViewModel()
    @Published var connectionStatus: String = "Idle"
  override init() {
        super.init()
    }

    func trackerService(_ trackerService: TrackerService, didSync trackerInfo: TrackerInfo) {
        print("✅ Synced tracker info: \(trackerInfo)")
    }

    func trackerService(_ trackerService: TrackerService, didReceive event: EventFrame, processed: (Bool) -> Void) {
        print("📥 Received event: \(event)")
        processed(true)
    }

    func trackerService(_ trackerService: TrackerService, didRetrieve event: EventFrame, processed: (Bool) -> Void) {
        print("📤 Retrieved event: \(event)")
        processed(true)
    }

    func trackerService(_ trackerService: TrackerService, didReceiveSPN spnEvent: SPNEventFrame, processed: (Bool) -> Void) {
        print("🔧 Received SPN event: \(spnEvent)")
        processed(true)
    }

    func trackerService(_ trackerService: TrackerService, didReceieveVirtualDashboardReport virtualDashboardReport: VirtualDashboardReport) {
        print("📊 Virtual dashboard: \(virtualDashboardReport)")
    }

    func trackerService(_ trackerService: TrackerService, onFirmwareUpgradeProgress progress: Float) {
        print("⬆️ Firmware upgrade progress: \(progress * 100)%")
    }

    func trackerService(_ trackerService: TrackerService, onFirmwareUpgradeFailed error: TrackerUpgradeError) {
        print("❌ Firmware upgrade failed: \(error)")
    }

    func trackerService(_ trackerService: TrackerService, onFirmwareUpgradeCompleted completed: Bool) {
        print("✅ Firmware upgrade completed: \(completed)")
    }

    func trackerService(_ trackerService: TrackerService, onError error: TrackerServiceError) {
        connectionStatus = "⚠️ Tracker error: \(error)"
    }
}*/
