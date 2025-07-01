//
//  CoordinatorClass.swift
//  NextEld
//
//  Created by priyanshi on 07/05/25.
//

import Foundation
import SwiftUI


class NavigationManager: ObservableObject {
    
    @Published var path: [AppRoute] = []

    func navigate(to route: AppRoute) {
        print("Navigating to \(route)")
        path.append(route)
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func reset(to route: AppRoute) {
        path = [route]
    }
}
