//
//  CardView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//
import SwiftUI

struct CardView: View {
    var title: String
    var icon: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 60, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue)
                )

            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}
