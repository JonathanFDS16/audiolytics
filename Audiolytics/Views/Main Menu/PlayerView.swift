//
//  PlayerView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//

import SwiftUI

struct PlayerView: View {
    let track: TrackInfo
    
    init(track: TrackInfo) {
            self.track = track
            print("Track is playing? \(track.isPlaying)")
            print("Track played at: \(String(describing: track.playedAt))")
        }

    var body: some View {
        VStack(spacing: 8) {
            if let url = track.albumArtURL {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Color.gray
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Text(track.name)
                .font(.headline)

            Text(track.artist)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let playedAt = track.playedAt, !track.isPlaying {
                Text("Last played: \(playedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else if track.isPlaying {
                Text("Now Playing")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

#Preview {
    PlayerView(track: TrackInfo(
        name: "Mock Song",
        artist: "Mock Artist",
        albumArtURL: URL(string: "https://via.placeholder.com/120"),
        isPlaying: false,
        playedAt: Date(),
        uri: "spotify:track:mockuri"
    ))
}
