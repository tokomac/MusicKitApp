//
//  NowPlayingCell.swift
//  MusicKitApp
//
//  Created by tokomac
//

import Combine
import MusicKit
import SwiftUI

struct NowPlayingCell: View {

    @ObservedObject var musicType = MusicType.shared

    var body: some View {
        switch musicType.musicType {
        case .Song, .Track:
            NowPlayingDefaultCell(musicType: musicType)
        case .none:
            EmptyView()
        }
    }
}

private struct NowPlayingDefaultCell: View {

    @ObservedObject var musicType: MusicType
    @State private var isExpanded = false

    var body: some View {
        HStack {
            switch musicType.musicType {
            case .Song:
                NowPlaySongCell(music: SongPlay.shared)
            case .Track:
                NowPlayTrackCell(music: TrackPlay.shared)
            case .none:
                EmptyView()
            }
        }
        .frame(height: 42)
        .accentColor(.black)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            isExpanded = true
        }
    }
}

private struct ArtWorkCell: View {
    
    let artWork: Artwork?
    
    private let artworkSize: CGFloat = 40
    private let artworkCornerRadius: CGFloat = 6.0
    private let secondaryGray: Color = .init(white: 0.85)
    
    var body: some View {
        if let art = artWork {
            imageContainer(for: art)
                .frame(width: artworkSize, height: artworkSize)
        }
    }
    
    private func imageContainer(for artwork: Artwork) -> some View {
        VStack {
            Spacer()
            ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                .cornerRadius(artworkCornerRadius)
                .padding(.leading, 23)
            Spacer()
        }
    }
}

private struct titleCell: View {
    
    let title: String?
    
    var body: some View {
        if let title = title {
            Text(title)
                .lineLimit(1)
                .padding(.leading, 23)
        }
    }
}

private struct playButtonImage: View {
    
    let isPlaying: Bool
    
    var body: some View {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            .font(.system(size: 22))
    }
}

private struct skipButtonImage: View {
    
    var body: some View {
        Image(systemName: "forward.fill")
            .font(.system(size: 22))
    }
}

private struct NowPlaySongCell: View {

    @ObservedObject var music: SongPlay

    var body: some View {
        if let track = music.track {
            ArtWorkCell(artWork: track.artwork)
            titleCell(title: track.title)
            Spacer()
            Button(action: {
                music.isPlaying ? music.playStop() : music.PlayTrack(track)
            }) {
                playButtonImage(isPlaying: music.isPlaying)
            }
            .padding(.trailing, 8)
            Button(action: {
                music.skipToNextEntry()
            }) {
                skipButtonImage()
            }
        }
    }
}

private struct NowPlayTrackCell: View {

    @ObservedObject var music: TrackPlay
    
    var body: some View {
        if let track = music.track {
            ArtWorkCell(artWork: track.artwork)
            titleCell(title: track.title)
            Spacer()
            Button(action: {
                music.isPlaying ? music.playStop() : music.PlayTrack(track)
            }) {
                playButtonImage(isPlaying: music.isPlaying)
            }
            .padding(.trailing, 8)
            Button(action: {
                music.skipToNextEntry()
            }) {
                skipButtonImage()
            }
        }
    }
}
