//
//  VariablesViewController.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 10/6/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit
import PacificTrack

class VariablesViewController: UIViewController {
    let trackerService = TrackerService.sharedInstance
    
    @IBOutlet var peIntervalTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    var systemVariable: TrackerSystemVariable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if trackerService.tracker?.productName.starts(with: "PT40") == true {
            systemVariable = "HUC"
        } else {
            // PT30
            systemVariable = SystemVariable.timeBetweenPeriodicEvents
        }
        
        trackerService.getSystemVariable(systemVariable) { variableResponse, error in
            guard
                error == .noError,
                let variable = variableResponse,
                variable.status == .success
            else {
                self.displayAlert(title: "Error", message: "Can't fetch the variable")
                self.peIntervalTextField.placeholder = "error"
                return
            }
            
            self.peIntervalTextField.placeholder = ""
            self.peIntervalTextField.text = variable.variablePair.value
            self.peIntervalTextField.isEnabled = true
            self.saveButton.isEnabled = true
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard
            let peIntervalText = peIntervalTextField.text?.trimmingCharacters(in: .whitespaces),
            peIntervalText != ""
        else {
            displayAlert(title: "Invalid value", message: "Value can't be empty")
            return
        }
        
        saveButton.isEnabled = false
        trackerService.setSystemVariable(systemVariable, value: peIntervalText) { variableResponse, error in
            self.saveButton.isEnabled = true
            
            guard
                error == .noError,
                let variable = variableResponse,
                variable.status == .success
            else {
                // handle error
                self.displayAlert(title: "Error", message: "An error occurred while seting the variable value")
                return
            }
            
            self.displayAlert(title: "Success", message: "Variable set to \(peIntervalText)")
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
