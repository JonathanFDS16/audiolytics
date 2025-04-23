//
//  TopView.swift
//  Audiolytics
//
//  Created by Hannah on 4/23/25.
//
import SwiftUI

struct TopView: View {
    @State private var topArtists: [Artist] = []
    @State private var topTracks: [Track] = []
    @State private var genreList: [String] = []
    @State private var timeFrame: String = "short_term"
    @State private var limit: Int = 5
    
    func fetchTopTracks() {
        SpotifyService().getTopTracks(timeRange: timeFrame, limitNum: limit) { tracks in
            DispatchQueue.main.async {
                self.topTracks = tracks
            }
        }
    }
    
    func fetchTopArtists() {
        SpotifyService().getTopArtists(timeRange: timeFrame, limitNum: limit) { artists in
            DispatchQueue.main.async {
                self.topArtists = artists
            }
        }
    }
    
    func fetchGenres() {
        SpotifyService().getTopArtists(timeRange: timeFrame, limitNum: limit) { artists in
            DispatchQueue.main.async {
                self.topArtists = artists
                let genres = artists.compactMap { $0.genres }.flatMap { $0 }
                           self.genreList = Array(Set(genres)).sorted()
                           print("Genres: \(self.genreList)")
            }
        }
        
        
    }
    

    var body: some View {
        VStack() {
            Text("App")
       
            HStack(){
                
                //do segmented picker instead?
                Button("short"){
                timeFrame = "short_term"
                    fetchTopTracks()
                    fetchTopArtists()
                }
                Button("med")
                {
                timeFrame = "medium_term"
                    fetchTopTracks()
                    fetchTopArtists()
                }
                Button("long"){
                timeFrame = "long_term"
                    fetchTopTracks()
                    fetchTopArtists()
                }
               /*Picker("Number of entries", selection: $limit)
                {
                    ForEach(1...50, id: \.self) { number in
                           Text("\(number)")
                       }
                }
                pickerStyle(.wheel)
                */
                Button("10 entries")
                {
                    limit = 10
                    fetchTopTracks()
                    fetchTopArtists()
                }
              
            }
            
           
            VStack() {
                       Text("Top Tracks")
                           .font(.title)
                           .padding(.bottom)

                       if topTracks.isEmpty {
                           Text("Loading...")
                               .onAppear {
                                   fetchTopTracks()
                               }
                       } else {
                           List(topTracks) { track in
                               VStack(alignment: .leading, spacing: 4) {
                                   Text(track.name)
                                       .font(.headline)
                                   Text(" by " + track.artists.map { $0.name }.joined(separator: ", "))
                               }
                               
                               .padding(.vertical, 4)
                           }
                           .listStyle(.plain)
                       }
                   }
                   .padding()
            
            .frame(height: 350)
            .padding()
        }
        
            VStack(alignment: .leading) {
                       Text("Top Artists")
                           .font(.title)
                           .padding(.bottom)

                       if topArtists.isEmpty {
                           Text("Loading...")
                               .onAppear {
                                   fetchTopArtists()
                               }
                       } else {
                           List(topArtists) { artist in
                               VStack(alignment: .leading, spacing: 4) {
                                   Text(artist.name)
                                       .font(.headline)
                               }
                               .padding(.vertical, 4)
                           }
                           .listStyle(.plain)
                       }
                   }
                   .padding()
            
            .frame(height: 350)
            .padding()
        }
            
        
        }
    

    #Preview {
        TopView()
    }
    

