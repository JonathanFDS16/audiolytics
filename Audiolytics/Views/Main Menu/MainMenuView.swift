//
//  MainMenuView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI
import Foundation

struct MainMenuView: View {
    let accessToken: String
    @State private var username: String = "User"
    @StateObject private var songTracker: SongTrackerModel

    init(accessToken: String, songTracker: SongTrackerModel) {
        self.accessToken = accessToken
        _songTracker = StateObject(wrappedValue: songTracker)
        //Username field broke, will fix later
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

                        HStack(spacing: 16) {
                            NavigationLink(destination: WrappedView()) {
                                CardView(title: "Weekly Wrapped", icon: "calendar")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }

                            VStack(spacing: 16) {
                                NavigationLink(destination: PlaceholderView()) {
                                    CardView(title: "Placeholder", icon: "waveform")
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
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                    .onAppear {
                        Task {
                            await songTracker.fetchNowOrLastPlayed(token: accessToken)
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
