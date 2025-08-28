//
//  AddDvirScreenView.swift
//  NextEld
//
//  Created by Priyanshi on 21/05/25.
//

import SwiftUI

struct AddDvirScreenView: View  {
    
    @EnvironmentObject var navmanager: NavigationManager
    @State private var notesText: String = ""
    @State private var showSignaturePopup = false
    @State private var signaturePath = Path()
    //MARK: -  to show a selected data @binding use
    @Binding var selectedVehicle: String
    @State private var truckDefectSelection: String? = nil
    @State private var trailerDefectSelection: String? = nil
    
    @State private var Showpopup: Bool = false
    @State private var selectedTab = ""
    @EnvironmentObject var trailerVM: TrailerViewModel
    
    @State private var showPopupVechicle = false
    @EnvironmentObject var vehicleVM: VehicleConditionViewModel
  //  @EnvironmentObject var dvirVM: DvirViewModel

    @Binding var selectedVehicleupdated: String
    let selectedRecord: DvirRecord
    
    @State  var driverName:String = ""
    @State  var odometer : String = ""
    @State  var  companyName: String = ""
    @State  var Location: String  = ""
    @State  var  driverID: String  = ""

    
    @State private var date: String = ""
    @State private var time: String = ""

    @State private var selectedCoDriver: String? = nil


    @State private var showSignaturePad = false
    @State private var showCoDriverPopup = false
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var shippingVM: ShippingDocViewModel


    
    
    var body: some View {
       
        ZStack {
            VStack(spacing: 0) {
                
                // MARK: - Top Strip
                ZStack(alignment: .topLeading) {
                    Color(UIColor.wine)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 10)
                }
                
                // MARK: - Header
                ZStack(alignment: .top) {
                    Color.white
                        .frame(height: 52)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                    
                    HStack {
                        Button(action: {
                            navmanager.goBack()
                            
                        }) {
                            Image(systemName: "arrow.left")
                                .bold()
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                        
                        Text("Add Dvir")
                            .font(.headline)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.wine).shadow(radius: 1))
                    .frame(height: 40, alignment: .topLeading)
                }
                
                // MARK: - Main Content Scroll
                UniversalScrollView {
                    VStack(spacing: 8) {
                        
                        // Driver Info
                        CardContainer {
                            VStack(alignment: .leading, spacing: 15) {
                                DvirField(label: "Driver", value: driverName)
                                DvirField(label: "Time", value: time)
                                DvirField(label: "Date", value: date)
                                DvirField(label: "Odometer", value: "0")
                                DvirField(label: "Company", value: companyName)
                                DvirField(label: "Location", value: Location)
                            }
                        }
                        
                        // Vehicle
                        CardContainer {
                            Button(action: {
                                navmanager.navigate(to: .ADDVehicle)
                               
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Vehicle")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        //MARK: -  to show a selected data
                                        Text("\(selectedVehicle)")
                                        
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        //  print(selectedVehicle)
                                    }
                                    
                                    Spacer()
                                    Image("pencil").foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Trailer
                        CardContainer {
                            Button(action: {
                                
                                navmanager.navigate(to: AppRoute.trailerScreen)   //MARK: -  26 july
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Trailer")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        // Text("None")
                                        Text(trailerVM.trailers.first ?? "None")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                    
                                    Spacer()
                                    Image("pencil").foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Truck/Trailer Defects
                        CardContainer {
                            VStack(alignment: .center, spacing: 16) {
                                Text("Truck 1894")
                                    .font(.headline)
                                
                                VStack(spacing: 10) {
                                    Button(action: {
                                        truckDefectSelection = "no"
                                    }) {
                                        Text("No Defects")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(truckDefectSelection == "no" ?Color(UIColor.wine) : Color.white)
                                            .foregroundColor(truckDefectSelection == "no" ? .white : (Color(UIColor.wine)))
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.wine), lineWidth: 1))
                                            .cornerRadius(8)
                                    }
                                    
                                    Button(action: {
                                        truckDefectSelection = "yes"
                                        Showpopup = true
                                    }) {
                                        Text("Has Defects")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(truckDefectSelection == "yes" ? Color(UIColor.wine) : Color.white)
                                            .foregroundColor(truckDefectSelection == "yes" ? .white : Color(UIColor.wine))
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.wine), lineWidth: 1))
                                            .cornerRadius(8)
                                    }
                                }
                                
                                //Text("Trailer None")
                                Text(trailerVM.trailers.first ?? "None")
                                    .font(.headline)
                                
                                VStack(spacing: 10) {
                                    Button(action: {
                                        trailerDefectSelection = "no"
                                    }) {
                                        Text("No Defects")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(trailerDefectSelection == "no" ? Color(UIColor.wine) : Color.white)
                                            .foregroundColor(trailerDefectSelection == "no" ? .white : Color(UIColor.wine))
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.wine), lineWidth: 1))
                                            .cornerRadius(8)
                                    }
                                    
                                    Button(action: {
                                        trailerDefectSelection = "yes"
                                        Showpopup = true
                                    }) {
                                        Text("Has Defects")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(trailerDefectSelection == "yes" ? Color(UIColor.wine): Color.white)
                                            .foregroundColor(trailerDefectSelection == "yes" ? .white : Color(UIColor.wine))
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.wine), lineWidth: 1))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        
                        // Notes
                        CardContainer {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $notesText)
                                    .frame(height: 200)
                                    .padding(2)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(10)
                                
                                if notesText.isEmpty {
                                    Text("Write note here...")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 12)
                                }
                            }
                            
                            HStack {
                                Button(action: {
                                    
                                    showPopupVechicle = true
                                    print("Vehicle Condition Added")
                                }) {
                         
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Vehicle Condition")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        
                                        //  Show selected condition or default "None"
                                        Text(vehicleVM.selectedCondition ?? "None")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.clear)
                                }
                            }
                          
                        }
                       
                    }
                    
                    // Signature Button
                    CardContainer {
                        Button(action: {
                            selectedTab = "Driver Signature"
                            showSignaturePopup = true
                        }) {
                            Text("Add Driver Signature")
                                .foregroundColor(.black)
                                .font(.headline)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .cornerRadius(10)
                        }
                        .frame(width: 350, height: 80)
                    }

                    
                    .onAppear {
                        // Load defaults from UserDefaults
                        loadLoginData()

                        // Only use selectedRecord values if they're non-empty (editing existing record)
                        if !selectedRecord.driver.isEmpty {
                            driverName = selectedRecord.driver
                            odometer = selectedRecord.odometer
                            companyName = selectedRecord.company
                            Location = selectedRecord.location
                            truckDefectSelection = selectedRecord.truckDefect
                            trailerDefectSelection = selectedRecord.trailerDefect
                            date = selectedRecord.date.isEmpty ? DateTimeHelper.currentDate() : selectedRecord.date
                            time = selectedRecord.time.isEmpty ? DateTimeHelper.currentTime() : selectedRecord.time

                            if vehicleVM.selectedCondition == nil || vehicleVM.selectedCondition == "None" {
                                vehicleVM.selectedCondition = selectedRecord.vehicleCondition
                            }
                        } else {
                            // If new record, use current date/time
                            date = DateTimeHelper.currentDate()
                            time = DateTimeHelper.currentTime()
                        }
                    }


                    HStack{
                        Button(action: {
                            let signatureImage = signatureToImage(path: signaturePath, size: CGSize(width: 300, height: 150))
                            let signatureData = signatureImage.pngData()
                            
                            let record = DvirRecord(
                                driver: driverName,
                                time: time,
                                date: date,
                                odometer: odometer,
                                company: companyName,
                                location: Location,
                                vehicle: selectedVehicle,
                                trailer: trailerVM.trailers.first ?? "None",
                                truckDefect: truckDefectSelection ?? "no",
                                trailerDefect: trailerDefectSelection ?? "no",
                                vehicleCondition: vehicleVM.selectedCondition ?? "None",
                                notes: notesText,
                                signature: signatureData
                            )
                            
                            DvirDatabaseManager.shared.insertRecord(record)
                            
                            if let id = record.id, id > 0 {
                                updateDvirDataUsingCommonService(record: record, dvirLogId: driverID)
                                
                            } else {
                                uploadDvirDataUsingCommonService(record: record)
                            }
                            navmanager.navigate(to: AppRoute.DvirDataListView)
                        }) {
                            Text("Add Dvir")
                                .frame(width: 350, height: 50)
                                .foregroundColor(.white)
                                .background(Color(UIColor.wine))
                                .cornerRadius(10)
                        }
                    }
                    
                  
                }
                .padding(.horizontal, 5)
            }
            .navigationBarBackButtonHidden()
            
            // MARK: - Signature Popup Overlay
           /* if showSignaturePopup {
                PopupContainer(isPresented: $showSignaturePopup) {
                    SignatureCertifyView (signaturePath: $signaturePath)
                }
                
            }*/
            
          //  if selectedTab == "Certify" {
            if showSignaturePopup {
                SignatureCertifyView(
                    signaturePath: $signaturePath,
                    selectedVehicle: "vehiclesc",
                    selectedTrailer: trailerVM.trailers.last ?? "None",
                    selectedShippingDoc: shippingVM.ShippingDoc.last ?? "None",
                    selectedCoDriver: selectedCoDriver,
                    certifiedDate: DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
 
                )
                .environmentObject(trailerVM)
                .environmentObject(shippingVM)
                .transition(.slide)
           }

                
            // MARK: - Defect Popup Overlay
            if Showpopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .zIndex(1)
                
                DefectPopupView(isPresented: $Showpopup)
                    .frame(width: 300, height: 400)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .zIndex(2)
                    .transition(.scale)
            }
                
            //MARK: - Vehicle popup
            if showPopupVechicle {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showPopupVechicle = false }
                
                VehicleConditionPopupView(isPresented: $showPopupVechicle)
                    .environmentObject(vehicleVM)
                    .transition(.scale)
            }
                
        }
       
        .animation(.easeInOut, value: showSignaturePopup)
        .animation(.easeInOut, value: Showpopup)
        .animation(.easeInOut, value: showPopupVechicle)
    }
        //MARK: - load login data into swiftui
    func loadLoginData() {
        driverName = UserDefaults.standard.string(forKey: "driverName") ?? "N/A"
        Location = UserDefaults.standard.string(forKey: "customLocation") ?? "N/A"
        companyName = UserDefaults.standard.string(forKey: "companyName") ?? "N/A"
        driverID = UserDefaults.standard.string(forKey: "userId") ?? "n/a"

   }
    // MARK:   Convert the SwiftUI Path to UIImage, then to PNG Data
    func signatureToImage(path: Path, size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView:
            path
                .stroke(Color.black, lineWidth: 2)
                .background(Color.white)
                .frame(width: size.width, height: size.height)
        )
        let view = controller.view
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
}


//#Preview {
//    AddDvirScreenView()
//        .environmentObject(NavigationManager())
//}
//

