//
//  PlaylistCell.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct PlaylistCell: View {
    
    let playlist: Playlist
    let isLibrary: Bool
    
    init(_ playlist: Playlist, isLibrary: Bool = false) {
        self.playlist = playlist
        self.isLibrary = isLibrary
    }
    
    var body: some View {
        NavigationLink(destination: PlaylistDetailView(playlist: playlist, isLibrary: isLibrary)) {
            MusicItemCell(
                artwork: playlist.artwork,
                title: playlist.name,
                subtitle: (playlist.curatorName ?? "")
            )
        }
    }
}
