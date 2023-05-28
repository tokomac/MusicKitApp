//
//  MusicKitAppApp.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

@main
struct MusicKitAppApp: App {
    
    private var authorization = MusicKitAuthorizationModel.shared

    @State private var selectedTab = 0
    @State private var tabBarHeight: CGFloat = 0.0

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                if selectedTab == 0 {
                    RecentlyPlayedView()
                }
                else if selectedTab == 1 {
                    LibraryView()
                }
                MusicAppTabView() { selectedTab in
                    self.selectedTab = selectedTab
                }
            }
            .accentColor(.pink)
            .onPreferenceChange(TabSizePreferenceKey.self) { value in
                tabBarHeight = value.height
            }
            .task {
                let musicAuthorizationStatus = authorization.musicKitAuthorizationStatus
                if musicAuthorizationStatus == .notDetermined || musicAuthorizationStatus == .denied {
                    await authorization.requestMusicAuthorization()
                }
            }
        }
    }
}
