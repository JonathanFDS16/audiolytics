//
//  ListeningHistoryView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//
import SwiftUI

struct ListeningHistoryView: View {
    let showHistory: Bool
    let recentTracks: [TrackInfo]
    let toggleAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    toggleAction()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showHistory ? 180 : 0))
                        .animation(.easeInOut(duration: 0.25), value: showHistory)

                    ZStack {
                        Text("Expand Recent Listening").opacity(showHistory ? 0 : 1)
                        Text("Hide Recent Listening").opacity(showHistory ? 1 : 0)
                    }
                    .frame(width: 180, alignment: .leading)
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }

            if showHistory {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(recentTracks, id: \.name) { track in
                            HStack {
                                if let url = track.albumArtURL {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                }

                                VStack(alignment: .leading) {
                                    Text(track.name)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                    Text(track.artist)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    if let playedAt = track.playedAt {
                                        Text("Played at \(playedAt.formatted(date: .omitted, time: .shortened))")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }

                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 360)
                .transition(.opacity.combined(with: .slide))
            }
        }
    }
}

#Preview {
    ListeningHistoryView(
        showHistory: true,
        recentTracks: [
            TrackInfo(
                name: "Very Real Song",
                artist: "Very Real Artist",
                albumArtURL: nil,
                isPlaying: false,
                playedAt: Date(),
                uri: "spotify:track:defrealuri"
            )
        ],
        toggleAction: {}
    )
}
