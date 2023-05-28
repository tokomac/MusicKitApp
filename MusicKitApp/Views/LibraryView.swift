//
//  LibraryView.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct LibraryView: View {
    
    @StateObject private var searchViewModel = LibrarySearchViewModel()
    @State private var response: MusicLibraryResponse<Playlist>? = nil
    
    var body: some View {
        VStack {
            navigationView
                .task {
                    try? await loadLibraryPlaylists()
                }
        }
    }
    
    private var navigationView: some View {
        NavigationView {
            navigationPrimaryView
                .navigationTitle("MusicKitApp")
        }
        .searchable(text: $searchViewModel.searchTerm)
    }
    
    private var navigationPrimaryView: some View {
        VStack(alignment: .leading) {
            libraryPlaylists
                .resignKeyboardOnDragGesture()
        }
    }
    
    @ViewBuilder
    private var librarySearchView: some View {
        if let searchResponse = searchViewModel.searchResponse {
            List {
                if !searchResponse.songs.isEmpty {
                    Section(header: Text("Songs").fontWeight(.semibold)) {
                        ForEach(searchResponse.songs) { song in
                            TrackCell(.song(song))
                        }
                    }
                }
                if !searchResponse.musicVideos.isEmpty {
                    Section(header: Text("Music Videos").fontWeight(.semibold)) {
                        ForEach(searchResponse.musicVideos) { musicVideo in
                            TrackCell(.musicVideo(musicVideo))
                        }
                    }
                }
                if !searchResponse.albums.isEmpty {
                    Section(header: Text("Albums").fontWeight(.semibold)) {
                        ForEach(searchResponse.albums) { album in
                            AlbumCell(album)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var libraryPlaylists: some View {
        if searchViewModel.searchResponse != nil {
            librarySearchView
        } else if let response = response {
            List {
                Section(header: Text("Library Playlists").fontWeight(.semibold)) {
                    ForEach(response.items) { playlist in
                        PlaylistCell(playlist, isLibrary: true)
                    }
                }
                Spacer(minLength: 20)
            }
        }
    }
    
    // MARK: - Methods
    
    @MainActor
    private func loadLibraryPlaylists() async throws {
        let request = MusicLibraryRequest<Playlist>()
        let response = try await request.response()
        self.response = response
    }
}
