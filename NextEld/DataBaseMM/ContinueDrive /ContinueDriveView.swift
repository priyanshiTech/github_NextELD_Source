//
//  ContinueDriveView.swift
//  NextEld
//
//  Created by priyanshi   on 30/09/25.
//

import Foundation
import SwiftUI

// MARK: - Continue Drive Table View
struct ContinueDriveTableView: View {
    @StateObject private var viewModel = ContinueDriveViewModel()
    @State private var currentPage = 0
    private let recordsPerPage = 10
    @EnvironmentObject var navmanager: NavigationManager
    
    var paginatedRecords: [ContinueDriveModel] {
        let start = currentPage * recordsPerPage
        let end = min(start + recordsPerPage, viewModel.continueDriveData.count)
        return Array(viewModel.continueDriveData[start..<end])
    }
    
    var totalPages: Int {
        max(1, (viewModel.continueDriveData.count + recordsPerPage - 1) / recordsPerPage)
    }
    
    var body: some View {
        VStack {
  
            HStack {
                Button(action: {
                    navmanager.goBack()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .bold()
                }
                .buttonStyle(PlainButtonStyle())

                
                Spacer()
                
                Text("Continue Drive Records")
                    .font(.headline)
                
                Spacer()
                
                // placeholder to balance layout
                Spacer().frame(width: 60)
            }
               .padding()
               Divider()
            
            // MARK: - Table
            ScrollView(.horizontal) {
                VStack(alignment: .leading, spacing: 0) {
                    ContinueDriveTableHeader()
                        .background(Color.gray.opacity(0.2))
                    
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            ForEach(paginatedRecords.indices, id: \.self) { index in
                                let record = paginatedRecords[index]
                                ContinueDriveTableRow(record: record)
                                    .background(Color.white)
                                Divider()
                            }
                        }
                    }
                }
            }
            Divider()
            
            // MARK: - Pagination Controls
            HStack {
                Button("Previous") {
                    if currentPage > 0 { currentPage -= 1 }
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                Text("Page \(currentPage + 1) of \(totalPages)")
                    .bold()
                
                Spacer()
                
                Button("Next") {
                    if (currentPage + 1) * recordsPerPage < viewModel.continueDriveData.count {
                        currentPage += 1
                    }
                }
                .disabled((currentPage + 1) * recordsPerPage >= viewModel.continueDriveData.count)
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.loadContinueDriveData()
        }
        .padding()
    }
}

// MARK: - Table Header
struct ContinueDriveTableHeader: View {
    var body: some View {
        
        HStack(spacing: 5) {
            
            TableCellForContinueDrive(text: "Id", width: 120, isHeader: true)
            TableCellForContinueDrive(text: "userId", width: 120, isHeader: true)
            TableCellForContinueDrive(text: "Status", width: 150, isHeader: true)
            TableCellForContinueDrive(text: "Start Time", width: 250, isHeader: true)
            TableCellForContinueDrive(text: "End Time", width: 150, isHeader: true)
            TableCellForContinueDrive(text: "Break_Time", width: 150, isHeader: true)
            
        }
    }
}

// MARK: - Continue Drive Table View
struct ContinueDriveTableRow: View {
    let record: ContinueDriveModel
    
    var body: some View {
      
        HStack(spacing: 5) {
            
            TableCellForContinueDrive(text: "\(record.id ?? 0)", width: 120)
            TableCellForContinueDrive(text: "\(DriverInfo.driverId ?? 0)", width: 120)
            TableCellForContinueDrive(text: record.status, width: 150)
            TableCellForContinueDrive(text: record.startTime, width: 250)
            TableCellForContinueDrive(text: record.endTime, width: 150)
            TableCellForContinueDrive(text: record.breakTime, width: 150)
        
        }
    }
}

// MARK: - Reusable Cell
struct TableCellForContinueDrive: View {
    let text: String
    let width: CGFloat
    var isHeader: Bool = false
    
    var body: some View {
        Text(text)
            .font(isHeader ? .headline : .body)
            .frame(width: width, height: 40)
            .background(isHeader ? Color.gray.opacity(0.15) : Color.white)
            .border(Color.gray, width: 0.5)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
}






// MARK: - Preview
#Preview {
    ContinueDriveTableView()
}
