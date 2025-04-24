//
//  SavedPlaylistView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//

import SwiftUI

struct SavedPlaylistView: View {
    let accessToken: String
    @State private var playlists: [SpotifyPlaylist] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading playlists...")
                } else if playlists.isEmpty {
                    Text("You haven’t generated any playlists yet.")
                        .foregroundColor(.gray)
                } else {
                    List(playlists) { playlist in
                        HStack {
                            if let url = playlist.imageURL {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            Text(playlist.name)
                        }
                    }
                }
            }
            .navigationTitle("Saved Playlists")
            .task {
                await loadSavedPlaylists()
            }
        }
    }

    func loadSavedPlaylists() async {
        guard let url = URL(string: "https://api.spotify.com/v1/me/playlists?limit=50") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(PlaylistResponse.self, from: data)
            let savedIDs = Set(PlaylistBuilder.getSavedPlaylistIDs())
            playlists = decoded.items.filter { savedIDs.contains($0.id) }
        } catch {
            errorMessage = "Failed to load playlists: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

#Preview {
    let mockPlaylists = [
        SpotifyPlaylist(
            id: "1",
            name: "Audiolytics: Tester",
            images: [SpotifyImage(url: URL(string: "https://via.placeholder.com/111")!)]
        ),
        SpotifyPlaylist(
            id: "2",
            name: "Audiolytics: Aaa",
            images: [SpotifyImage(url: URL(string: "https://via.placeholder.com/999")!)]
        )
    ]

    return NavigationStack {
        List(mockPlaylists) { playlist in
            HStack {
                if let url = playlist.imageURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Text(playlist.name)
            }
        }
        .navigationTitle("Saved Playlists")
    }
}
