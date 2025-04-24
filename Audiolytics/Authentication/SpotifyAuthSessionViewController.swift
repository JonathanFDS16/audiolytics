import SwiftUI
import AuthenticationServices
import Security
import CryptoKit

struct SpotifyAuthSessionViewController: UIViewControllerRepresentable {
    let onSuccess: (String) -> Void
    let onCancel: () -> Void
    let clientId = SpotifyConfig.clientId
    let redirectUri = SpotifyConfig.redirectUri

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // Dummy controller, just for presentation
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let scope = "user-read-private user-read-email user-read-playback-state user-read-recently-played user-top-read playlist-modify-private playlist-modify-public"
        
        let verifier = generateRandomString(length: 64)
        let challenge = sha256Base64URL(verifier)
        UserDefaults.standard.set(verifier, forKey: "code_verifier")

        var components = URLComponents(string: "https://accounts.spotify.com/authorize")!
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "code_challenge", value: challenge)
        ]
        
        guard let authURL = components.url else { return }

        let session = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: "audiolytics"
        ) { callbackURL, error in
            if let error = error {
                print("Spotify auth failed:", error.localizedDescription)
                onCancel()
                return
            }

            guard let callbackURL = callbackURL,
                  let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                    .queryItems?.first(where: { $0.name == "code" })?.value else {
                onCancel()
                return
            }

            onSuccess(code)
        }

        session.presentationContextProvider = context.coordinator
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func generateRandomString(length: Int) -> String {
        let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let possibleArray = Array(possible)
        var result = ""

        var randomBytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)

        guard status == errSecSuccess else {
            fatalError("Unable to generate random bytes")
        }

        for byte in randomBytes {
            result.append(possibleArray[Int(byte) % possibleArray.count])
        }

        return result
    }

    func sha256(_ input: String) -> Data {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return Data(hashed)
    }

    func sha256Base64URL(_ input: String) -> String {
        let hash = sha256(input)
        return hash
            .base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    class Coordinator: NSObject, ASWebAuthenticationPresentationContextProviding {
        func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            // Get the first active window scene
            let scene = UIApplication.shared
                .connectedScenes
                .first { $0.activationState == .foregroundActive } as? UIWindowScene

            // Get the key window in that scene
            return scene?
                .windows
                .first { $0.isKeyWindow } ?? ASPresentationAnchor()
        }
    }

}
