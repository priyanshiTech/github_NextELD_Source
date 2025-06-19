//
//  DeviceInfoView.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 1/23/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit

class DeviceInfoView: UIView {
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var latLongLabel: UILabel!
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var sateliteStatusLabel: UILabel!
    @IBOutlet var odometerLabel: UILabel!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var engineHoursLabel: UILabel!
    @IBOutlet var rpmLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let bundle = Bundle.init(for: DeviceInfoView.self)
        guard
            let viewsToAdd = bundle.loadNibNamed("DeviceInfoView", owner: self, options: nil),
            let contentView = viewsToAdd.first as? UIView
        else {
            return
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
