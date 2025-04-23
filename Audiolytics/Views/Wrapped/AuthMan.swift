//
//  AuthMan.swift
//  Audiolytics
//
//  Created by Hannah on 4/23/25.
//

import AuthenticationServices
import SwiftUI

class AuthMan: NSObject, ObservableObject {
    private let clientID = "c5b9203f096a4ba7abcadba5d31def4a"
    private let redirectURI = "audiolytics://callback"
    private let scopes = "user-top-read"

    func authenticate() {
        let authURL = URL(string:
            "https://accounts.spotify.com/authorize?client_id=\(clientID)&response_type=token&redirect_uri=\(redirectURI)&scope=\(scopes)")!

        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: "myapp") { callbackURL, error in
            guard
                error == nil,
                let callbackURL = callbackURL,
                let fragment = callbackURL.fragment,
                let token = fragment.components(separatedBy: "&").first(where: { $0.contains("access_token") })?.split(separator: "=").last
            else {
                print("Authentication failed")
                return
            }

            let accessToken = String(token)
            UserDefaults.standard.set(accessToken, forKey: "access_token")
        }

        session.presentationContextProvider = self
        session.start()
    }
}

extension AuthMan: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
