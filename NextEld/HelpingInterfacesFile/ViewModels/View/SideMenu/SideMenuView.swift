//
//  SideMenuView.swift
//  NextEld
//
//  Created by Priyanshi on 12/05/25.
//
import SwiftUI


struct SideMenuView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @Binding var showLogoutPopup: Bool
    @Binding var showDeleteConfirm: Bool
    
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.white
                .ignoresSafeArea()
            
            UniversalScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                        .padding(.vertical, 20)
                        .padding(.horizontal, 16)

                    ForEach(SideMenuRowType.allCases, id: \.self) { row in
                        RowView(
                            isSelected: selectedSideMenuTab == row.rawValue,
                            imageName: row.iconName,
                            title: row.title
                        ) {
                            withAnimation {
                                selectedSideMenuTab = row.rawValue
                                handleSelection(row)
                            }
                        }
                    }

                    Spacer()
                }
                .frame(width: 270)
                .background(Color.white)
            }
        }

        
        
        .scrollIndicators(.hidden)
        .background(Color.clear)
    }

    func ProfileImageView() -> some View {
        HStack(spacing: 12) {
            Image("person image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.5), lineWidth: 4)
                )
                .padding()
            VStack(alignment: .leading, spacing: 0) {
                Text("Mark Joseph")
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                    .foregroundColor(.black)

                Text("ELD ID - 17")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
        }
    }

    func handleSelection(_ row: SideMenuRowType) {
       switch row {
        case .DailyLogs:
           navmanager.path.append(AppRoute.DailyLogs(tittle: "Daily Logs"))
       case .DvirPriTrip:
           navmanager.path.append(AppRoute.AddDvirPriTrip)
       case . DotInspection:
           navmanager.path.append(AppRoute.DotInspection(tittle: "road Side inspection"))
       case .coDriver:
           navmanager.path.append(AppRoute.CoDriverLogin)
       case .Vehicle:
           navmanager.path.append(AppRoute.AddVichleMode)
           
       case .companyInformation:
           navmanager.path.append(AppRoute.CompanyInformationView)
       case .InformationPocket:
           navmanager.path.append(AppRoute.InformationPacket)
       case .Rules:
           navmanager.path.append(AppRoute.RulesView)
       case .ELDConnection:
           navmanager.path.append(AppRoute.Scanner)
       case .settings:
           navmanager.path.append(AppRoute.Settings)
       case .support:
           navmanager.path.append(AppRoute.SupportView)
       case .FirmWareUpdate:
           navmanager.path.append(AppRoute.FirmWare_Update)
       case .logout:
           showLogoutPopup = true
           presentSideMenu = false
       case .version:
           presentSideMenu = false
           showDeleteConfirm = true
    
        }
    }

    func RowView(isSelected: Bool, imageName: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Rectangle()
                    .fill(isSelected ? Color.white : Color.clear)
                    .frame(width: 4)

                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .black : .black)
                    .frame(width: 26, height: 26)

                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(isSelected ? .black : .black)

                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(isSelected ? Color(uiColor: .systemGray6) : Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
