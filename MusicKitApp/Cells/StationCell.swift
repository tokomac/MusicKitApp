//
//  StationCell.swift
//  MusicKitApp
//
//  Created by tokomac
//

import MusicKit
import SwiftUI

struct StationCell: View {

    // MARK: - Initialization

    init(_ station: Station) {
        self.station = station
    }

    // MARK: - Properties

    let station: Station

    // MARK: - View

    var body: some View {
        VStack {
            let _ = print("Station  \(station.description)")
        }
    }
}
