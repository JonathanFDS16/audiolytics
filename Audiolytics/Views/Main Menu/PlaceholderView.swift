//
//  PlaceholderView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//

import SwiftUI

struct PlaceholderView: View {
var body: some View {
       VStack {
           //Placeholder for now
           Text("Placeholder")
       }
       .navigationTitle("Placeholder")
   }
}
#Preview {
   NavigationStack {
       PlaceholderView()
   }
}
