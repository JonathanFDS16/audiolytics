//
//  WrappedView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI







struct WrappedView: View {
    
    
    //all placeholders
   private var colorsArr: [Color] = [.red, .green, .yellow, .blue]
    
       var body: some View {
           ScrollView(.horizontal, showsIndicators: true) {
               HStack(spacing: 15) {
                   ForEach(0..<colorsArr.count, id: \.self) { index in
                       RoundedRectangle(cornerRadius: 20)
                           .fill(colorsArr[index])
                           .shadow(radius: 5, x: 5, y: 5)
                           .frame(width: UIScreen.main.bounds.width - 100, height: 400)
                           .scrollTransition { content, phase in
                                                       content
                                                           .opacity(phase.isIdentity ? 1 : 0.5)
                                                           .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
                                                   }
                   }
               }
               .scrollTargetLayout()
           }
           .contentMargins(50, for: .scrollContent)
           .scrollTargetBehavior(.viewAligned)
       }
    
}

#Preview {
    NavigationStack {
        WrappedView()
    }
}
