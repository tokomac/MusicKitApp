//
//  MusicKitAuthorizationModel.swift
//  MusicKitApp
//
//  Created by tokomac
//

import Combine
import MusicKit
import SwiftUI

class MusicKitAuthorizationModel: ObservableObject {
    
   static let shared = MusicKitAuthorizationModel()
    
    @Published var musicKitAuthorizationStatus: MusicAuthorization.Status = .notDetermined
    @Environment(\.openURL) private var openURL

    private var musicAuthorizationStatusObserver: AnyCancellable?
    
    func requestMusicAuthorization() async {
        switch musicKitAuthorizationStatus {
            case .notDetermined:
                Task {
                    let musicAuthorizationStatus = await MusicAuthorization.request()
                    await update(with: musicAuthorizationStatus)
                }
            case .denied:
                if let settingsURL = await URL(string: UIApplication.openSettingsURLString) {
                    openURL(settingsURL)
                }
            default:
                fatalError("No button should be displayed for current authorization status: \(musicKitAuthorizationStatus).")
        }
    }
    
    @MainActor
    private func update(with musicAuthorizationStatus: MusicAuthorization.Status) {
        self.musicKitAuthorizationStatus = musicAuthorizationStatus
    }
}

