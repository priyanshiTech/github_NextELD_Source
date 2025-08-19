//
//  VariablesView.swift
//  NextEld
//
//  Created by Inurum   on 17/06/25.
//


/*import SwiftUI
import PacificTrack

struct VariablesView: View {
    @State private var peInterval: String = ""
    @State private var isLoading = true
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private let trackerService = TrackerService.sharedInstance
  // @State private var systemVariable: PacificTrackSystemVariable = .timeBetweenPeriodicEvents
    @State private var systemVariable: String = "TPE" // or any other variable name the SDK supports

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter PE Interval", text: $peInterval)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(isLoading)
                .padding()

            Button(action: savePEInterval) {
                if isSaving {
                    ProgressView()
                } else {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isSaving || isLoading)
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Set Variables")
        .onAppear(perform: loadSystemVariable)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func loadSystemVariable() {
        if trackerService.tracker?.productName.starts(with: "PT40") == true {
            systemVariable = "HUC"
        } else {
            //systemVariable = .timeBetweenPeriodicEvents
            

        }

        trackerService.getSystemVariable(systemVariable) { variableResponse, error in
            DispatchQueue.main.async {
                isLoading = false
                guard
                    error == .noError,
                    let variable = variableResponse,
                    variable.status == .success
                else {
                    showAlert(title: "Error", message: "Can't fetch the variable.")
                    return
                }

                peInterval = variable.variablePair.value
            }
        }
    }

    private func savePEInterval() {
        guard !peInterval.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: "Invalid", message: "Value can't be empty.")
            return
        }

        isSaving = true
        trackerService.setSystemVariable(systemVariable, value: peInterval) { variableResponse, error in
            DispatchQueue.main.async {
                isSaving = false

                guard
                    error == .noError,
                    let variable = variableResponse,
                    variable.status == .success
                else {
                    showAlert(title: "Error", message: "An error occurred while setting the variable.")
                    return
                }

                showAlert(title: "Success", message: "Variable set to \(peInterval)")
            }
        }
    }

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}



#Preview {
    VariablesView()
}
*/
