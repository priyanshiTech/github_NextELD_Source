//
//  ContentView.swift
//  NextEld
//
//  Created by AroGeek11 on 05/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {

         Image("NextELD")
                .frame(width: 40.0, height: 40.0)
                .imageScale(.large)
                .foregroundStyle(.tint)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
         .background(.blue)
       
    }
    
}

#Preview {
    ContentView()
}
