//
//  FirmWare Update.swift
//  NextEld
//
//  Created by Inurum on 31/05/25.
//

import SwiftUI

struct FirmWare_Update: View {
    @EnvironmentObject var navmanager: NavigationManager
    @State var tittle = "FirmWare Update"
    
    var body: some View {
        
        VStack(spacing:0){
            
            ZStack(alignment: .topLeading){
              //  Color(UIColor.blue)
                Color(.blue)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:2)
              
            }
            
            HStack {
                Button(action: {
                    navmanager.goBack()
                    
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                Text(tittle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
                
            }
            .padding()
            .background(Color.blue.shadow(radius: 1))
            .frame(height: 40, alignment: .topLeading)
            Spacer(minLength: 20)
            
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    FirmWare_Update()
}
