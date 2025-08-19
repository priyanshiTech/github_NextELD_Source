//
//  CalanderView.swift
//  NextEld
//
//  Created by Inurum   on 21/05/25.
//

import Foundation
import SwiftUI
import SwiftUI

import SwiftUI

struct CalendarButton: View {
    var title: String
    @Binding var selectedDate: Date
    @State private var showDatePicker = false
   

    var body: some View {
        Button(action: {
            showDatePicker.toggle()
        }) {
            HStack {
                Text("\(title): \(formattedDate)")
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
                   // .frame(maxWidth: .infinity, minHeight: 50)
                    .frame(width: 100 , height: 100 , alignment: .leading)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke( Color(uiColor: .wine), lineWidth: 2)
            )
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("Select \(title)", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                
                Button("Done") {
                  //  onDateSelected?()
                    showDatePicker = false

                }
                .padding()
            }
            .presentationDetents([.medium])
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
}
import SwiftUI

struct DatePickerPopup: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    var onDateSelected: (() -> Void)? = nil
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()

            Button("Done") {
                isPresented = false
                onDateSelected?()
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
}
