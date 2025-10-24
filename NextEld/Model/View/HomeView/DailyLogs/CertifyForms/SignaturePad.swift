//
//  SignaturePad.swift
//  NextEld
//
//  Created by priyanshi on 26/05/25.
//

import Foundation
import SwiftUI


struct SignaturePad: View {
    @Binding var path: Path
    @State private var previousPoint: CGPoint?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                path
                    .stroke(Color.black, lineWidth: 2)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .contentShape(Rectangle()) // Make entire area tappable for gestures
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if previousPoint == nil {
                            path.move(to: value.location)
                        } else {
                            path.addLine(to: value.location)
                        }
                        previousPoint = value.location
                    }
                    .onEnded { _ in
                        previousPoint = nil
                    }
            )
        }
        .frame(width: 300, height: 200) // fixed size as you want
    }
}
