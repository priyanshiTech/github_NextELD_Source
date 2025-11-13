import SwiftUI
import AVFoundation

class ScannerQR: NSObject, ObservableObject {
    @Published var scannedCode: String?
    @Published var isScanning = true
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
        checkCameraPermission()
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCaptureSession()
                    } else {
                        self?.showAlert = true
                        self?.errorMessage = "Camera access is required to scan QR codes"
                    }
                }
            }
        case .denied, .restricted:
            showAlert = true
            errorMessage = "Camera access is required to scan QR codes"
        @unknown default:
            break
        }
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        
        self.captureSession = captureSession
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func startScanning() {
        isScanning = true
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func stopScanning() {
        isScanning = false
        captureSession?.stopRunning()
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        guard let captureSession = captureSession else { return nil }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer
        
        return previewLayer
    }
}

extension ScannerQR: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.scannedCode = stringValue
                self?.isScanning = false
                self?.stopScanning()
            }
        }
    }
}

struct QRScannerView: View {
    @StateObject private var scanner = ScannerQR()
    @Environment(\.presentationMode) var presentationMode
    @Binding var scannedCode: String?
    
    var body: some View {
        ZStack {
            QRScannerRepresentable(scanner: scanner)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
                
                if let code = scanner.scannedCode {
                    Text("Scanned: \(code)")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
            }
        }
        .alert(isPresented: $scanner.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(scanner.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: scanner.scannedCode) { newValue in
            if let code = newValue {
                scannedCode = code
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct QRScannerRepresentable: UIViewRepresentable {
    let scanner: ScannerQR
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        if let previewLayer = scanner.getPreviewLayer() {
            previewLayer.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = scanner.getPreviewLayer() {
            previewLayer.frame = uiView.layer.bounds
        }
    }
} 