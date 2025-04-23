//
//  GrabTop.swift
//  Audiolytics
//
//  Created by Hannah on 4/23/25.
//
import Foundation
import SwiftUI

struct TopTracksResponse: Codable {
    let items: [Track]
}

struct Track: Codable {
    let name: String
    let artists: [Artist]
    let album: Album
}

struct Artist: Codable {
    let name: String
}

struct Album: Codable {
    let name: String
}


class SpotifyService {
    private var accessToken: String? {
        UserDefaults.standard.string(forKey: "access_token")
    }
    
    func getTopTracksRaw() {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            print("No access token available")
            return
        }

        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/tracks?limit=10")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("🔥 RAW JSON RESPONSE:\n\(jsonString)")
            } else {
                print("Could not convert data to string")
            }
        }.resume()
    }

    
     func getTopTracks(completion: @escaping ([Track]) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            print("No access token available")
            completion([])
            return
        }
        
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/tracks?limit=10")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching tracks: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion([])
                return
            }
            do {
                let decoded = try JSONDecoder().decode(TopTracksResponse.self, from: data)
                completion(decoded.items)
            } catch {
                print("Decoding failed: \(error)")
                completion([])
            }
        }.resume()
    }
}
