//
//  MusicItemCell.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct MusicItemCell: View {
    
    let artwork: Artwork?
    let artworkSize: CGFloat
    let artworkCornerRadius: CGFloat
    let title: String
    let subtitle: String
    let subtitleVerticalOffset: CGFloat
    
    private static let defaultArtworkSize = 40.0
    private static let defaultArtworkCornerRadius = 6.0
    
    init(
        artwork: Artwork? = nil,
        artworkSize: CGFloat = Self.defaultArtworkSize,
        artworkCornerRadius: CGFloat = Self.defaultArtworkCornerRadius,
        title: String,
        subtitle: String? = nil,
        subtitleVerticalOffset: CGFloat = 0.0
    ) {
        
        self.artwork = artwork
        self.artworkSize = artworkSize
        self.artworkCornerRadius = artworkCornerRadius
        self.title = title
        self.subtitle = (subtitle ?? "")
        self.subtitleVerticalOffset = subtitleVerticalOffset
    }
    
    var body: some View {
        HStack {
            if let itemArtwork = artwork {
                imageContainer(for: itemArtwork)
                    .frame(width: artworkSize, height: artworkSize)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                }
            }.padding(.leading, 12)

        }
    }
    
    private func imageContainer(for artwork: Artwork) -> some View {
        VStack {
            Spacer()
            ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                .cornerRadius(artworkCornerRadius)
            Spacer()
        }
    }
}
