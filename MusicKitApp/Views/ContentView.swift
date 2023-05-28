//
//  ContentView.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct MusicAppTabView: View {
    
    @State private var selectedIndex = 0
    
    let selectedHandler: (Int) -> Void
    private let secondaryGray: Color = .init(white: 0.85)
 
    var body: some View {
        VStack(spacing: 0) {
//            NowPlayingCell()
            NowPlayCell()
            Rectangle()
                .fill(secondaryGray)
                .frame(height: 1)
            tabView
                .onChange(of: selectedIndex) { value in
                    selectedHandler(value)
                }
        }
        .background(
            // PlayerTabViewのsizeを測るための.background
            // View自体をGeometryReaderで囲うと広がってしまうため
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: TabSizePreferenceKey.self,
                        value: proxy.size
                    )

            }
        )
        .background(Blur().edgesIgnoringSafeArea(.bottom))
    }
    
    var tabView: some View {
        HStack(spacing: 0) {
            MusicAppTabItem(
                index: 0,
                icon: Image(systemName: "magnifyingglass"),
                title: "Recent",
                selectedIndex: $selectedIndex
            )
            
            Spacer()
            
            MusicAppTabItem(
                index: 1,
                icon: Image(systemName: "music.note.house"),
                title: "Library",
                selectedIndex: $selectedIndex
            )
        }
        .padding(.top, 8)
        .padding(.horizontal, 8)
        .accentColor(.pink)
    }
}

struct MusicAppTabItem: View {
    
    let index: Int
    let icon: Image
    let title: String
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack {
            icon.imageScale(.large)
            Text(title)
                .font(.system(size: 10))
                .fontWeight(.bold)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .foregroundColor(selectedIndex == index ? .pink : .gray)
        .clipShape(Rectangle())
        .onTapGesture {
            selectedIndex = index
        }
    }
}

struct TabSizePreferenceKey: PreferenceKey {

    typealias Value = CGSize
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
