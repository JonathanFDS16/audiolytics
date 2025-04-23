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
            HStack {
                Image(systemName: "sparkle.magnifyingglass")
                TextField("Choose a song...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .cornerRadius(10)
                    .onSubmit {
                        print(searchText)
                        // Search for similar songs
                    }
            }
            .frame(maxWidth: 300)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(Capsule())
            
            VStack {
                Text("Would you like to search for:")
                Picker("Search by", selection: $searchFor) {
                    Text("Artist").tag("Artist")
                    Text("Album").tag("Album")
                    Text("Song").tag("Song")
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
