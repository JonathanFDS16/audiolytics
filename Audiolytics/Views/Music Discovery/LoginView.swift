//
//  LoginView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/22/25.
//
import SwiftUI

struct LoginView: View {
    @Binding var showAuth: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.green.opacity(0.8), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Audiolytics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                //Placeholder text, sorry I have 0 creativity
                Text("Stats for Music Lovers")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.headline)

                Button(action: {
                    showAuth = true
                }) {
                    HStack {
                        Image(systemName: "music.note")
                        Text("Continue with Spotify")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    LoginView(showAuth: .constant(false))
}
