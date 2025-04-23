//
//  SessionManager.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import Foundation

class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var isLoggedIn = false
    var accessToken: String?
    
//    func querySearch(query: String) async throws -> [TrackObject] {
//        let url = URL(string: "https://api.spotify.com/v1/search?q=\(query)&type=track&limit=50")!
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
//        return nil as! [TrackObject]
//    }
}

