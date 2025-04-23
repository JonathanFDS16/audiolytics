//
//  SearchView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/22/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchFor = "Song"
    var body: some View {
        VStack {
            VStack {
                Text("Would you like to search for:")
                Picker("Search by", selection: $searchFor) {
                    Text("Artist").tag("Artist")
                    Text("Album").tag("Album")
                    Text("Song").tag("Song")
                }
                TrackFilterView(searchMode: $searchFor) { year, genre, keyword, newAlbum, hipster in
                    print("Console: \(year), \(genre), \(keyword), \(newAlbum), \(hipster)")
                }
                
                // Depending on what is picked we allow for different selections
                // Albums --> artist, year, album, upc, tag:new, tag:hipster
                // Artists --> artist, year, genre,
                // Tracks --> artist, year, album, genre, isrc, track
                
            }
            .padding()
            // Replace with your filtered view content
            Text("Search result for: \(searchText)")
        }
    }
}

#Preview {
    SearchView()
}
