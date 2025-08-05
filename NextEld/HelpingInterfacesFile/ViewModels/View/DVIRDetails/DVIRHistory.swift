import SwiftUI

struct DVIRHistory: View {
    @EnvironmentObject var navManager: NavigationManager
    @State var email: String = ""
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var showFromDatePicker = false
    @State private var isFromDateSelected = false
    
    @State var title: String
    
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
            .frame(height: 50) // increased for better spacing
            
            // 🟦 Email DVIR Title & Icon - Moved to top just below header
            
            HStack(spacing: 10) {
                
                Text("Email Dvir")
                    .font(.system(size: 30))
                    .bold()
                    .foregroundColor(Color(uiColor: .wine))
                
                Image("email_icon_blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            .padding(.top, 16)
            .padding(.horizontal)
            
            .padding(.horizontal)
            .padding(.top, 12)
            // Date Filter Buttons
            HStack(spacing: 16) {
                
                Button(action: {
                    showFromDatePicker = true
                }) {
                    Text(isFromDateSelected ? " \(dateFormatted(fromDate))" : "From Date")
                        .foregroundColor(isFromDateSelected ? .black : .gray)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(uiColor: .wine), lineWidth: 2)
                        )
                }
                .sheet(isPresented: $showFromDatePicker) {
                    DatePickerPopup(
                        selectedDate: $fromDate,
                        isPresented: $showFromDatePicker,
                        onDateSelected: {
                            isFromDateSelected = true
                        }
                    )
                }
                
                Button(action: {
                    showFromDatePicker = true
                }) {
                    Text(isFromDateSelected ? " \(dateFormatted(toDate))" : "Current Date")
                        .foregroundColor(isFromDateSelected ? .black : .gray)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(uiColor: .wine), lineWidth: 2)
                        )
                }
                .sheet(isPresented: $showFromDatePicker) {
                    DatePickerPopup(
                        selectedDate: $fromDate,
                        isPresented: $showFromDatePicker,
                        onDateSelected: {
                            isFromDateSelected = true
                        }
                    )
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            //MARK: -  Email Field and Send Button
            HStack(spacing: 12) {
                
                TextField(
                    "",
                    text: $email,
                    prompt: Text("Enter Email")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                )
                .padding()
                .font(.system(size: 18))
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(uiColor: .wine), lineWidth: 2)
                )
                
                Button(action: {
                       // Send email action
                   }) {
                       Text("Send")
                           .font(.title3)
                           .frame(width: 90, height: 40)
                   }
                   .buttonStyle(.borderedProminent)
                   .tint(Color(uiColor: .wine)) //  Full wine color
                   .foregroundColor(.white)
               }
         
               .padding(.horizontal)
               .padding(.top, 12)
            }
        Spacer()
            .navigationBarBackButtonHidden()
        }
    }
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }

#Preview {
    DVIRHistory( title: "")
}
