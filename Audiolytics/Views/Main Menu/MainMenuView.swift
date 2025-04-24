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

                    ListeningHistoryView(
                        showHistory: showHistory,
                        recentTracks: songTracker.recentTracks,
                        toggleAction: { showHistory.toggle() }
                    )

                    FeatureGridView(
                        accessToken: accessToken,
                        songTracker: songTracker,
                        geo: geo
                    )
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .onAppear {
                    Task {
                        await songTracker.fetchNowOrLastPlayed(token: accessToken)
                        if let name = await songTracker.fetchUsername(token: accessToken) {
                            username = name
                        }
                    }
                }
            }
            .navigationTitle("Audiolytics")
        }
    }
}

#Preview {
    MainMenuView(
        accessToken: "mock_token",
        songTracker: SongTrackerModel.mockWithTrack
    )
}
