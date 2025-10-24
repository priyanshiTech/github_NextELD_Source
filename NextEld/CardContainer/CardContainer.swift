//
//  CardContainer.swift
//  NextEld
//
//  Created by Priyanshi on 08/05/25.
//

import Foundation
import SwiftUI

struct CardContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }

        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

}
