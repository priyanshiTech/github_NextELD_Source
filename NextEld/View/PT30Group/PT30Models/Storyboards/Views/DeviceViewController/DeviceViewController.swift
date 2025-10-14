//
//  DeviceViewController.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 12/30/19.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit
import CoreBluetooth
import PacificTrack
import SwiftUICore

protocol DeviceHandlerDelegate {
    func didStopHandling(_ viewController: UIViewController, peripheral: CBPeripheral)
}

class DeviceViewController: UIViewController {
  
    var peripheral: CBPeripheral?
    let trackerService = TrackerService.sharedInstance
    @IBOutlet var deviceInfoView: DeviceInfoView!
    @IBOutlet var virtualDashboardScrollView: UIScrollView!
    @IBOutlet var dashboardReportView: DashboardReportView!
    @EnvironmentObject var navmanager: NavigationManager
    @IBOutlet weak var backButtonLeftChevron: UIButton!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var serialLabel: UILabel!
    @IBOutlet var firmwareVersionLabel: UILabel!
    @IBOutlet var bleVersionLabel: UILabel!
    
    @IBOutlet var vinLabel: UILabel!
    @IBOutlet var imeiLabel: UILabel!
    @IBOutlet var imeiTitleLabel: UILabel!
    
    @IBOutlet var deviceInfoViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var storedEventsLabel: UILabel!
    @IBOutlet var storedEventsView: UIView!
    @IBOutlet var clearStoredEventsButton: UIButton!
    
    @IBOutlet var deviceInfoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var tabViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var updateFirmwareButton: UIButton!
    
    var updateStartTime: DispatchTime?
    
    var delegate: DeviceHandlerDelegate?
    
    var storedEventsViewController: StoredEventsViewController?
    var firmwareUpdateViewController: FirmwareUpdateViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prevent auto screen locking
        UIApplication.shared.isIdleTimerDisabled = true
        
        guard let trackerPeripheral = peripheral else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        showStoredEventsUI(false)
        trackerService.debug = true
        trackerService.delegate = self
        trackerService.handle(trackerPeripheral: trackerPeripheral)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // enable auto screen locking
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    //MARK: -  IBACTION For BACK Button ADD by PJ
    
    @IBAction func actionOnBackButton(_ sender: Any) {
        
      //  navmanager.navigate(to: AppRoute.homeFlow(.home))
    
    }
    
    @IBAction func selectedSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            virtualDashboardScrollView.isHidden = true
            deviceInfoView.isHidden = false
        } else {
            deviceInfoView.isHidden = true
            virtualDashboardScrollView.isHidden = false
        }
    }
    
    func refreshDeviceInfo(withTrackerInfo trackerInfo: TrackerInfo) {
        modelLabel.text = trackerInfo.productName
        serialLabel.text = trackerInfo.serialNumber
        firmwareVersionLabel.text = "L\(trackerInfo.mainVersion.level) \(trackerInfo.mainVersion.version)"
        bleVersionLabel.text = "L\(trackerInfo.bleVersion.level) \(trackerInfo.bleVersion.version)"
        
        if let vin = trackerInfo.vin {
            vinLabel.text = vin == "" ? "-" : vin
        } else {
            vinLabel.text = "-"
        }
        
        if let imei = trackerInfo.imei {
            imeiLabel.text = imei == "" ? "-" : imei
        } else {
            imeiLabel.text = "-"
        }
        
        if trackerInfo.productName.starts(with: "PT30") {
            updateFirmwareButton.isHidden = false
        } else {
            updateFirmwareButton.isHidden = true
        }
    }
    
    @IBAction func reloadStoredEventsCountTapped(_ sender: UIButton) {
        fetchStoredEventsCount()
    }
    
    func fetchStoredEventsCount() {
        trackerService.getStoredEventsCount { response, error in
            guard
                let storedEventsCountResponse = response,
                error == .noError
            else {
                return
            }
            
            self.storedEventsLabel.text = "\(storedEventsCountResponse.count)"
            
            if storedEventsCountResponse.count > 0 {
                self.clearStoredEventsButton.isEnabled = true
            } else {
                self.clearStoredEventsButton.isEnabled = false
            }
        }
    }
    
    @IBAction func clearStoredEventsTapped(_ sender: UIButton) {
        trackerService.clearStoredEvents { response, error in
            guard
                error == .noError,
                let clearStoredEventsResponse = response
            else {
                print("STORED EVENTS ERROR")
                return
            }
            
            if clearStoredEventsResponse.status == .success {
                self.storedEventsLabel.text = "0"
                self.clearStoredEventsButton.isEnabled = false
            }
        }
    }
    
    @IBAction func reloadVinTapped(_ sender: UIButton) {
        syncInformation()
    }
    
    func syncInformation() {
        if trackerService.tracker?.productName.starts(with: "PT40") == true {
            trackerService.getVehicleInformation { response, error in
                guard
                    let vehicleInformationResponse = response,
                    error == .noError
                else {
                    self.vinLabel.text = "-"
                    return
                }
                
                self.vinLabel.text = vehicleInformationResponse.vin == "" ? "-" : vehicleInformationResponse.vin
            }
        } else {
            trackerService.getInformation { response, error in
                guard
                    let getInformationResponse = response,
                    error == .noError
                else {
                    self.vinLabel.text = "-"
                    return
                }
                
                self.vinLabel.text  = getInformationResponse.vin == "" ? "-" : getInformationResponse.vin
            }
        }
    }
    
    @IBAction func disconnectButtonTapped(_ sender: UIButton) {
        let devicePeripheral = trackerService.stopHandling()
        
        if let peripheral = devicePeripheral {
            delegate?.didStopHandling(self, peripheral: peripheral)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func showStoredEventsUI(_ showAdditionalUI: Bool) {
        if showAdditionalUI {
            tabViewTopConstraint.constant = 92
            storedEventsView.isHidden = false
            imeiTitleLabel.isHidden = false
            imeiLabel.isHidden = false
        } else {
            tabViewTopConstraint.constant = 8
            storedEventsView.isHidden = true
            imeiTitleLabel.isHidden = true
            imeiLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "storedEvents":
                guard let storedEventsVC = segue.destination as? StoredEventsViewController else {
                    return
                }
                
                storedEventsVC.delegate = self
                
                trackerService.retrieveStoredEvents { response, error in
                    guard
                        let retrieveStoredEventsResponse = response,
                        error == .noError
                    else {
                        return
                    }
                    
                    // streaming started
                }
                
            case "firmwareUpdate":
                guard let firmwareUpdateVC = segue.destination as? FirmwareUpdateViewController else {
                    return
                }
                
                firmwareUpdateVC.delegate = self
                
                
                
            default: ()
        }
    }
    
    func cancelFirmwareUpdate() {
        if trackerService.state == .upgrade {
            trackerService.cancelUpgrade()
        }
    }
}

extension DeviceViewController: UIViewControllerEventsDelegate {
    func dismissed(_ viewController: UIViewController) {
        if viewController is StoredEventsViewController {
            storedEventsViewController = nil
            fetchStoredEventsCount()
        } else if viewController is FirmwareUpdateViewController {
            firmwareUpdateViewController = nil
            cancelFirmwareUpdate()
        }
    }
    
    func loaded(_ viewController: UIViewController) {
        if viewController is StoredEventsViewController {
            storedEventsViewController = viewController as? StoredEventsViewController
        } else if viewController is FirmwareUpdateViewController {
            firmwareUpdateViewController = viewController as? FirmwareUpdateViewController
        }
    }
}
