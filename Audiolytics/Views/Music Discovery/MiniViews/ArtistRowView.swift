//
//  ArtistRowView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/23/25.
//

import SwiftUI

struct ArtistRowView: View {
    let artist : ArtistObject
    
    var body: some View {
        HStack {
            let imageURL = artist.images.first?.url
            let name = artist.name
            
            AsyncImage(url: URL(string: imageURL ?? "")!)
            
            Text(name)
                .font(.caption)
        }
    }
}

#Preview {
//    ArtistRowView()
}
