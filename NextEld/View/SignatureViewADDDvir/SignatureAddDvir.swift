
import Foundation
import SwiftUI

struct SignatureAddDvir: View {
    
    @Binding var isPresented: Bool
    @Binding var points: [CGPoint]   // parent se bhi milega
    var onSave: (UIImage) -> Void    // yeh closure parent ko image bhejega
    
    var body: some View {
        ZStack {
            Color(uiColor:.black).opacity(0.4)
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
 
