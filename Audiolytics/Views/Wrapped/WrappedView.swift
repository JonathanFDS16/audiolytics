//
//  WrappedView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI

/* TOP 5 ARTISTS SHORT-TERM
 https://api.spotify.com/v1/me/top/artists?time_range=short_term&limit=5
 TOP 5 ARTISTS MEDIUM-TERM
 https://api.spotify.com/v1/me/top/artists?time_range=medium_term&limit=5
 TOP 5 ARTISTS LONG-TERM
 https://api.spotify.com/v1/me/top/artists?time_range=long_term&limit=5
 *****
 TOP 5 TRACKS SHORT-TERM
 https://api.spotify.com/v1/me/top/tracks?time_range=short_term&limit=5
 TOP 5 TRACKS MEDIUM-TERM
 https://api.spotify.com/v1/me/top/tracks?time_range=medium_term&limit=5
 TOP 5 TRACKS LONG-TERM
 https://api.spotify.com/v1/me/top/tracks?time_range=long_term&limit=5
 
 */

struct DataTestView: View{
    var body: some View{
        HStack{
            Text("Top artists")
            
        }
    }
}
struct WrappedView: View {
    //all placeholders
    private var colorsArr: [Color] = [.red, .green, .yellow, .blue]
    
       var body: some View {
           ScrollView(.horizontal, showsIndicators: true) {
               HStack(spacing: 15) {
                   ForEach(0..<colorsArr.count, id: \.self) { index in
                       RoundedRectangle(cornerRadius: 20)
                           .fill(colorsArr[index])
                           .shadow(radius: 5, x: 5, y: 5)
                           .frame(width: UIScreen.main.bounds.width - 100, height: 400)
                           .scrollTransition { content, phase in
                                                       content
                                                           .opacity(phase.isIdentity ? 1 : 0.5)
                                                           .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
                                                   }
                   }
               }
               .scrollTargetLayout()
           }
           .contentMargins(50, for: .scrollContent)
           .scrollTargetBehavior(.viewAligned)
       }
}

#Preview {
    NavigationStack {
        DataTestView()
    }
}
