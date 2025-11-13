//
//  StoredEventsTableViewController.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/13/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit
import PacificTrack

class StoredEventsViewController: UIViewController {
    var storedEvents: [EventFrame] = []
    var delegate: UIViewControllerEventsDelegate?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func addStoredEvent(_ event: EventFrame) -> Bool {
        storedEvents.insert(event, at: 0)
        tableView.reloadData()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.loaded(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.dismissed(self)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


