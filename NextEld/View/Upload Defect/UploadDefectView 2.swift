import SwiftUI

struct UploadDefectView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Top Bar
            HStack {
                Button(action: {
                    navmanager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                
                Text("Upload Defects")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 50)
            .background(Color.purple)
            .shadow(radius: 2)
            
            // MARK: - Defect Sections
            List {
                Section(header: Text("Truck Defect")
                    .font(.headline)
                    .foregroundColor(.black)
                ) {
                    HStack {
                        Text("None")
                            .foregroundColor(.gray)
                        Spacer()
                        Button("Upload") {
                            // Upload truck defect action
                        }
                        .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("Trailer Defect")
                    .font(.headline)
                    .foregroundColor(.black)
                ) {
                    HStack {
                        Text("Landing Gear")
                            .foregroundColor(.gray)
                        Spacer()
                        Button("Upload") {
                            // Upload trailer defect action
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    UploadDefectView()
}
