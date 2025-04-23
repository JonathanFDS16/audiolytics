//
//  TopView.swift
//  Audiolytics
//
//  Created by Hannah on 4/23/25.
//
import SwiftUI

struct TopView: View {
    @StateObject private var authManager = AuthMan()
    @State private var topArtists: [Artist] = []
    @State private var topTracks: [Track] = []
    
    var body: some View {
        VStack(spacing: 16) {
            Button("Login with Spotify") {
                authManager.authenticate()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            
            Button("Get Top Tracks") {
                SpotifyService().getTopTracks { tracks in
                    for track in tracks {
                        print("🎵 \(track.name) by \(track.artists.map { $0.name }.joined(separator: ", "))")
                    }
                }
            }
            Button("Get Raw Top Tracks") {
                SpotifyService().getTopTracksRaw()
            }

            .padding()
        }
    }
}
#Preview {
    TopView()
}

