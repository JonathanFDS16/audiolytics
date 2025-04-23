//
//  MainMenuView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI
import Foundation


struct MainMenuView: View {
    @State private var token: String = ""
    let accessToken: String
    @State private var listeningData: [[ListeningData]] = []
    @State private var username: String = "User"
    @State private var nowPlaying: TrackInfo?
    @StateObject private var songTracker = SongTrackerModel()



    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome, \(username)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.leading, 50)
                    
                    if let track = songTracker.nowPlaying {
                        HStack(spacing: 16) {
                            if let url = track.albumArtURL {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            }

                            VStack(alignment: .leading) {
                                Text(track.name)
                                    .font(.headline)
                                Text(track.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                if !track.isPlaying, let playedAt = track.playedAt {
                                    Text("Last played: \(playedAt.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("Now Playing")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                
                    WidgetCard(title: "Weekly Wrapped", icon: "calendar") {
                        WrappedView()
                    }

                    WidgetCard(title: "Listening Habits", icon: "waveform") {
                        ListeningHabitsView(allData: listeningData)
                    }

                    WidgetCard(title: "Music Discovery", icon: "sparkles") {
                        MusicDiscoveryView()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Audiolytics")
            .task {
                    var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me")!)
                    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

                    do {
                        let (data, _) = try await URLSession.shared.data(for: request)
                        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let name = json["display_name"] as? String {
                            username = name
                        }
                    } catch {
                        print("Failed to fetch user profile:", error.localizedDescription)
                    }
                        await songTracker.fetchNowOrLastPlayed(token: accessToken)
                    }

                }
            }
        }

    

#Preview {
    MainMenuView(accessToken: "fakeTokenForTesting")
}

struct WidgetCard<Destination: View>: View {
    var title: String
    var icon: String
    var destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
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

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal)
        }
    }
}

