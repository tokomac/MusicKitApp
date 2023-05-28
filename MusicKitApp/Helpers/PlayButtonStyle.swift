//
//  PlayButtonStyle.swift
//  MusicKitApp
//
//  Created by tokomac
//

import SwiftUI

struct PlayButtonStyle: ButtonStyle {
    
    private var backgroundColor: Color = .purple
    
    private static let backgroundCornerRadius: CGFloat = 8
    private static let paddingEdges: Edge.Set = .all
    private static let paddingLength: CGFloat? = nil
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title3.bold())
            .foregroundColor(.accentColor)
            .padding(Self.paddingEdges, Self.paddingLength)
            .background(backgroundColor.cornerRadius(Self.backgroundCornerRadius))
    }
}

extension ButtonStyle where Self == PlayButtonStyle {
    static var playStyle: PlayButtonStyle {
        PlayButtonStyle()
    }
}

