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
                .onAppear {
                           print("PlaylistGenView appeared yay")
                       }

            TextField("Playlist name", text: $playlistName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Generate Playlist") {
                print("Generate button tapped")
                print("Name: \(playlistName)")
                print("URIs: \(uris)")
                print("Creating: \(isCreating)")
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
            
            if playlistName.isEmpty {
                Text("Enter a playlist name").foregroundColor(.red)
            } else if uris.isEmpty {
                Text("No tracks provided").foregroundColor(.red)
            } else if isCreating {
                Text("Creating playlist...").foregroundColor(.gray)
            }


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
        guard !playlistName.isEmpty else {
            statusMessage = "Enter a name first."
            return
        }

        isCreating = true
        statusMessage = "Fetching user ID..."

        print("Using access token: \(accessToken)")

        if let userID = await PlaylistBuilder.fetchUserID(token: accessToken) {
            print("Got userID: \(userID)")
            statusMessage = "Creating playlist..."

            if let playlistID = await PlaylistBuilder.createPlaylist(token: accessToken, userID: userID, name: playlistName) {
                print("Created playlist with ID: \(playlistID)")
                statusMessage = "Adding tracks..."

                let success = await PlaylistBuilder.addTracks(token: accessToken, playlistID: playlistID, uris: uris)
                if success {
                    print("Successfully added tracks.")
                    statusMessage = "Playlist created!"
                    PlaylistBuilder.saveCreatedPlaylistID(playlistID, forUser: userID)
                    onFinished()
                } else {
                    print("Failed to add tracks.")
                    statusMessage = "Could not add tracks."
                }
            } else {
                print("Failed to create playlist.")
                statusMessage = "Couldn't create playlist."
            }
        } else {
            print("Failed to fetch user ID.")
            statusMessage = "Couldn't fetch user ID."
        }

        isCreating = false
    }

}

#Preview {
    PlaylistGenView(
        accessToken: "sometoken",
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

