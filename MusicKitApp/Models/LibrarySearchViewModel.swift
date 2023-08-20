//
//  LibrarySearchViewModel.swift
//  MusicKitApp
//
//  Created by tokomac
//

import Combine
import MusicKit
import SwiftUI

class LibrarySearchViewModel: ObservableObject {
    
    @Published var searchTerm = ""
    @Published var searchResponse: MusicLibrarySearchResponse?
    @Published var isDisplayingSuggestedPlaylists = false
    
    private var searchTermObserver: AnyCancellable?
    
    init() {
        searchTermObserver = $searchTerm
            .sink(receiveValue: librarySearch)
    }
    
    private func librarySearch(for searchTerm: String) {
        if searchTerm.isEmpty {
            isDisplayingSuggestedPlaylists = true
            searchResponse = nil
        } else {
            Task {
                let librarySearchRequest = MusicLibrarySearchRequest(
                    term: searchTerm,
                    types: [
                        Song.self,
                        MusicVideo.self,
                        Album.self
                    ]
                )
                do {
                    let librarySearchResponse = try await librarySearchRequest.response()
                    await self.update(with: librarySearchResponse, for: searchTerm)
                } catch {
                    fatalError("Failed to load library search results due to error: \(error).")
                }
            }
        }
    }
    
    @MainActor
    func update(with libraryResponse: MusicLibrarySearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.searchResponse = libraryResponse
        }
    }
}
