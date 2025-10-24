//
//  MoniterClass.swift
//  NextEld
//
//  Created by priyanshi on 19/07/25.
//
import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = true  // Default true, update in real-time

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}

//MARK: -  for internate connectivity


class InternateNetworkConnectivity: ObservableObject {
    static let shared = NetworkMonitor()  // Singleton
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
