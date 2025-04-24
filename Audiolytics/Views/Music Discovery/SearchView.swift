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
    @State private var tracks: [TrackObject] = []
    @State private var albums: [SimplifiedAlbumObject] = []
    @State private var artists: [ArtistObject] = []
    @State private var showResults = false
    
    var body: some View {
        VStack {
            if !showResults {
                VStack {
                    Text("What would you like to search for:")
                        .font(.headline)
                        .padding()
                    Picker("Search by", selection: $searchFor) {
                        Text("Artist").tag("artist")
                        Text("Album").tag("album")
                        Text("Song").tag("track")
                    }
                    .pickerStyle(.segmented)
                    .animation(.easeInOut, value: searchFor)
                    
                    TrackFilterView(searchMode: $searchFor) { year, genre, keyword, newAlbum, hipster in
                        let params = SpotifySearchParams(type: searchFor, year: year, genre: genre, keyword: keyword, tag: newAlbum ? "new" : hipster ? "hipster" : nil)
                        
                        let accessToken = UserDefaults.standard.string(forKey: "access_token") ?? ""
                        
                        searchSpotifyItems(with: params, accessToken: accessToken) { result in
                            
                            switch result {
                            case .success(let data):
                                DispatchQueue.main.async {
                                    do {
                                        switch searchFor {
                                        case "album":
                                            let decoded = try JSONDecoder().decode(AlbumSearchResponse.self, from: data)
                                            self.albums = decoded.albums.items
                                        case "track":
                                            let decoded = try JSONDecoder().decode(TrackSearchResponse.self, from: data)
                                            self.tracks = decoded.tracks.items
                                        case "artist":
                                            let decoded = try JSONDecoder().decode(ArtistsSearchResponse.self, from: data)
                                            self.artists = decoded.artists.items
                                        default:
                                            break
                                        }
                                        withAnimation {
                                            self.showResults = true
                                        }
                                    } catch {
                                        print("❌ Decode error: \(error)")
                                    }
                                }
                            case .failure(let error):
                                print("❌ Search failed: \(error.localizedDescription)")
                                
                            }
                        }
                    }
                }
                .padding()
            }
            
            if showResults {
                Text("What we got for you")
                    .font(.headline)
                if searchFor == "track" {
                    List {
                        ForEach(tracks, id: \.id) { track in
                            HStack {
                                AsyncImage(url: track.displayImageURL) { image in
                                    image.resizable()
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                Text(track.name)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else if searchFor == "album" {
                    List {
                        ForEach(albums, id: \.id) { track in
                            HStack {
                                AsyncImage(url: track.displayImageURL) { image in
                                    image.resizable()
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                Text(track.name)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    List {
                        ForEach(artists, id: \.id) { track in
                            HStack {
                                AsyncImage(url: track.displayImageURL) { image in
                                    image.resizable()
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                Text(track.name)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                Button("Go back to search") {
                    withAnimation {
                        showResults = false
                    }
                }
                .padding()
            }
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
