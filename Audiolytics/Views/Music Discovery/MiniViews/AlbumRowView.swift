//
//  AlbumRowView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/23/25.
//

import SwiftUI

struct AlbumRowView: View {
    let album : AlbumObject
    
    var body: some View {
        HStack {
            let imageURL = album.images.first?.url
            let name = album.name
            
            AsyncImage(url: URL(string: imageURL ?? "")!)
            
            Text(name)
                .font(.caption)
        }
    }
}

#Preview {
//    AlbumRowView()
}
