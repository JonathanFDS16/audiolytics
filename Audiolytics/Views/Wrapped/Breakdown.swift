//
//  Breakdown.swift
//  Audiolytics
//
//  Created by Hannah on 4/23/25.
//
import SwiftUI
import Charts

struct Breakdown: View {
   
 
    
    
    
    let genres = ["Pop", "Rock", "Hip Hop", "EDM", "Classical"]
    
    var body: some View {
      
        Chart {
            ForEach(genres, id: \.self) { genre in
                SectorMark(
                    angle: .value("Value", 1), // All equal slices
                    innerRadius: .ratio(0.45)
                )
                .foregroundStyle(by: .value("Genre", genre))
            }
        }
        
        .frame(height: 350)
        .padding()
    }
}
#Preview{
    Breakdown()
}
