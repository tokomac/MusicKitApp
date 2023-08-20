//
//  MusicPlayerModel.swift
//  MusicKitApp
//
//  Created by tokomac
//

import Combine
import MusicKit
import SwiftUI

enum NowPlayingMusicItemEnum {
    case Song
    case Track
}

class NowPlayingMusicItem: ObservableObject {
    
    static let shared = NowPlayingMusicItem()
    @Published var musicItem: NowPlayingMusicItemEnum?
    
    func musicItemSet(_ musicItem: PlayableMusicItem) {
        switch type(of: musicItem) {
        case is Song.Type:
            self.musicItem = .Song
        case is Track.Type:
            self.musicItem = .Track
        default:
            self.musicItem = .none
        }
    }
}

protocol MusicPlayerProtocol: AnyObject {
    associatedtype MusicItemType: PlayableMusicItem
    var track: MusicItemType? { get set }
    var trackList: MusicItemCollection<MusicItemType>? { get set }
    var isPlaying: Bool { get set }
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
        
        NowPlayingMusicItem.shared.musicItemSet(track)
        
        Task {
            do {
                try await musicPlayer.play()
            } catch {
                fatalError("Failed to prepare music player to play \(track).")
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

        NowPlayingMusicItem.shared.musicItemSet(track)
        
        Task {
            do {
                try await musicPlayer.play()
            } catch {
                fatalError("Failed to prepare music player to play \(track).")
            }
        }
    }
    
    func skipToNextEntry() {
        if let track = track, let trackList = trackList {
            let count = trackList.count
            let musicPlayer = self.musicPlayer
            if let index = trackList.firstIndex(where: { $0.id == track.id }) {
                var ix: Int {
                    if (index + 1) >= count { return 0 }
                    return index + 1
                }
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
