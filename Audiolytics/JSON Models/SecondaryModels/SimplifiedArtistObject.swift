//
//  SimplifiedArtistObject.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/23/25.
//

import Foundation

struct SimplifiedArtistObject: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}
