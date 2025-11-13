//
//  VechicleInfoView.swift
//  NextEld
//
//  Created by priyanshi   on 06/10/25.
//

import Foundation
import SwiftUI

struct VehicleInfoView: View {
    var GadiNo: String
    var trailer:String
    
    var body: some View {
        HStack {
            VStack(spacing: 5) {
                Text("Truck")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .bold()
                
                Label(GadiNo, systemImage: "")
                    .foregroundColor(Color(uiColor: .wine))
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(UIColor.lightWine))
            .cornerRadius(5)
            
            Spacer()
            
            VStack(spacing: 5) {
                Text("Trailer")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .bold()
                
                Label(trailer, systemImage: "")
                    .foregroundColor(Color(uiColor: .wine))
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(UIColor.lightWine))
            .cornerRadius(5)
        }
        .padding(.horizontal)
    }
}
