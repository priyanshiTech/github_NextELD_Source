//
//  DotInsception.swift
//  NextEld
//
//  Created by Inurum   on 22/05/25.
//

import Foundation
import SwiftUI

struct RoadSideInspectionView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Road side inspection")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Email logs for the 24-hour period and the previous day for one HOS cycle")
                    .font(.body)
                    .padding(.bottom)

                Button(action: {
                    // Email Logs action
                }) {
                    Text("Email Logs")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Text("Send logs for the 24-hour period and the previous days for one HOS cycle")
                    .font(.body)

                Button(action: {
                    // Data Transfer action
                }) {
                    Text("Data Transfer")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Text("Inspect logs for the 24-hour period and the previous days for men HOS cycle")
                    .font(.body)

                Button(action: {
                    // Review On Device action
                }) {
                    Text("Review On Device")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Text("Email DVIR for the 24-hour period and the previous day for one HOS cycle")
                    .font(.body)

                Button(action: {
                    // Email Dvir action
                }) {
                    Text("Email Dvir")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Road Side Inspection")
        }
    }
}

struct ContentView: View {
    var body: some View {
        RoadSideInspectionView()
    }
}

@main
struct RoadSideInspectionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
