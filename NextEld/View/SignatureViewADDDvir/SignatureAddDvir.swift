
import Foundation
import SwiftUI
import SwiftUI

struct SignatureAddDvir: View {

    @Binding var isPresented: Bool
    @Binding var points: [CGPoint]
    var onSave: (UIImage) -> Void

    var body: some View {
        ZStack {
            // Dim Background
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 18) {

                // Header
                HStack {
                    Text("Driver Signature")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Spacer()

                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)

                Divider()

                // Signature Box
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                        .background(Color.white.cornerRadius(12))
                        .frame(height: 220)

                    SignatureCanvas(points: $points)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)

                // Certification Text
                Text("I hereby certify that my data entries are true and correct")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                // Action Buttons
                HStack(spacing: 14) {

                    Button {
                        points.removeAll()
                    } label: {
                        Text("Clear")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.gray)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                            )
                    }

                    Button {
                        let image = signatureToImage(
                            points: points,
                            size: CGSize(width: 320, height: 160)
                        )
                        onSave(image)
                        isPresented = false
                    } label: {
                        Text("Agree")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color(uiColor: .wine))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

            }
            .padding(.vertical, 18)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 12)
            .frame(maxWidth: 360)
            .padding(.horizontal)
        }
    }
}



// Helper: Path -> UIImage
func signatureToImage(points: [CGPoint], size: CGSize) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
        // Fill with white background to ensure visibility
        UIColor.white.setFill()
        context.fill(CGRect(origin: .zero, size: size))
        // Draw signature in black with proper line settings
         //  UIColor.black.setStroke()
        let cgContext = context.cgContext
        cgContext.setLineWidth(3.0)
        cgContext.setLineCap(.round)
        cgContext.setLineJoin(.round)
        cgContext.setStrokeColor(UIColor.black.cgColor)
        
        // Draw the signature path - connect all points
        let drawablePoints = points.filter { !$0.isStrokeBreak }
        guard drawablePoints.count > 1 else { return }
        
        cgContext.beginPath()
        var needsMove = true
        for point in points {
            guard !point.isStrokeBreak else {
                needsMove = true
                continue
            }
            
            if needsMove {
                cgContext.move(to: point)
                needsMove = false
            } else {
                cgContext.addLine(to: point)
            }
        }
        cgContext.strokePath()
    }
}
// MARK: - Signature Canvas
struct SignatureCanvas: View {
    @Binding var points: [CGPoint]
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                var needsMove = true
                for point in points {
                    guard !point.isStrokeBreak else {
                        needsMove = true
                        continue
                    }
                    
                    if needsMove {
                        path.move(to: point)
                        needsMove = false
                    } else {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(Color(uiColor:.black), lineWidth: 2)
            .background(Color.white)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    points.append(value.location)
                }
                .onEnded { _ in
                    if points.last?.isStrokeBreak != true {
                        points.append(.strokeBreak)
                    }
                }
            )
        }
        .clipped()
    }
}

private extension CGPoint {
    static var strokeBreak: CGPoint {
        CGPoint(x: CGFloat.nan, y: CGFloat.nan)
    }
    
    var isStrokeBreak: Bool {
        x.isNaN || y.isNaN
    }
}
 
