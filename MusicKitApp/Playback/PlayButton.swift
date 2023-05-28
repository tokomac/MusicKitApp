//
//  PlayButton.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct PlayButton: View {
    
    let track: Track
    let trackList: MusicItemCollection<Track>
    
    private var symbolName: String {
        return (musicPlayerModel.isPlaying ? "pause.fill" : "play.fill")
    }

    private var title: LocalizedStringKey {
        return (musicPlayerModel.isPlaying ? pauseButtonTitle : playButtonTitle)
    }

    @ObservedObject private var musicPlayerModel = TrackPlay.shared

    private let playButtonTitle: LocalizedStringKey = "Play"
    private let pauseButtonTitle: LocalizedStringKey = "Pause"

    init(_ track: Track, _ trackList: MusicItemCollection<Track>) {
        self.track = track
        self.trackList = trackList
    }

    // MARK: - View

    var body: some View {
        Button(action: { musicPlayerModel.play(track, in: trackList, with: track.id) }) {
            HStack {
                Image(systemName: (musicPlayerModel.isPlaying ? "pause.fill" : "play.fill"))
                    .foregroundColor(.white)
                Text((musicPlayerModel.isPlaying ? pauseButtonTitle : playButtonTitle))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 200)
        }
        .buttonStyle(.playStyle)
        .animation(.easeInOut(duration: 0.1), value: musicPlayerModel.isPlaying)
    }
}
