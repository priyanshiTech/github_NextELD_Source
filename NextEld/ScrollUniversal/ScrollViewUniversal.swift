//
//  ScrollViewUniversal.swift
//  NextEld
//
//  Created by Priyanshi on 08/05/25.
//

import Foundation
import SwiftUI

struct UniversalScrollView<Content: View>: View {
    
    let axis: Axis.Set
    let showsIndicators: Bool
    let content: Content

    init(
        axis: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    var body: some View {
        
        ScrollView(axis, showsIndicators: showsIndicators) {
            if axis == .vertical {
                VStack(alignment: .leading, spacing: 14) {
                    content
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            } else {
                HStack(alignment: .top, spacing: 14) {
                    content
                }
                .padding()
            }
               
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
    }
}
