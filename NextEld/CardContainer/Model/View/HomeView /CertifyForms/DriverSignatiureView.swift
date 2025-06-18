//
//  DriverSignatiureView.swift
//  NextEld
//
//  Created by Inurum   on 26/05/25.
//

import Foundation
import SwiftUI

struct SignatureCertifyView: View {
    @Binding var signaturePath: Path

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()

            Text("Driver Signature")
                .font(.headline)
                .padding(.leading)
            
            SignaturePad(path: $signaturePath)
                .frame(height: 300)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10)) // restrict drawing to shape
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding(.horizontal)

            Text("I hereby certify that my data entries and my record of duty status for this 24 hour period are true and correct")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            HStack(spacing: 16) {
                Button("Clear Signature") {
                    signaturePath = Path()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .bold()
                .lineLimit(1)
                .font(.footnote)
                .background(Color.white)
                .foregroundColor(.blue)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )

                Button("Agree") {
                    print("Signature confirmed")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .bold()
                .font(.footnote)

                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            Spacer()
        }
        .transition(.slide)
    }
}

#Preview {
    SignatureCertifyPreviewWrapper()
}


//MARK:  popup view Resuable
struct SignatureCertifyPreviewWrapper: View {
    @State private var path = Path()
    
    var body: some View {
        SignatureCertifyView(signaturePath: $path)
    }
}

//MARK: -  create a popup for resuable in app

struct PopupContainer<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ZStack(alignment: .topTrailing) {
                        VStack {
                            content
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .frame(maxWidth: 300)
                        .fixedSize(horizontal: false, vertical: true)

                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                                .padding(12)
                        }
                    }
                }
            }
            .zIndex(10)
        }
    }
}
