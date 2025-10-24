//
//  StoreEventView.swift
//  NextEld
//
//  Created by Priyanshi   on 17/06/25.
//

/*import Foundation
import PacificTrack

class StoredEventsViewModel: ObservableObject {
    @Published var storedEvents: [EventFrame] = []

    func startListeningForEvents() {
        // Start retrieving and let SDK stream individual events
        TrackerService.sharedInstance.retrieveStoredEvents { response, error in
            guard error == .noError else {
                print("Error retrieving stored events")
                return
            }

            // No need to parse `response?.events`, because events come via delegate
            print("Started retrieving stored events...")
        }
    }

    func addStoredEvent(_ event: EventFrame) {
        DispatchQueue.main.async {
            self.storedEvents.insert(event, at: 0)
        }
    }
}*/
