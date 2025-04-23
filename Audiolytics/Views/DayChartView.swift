//
//  DayChartView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI
import Charts

struct DayChartView: View {
    let day: String
    let hourlyData: [HourlyData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Listening Breakdown for \(day)")
                .font(.headline)
            
            Chart(hourlyData) { hourEntry in
                BarMark(
                    x: .value("Hour", "\(hourEntry.hour):00"),
                    y: .value("Minutes", hourEntry.minutesListened)
                )
                .foregroundStyle(.green.opacity(0.5))
            }
            .frame(height: 150)
        }
        .padding(.top, 10)
        .transition(.slide)
    }
}

#Preview {
    DayChartView(day: "Wed", hourlyData: HourlyData.mock(for: .now))
}
