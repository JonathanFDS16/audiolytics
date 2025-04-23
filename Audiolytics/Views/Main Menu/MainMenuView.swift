import Foundation
//
//  MainMenuView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI

struct MainMenuView: View {
    let accessToken: String
    @State private var username: String = "User"
    @StateObject private var songTracker: SongTrackerModel
    @State private var showHistory = false

    init(accessToken: String, songTracker: SongTrackerModel) {
        self.accessToken = accessToken
        _songTracker = StateObject(wrappedValue: songTracker)
        print("Initialized MainMenuView with username: \(username)")
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 24) {
                    Text("Welcome, \(username)")
                        .font(.title)
                        .foregroundColor(.primary)

                    if let track = songTracker.nowPlaying {
                        PlayerView(track: track)
                    }
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showHistory.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees(showHistory ? 180 : 0))
                                .animation(
                                    .easeInOut(duration: 0.25),
                                    value: showHistory)

                            ZStack {
                                Text("Expand Recent Listening")
                                    .opacity(showHistory ? 0 : 1)
                                Text("Hide Recent Listening")
                                    .opacity(showHistory ? 1 : 0)
                            }
                            .frame(width: 180, alignment: .leading)
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }

                    if showHistory {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(songTracker.recentTracks, id: \.name) {
                                    track in
                                    HStack {
                                        if let url = track.albumArtURL {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                            } placeholder: {
                                                Color.gray
                                            }
                                            .frame(width: 40, height: 40)
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 6))
                                        }

                                        VStack(alignment: .leading) {
                                            Text(track.name)
                                                .font(.subheadline)
                                                .lineLimit(1)
                                            Text(track.artist)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            if let playedAt = track.playedAt {
                                                Text(
                                                    "Played at \(playedAt.formatted(date: .omitted, time: .shortened))"
                                                )
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
                        .frame(height: 350)
                        .transition(.opacity.combined(with: .slide))
                        //Considering adjusting transition later
                    }
                    HStack(spacing: 16) {
                        NavigationLink(destination: TopView()) {
                            CardView(title: "Weekly Wrapped", icon: "calendar")
                                .frame(
                                    maxWidth: .infinity, maxHeight: .infinity)
                        }

                        VStack(spacing: 16) {
                            NavigationLink(destination: PlaceholderView()) {
                                CardView(title: "Placeholder", icon: "waveform")
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: .infinity)
                            }

                            NavigationLink(destination: MusicDiscoveryView()) {
                                CardView(
                                    title: "Music Discovery", icon: "sparkles"
                                )
                                .frame(
                                    maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: geo.size.height * 0.35)
                    .padding(.horizontal)
                }
                .frame(
                    width: geo.size.width, height: geo.size.height,
                    alignment: .top
                )
                .onAppear {
                    Task {
                        await songTracker.fetchNowOrLastPlayed(token: accessToken)
                        if let name = await songTracker.fetchUsername(token: accessToken) {
                            username = name
                        }
                        print("recentTracks count:", songTracker.recentTracks.count)
                    }
                }

            }
            .navigationTitle("Audiolytics")
        }
    }
}

struct CardView: View {
    var title: String
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.blue)
                .clipShape(Circle())

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

extension SongTrackerModel {
    static var mockWithTrack: SongTrackerModel {
        let model = SongTrackerModel()
        model.nowPlaying = TrackInfo(
            name: "Mock Song",
            artist: "Mock Artist",
            albumArtURL: URL(string: "https://via.placeholder.com/120"),
            isPlaying: false,
            playedAt: Date()
        )
        return model
    }
}

#Preview {
    MainMenuView(
        accessToken: "fakeTokenForTesting",
        songTracker: SongTrackerModel.mockWithTrack
    )
}
