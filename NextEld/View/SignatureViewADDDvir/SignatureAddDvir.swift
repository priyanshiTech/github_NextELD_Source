//
//  SignatureAddDvir.swift
//  NextEld
//
//  Created by priyanshi   on 04/09/25.
//

import Foundation
import SwiftUI

struct SignatureAddDvir: View {
    @Binding var isPresented: Bool
    @Binding var points: [CGPoint]   // parent se bhi milega
    var onSave: (UIImage) -> Void    // yeh closure parent ko image bhejega
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { isPresented = false }
            
            VStack(spacing: 16) {
                HStack {
                    Text("Driver Signature")
                        .font(.headline)
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // Signature Canvas
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                        .frame(height: 200)
                    
                    SignatureCanvas(points: $points)
                        .frame(height: 200)
                }
                .padding(.horizontal)
                
                // Certification
                Text("I hereby certify that my data entries are true and correct")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Buttons
                HStack(spacing: 16) {
                    Button("Clear") { points.removeAll() }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                    
                    Button("Agree") {
                        let image = signatureToImage(points: points, size: CGSize(width: 300, height: 150))
                        onSave(image)         // parent ko image bhej do
                        isPresented = false   // popup close
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.wine))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding()
        }
    }
}

// Helper: Path -> UIImage
func signatureToImage(points: [CGPoint], size: CGSize) -> UIImage {
    let path = Path { p in
        if let first = points.first {
            p.move(to: first)
            for pt in points.dropFirst() {
                p.addLine(to: pt)
            }
        }
    }
    let controller = UIHostingController(rootView:
        path.stroke(Color.black, lineWidth: 2)
            .background(Color.white)
            .frame(width: size.width, height: size.height)
    )
    let view = controller.view
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
        view?.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
    }
}

// MARK: - Signature Canvas
struct SignatureCanvas: View {
    @Binding var points: [CGPoint]
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                if let first = points.first {
                    path.move(to: first)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(Color.black, lineWidth: 2)
            .background(Color.white)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            points.append(value.location)
                        }
            )
        }
        .clipped()
    }
}









// Helper: Path -> UIImage
//func signatureToImage(points: [CGPoint], size: CGSize) -> UIImage {
//    let path = Path { p in
//        if let first = points.first {
//            p.move(to: first)
//            for pt in points.dropFirst() {
//                p.addLine(to: pt)
//            }
//        }
//    }
//    let controller = UIHostingController(rootView:
//        path.stroke(Color.black, lineWidth: 2)
//            .background(Color.white)
//            .frame(width: size.width, height: size.height)
//    )
//    let view = controller.view
//    let renderer = UIGraphicsImageRenderer(size: size)
//    return renderer.image { _ in
//        view?.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
//    }
//}
//// MARK: - Preview
//struct SignaturePopupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignatureAddDvir(isPresented: .constant(true))
//    }
//}



/*struct SignatureAddDvir: View {
    @Binding var isPresented: Bool
    @State private var points: [CGPoint] = []
    var onSave: (UIImage) -> Void
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Driver Signature")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Signature area
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                        .frame(height: 200)
                    
                    SignatureCanvas(points: $points)
                        .frame(height: 200)
                }
                .padding(.horizontal)
                
                // Certification text
                Text("I hereby certify that my data entries and my record of duty status for this 24 hour period are true and correct")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Buttons
                HStack(spacing: 16) {
                    Button(action: { points.removeAll() }) {
                        Text("Clear Signature")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color(UIColor.wine))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.wine)))
                    }
                    
                    Button(action: {
                        // Save or handle signature
                        let image = signatureToImage(points: points, size: CGSize(width: 300, height: 150))
                        onSave(image)
                        isPresented = false
                    }) {
                        Text("Agree")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .wine))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding()
        }
    }
}*/
