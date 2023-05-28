//
//  RecentlyPlayedView.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct RecentlyPlayedView: View {
    
    //    let musicPlayerModel: MusicPlayerModel
    @StateObject private var recentlyPlayedViewModel = RecentlyPlayedViewModel.shared
    
    var body: some View {
        VStack {
            navigationView
                .task {
                    recentlyPlayedViewModel.loadRecentlyPlayed()
                }
        }
    }
    
    private var navigationView: some View {
        NavigationView {
            navigationPrimaryView
                .navigationTitle("MusicKitApp")
        }
    }
    
    private var navigationPrimaryView: some View {
        VStack(alignment: .leading) {
            recentlyPlayedView
        }
    }
    
    private var recentlyPlayedView: some View {
        List {
            Section(header: Text("Recently Played").fontWeight(.semibold)) {
                ForEach(recentlyPlayedViewModel.recentlyPlayedItems, id: \.self) { recentlyPlayedItem in
                    SongCell(recentlyPlayedItem, recentlyPlayedViewModel.recentlyPlayedItems)
                }
            }
            Spacer(minLength: 20)
        }
    }
}
