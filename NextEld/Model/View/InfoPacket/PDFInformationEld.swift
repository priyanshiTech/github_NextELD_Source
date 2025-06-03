//
//  PDFInformationEld.swift
//  NextEld
//
//  Created by priyanshi   on 30/05/25.
//

import Foundation
import SwiftUI
import PDFKit


// MARK: - PDF Viewer with Header
struct PDFViewerWithHeader: View {
    let fileName: String
    let title: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()
            .background(Color.blue)

            Divider()

            // PDF content
            if let url = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
                PDFKitView(url: url)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                Text("PDF not found")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

// MARK: - PDFKit View (Wrapper for PDFKit)
struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
