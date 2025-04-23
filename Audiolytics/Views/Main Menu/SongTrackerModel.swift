//
//  SongTrackerModel.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//

import Foundation

struct TrackInfo {
    let name: String
    let artist: String
    let albumArtURL: URL?
    let isPlaying: Bool
    let playedAt: Date?
}
    @MainActor
    class SongTrackerModel: ObservableObject {
        @Published var nowPlaying: TrackInfo?
        
        func fetchNowOrLastPlayed(token: String) async {
            let didGetCurrent = await fetchCurrentlyPlaying(token: token)
            if !didGetCurrent {
                _ = await fetchRecentlyPlayed(token: token)
            }
        }
        
        private func fetchCurrentlyPlaying(token: String) async -> Bool {
            var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/player")!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let item = json["item"] as? [String: Any],
                   let name = item["name"] as? String,
                   let artists = item["artists"] as? [[String: Any]],
                   let firstArtist = artists.first?["name"] as? String,
                   let album = item["album"] as? [String: Any],
                   let images = album["images"] as? [[String: Any]],
                   let imageURL = images.first?["url"] as? String {
                    
                    self.nowPlaying = TrackInfo(
                        name: name,
                        artist: firstArtist,
                        albumArtURL: URL(string: imageURL),
                        isPlaying: json["is_playing"] as? Bool ?? false,
                        playedAt: nil
                    )
                    return true
                }
            } catch {
                print("Failed to fetch currently playing: \(error.localizedDescription)")
            }
            return false
        }
        
        private func fetchRecentlyPlayed(token: String) async -> Bool {
            var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/player/recently-played?limit=1")!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    guard let items = json["items"] as? [[String: Any]], !items.isEmpty else {
                        print("No recently played items found.")
                        return false
                    }

                    let first = items[0]

                    guard let playedAtStr = first["played_at"] as? String,
                          let track = first["track"] as? [String: Any],
                          let name = track["name"] as? String,
                          let artists = track["artists"] as? [[String: Any]],
                          let firstArtist = artists.first?["name"] as? String,
                          let album = track["album"] as? [String: Any],
                          let images = album["images"] as? [[String: Any]],
                          let imageURL = images.first?["url"] as? String else {
                        print("Failed to extract track info from recently played response.")
                        return false
                    }

                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    let playedAt = formatter.date(from: playedAtStr)

                    self.nowPlaying = TrackInfo(
                        name: name,
                        artist: firstArtist,
                        albumArtURL: URL(string: imageURL),
                        isPlaying: false,
                        playedAt: playedAt
                    )
                    return true
                }
            } catch {
                print("Failed to fetch recently played: \(error.localizedDescription)")
            }
            return false
        }

        
        func fetchUsername(token: String) async -> String? {
            var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me")!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let displayName = json["display_name"] as? String {
                    return displayName
                }
            } catch {
                print("Failed to fetch username: \(error.localizedDescription)")
            }
            return nil
        }
    }



