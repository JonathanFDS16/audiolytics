//
//  WrappedView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI

struct WrappedView: View {
    var body: some View {
        VStack {
            //Placeholder for now
            Text("Your Top Artists")
        }
        .navigationTitle("Weekly Wrapped")
    }
}

#Preview {
    NavigationStack {
        WrappedView()
    }
}
