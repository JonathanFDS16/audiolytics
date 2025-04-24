import Foundation

struct TrackObject: Codable {
    let album: AlbumObject?
    let artists: [SimplifiedArtistObject]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let isPlayable: Bool?
    let linkedFrom: LinkedTrackObject?
    let name: String
    let previewUrl: String?
    let trackNumber: Int
    let type: String
    let uri: String
    let popularity: Int?

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalUrls = "external_urls"
        case href, id
        case isPlayable = "is_playable"
        case linkedFrom = "linked_from"
        case name
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type, uri, popularity
    }
}

struct LinkedTrackObject: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, type, uri
    }
}

