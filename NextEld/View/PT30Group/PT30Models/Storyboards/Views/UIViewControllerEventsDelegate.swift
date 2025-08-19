//
//  UIViewControllerEventsDelegate.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/14/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit

protocol UIViewControllerEventsDelegate {
    func dismissed(_ viewController: UIViewController)
    func loaded(_ viewController: UIViewController)
}
