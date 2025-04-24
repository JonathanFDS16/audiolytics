//
//  TrackRowView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/23/25.
//

import SwiftUI

struct TrackRowView: View {
    let track: TrackObject
    
    var body: some View {
        let imageURL = track.album?.images.first?.url
        let name = track.name
        HStack {
            AsyncImage(url: URL(string: imageURL ?? ""))
            Text(name)
        }
        
    }
}

#Preview {
//    TrackObject(name: "Test", album: nil)
//    TrackRowView()
}
