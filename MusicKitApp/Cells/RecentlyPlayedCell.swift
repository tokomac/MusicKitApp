//
//  RecentlyPlayedCell.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct RecentlyPlayedCell: View {
    
    let recentlyPlayedItem: RecentlyPlayedMusicItem
    
    init(_ recentlyPlayedItem: RecentlyPlayedMusicItem) {
        self.recentlyPlayedItem = recentlyPlayedItem
    }
    
    var body: some View {
        switch recentlyPlayedItem {
            case .album(let album):
                AlbumCell(album)
                    .recentlyPlayedCellStyle()
                
            case .playlist(let playlist):
                PlaylistCell(playlist)
                    .recentlyPlayedCellStyle()
                
            case .station(let station):
                StationCell(station)
                    .recentlyPlayedCellStyle()
                
            @unknown default:
                EmptyView()
        }
    }
}

struct RecentlyPlayedCellStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(UIColor.systemBackground))
            }
    }
}

extension View {
    func recentlyPlayedCellStyle() -> some View {
        return modifier(RecentlyPlayedCellStyle())
    }
}
