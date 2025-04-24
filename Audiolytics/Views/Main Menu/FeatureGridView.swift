//
//  FeatureGridView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//
import SwiftUI

struct FeatureGridView: View {
    let accessToken: String
    let songTracker: SongTrackerModel
    let geo: GeometryProxy

    var body: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: TopView()) {
                CardView(title: "Wrapped", icon: "calendar")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack(spacing: 16) {
                NavigationLink(
                    destination: SavedPlaylistView(accessToken: accessToken)
                ) {
                    CardView(title: "Playlist Generator", icon: "plus.rectangle.on.rectangle")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                NavigationLink(destination: MusicDiscoveryView()) {
                    CardView(title: "Music Discovery", icon: "sparkles")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: geo.size.height * 0.35)
        .padding(.horizontal)
    }
}

#Preview {
    GeometryReader { geo in
        FeatureGridView(
            accessToken: "totallyrealtoken",
            songTracker: SongTrackerModel.mockWithTrack,
            geo: geo
        )
    }
}
