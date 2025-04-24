//
//  SpotifyItemRow.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/24/25.
//

import SwiftUI

protocol SpotifyDisplayable: Identifiable {
    var displayName: String { get }
    var displayImageURL: URL? { get }
    var id: String { get }
}

extension TrackObject: SpotifyDisplayable {
    var displayName: String { name }
    var displayImageURL: URL? { URL(string: album?.images.first?.url ?? "") }
    var ids : String { id }
}

extension SimplifiedAlbumObject: SpotifyDisplayable {
    var displayName: String { name }
    var displayImageURL: URL? { URL(string: images.first?.url ?? "") }
    var ids : String { id }
}

extension ArtistObject: SpotifyDisplayable {
    var displayName: String { name }
    var displayImageURL: URL? { URL(string: images.first?.url ?? "") }
    var ids : String { id }
}


struct SpotifyItemRow: View {
    let item: any SpotifyDisplayable
        
    var body: some View {
        HStack {
            AsyncImage(url: item.displayImageURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(item.displayName)
                .font(.headline)
        }
    }
}

#Preview {
//    SpotifyItemRow()
}
