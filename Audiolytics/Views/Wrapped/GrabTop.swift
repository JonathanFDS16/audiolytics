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
struct TopArtistsResponse: Codable {
    let items: [Artist]
}

struct Track: Codable, Identifiable {
    let name: String
    let artists: [Artist]
    let id = UUID()
}

struct Artist: Codable, Identifiable {
    let name: String
    let id = UUID()
}

struct DetailedArtist: Codable, Identifiable {
    let name: String
    let popularity: Int
    let genres: [String]
    let id = UUID()
}


struct Album: Codable {
    let name: String
}

struct Genre: Identifiable{
    var name : String
    var id = UUID()
}


class SpotifyService {
    private var accessToken: String? {
        UserDefaults.standard.string(forKey: "access_token")
    }
    
    func getTopTracks(timeRange: String, limitNum: Int, completion: @escaping ([Track]) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            print("No access token available")
            completion([])
            return
        }
        guard let url = URL(string: "https://api.spotify.com/v1/me/top/tracks?time_range=\(timeRange)&limit=\(limitNum)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        print("Token: \(token)")
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
                /*
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🔵 Raw JSON response:\n\(jsonString)")
                }
*/
                let decoded = try JSONDecoder().decode(TopTracksResponse.self, from: data)
                completion(decoded.items)
            } catch {
                print("Decoding failed: \(error)")
                completion([])
            }
        }.resume()
    }
    
    func getTopArtists(timeRange: String, limitNum: Int, completion: @escaping ([Artist]) -> Void) {
       guard let token = UserDefaults.standard.string(forKey: "access_token") else {
           print("No access token available")
           completion([])
           return
       }
       
        guard let url = URL(string: "https://api.spotify.com/v1/me/top/artists?time_range=\(timeRange)&limit=\(limitNum)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
       request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
       request.httpMethod = "GET"
       
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               print("Error fetching artists: \(error.localizedDescription)")
               completion([])
               return
           }
           
           guard let data = data else {
               print("No data returned")
               completion([])
               return
           }
           do {
              /* if let jsonString = String(data: data, encoding: .utf8) {
                   print(" Raw JSON response:\n\(jsonString)")
               }
*/
               let decoded = try JSONDecoder().decode(TopArtistsResponse.self, from: data)
               let artists = decoded.items.map { artist in
                              Artist(
                                  name: artist.name
                              )
                          }
               completion(decoded.items)
           } catch {
               print("Decoding failed: \(error)")
               completion([])
           }
       }.resume()
   }

}
