//
//  AddDvirPopupHome.swift
//  NextEld
//
//  Created by priyanshi on 31/10/25.
//
import SwiftUI
import UIKit

struct UploadDefectView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @State private var showUploadPopup = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
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
                .background(Color(uiColor: .wine))
                .shadow(radius: 2)
                
                // MARK: - Defect Sections
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Truck Defect")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        HStack {
                            Text("None")
                                .foregroundColor(.gray)
                            Spacer()
                            Button("Upload") {
                                withAnimation(.easeInOut) {
                                    showUploadPopup = true
                                }
                            }
                            .foregroundColor(.red)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Trailer Defect")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        HStack {
                            Text("Landing Gear")
                                .foregroundColor(.gray)
                            Spacer()
                            Button("Upload") {
                                withAnimation(.easeInOut) {
                                    showUploadPopup = true
                                }
                            }
                            .foregroundColor(.red)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
            // MARK: - Bottom Sheet Popup
            if showUploadPopup {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showUploadPopup = false
                        }
                    }
                
                VStack(spacing: 16) {
                    Capsule()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 40, height: 5)
                        .padding(.top, 10)
                    
                    Text("Select Option")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 5)
                    
                    HStack(spacing: 150) {
                        Button(action: {
                            print("Camera tapped")
                            sourceType = .camera
                            showUploadPopup = false
                            showImagePicker = true
                        }) {
                            VStack {
                                Image("camera")
                                    .resizable()
                                    .frame(width: 40, height: 35)
                                    .foregroundColor(.purple)
                                Text("Camera")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        
                        Button(action: {
                            print("Gallery tapped")
                            sourceType = .photoLibrary
                            showUploadPopup = false
                            showImagePicker = true
                        }) {
                            VStack {
                                Image("apple")
                                    .resizable()
                                    .frame(width: 40, height: 35)
                                    .foregroundColor(.purple)
                                Text("Gallery")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .ignoresSafeArea(edges: .bottom)
                )
                .transition(.move(edge: .bottom))
                .animation(.spring(), value: showUploadPopup)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
        }
    }
}






struct RoundedCorner: Shape {
    var radius: CGFloat = 10.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    UploadDefectView()
}
