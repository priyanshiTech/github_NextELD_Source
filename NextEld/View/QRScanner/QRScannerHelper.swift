import SwiftUI

struct QRScannerHelper {
    static func validateQRCode(_ code: String) -> Bool {
        // Add your QR code validation logic here
        return !code.isEmpty
    }
    
    static func processQRCode(_ code: String) -> String? {
        // Add your QR code processing logic here
        return code
    }
}

struct QRScannerOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.7)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                VStack {
                    Spacer()
                    Text("Position QR code within frame")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                }
            }
        }
    }
}

struct QRScannerButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image("qr-scan")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
} 