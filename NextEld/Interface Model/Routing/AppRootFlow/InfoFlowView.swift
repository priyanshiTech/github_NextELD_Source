//
//  InfoFlowView.swift
//  NextEld
//
//  Created by priyanshi   on 09/10/25.
//

import Foundation
import SwiftUI

struct InfoFlowView: View {
    var body: some View {
        NavigationStack {
            CompanyInformationView() // default
                .navigationDestination(for: AppRoute.InfoFlow.self) { route in
                    switch route {
                    case .CompanyInformationView:
                        CompanyInformationView()
                    case .InformationPacket:
                        InformationPacket()
                    case .RulesView:
                        RulesView()
                    }
                }
        }
    }
}
