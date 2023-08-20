//
//  RecentlyPlayedViewModel.swift
//  MusicKitApp
//
//  Created by tokomac
//

import Combine
import MusicKit
import SwiftUI

class RecentlyPlayedViewModel: ObservableObject {
    
    static let shared = RecentlyPlayedViewModel()
    
    @Published var recentlyPlayedItems: MusicItemCollection<Song> = []
    @ObservedObject private var status = MusicKitAuthorizationModel.shared
    
    private var musicAuthorizationStatusObserver: AnyCancellable?
    
    func loadRecentlyPlayed() {
        musicAuthorizationStatusObserver = status.$musicKitAuthorizationStatus
            .filter { authorizationStatus in
                return (authorizationStatus == .authorized)
            }
            .sink { [weak self] _ in
                self?.loadRecentlyPlayedItems()
            }
    }
    
    private func loadRecentlyPlayedItems() {
        Task {
            do {
                let recentlyPlayedRequest = MusicRecentlyPlayedRequest<Song>()
                let recentlyPlayedResponse = try await recentlyPlayedRequest.response()
                await self.updateRecentlyPlayedItems(recentlyPlayedResponse.items)
            } catch {
                fatalError("Failed to load suggested playlists due to error: \(error).")
            }
        }
    }
    
    @MainActor
    private func updateRecentlyPlayedItems(_ items: MusicItemCollection<Song>) async {
        recentlyPlayedItems = items
    }
}

