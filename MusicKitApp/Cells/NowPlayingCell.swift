//
//  NowPlayingCell.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

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

struct NowPlayCell: View {

    @ObservedObject private var songPlay = SongPlay.shared
    @ObservedObject private var trackPlay = TrackPlay.shared
    @ObservedObject private var musicType = MusicType.shared
    
    @State private var isExpanded = false
    
    var body: some View {
        if musicType.musicType == MusicTypeEnum.Song {
            if let track = songPlay.track {
                HStack {
                    ArtWorkCell(artWork: track.artwork)
                    titleCell(title: track.title)
                    Spacer()
                    Button(action: {
                        songPlay.isPlaying ? songPlay.playStop() : songPlay.PlayTrack(songPlay.track!)
                    }) {
                        Image(systemName: songPlay.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 22))
                    }
                    .padding(.trailing, 8)
                    Button(action: {
                        songPlay.skipToNextEntry()
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 22))
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
        } else {
            if let track = trackPlay.track {
                HStack {
                    ArtWorkCell(artWork: track.artwork)
                    titleCell(title: track.title)
                    Spacer()
                    Button(action: {
                        trackPlay.isPlaying ? trackPlay.playStop() : trackPlay.PlayTrack(trackPlay.track!)
                    }) {
                        Image(systemName: trackPlay.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 22))
                    }
                    .padding(.trailing, 8)
                    Button(action: {
                        trackPlay.skipToNextEntry()
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 22))
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
    }
}
