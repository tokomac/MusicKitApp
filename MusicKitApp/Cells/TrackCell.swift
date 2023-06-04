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
    var parentCollectionID: MusicItemID? { get }
    var parentCollectionArtistName: String? { get }
    var shouldDisplayArtwork: Bool { get }
}

private func subTitle(artistName: String?, parentCollectionArtistName: String?) -> String {
    var subtitle = ""
    if let artistName = artistName {
        if artistName != parentCollectionArtistName {
            subtitle = artistName
        }
    }
    return subtitle
}

private struct MusicItemCellView: View {
    
    let artwork: Artwork?
    let title: String?
    let subtitle: String?
    let minimumHeight: CGFloat? = 50
    
    var body: some View {
        MusicItemCell(
            artwork: artwork,
            title: title!,
            subtitle: subtitle
        )
        .frame(minHeight: minimumHeight)
    }
}

struct SongCell: View, TrackCellTypeProtocol {

    typealias MusicItemType = Song

    let track: MusicItemType?
    let trackList: MusicItemCollection<MusicItemType>?
    let parentCollectionID: MusicItemID?
    let parentCollectionArtistName: String?
    let shouldDisplayArtwork: Bool

    var body: some View {
        Button(action: { SongPlay.shared.play(track!, in: trackList, with: parentCollectionID) }) {
            MusicItemCellView(artwork: track?.artwork,
                              title: track!.title,
                              subtitle: subTitle(artistName: track?.artistName, parentCollectionArtistName: self.parentCollectionArtistName))
        }
    }

    init(_ song: MusicItemType, _ trackList: MusicItemCollection<MusicItemType>) {
        self.track = song
        self.trackList = trackList
        self.parentCollectionID = nil
        self.parentCollectionArtistName = nil
        self.shouldDisplayArtwork = true
    }
}

struct TrackCell: View, TrackCellTypeProtocol {

    typealias MusicItemType = Track

    let track: MusicItemType?
    let trackList: MusicItemCollection<MusicItemType>?
    let parentCollectionID: MusicItemID?
    let parentCollectionArtistName: String?
    let shouldDisplayArtwork: Bool

    var body: some View {
        Button(action: { TrackPlay.shared.play(track!, in: trackList, with: parentCollectionID) }) {
            MusicItemCellView(artwork: track?.artwork,
                              title: track!.title,
                              subtitle: subTitle(artistName: track?.artistName, parentCollectionArtistName: self.parentCollectionArtistName))
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
