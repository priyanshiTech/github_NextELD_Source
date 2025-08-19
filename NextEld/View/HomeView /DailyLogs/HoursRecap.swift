//
//  HoursRecap.swift
//  NextEld
//  Created by Inurum   on 15/05/25.
//

import SwiftUI

struct HoursRecap: View {
 var tittle: String
 var selection : String?

    let entries: [WorkEntry] = generateWorkEntries()
    @EnvironmentObject var navManager : NavigationManager
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    var body: some View {

        VStack (spacing: 0 ){
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:2)
              
            }
            HStack {
                Button(action: {
                 //   presentationMode.wrappedValue.dismiss()
                    navManager.goBack()
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
            .background(Color(uiColor: .wine).shadow(radius: 1))
            .frame(height: 40, alignment: .topLeading)
            Spacer(minLength: 20)

            HStack{
                Text("Date")
                    .foregroundColor(.white)
                    .bold()
                Spacer()
                Text("Hour Worked")
                    .foregroundColor(.white)
                    .bold()

            }    .padding()
                .background(Color(uiColor: .wine).shadow(radius: 1))
                 .frame(height: 40, alignment: .topLeading)
                Spacer(minLength: 20)
            
            List(entries) { entry in
                       HStack {
                           Text(dateFormatter.string(from: entry.date))
                               .frame(maxWidth: .infinity, alignment: .leading)
                           Text("\(entry.hoursWorked, specifier: "00.%.1f") hrs")
                               .frame(alignment: .trailing)
                       }
                       .padding(.vertical, 4)
                   } .scrollIndicators(.hidden)
      
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    HoursRecap(tittle: "Hours Recap")
}
