//
//  SearchView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/22/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchFor = ""
    var body: some View {
        VStack {
            VStack {
                Text("Would you like to search for:")
                Picker("Search by", selection: $searchFor) {
                    Text("Artist").tag("artist")
                    Text("Album").tag("album")
                    Text("Song").tag("track")
                }
                .pickerStyle(.segmented)
                
                TrackFilterView(searchMode: $searchFor) { year, genre, keyword, newAlbum, hipster in
                    let params = SpotifySearchParams(type: searchFor, year: year, genre: genre, keyword: keyword, tag: newAlbum ? "new" : hipster ? "hipster" : nil)
                    
                    let accessToken = UserDefaults.standard.string(forKey: "access_token") ?? ""
                    
                    searchSpotifyItems(with: params, accessToken: accessToken) { result in
                        
                        switch result {
                           case .success(let data):
                               do {
                                   if let jsonString = String(data: data, encoding: .utf8) {
                                              print("✅ JSON String:\n\(jsonString)")
                                    
                                          } else {
                                              print("❌ Failed to convert data to string.")
                                }
                                   // Needs to decode according to what I have searchedFor
                                   if searchFor == "album" {
                                       let decoded = try JSONDecoder().decode(AlmbumsSearchResponse.self, from: data)
                                       print("\(decoded)")
                                       let albums = decoded.albums.items
                                       for album in albums {
                                           print("🎵 \(album.name)")
                                       }
                                   }
                                   else if searchFor == "track" {
                                       let decoded = try JSONDecoder().decode(TrackSearchResponse.self, from: data)
                                       print("\(decoded)")
                                       let tracks = decoded.tracks.items
                                       for track in tracks {
                                           print("🎵 \(track.name)")
                                       }                                   }
                                   else {
                                       let decoded = try JSONDecoder().decode(ArtistsSearchResponse.self, from: data)
                                       print("\(decoded)")
                                       let artists = decoded.artists.items
                                       for artist in artists {
                                           print("🎵 \(artist.name)")
                                       }
                                   }
                                   
                               } catch {
                                   print("❌ Failed to decode: \(error)")
                               }
                           case .failure(let error):
                               print("❌ Search failed: \(error.localizedDescription)")
                            
                        }
                    }
                }
            }
            .padding()
            
            Text("Search result for: \(searchText)")
        }
    }
}

struct SpotifySearchParams {
    let type: String          // "track", "album", or "artist"
    let year: String?         // "2020", "2000-2023"
    let genre: String?        // "pop", "hip-hop"
    let keyword: String?      // "love", "sunset"
    let tag: String?          // "new", "hipster"
}

func searchSpotifyItems(
    with params: SpotifySearchParams,
    accessToken: String,
    completion: @escaping (Result<Data, Error>) -> Void
) {
    var queryItems: [String] = []
    
    if let keyword = params.keyword {
        queryItems.append(keyword)
    }
    if let genre = params.genre {
        queryItems.append("genre:\"\(genre)\"")
    }
    if let year = params.year {
        queryItems.append("year:\(year)")
    }
    if let tag = params.tag {
        queryItems.append("tag:\(tag)")
    }
    
    let query = queryItems.joined(separator: " ")
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
    print("Query: \(query)")
    
    guard let url = URL(string: "https://api.spotify.com/v1/search?q=\(query)&type=\(params.type)&limit=20") else {
        completion(.failure(NSError(domain: "InvalidURL", code: -1)))
        return
    }
    
    print("URL: \(url)")

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "NoData", code: -1)))
            return
        }
        completion(.success(data))
    }.resume()
}

#Preview {
    SearchView()
}
