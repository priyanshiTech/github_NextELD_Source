//
//  ContinueDriveDemoView.swift
//  NextEld
//
//  Created by AI Assistant
//

import SwiftUI

struct ContinueDriveDemoView: View {
    @StateObject private var viewModel = ContinueDriveViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Continue Drive Management")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button("Save Sample Continue Drive Data") {
                        saveSampleData()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("View All Records") {
                        viewModel.loadContinueDriveData()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Clear All Data") {
                        ContinueDriveDBManager.shared.deleteAllContinueDriveData()
                        viewModel.loadContinueDriveData()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
                .padding()
                
                // Data Count
                Text("Total Records: \(viewModel.continueDriveData.count)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // Records List
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.continueDriveData.isEmpty {
                    VStack {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No Continue Drive Records")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Tap 'Save Sample Data' to create test records")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.continueDriveData) { data in
                        ContinueDriveRowView(data: data)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Continue Drive Demo")
            .onAppear {
                viewModel.loadContinueDriveData()
            }
        }
    }
    
    private func saveSampleData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = formatter.string(from: Date())
        
        // Save sample data
        viewModel.saveContinueDriveData(
            status: "Continue Drive",
            startTime: now,
            remainingTime: "08:00:00",
            breakTime: "00:30:00",
            isRunning: true
        )
        
        // Save another sample after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let laterTime = formatter.string(from: Date().addingTimeInterval(3600)) // 1 hour later
            viewModel.saveContinueDriveData(
                status: "Continue Drive",
                startTime: laterTime,
                remainingTime: "07:30:00",
                breakTime: "00:25:00",
                isRunning: false
            )
        }
    }
}

#Preview {
    ContinueDriveDemoView()
}
