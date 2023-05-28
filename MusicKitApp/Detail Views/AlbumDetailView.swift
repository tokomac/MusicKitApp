//
//  AlbumDetailView.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct AlbumDetailView: View {
    
    @State var album: Album
    
    private static let artworkWidth = 320.0
    private static let artworkCornerRadius = 8.0
    
    var body: some View {
        List {
            header
                .listRowBackground(Color.clear)
            
            if let tracks = album.tracks {
                Section(header: Text("Tracks")) {
                    ForEach(tracks) { track in
                        TrackCell(track, from: album)
                    }
                }
            }
            
            if let relatedAlbums = album.relatedAlbums, !relatedAlbums.isEmpty {
                Section(header: Text("Related Albums")) {
                    ForEach(relatedAlbums) { album in
                        AlbumCell(album)
                    }
                }
            }
        }
        .navigationTitle(album.title)
        .task {
            await loadDetailedAlbum()
        }
    }
    
    private var header: some View {
        VStack {
            if let artwork = album.artwork {
                ArtworkImage(artwork, width: Self.artworkWidth)
                    .cornerRadius(Self.artworkCornerRadius)
            }
            Text(album.artistName)
                .font(.title3.bold())
            if let tracks = album.tracks {
                PlayButton(tracks[0], tracks)
            }
        }
    }
    
    @MainActor
    private func loadDetailedAlbum() async {
        do {
            let detailedAlbum = try await album.with(.tracks, .relatedAlbums)
            album = detailedAlbum
        } catch {
            print("Failed to load additional content for \(album) with error: \(error).")
        }
    }
}
