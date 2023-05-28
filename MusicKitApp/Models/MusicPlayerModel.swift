//
//  MusicPlayerModel.swift
//  MusicKitApp
//
//  Created by tokomac
//

import Combine
import MusicKit
import SwiftUI

enum MusicTypeEnum {
    case Song
    case Track
}

class MusicType: ObservableObject {
    
    static let shared = MusicType()
    @Published var musicType: MusicTypeEnum?
    
    func musicTypeSet(_ _musictype: PlayableMusicItem) {
        switch type(of: _musictype) {
        case is Song.Type:
            musicType = .Song
        case is Track.Type:
            musicType = .Track
        default:
            break
        }
    }
}

protocol MusicPlayerProtocol: AnyObject {
    associatedtype MusicItemType: PlayableMusicItem
    var track: MusicItemType? { get set }
    var trackList: MusicItemCollection<MusicItemType>? { get set }
    var isPlaying: Bool { get set }
    var musicPlayer: ApplicationMusicPlayer { get }
    var playbackStateObserver: AnyCancellable? { get set }
    var isPlaybackQueueInitialized: Bool { get set }
    var playbackQueueInitializationItemID: MusicItemID? { get set }
    var trackListCount: Int? { get set }
}

extension MusicPlayerProtocol {
    
    var musicPlayer: ApplicationMusicPlayer {
        let musicPlayer = ApplicationMusicPlayer.shared
        if playbackStateObserver == nil {
            playbackStateObserver = musicPlayer.state.objectWillChange
                .sink { [weak self] in
                    self?.handlePlaybackStateDidChange()
                }
        }
        return musicPlayer
    }
    
    func PlayTrack(_ track: MusicItemType) {

        let musicPlayer = self.musicPlayer
        setQueue(for: [track])

        self.isPlaybackQueueInitialized = true
        self.playbackQueueInitializationItemID = track.id
        self.track = track
        
        MusicType.shared.musicTypeSet(track)
        
        Task {
            do {
                try await musicPlayer.play()
            } catch {
                print(error.localizedDescription)
                print("Failed to prepare music player to play \(track).")
            }
        }
    }
    
    func play(_ track: MusicItemType, in trackList: MusicItemCollection<MusicItemType>?, with parentCollectionID: MusicItemID?) {
        let musicPlayer = self.musicPlayer
        if let specifiedTrackList = trackList {
            setQueue(for: specifiedTrackList, startingAt: track)
        } else {
            setQueue(for: [track])
        }
        self.isPlaybackQueueInitialized = true
        self.playbackQueueInitializationItemID = parentCollectionID

        self.track = track
        self.trackList = trackList

        MusicType.shared.musicTypeSet(track)
        
        Task {
            do {
                try await musicPlayer.play()
            } catch {
                print("Failed to prepare music player to play \(track).")
            }
        }
    }
    
    func togglePlaybackStatus<MusicItemType: PlayableMusicItem>(for item: MusicItemType) {
        if !isPlaying {
            let isPlaybackQueueInitializedForSpecifiedItem = isPlaybackQueueInitialized && (playbackQueueInitializationItemID == item.id)
            if !isPlaybackQueueInitializedForSpecifiedItem {
                let musicPlayer = self.musicPlayer
                setQueue(for: [item])
                self.isPlaybackQueueInitialized = true
                self.playbackQueueInitializationItemID = item.id
                Task {
                    do {
                        try await musicPlayer.play()
                    } catch {
                        print("Failed to prepare music player to play \(item).")
                    }
                }
            } else {
                Task {
                    try? await musicPlayer.play()
                }
            }
        } else {
            musicPlayer.pause()
        }
    }

    func skipToNextEntry() {
        if let track = track, let trackList = trackList {
            let count = trackList.count
            let musicPlayer = self.musicPlayer
            if let index = trackList.firstIndex(where: { $0.id == track.id }) {
                var ix = index + 1
                if ix >= count { ix = 0 }
                self.track = trackList[ix]

                if isPlaying {
                    playStop()
                }
                Task {
                    do {
                        try await musicPlayer.skipToNextEntry()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func playStop() {
        musicPlayer.stop()
    }
    
    func setQueue<S: Sequence, PlayableMusicItemType: PlayableMusicItem>(
        for playableItems: S,
        startingAt startPlayableItem: S.Element? = nil
    ) where S.Element == PlayableMusicItemType {
        ApplicationMusicPlayer.shared.queue = ApplicationMusicPlayer.Queue(for: playableItems, startingAt: startPlayableItem)
    }
    
    func handlePlaybackStateDidChange() {
        isPlaying = (musicPlayer.state.playbackStatus == .playing)
    }
}

class SongPlay: ObservableObject, MusicPlayerProtocol {

    static let shared = SongPlay()
    typealias MusicItemType = Song
    @Published var track: MusicItemType?
    @Published var trackList: MusicItemCollection<MusicItemType>?
    @Published var isPlaying: Bool = false
    var playbackStateObserver: AnyCancellable?
    var isPlaybackQueueInitialized: Bool = false
    var playbackQueueInitializationItemID: MusicItemID?
    var trackListCount: Int?
}

class TrackPlay: ObservableObject, MusicPlayerProtocol {
 
    static let shared = TrackPlay()
    typealias MusicItemType = Track
    @Published var track: MusicItemType?
    @Published var trackList: MusicItemCollection<MusicItemType>?
    @Published var isPlaying: Bool = false
    var playbackStateObserver: AnyCancellable?
    var isPlaybackQueueInitialized: Bool = false
    var playbackQueueInitializationItemID: MusicItemID?
    var trackListCount: Int?
}
