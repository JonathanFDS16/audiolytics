//
//  MusicDiscoveryView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/22/25.
//
import SwiftUI

struct MusicDiscoveryView: View {
    @State var isAnimating = true //TODO remember to set to true
    @State var isSearching = false
    @State var scaleMagnifyingGlass = 1.0
    var body: some View {
        VStack {
            //Placeholder for now
            if !isSearching {
                VStack {
                    Image(systemName: "sparkle.magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .scaleEffect(scaleMagnifyingGlass)
                        .onAppear {
                            startAnimating()
                        }
                        .onTapGesture {
                            isAnimating = false
                            withAnimation(.spring) {
                                isSearching = true
                            }
                        }
                    Text("Escape the algorithm and explore something different!")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .transition(.opacity)
            }
            else if isSearching {
                SearchView()
                    .transition(.slide)
            }
        }
        .navigationTitle("Music Discovery")
    }
    
    func startAnimating() {
        guard isAnimating else { return }
        withAnimation(.spring(duration: 2.0)) {
            scaleMagnifyingGlass = 1.2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(duration: 2.0)) {
                scaleMagnifyingGlass = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if isAnimating {
                    startAnimating()
                }
            }
        }
    }
}



#Preview {
    NavigationStack {
        MusicDiscoveryView()
    }
}
