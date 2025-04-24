import Foundation

struct AlbumObject: Codable {
    let albumType: String
    let artists: [SimplifiedArtistObject]
    let availableMarkets: [String]?
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [SpotifyImage]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let totalTracks: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}


struct ExternalUrls: Codable {
    let spotify: String
}

struct SpotifyImage: Codable {
    let height: Int?
    let url: String
    let width: Int?
}
