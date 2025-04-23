//
//  Tracks.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/23/25.
//

import Foundation

struct Tracks : Codable {
    let href : String
    let limit : Int
    let next : String?
    let offset : Int
    let previous : String?
    let total : Int
    let items : [TrackObject]
}
