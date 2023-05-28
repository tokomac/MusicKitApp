//
//  PlaylistDetailView.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct PlaylistDetailView: View {
    
    @State var playlist: Playlist
    @State var isShowingPlaylistPicker = false
    @State var itemToAdd: Track?
    var isLibrary: Bool
    
    var body: some View {
        content
            .navigationTitle(playlist.name)
            .task {
                await self.loadDetailedPlaylist()
            }
    }
    
    private var content: some View {
        List {
            header
                .listRowBackground(Color.clear)
            
            if let tracks = playlist.tracks {
                Section(header: Text("Tracks")) {
                    ForEach(tracks, id: \.self) { track in
                        TrackCell(track, from: playlist)
                    }
                }
                Spacer(minLength: 20)
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .center) {
            if let artwork = playlist.artwork {
                ArtworkImage(artwork, width: 320, height: 320)
                    .cornerRadius(8.0)
            }
            if let tracks = playlist.tracks {
                PlayButton(tracks[0], tracks)
            }
        }
    }
    
    @MainActor
    private func loadDetailedPlaylist() async {
        do {
            let detailedPlaylist = try await playlist.with(.tracks, preferredSource: isLibrary ? .library : .catalog)
            playlist = detailedPlaylist
        } catch {
            print("Failed to load additional content for \(playlist) with error: \(error).")
        }
    }
}
