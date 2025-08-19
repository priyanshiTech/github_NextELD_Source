//
//  UI&SwiftUIConnecter.swift
//  NextEld
//
//  Created by Priyanshi   on 18/06/25.
//

import Foundation
import SwiftUI
import UIKit

//struct DeviceListWrapper: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> DeviceListViewController {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "DeviceListViewController") as! DeviceListViewController
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: DeviceListViewController, context: Context) {
//        // Update if needed
//    }
//}
import SwiftUI
import UIKit

struct DeviceListWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DeviceListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let vc = storyboard
            .instantiateViewController(identifier: "DeviceListViewController")
            as? DeviceListViewController else {
            fatalError("Unable to load DeviceListViewController from storyboard")
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: DeviceListViewController, context: Context) {
        // No updates needed for now
    }
}
