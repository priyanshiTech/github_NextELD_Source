//
//  FirmwareUpdateViewController.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 10/2/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit
import PacificTrack

class FirmwareUpdateViewController: UIViewController {
    var delegate: UIViewControllerEventsDelegate?
    let trackerService = TrackerService.sharedInstance
    
    // UI
    @IBOutlet var infoLabel: UILabel!
    
    @IBOutlet var progressView: UIView!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var estimateLabel: UILabel!
    
    @IBOutlet var updateFirmwareButton: UIButton!
    
    var isUpdateButtonVisible = false {
        didSet {
            if isUpdateButtonVisible {
                updateFirmwareButton.isHidden = false
                progressView.isHidden = true
            } else {
                updateFirmwareButton.isHidden = true
                progressView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true // iOS 13+ only
        } else {
            self.modalPresentationStyle = .fullScreen
        }
        
        trackerService.isUpgradeAvailable { isUpgradeAvailable, error in
            guard error == .noError else {
                // error occurred
                switch error {
                    case .deviceInfoFailed:
                        self.infoLabel.text = "Error obtaining device info"
                        
                    case .getFirmwareInfoFailed:
                        self.infoLabel.text = "Error obtaining firmware info"
                        
                    case .unauthorized:
                        self.infoLabel.text = "Unauthorized - API key missing"
                        
                    default:
                        self.infoLabel.text = "Error occurred"
                }
                
                self.progressView.isHidden = true
                if #available(iOS 13.0, *) {
                    self.isModalInPresentation = false
                }
                
                return
            }
            
            if isUpgradeAvailable {
                self.infoLabel.text = "Update available"
                self.isUpdateButtonVisible = true
            } else {
                self.infoLabel.text = "Device firmware is up-to-date."
                self.progressView.isHidden = true
                if #available(iOS 13.0, *) {
                    self.isModalInPresentation = false
                }
            }
        }
        
        delegate?.loaded(self)
    }
    
    public func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        close()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.dismissed(self)
    }
    
    @IBAction func updateFirmwareButtonTapped(_ sender: UIButton) {
        isUpdateButtonVisible = false
        self.infoLabel.text = "Updating..."
        trackerService.performUpgrade()
    }
}
