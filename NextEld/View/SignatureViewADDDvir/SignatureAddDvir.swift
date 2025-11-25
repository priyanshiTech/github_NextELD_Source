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
    @Binding var strokes: [[CGPoint]]     // multiple strokes
    var onSave: (UIImage) -> Void         // return saved signature image

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { isPresented = false }

            VStack(spacing: 16) {

                // Header
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

                    SignatureCanvas(strokes: $strokes)
                        .frame(height: 200)
                }
                .padding(.horizontal)

                // Certification Text
                Text("I hereby certify that my data entries are true and correct")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Buttons
                HStack(spacing: 16) {

                    // Clear Signature
                    Button("Clear") {
                        strokes.removeAll()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.red)
                    .cornerRadius(10)

                    // Save Signature
                    Button("Agree") {
                        let img = signatureToImage(strokes: strokes,
                                                   size: CGSize(width: 300, height: 150))
                        onSave(img)
                        isPresented = false
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





func signatureToImage(strokes: [[CGPoint]], size: CGSize) -> UIImage {

    let renderer = UIGraphicsImageRenderer(size: size)

    return renderer.image { context in

        UIColor.white.setFill()
        context.fill(CGRect(origin: .zero, size: size))

        let cg = context.cgContext
        cg.setLineWidth(3)
        cg.setLineCap(.round)
        cg.setStrokeColor(UIColor.black.cgColor)

        for stroke in strokes {
            guard stroke.count > 1 else { continue }

            cg.move(to: stroke.first!)
            for p in stroke.dropFirst() {
                cg.addLine(to: p)
            }
            cg.strokePath()
        }
    }
}

struct SignatureCanvas: View {

    @Binding var strokes: [[CGPoint]]   // each stroke = array of points

    var body: some View {
        GeometryReader { geo in
            ZStack {

                // Draw all strokes
                ForEach(0..<strokes.count, id: \.self) { index in
                    Path { path in
                        let stroke = strokes[index]
                        if let first = stroke.first {
                            path.move(to: first)
                            for p in stroke.dropFirst() {
                                path.addLine(to: p)
                            }
                        }
                    }
                    .stroke(Color.black, lineWidth: 2)
                }
            }
            .background(Color.white)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if strokes.isEmpty || strokes.last?.isEmpty == false {
                            // Start a new stroke
                            strokes.append([])
                        }
                        strokes[strokes.count - 1].append(value.location)
                    }
                    .onEnded { _ in
                        // End stroke automatically
                    }
            )
        }
        .clipped()
    }
}



//struct SignatureAddDvir: View {
//    
//    @Binding var isPresented: Bool
//    @Binding var points: [CGPoint]   // parent se bhi milega
//    var onSave: (UIImage) -> Void    // yeh closure parent ko image bhejega
//    
//    var body: some View {
//        ZStack {
//            Color(uiColor:.black).opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture { isPresented = false }
//            
//            VStack(spacing: 16) {
//                HStack {
//                    Text("Driver Signature")
//                        .font(.headline)
//                    Spacer()
//                    Button(action: { isPresented = false }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.red)
//                            .font(.title2)
//                    }
//                }
//                .padding(.horizontal)
//                
//                // Signature Canvas
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray.opacity(0.6), lineWidth: 2)
//                        .frame(height: 200)
//                    
//                    SignatureCanvas(points: $points)
//                        .frame(height: 200)
//                }
//                .padding(.horizontal)
//                
//                // Certification
//                Text("I hereby certify that my data entries are true and correct")
//                    .font(.footnote)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//                
//                // Buttons
//                HStack(spacing: 16) {
//                    Button("Clear") { points.removeAll() }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.white)
//                        .foregroundColor(.red)
//                        .cornerRadius(10)
//                    
//                    Button("Agree") {
//                        let image = signatureToImage(points: points, size: CGSize(width: 300, height: 150))
//                        onSave(image)         // parent ko image bhej do
//                        isPresented = false   // popup close
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color(UIColor.wine))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                .padding(.horizontal)
//            }
//            .background(Color.white)
//            .cornerRadius(16)
//            .shadow(radius: 10)
//            .padding()
//        }
//    }
//}

// Helper: Path -> UIImage
//func signatureToImage(points: [CGPoint], size: CGSize) -> UIImage {
//    let renderer = UIGraphicsImageRenderer(size: size)
//    return renderer.image { context in
//        // Fill with white background to ensure visibility
//        UIColor.white.setFill()
//        context.fill(CGRect(origin: .zero, size: size))
//        
//        // Draw signature in black with proper line settings
//      //  UIColor.black.setStroke()
//       
//        let cgContext = context.cgContext
//        cgContext.setLineWidth(3.0)
//        cgContext.setLineCap(.round)
//        cgContext.setLineJoin(.round)
//        cgContext.setStrokeColor(UIColor.black.cgColor)
//        
//        // Draw the signature path - connect all points
//        guard points.count > 1 else { return }
//        
//        cgContext.move(to: points[0])
//        for i in 1..<points.count {
//            cgContext.addLine(to: points[i])
//        }
//        cgContext.strokePath()
//    }
//}

// MARK: - Signature Canvas
//struct SignatureCanvas: View {
//    @Binding var points: [CGPoint]
//
//    var body: some View {
//        GeometryReader { geo in
//            Path { path in
//                if let first = points.first {
//                    path.move(to: first)
//                    for point in points.dropFirst() {
//                        path.addLine(to: point)
//                    }
//                }
//            }
//            .stroke(Color(uiColor:.black), lineWidth: 2)
//            .background(Color.white)
//            .gesture(DragGesture(minimumDistance: 0)
//                        .onChanged { value in
//                            points.append(value.location)
//                        }
//            )
//        }
//        .clipped()
//    }
//}

