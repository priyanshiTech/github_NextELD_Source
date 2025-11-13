//
//  DashboardReportView.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 13.8.22..
//  Copyright © 2022 Pacific Track, LLC. All rights reserved.
//

import UIKit

class DashboardReportView: UIView {
    @IBOutlet var busLabel: UILabel!
    @IBOutlet var gearLabel: UILabel!
    @IBOutlet var seatBeltLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var rpmLabel: UILabel!
    @IBOutlet var numberOfDtcLabel: UILabel!
    @IBOutlet var oilPressureLabel: UILabel!
    @IBOutlet var oilLevelLabel: UILabel!
    @IBOutlet var oilTempLabel: UILabel!
    @IBOutlet var coolantLevelLabel: UILabel!
    @IBOutlet var coolantTempLabel: UILabel!
    @IBOutlet var fuelLevelLabel: UILabel!
    @IBOutlet var fuelLevelTank2Label: UILabel!
    @IBOutlet var DEFLevelLabel: UILabel!
    @IBOutlet var loadLabel: UILabel!
    @IBOutlet var ambientPressureLabel: UILabel!
    @IBOutlet var intakeTemperatureLabel: UILabel!
    @IBOutlet var fuelTankTemperatureLabel: UILabel!
    @IBOutlet var intercoolerTemperatureLabel: UILabel!
    @IBOutlet var turboOilTemperatureLabel: UILabel!
    @IBOutlet var transmisionOilTemperatureLabel: UILabel!
    @IBOutlet var fuelRateLabel: UILabel!
    @IBOutlet var fuelEconomyLabel: UILabel!
    @IBOutlet var ambientTemperatureLabel: UILabel!
    @IBOutlet var odometerLabel: UILabel!
    @IBOutlet var engineHoursLabel: UILabel!
    @IBOutlet var idleHoursLabel: UILabel!
    @IBOutlet var PTOLabel: UILabel!
    @IBOutlet var totalFuelIdleLabel: UILabel!
    @IBOutlet var totalFuelUsedLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let bundle = Bundle.init(for: DashboardReportView.self)
        guard
            let viewsToAdd = bundle.loadNibNamed("DashboardReportView", owner: self, options: nil),
            let contentView = viewsToAdd.first as? UIView
        else {
            return
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
