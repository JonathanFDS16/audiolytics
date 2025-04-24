//
//  DiscoveryListView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/23/25.
//
//
//import SwiftUI
//
//struct SpotifyListView: View {
//    @Binding var items: [any SpotifyDisplayable]
//    
//    var body: some View {
//        List {
//            ForEach(items, id: \.ids) { track in
//                HStack {
//                    AsyncImage(url: track.displayImageURL) { image in
//                        image.resizable()
//                        
//                    } placeholder: {
//                        ProgressView()
//                    }
//                        .frame(width: 50, height: 50)
//                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
//                    Text(track.name)
//                }
//            }
//        }
//        .listStyle(.plain)
//    }
//}
//
//#Preview {
////    SpotifyListView(items: [])
//}
