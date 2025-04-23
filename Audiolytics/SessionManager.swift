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
}

