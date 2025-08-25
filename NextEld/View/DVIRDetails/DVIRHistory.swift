import SwiftUI


import SwiftUI

struct DVIRHistory: View {
    @EnvironmentObject var navManager: NavigationManager
    @State var email: String = ""
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var showFromDatePicker = false
    @State private var showToDatePicker = false
    @State private var isFromDateSelected = false
    @State private var isToDateSelected = false
    @StateObject private var viewModel = DVIRAPIViewModel(networkManager: NetworkManager())

    @State var title: String
    @State private var alertMessage = ""
    @State private var showValidationAlert = false
      @State private var showAPISuccessAlert = false
      @State private var showAPIErrorAlert = false

    var body: some View {
        VStack(spacing:0) {
            // Top Bar Strip
            Color(uiColor: .wine)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 2)
            
            // Header Bar
            HStack {
                Button(action: {
                    navManager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .bold()
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .wine).shadow(radius: 1))
            .frame(height: 50)
            
            // Title
            HStack(spacing: 10) {
                Text("Email Dvir")
                    .font(.system(size: 30))
                    .bold()
                    .foregroundColor(Color(uiColor: .wine))
                
               // Image("email_icon_blue")
                Image("gmail")
              
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            .padding(.top, 16)
            .padding(.horizontal)
            
            // Date Pickers
            HStack(spacing: 16) {
                Button(action: { showFromDatePicker = true }) {
                    Text(isFromDateSelected ? "\(formatDates(fromDate))" : "From Date")
                        .foregroundColor(isFromDateSelected ? .black : .gray)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(uiColor: .wine), lineWidth: 2))
                }
                .sheet(isPresented: $showFromDatePicker) {
                    DatePickerPopup(
                        selectedDate: $fromDate,
                        isPresented: $showFromDatePicker,
                        onDateSelected: { isFromDateSelected = true }
                    )
                }
                
                Button(action: { showToDatePicker = true }) {
                    Text(isToDateSelected ? " \(formatDates(toDate))" : "To Date")
                        .foregroundColor(isToDateSelected ? .black : .gray)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(uiColor: .wine), lineWidth: 2))
                }
                .sheet(isPresented: $showToDatePicker) {
                    DatePickerPopup(
                        selectedDate: $toDate,
                        isPresented: $showToDatePicker,
                        onDateSelected: { isToDateSelected = true }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Email + Send button
            HStack(spacing: 12) {
                TextField(
                    "",
                    text: $email,
                    prompt: Text("Enter Email").foregroundColor(.gray)
                )
                .padding()
                .font(.system(size: 18))
                .frame(height: 50)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(uiColor: .wine), lineWidth: 2))
                
                Button(action: {
                    if email.isEmpty {
                        alertMessage = "Please enter email"
                        showValidationAlert = true
                    } else if !isValidEmail(email) {
                        alertMessage = "Invalid email format"
                        showValidationAlert = true
                    } else if !isFromDateSelected {
                        alertMessage = "Please select From Date"
                        showValidationAlert = true
                    } else if !isToDateSelected {
                        alertMessage = "Please select To Date"
                        showValidationAlert = true
                    } else {
                        Task {
                            let fromStr = formatDates(fromDate, endOfDay: false)
                            let toStr = formatDates(toDate, endOfDay: true)
                            await viewModel.fetchDVIRData(fromDate: fromStr, toDate: toStr, email: email)
                            
                            if let success = viewModel.successMessage {
                                alertMessage = success
                                showAPISuccessAlert = true
                                
                            } else if let error = viewModel.errorMessage {
                                alertMessage = error
                                showAPISuccessAlert = true
                            }
                        }
                    }
                }) {
                    Text("Send")
                        .font(.title3)
                        .frame(width: 90, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(uiColor: .wine))
                .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Spacer()
        }

        .alert("Validation Error", isPresented: $showValidationAlert) {
              Button("OK", role: .cancel) { }
          } message: {
              Text(alertMessage)
          }
          
          // API Success Alert (navigate back after OK)
          .alert("Message", isPresented: $showAPISuccessAlert) {
              Button("OK") {
                  navManager.goBack()
              }
          } message: {
              Text(alertMessage)
          }
          
          // API Error Alert (stay on same page)
          .alert("Error", isPresented: $showAPIErrorAlert) {
              Button("OK", role: .cancel) { }
          } message: {
              Text(alertMessage)
          }
        .navigationBarBackButtonHidden()
    }
    
    func formatDates(_ date: Date, endOfDay: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = .current
        if endOfDay {
            return formatter.string(from: Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!)
        } else {
            return formatter.string(from: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

#Preview {
    DVIRHistory(title: "")
}








