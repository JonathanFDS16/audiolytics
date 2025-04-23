//
//  MainMenuView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI

struct MainMenuView: View {
    //@State private var listeningData: [[ListeningData]] = []
    @State private var token: String = ""
    let accessToken: String
    @State private var listeningData: [[ListeningData]] = MockListeningData.weekly

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                NavigationLink("Weekly Wrapped", destination: WrappedView())
                NavigationLink("Listening Habits", destination: ListeningHabitsView(allData: listeningData))
                NavigationLink("Music Discovery", destination: MusicDiscoveryView())
                
/* WIP Data retrieval
                if !listeningData.isEmpty {
                    NavigationLink("Listening Habits", destination: ListeningHabitsView(allData: listeningData))
                } else {
                           
                                }
                }
        */
            }
            .navigationTitle("Audiolytics")
        }
    }
}

#Preview {
    NavigationStack {
        MainMenuView(accessToken: "fakeTokenforTesting")
    }
}
