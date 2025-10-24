//
//  DeviceListViewController+UIViewControllerEventDelegate.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/14/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit

extension DeviceListViewController: UIViewControllerEventsDelegate {
    func dismissed(_ viewController: UIViewController) {
        if self.centralManager?.state != .poweredOn {
            performSegue(withIdentifier: "showBluetoothStatus", sender: self)
        }
    }
    
    func loaded(_ viewController: UIViewController) {
        
    }
}
