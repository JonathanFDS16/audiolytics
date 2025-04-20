//
//  ContentView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showAuth = false
    @State private var authCode: String?

    var body: some View {
        VStack(spacing: 20) {
            if let code = authCode {
                Text("Code: \(code)")
                    .padding()
            }

            Button("Login with Spotify") {
                showAuth = true
            }
        }
        .sheet(isPresented: $showAuth) {
            SpotifyAuthSessionViewController(
                onSuccess: { code in
                    authCode = code
                    showAuth = false
                    exchangeCodeForToken(code: authCode ?? "")
                },
                onCancel: {
                    showAuth = false
                }
            )
        }
    }
}

func exchangeCodeForToken(code: String) {
    guard let verifier = UserDefaults.standard.string(forKey: "code_verifier") else { return }
    guard code != "" else { return }

    var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
    request.httpMethod = "POST"

    let params = [
        "client_id": SpotifyConfig.clientId,
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": SpotifyConfig.redirectUri,
        "code_verifier": verifier
    ]

    request.httpBody = params
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")
        .data(using: .utf8)

    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("Received tokens: \(json)")
            }
        }
    }.resume()
}

#Preview {
    ContentView()
}
