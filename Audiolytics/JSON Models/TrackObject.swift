//
//  TrackObject.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/22/25.
//

import Foundation

struct TrackObject: Codable {
    var id: String
    var name: String
    var artist: String
    var album: String
    var duration: Double
    var releaseDate: String
    var explicit: Bool
    var popularity: Int
    var uri: String
    
    // TODO still much missing
}
