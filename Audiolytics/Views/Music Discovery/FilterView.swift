//
//  FilterView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/23/25.
//

import SwiftUI

struct TrackFilterView: View {
    @Binding var searchMode : String
    @State private var selectedGenre = "Hip-Hop"
    @State private var yearRange: String = ""
    @State private var keyword = ""
    
    @State private var showNewAlbumExplanation = false
    @State private var showHipsterModeExplanation = false
    @State private var newAlbums = false
    @State private var hipster = false
    
    // completion with Year, Genre, Keyword, NewAlbum, Hipster
    var completion : (String, String, String, Bool, Bool) -> Void

    let genres = ["Hip-Hop", "Pop", "Rock", "Jazz", "Electronic", "Classical"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            if searchMode != "album" {
                // Genre Picker
                HStack(alignment: .center) {
                    Text("Genre")
                    Picker("Genre", selection: $selectedGenre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }

            // Year Range Slider
            HStack(alignment: .center) {
                Text("Year or Year Range")
                TextField("e.g 2020 or 1950-2025", text: $yearRange)
            }
            
            if searchMode != "artist" {
                // Keyword Input
                HStack (alignment: .center) {
                    Text("Keyword")
                    TextField("e.g. love, party, heartbreak", text: $keyword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .clipShape(Capsule())
                }
            }
            
            if searchMode == "album" {
                Toggle(isOn: $newAlbums) {
                    HStack {
                        Text("New Albums Only")
                        Image(systemName: "questionmark.circle")
                            .onTapGesture {
                                showNewAlbumExplanation = true
                            }
                            .alert("New Albums Only", isPresented: $showNewAlbumExplanation) {
                                Button ("Ok", role: .cancel) {
                                    showNewAlbumExplanation = false
                                }
                            } message: {
                                Text("Only shows albums released in the last two weeks")
                            }
                    }
                }
                Toggle(isOn: $hipster) {
                    HStack {
                        Text("Hipster Mode")
                        Image(systemName: "questionmark.circle")
                            .onTapGesture {
                                showHipsterModeExplanation = true
                            }
                            .alert("Hipster Mode", isPresented: $showHipsterModeExplanation) {
                                Button ("Ok", role: .cancel) {
                                    showHipsterModeExplanation = false
                                }
                            } message: {
                                Text("Only shows unpopular albums")
                            }
                    }
                }
            }


            // Submit Button
            Button(action: {
                completion(yearRange, selectedGenre, keyword, false, false)
                yearRange = ""//TODO fix this
                
            }) {
                Text("Search")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    @State @Previewable var searchMode: String = "Artist"
    TrackFilterView(searchMode: $searchMode) { _, _ ,_, _, _ in }
}
