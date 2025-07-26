//
//  Reuseable  Label.swift
//  NextEld
//
//  Created by Priyanshi on 08/05/25.
//

import Foundation
import SwiftUI


//MARK: - Dynamiclabel
struct DynamicLabel: View {
    var text: String
    var systemImage: String?
    var textColor: Color = .blue
    var font: Font = .body

    var body: some View {
        HStack {
            if let icon = systemImage {
                Image(systemName: icon)
            }
            Text(text)
        }
        .foregroundColor(textColor)
        .font(.system(size: 19))
        .font(font)
        .bold()
       
    }
}

//MARK: - co0mmon icon button 
struct IconButton: View {
    var iconName: String
    var action: () -> Void
    var iconColor: Color = .black
    var iconSize: CGFloat = 25
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: iconSize))
                .foregroundColor(iconColor)
        }
    }
}


struct CustomIconButton: View {
    var iconName: String
    var title: String // New text label next to icon
    var action: () -> Void
    var iconColor: Color = .white
    var iconSize: CGFloat = 24

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(iconName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.system(size:14))
                    .bold()
                    .foregroundColor(.white)
                   // .font(.system(size: 14, weight: .medium))
            }
        }
    }
}
