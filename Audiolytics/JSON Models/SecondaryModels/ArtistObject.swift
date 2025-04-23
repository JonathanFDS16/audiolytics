//
//  Artists.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/23/25.
//
import Foundation

struct ArtistObject: Codable {
    let externalUrls: ExternalUrls
    let followers: Followers
    let genres: [String]
    let href: String
    let id: String
    let images: [SpotifyImage]
    let name: String
    let popularity: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

struct Followers: Codable {
    let href: String?
    let total: Int
}



