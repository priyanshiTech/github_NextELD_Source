//
//  signature.swift
//  NextEld
//
//  Created by Inurum   on 21/05/25.
//

import SwiftUI

struct signature: View {
    
    @Binding var path: Path
    @State private var currentPoint: CGPoint?
    
    var body: some View {
        {
       
           Spacer()
            Text("Driver Signature")
                .font(.headline)
                .padding(.leading)

            signature(path: $path)
                .frame(height: 200)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 5)
                )
                .padding(.horizontal)
            
            Text("I hereby certify  that my data entries and my record of duty status for this 24 hour period are true and correct")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
            HStack(spacing: 16) {
                Button("Clear Signature") {
                    signature = Path()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .bold()
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
                .background(Color.blue)
                .foregroundColor(.white)
                
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            
        }
    }
}
struct SignaturdePadPreviewWrapper: View {
    @State private var signaturePath = Path()

    var body: some View {
        SignaturePad(path: $signaturePath)
            .frame(height: 250)
            .padding()
    }
}




#Preview {
    SignaturePadPreviewWrapper()
}
