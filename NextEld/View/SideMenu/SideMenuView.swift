//
//  SideMenuView.swift
//  NextEld
//
//  Created by Priyanshi on 12/05/25.

import SwiftUI


struct SideMenuView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @Binding var showDeleteConfirm: Bool
    @Binding var showSyncConfirmation: Bool
    var onLogoutRequested: () -> Void

    var body: some View {
        
        ZStack(alignment: .leading) {
            Color.white
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                
            ProfileImageView()
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            
            UniversalScrollView {

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
        HStack(alignment: .center, spacing: 12) {
            Image("person image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color(uiColor:.black).opacity(0.5), lineWidth: 3)
                )
                .padding(.leading, 16)

            //#p changes
            VStack(alignment: .leading, spacing: 4) {
                Text(AppStorageHandler.shared.driverName ?? "")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(uiColor:.black))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("ELD ID - \(String(AppStorageHandler.shared.driverId ?? 0))")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(uiColor:.gray))
                    .lineLimit(1)
            }
            .padding(.leading, 2)
            .padding(.trailing, 16)

            Spacer()
        }
        .padding(.vertical, 8)
    }


func handleSelection(_ row: SideMenuRowType) {
    
       switch row {
           
        case .DailyLogs:
           navmanager.path.append(AppRoute.HomeFlow.DailyLogs(tittle: "Daily Logs"))
       case .DvirPriTrip:
           navmanager.path.append(AppRoute.HomeFlow.AddDvirPriTrip)
       case . DotInspection:
           navmanager.path.append(AppRoute.HomeFlow.DotInspection(tittle: "Road Side inspection"))
       case .coDriver:
           navmanager.path.append(AppRoute.HomeFlow.CoDriverLogin)
       case .Vehicle:
           navmanager.path.append(AppRoute.HomeFlow.AddVichleMode)
       case .companyInformation:
           navmanager.path.append(AppRoute.HomeFlow.CompanyInformationView)
       case .InformationPocket:
           navmanager.path.append(AppRoute.HomeFlow.InformationPacket)
       case .Rules:
           navmanager.path.append(AppRoute.HomeFlow.RulesView)
       case .ELDConnection:
           presentSideMenu = false
           // Reset to root (scanner view) instead of pushing scanner again
           navmanager.reset()
       case .settings:
           navmanager.path.append(AppRoute.HomeFlow.Settings)
       case .support:
           navmanager.path.append(AppRoute.HomeFlow.SupportView)
       case .FirmWareUpdate:
           navmanager.path.append(AppRoute.HomeFlow.FirmWare_Update)
       case .logout:
           onLogoutRequested()
           
       case .version:
           presentSideMenu = false
           showDeleteConfirm = true
    
       case .Sync:
           presentSideMenu = false
        showSyncConfirmation = true   // <-- Trigger popup
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
                    .foregroundColor(isSelected ? Color(uiColor:.black) : Color(uiColor:.black))
                    .frame(width: 26, height: 26)

                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(isSelected ? Color(uiColor:.black) : Color(uiColor:.black))
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(isSelected ? Color(uiColor: .systemGray6) : Color(uiColor:.white))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
