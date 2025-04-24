//
//  PlaylistGenView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//
import SwiftUI

struct PlaylistGenView: View {
    let accessToken: String
    let uris: [String]
    let onFinished: () -> Void

    @State private var playlistName: String = ""
    @State private var isCreating = false
    @State private var statusMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Playlist")
                .font(.title2)
                .fontWeight(.semibold)

            TextField("Playlist name", text: $playlistName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Generate Playlist") {
                Task {
                    await generatePlaylist()
                }
            }
            .disabled(playlistName.isEmpty || uris.isEmpty || isCreating)
            .frame(maxWidth: .infinity)
            .padding()
            .background(playlistName.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

            if let status = statusMessage {
                Text(status)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }

            Spacer()
        }
        .padding()
    }

    func generatePlaylist() async {
        guard !playlistName.isEmpty else { return }
        isCreating = true

        if let userID = await PlaylistBuilder.fetchUserID(token: accessToken),
           let playlistID = await PlaylistBuilder.createPlaylist(token: accessToken, userID: userID, name: playlistName) {
            
            let success = await PlaylistBuilder.addTracks(token: accessToken, playlistID: playlistID, uris: uris)
            if success {
                statusMessage = "Playlist created!"
                onFinished()
            } else {
                statusMessage = "Could not add tracks."
            }
        } else {
            statusMessage = "Didn't create playlist."
        }

        isCreating = false
    }
}

#Preview {
    PlaylistGenView(
        accessToken: "mock_token",
        uris: [
            "spotify:track:mock1",
            "spotify:track:mock2",
            "spotify:track:mock3"
        ],
        onFinished: {
            print("Preview finished")
        }
    )
}

