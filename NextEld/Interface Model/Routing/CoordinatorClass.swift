//
//  CoordinatorClass.swift
//  NextEld
//
//  Created by priyanshi on 07/05/25.
//

import Foundation
import SwiftUI


class AppRootManager: ObservableObject {
    @Published var currentRoot: ApplicationRoot = .splashScreen
}


class NavigationManager: ObservableObject {
    
    @Published var path = NavigationPath()

    func navigate(to route: any Hashable) {
        print("Navigating to \(route)")
        path.append(route)
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func reset(to route: any Hashable) {
        path = NavigationPath()
        path.append(route)
    }
    
    func reset() {
        path = NavigationPath()
    }

}






