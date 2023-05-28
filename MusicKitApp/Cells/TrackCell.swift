//
//  TrackCell.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

protocol TrackCellTypeProtocol {
    associatedtype MusicItemType: MusicItem
    var track: MusicItemType? { get }
    var trackList: MusicItemCollection<MusicItemType>? { get }
}

struct SongCell: View, TrackCellTypeProtocol {

    typealias MusicItemType = Song

    let track: MusicItemType?
    let trackList: MusicItemCollection<MusicItemType>?

    private static let minimumHeight: CGFloat? = 50

    let parentCollectionID: MusicItemID?
    let parentCollectionArtistName: String?
    let shouldDisplayArtwork: Bool

    private var subtitle: String {
        var subtitle = ""
        if track?.artistName != parentCollectionArtistName {
            subtitle = track!.artistName
        }
        return subtitle
    }

    var body: some View {
        Button(action: { SongPlay.shared.play(track!, in: trackList, with: parentCollectionID) }) {
            MusicItemCell(
                artwork: track?.artwork,
                title: track!.title,
                subtitle: subtitle
            )
            .frame(minHeight: Self.minimumHeight)
        }
    }

    init(_ song: MusicItemType, _ b: MusicItemCollection<MusicItemType>) {
        self.track = song
        self.trackList = b
        self.parentCollectionID = nil
        self.parentCollectionArtistName = nil
        self.shouldDisplayArtwork = true
    }
}

struct TrackCell: View, TrackCellTypeProtocol {

    typealias MusicItemType = Track

    let track: MusicItemType?
    let trackList: MusicItemCollection<MusicItemType>?

    private static let minimumHeight: CGFloat? = 50

    let parentCollectionID: MusicItemID?
    let parentCollectionArtistName: String?
    let shouldDisplayArtwork: Bool

    private var subtitle: String {
        var subtitle = ""
        if track?.artistName != parentCollectionArtistName {
            subtitle = track!.artistName
        }
        return subtitle
    }

    var body: some View {
        Button(action: { TrackPlay.shared.play(track!, in: trackList, with: parentCollectionID) }) {
            MusicItemCell(
                artwork: track?.artwork,
                title: track!.title,
                subtitle: subtitle
            )
            .frame(minHeight: Self.minimumHeight)
        }
    }

    init(_ track: MusicItemType, from playlist: Playlist) {
        self.track = track
        self.trackList = playlist.tracks
        self.parentCollectionID = playlist.id
        self.parentCollectionArtistName = playlist.curatorName
        self.shouldDisplayArtwork = true
    }

    init(_ track: MusicItemType, from album: Album) {
        self.track = track
        self.trackList = album.tracks
        self.parentCollectionID = album.id
        self.parentCollectionArtistName = album.artistName
        self.shouldDisplayArtwork = false
    }

    init(_ track: MusicItemType) {
        self.track = track
        self.trackList = nil
        self.parentCollectionID = nil
        self.parentCollectionArtistName = nil
        self.shouldDisplayArtwork = true
    }
}
