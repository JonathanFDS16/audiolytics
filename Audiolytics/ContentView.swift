//
//  ContentView.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/6/25.
//

import SwiftUI

struct ContentView: View {
<<<<<<< Updated upstream
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
=======
    @State private var showAuth = false
    @State private var authCode: String?
    @State private var isLoggedIn = false
    @State private var accessToken: String?

    var body: some View {
            if isLoggedIn, let token = accessToken {
                  MainMenuView(accessToken: token)
                /* Text("Code: \(code)")
                    .padding()
                 */
            }
        else {
               VStack(spacing: 20) {
                   Button("Login with Spotify") {
                       showAuth = true
                   }
            }
        
               .sheet(isPresented: $showAuth) {
                   SpotifyAuthSessionViewController(
                    onSuccess: { code in
                        authCode = code
                        showAuth = false
                        //  exchangeCodeForToken(code: authCode ?? "")
                        exchangeCodeForToken(code: authCode ?? "") { token in
                            accessToken = token
                            isLoggedIn = true
                        }
                    },
                    onCancel: {
                        showAuth = false
                    }
                   )
               }
>>>>>>> Stashed changes
        }
        .padding()
    }
}

<<<<<<< Updated upstream
=======
func exchangeCodeForToken(code: String, onComplete: @escaping (String) -> Void) {
    guard let verifier = UserDefaults.standard.string(forKey: "code_verifier") else { return }
   // guard code != "" else { return }

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
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("Received tokens: \(json)")
                if let accessToken = json["access_token"] as? String {
                    DispatchQueue.main.async {
                        onComplete(accessToken)
                    }
                }
            }
        }
    }.resume()
}

>>>>>>> Stashed changes
#Preview {
    ContentView()
}
