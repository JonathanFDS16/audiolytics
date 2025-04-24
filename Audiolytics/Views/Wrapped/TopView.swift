//
//  TopView.swift
//  Audiolytics
//
//  Created by Hannah on 4/23/25.
//
import SwiftUI
import Charts
import Foundation

struct InfoCard: View {
    let title: String
    let content: AnyView
    let gradient: LinearGradient // Accept gradient as a parameter
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(gradient) // Use the passed gradient for the card's background
            .shadow(radius: 5, x: 5, y: 5)
            .frame(width: UIScreen.main.bounds.width - 100, height: 500)
            .overlay(
                VStack {
                    Text(title)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 20)
                        .frame(alignment: .top)
                    
                    Spacer()
                    
                    content // This will be the content (tracks, artists, genres)
                    
                    Spacer()
                }
                .padding()
              
            )
    }
}

struct TopView: View {
    @State private var topArtists: [Artist] = []
    @State private var topTracks: [Track] = []
    @State private var uriList: [String] = []
    @State private var genreList: [String] = []
    @State private var popularityList: [Int] = []
    @State private var timeFrame: String = "short_term"
    @State private var limit: Int = 10
    @State private var obscureScore: Int = 0
    
    func fetchTopTracks() {
        SpotifyService().getTopTracks(timeRange: timeFrame, limitNum: limit) { tracks in
            DispatchQueue.main.async {
                self.topTracks = tracks
                self.uriList = tracks.map { $0.uri }
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
                genreList = artists.compactMap { $0.genres }.flatMap { $0 }
                print(genreList)
                self.popularityList = artists.map { $0.popularity }
                print(popularityList)
                let popSum = popularityList.reduce(0, +)
                let length = popularityList.count
                let avgPop = Double(popSum)/Double(length)
                let obscurityScore = (Int)(100.0 - avgPop)
                obscureScore = obscurityScore
            }
        }
    }
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Select data range:")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, -7)
                Picker("Time Range", selection: $timeFrame) {
                    Text("1 Month").tag("short_term")
                    Text("6 Months").tag("medium_term")
                    Text("1 Year").tag("long_term")
                }
                .pickerStyle(.segmented)
                .onChange(of: timeFrame) {
                    fetchTopTracks()
                    fetchTopArtists()
                    fetchGenres()
                }
                .padding()
                
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 7) {
                        InfoCard(
                            title: "Top Songs",
                            content: AnyView(
                                VStack(alignment: .leading) {
                                    if topTracks.isEmpty {
                                        Text("Loading songs...")
                                    }
                                    else {
                                        ForEach(Array(topTracks.prefix(10).enumerated()), id: \.element.id) { index, track in
                                            Text("\(index + 1). \(track.name) – \(track.artists.map { $0.name }.joined(separator: ", "))")
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            ),
                            gradient: LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .topLeading, endPoint: .bottomTrailing) // Gradient
                            
                            
                        )
                        .padding(.vertical)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                                .scaleEffect(phase.isIdentity ? 1 : 0.80)
                        }
                        
                        InfoCard(
                            title: "Top Artists",
                            content: AnyView(
                                VStack(alignment: .leading) {
                                    if topArtists.isEmpty {
                                        Text("Loading artists...")
                                    } else {
                                        ForEach(Array(topArtists.prefix(10).enumerated()), id: \.element.id) { index, artist in
                                            Text("\(index + 1). \(artist.name)")
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        }
                                    }
                                }
                            ),
                            gradient: LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing) // Gradient
                            
                        )
                        .padding(.vertical)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                                .scaleEffect(phase.isIdentity ? 1 : 0.80)
                        }
                        
                        InfoCard(
                            title: "Top Genres",
                            content: AnyView(
                                VStack(alignment: .leading) {
                                    if genreList.isEmpty {
                                        Text("Loading genres...")
                                    }
                                    else {
                                        
                                        let genreCounts = Dictionary(grouping: genreList, by: { $0 })
                                            .mapValues { $0.count }
                                        
                                        Chart {
                                            ForEach(genreCounts.sorted(by: { $0.value > $1.value }), id: \.key) { genre, count in
                                                SectorMark(
                                                    angle: .value("Count", count)
                                                )
                                                .foregroundStyle(by: .value("Genre", genre))
                                            }
                                        }
                                    }
                                }
                            ),
                            
                            gradient: LinearGradient(gradient: Gradient(colors: [.yellow, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            
                        )
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                                .scaleEffect(phase.isIdentity ? 1 : 0.80)
                        }
                        
                        InfoCard(title: "My Wrapped",
                                 content: AnyView(
                                    VStack() {
                                        
                                        // Top Tracks Section
                                        VStack() {
                                            Text("Top Tracks")
                                                .font(.title2)
                                                .bold()
                                            
                                            ForEach(Array(topTracks.prefix(5).enumerated()), id: \.element.id) { index, track in
                                                Text("\(index + 1). \(track.name) – \(track.artists.map { $0.name }.joined(separator: ", "))")
                                                    .font(.headline)
                                            }
                                        }
                                        .padding()
                                        // Top Artists Section
                                        VStack() {
                                            Text("Top Artists")
                                                .font(.title2)
                                                .bold()
                                            
                                            ForEach(Array(topArtists.prefix(5).enumerated()), id: \.element.id) { index, artist in
                                                Text("\(index + 1). \(artist.name)")
                                                    .font(.headline)
                                                
                                            }
                                        }
                                    
                                    .padding()
                                        VStack(){
                                            Spacer()
                                            Text("Obscurity Score: \(obscureScore)")
                                        }
                                        }
                                   
                                 ),
                                 gradient: LinearGradient(gradient: Gradient(colors: [.blue, .purple, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)).scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                                .scaleEffect(phase.isIdentity ? 1 : 0.80)
                        }
                        
                    }
                    
                    .padding(.horizontal)
                    .padding(.horizontal, (UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.8) / 2)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    
                }
                
                .onAppear {
                    fetchTopTracks()
                    fetchTopArtists()
                    fetchGenres()
                }
                
            }
        
        }
        NavigationLink(destination: {
         
            if let accessToken = UserDefaults.standard.string(forKey: "access_token") {
                return PlaylistGenView(
                    accessToken: accessToken,
                    uris: uriList,
                    onFinished: {
                        print("success yippee")
                    }
                )
            } else {
                return PlaylistGenView(
                    accessToken: "",
                    uris: [String](),
                    onFinished: {
                       print("not success sad")
                    }
                )
            }
        }()) {
            Text("Create Playlist")
                .bold()
                .foregroundColor(.black)
                .font(.title2)
        }
        
    }
}
    
    #Preview {
        TopView()
    }
    
    

