//
//  LogsFlowView.swift
//  NextEld
//
//  Created by priyanshi   on 09/10/25.
//

import Foundation
import SwiftUI

struct LogsFlowView: View {
    @Binding var selectedVehicle: String
    @Binding var vehicleID: Int

    var body: some View {
        NavigationStack {
            DriverLogListView() // or some default
                .navigationDestination(for: AppRoute.LogsFlow.self) { route in
                    switch route {
                    case .DailyLogs(let title):
                        DailyLogView(title: title, entry: WorkEntry(date: Date(), hoursWorked: 0))
                    case .EmailLogs(let title):
                        EmailLogs(title: title)
                    case .RecapHours(let title):
                        HoursRecap(tittle: title)
                    case .continueDriveTableView:
                        ContinueDriveTableView()
                    case .DatabaseCertifyView:
                        DatabaseCertifyView()
                    case .CertifySelectedView(let title):
                        CertifySelectedView(vehiclesc: $selectedVehicle, VechicleID: $vehicleID, title: title)
                    case .LogsDetails(let title, let entry):
                        LogsDetails(title: title, entry: entry)
                    case .EyeViewData(let title, let entry):
                        EyeViewData(title: title, entry: entry)
                    case .driverLogListView:
                        DriverLogListView()
                    case .DvirDataListView:
                        DvirListView()
                    case .AddDvirPriTrip:
                        EmailDvir(
                            tittle: "Email DVIR",
                            updateRecords: DvirDatabaseManager.shared.fetchAllRecords(),
                            onSelect: { _ in }
                        )
                    case .DvirHostory(let title):
                        DVIRHistory(title: title)
                    case .DataTransferView:
                        DataTransferInspectionView()
                    }
                }
        }
    }
}
