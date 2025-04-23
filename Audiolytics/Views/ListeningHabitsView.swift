//
//  ListeningHabitsView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI

struct ListeningHabitsView: View {
    let allData: [[ListeningData]]

    @State private var selectedDay: String?
    @State private var selectedMinutes: Int?
    @State private var selectedHourlyData: [HourlyData] = []

    var body: some View {
        VStack {
            Text("Listening Habits")
                .font(.title)

            TabView {
                ForEach(allData.indices, id: \.self) { index in
                    WeekChartView(
                        data: allData[index],
                        weekNumber: index + 1,
                        selectedDay: $selectedDay,
                        selectedMinutes: $selectedMinutes,
                        selectedHourlyData: $selectedHourlyData
                    )
                }
            }
            .tabViewStyle(.page)
            .frame(height: 300)

            Divider()

            if let day = selectedDay, !selectedHourlyData.isEmpty {
                DayChartView(day: day, hourlyData: selectedHourlyData)
            }
        }
        .padding()
        .navigationTitle("Listening Habits")
    }
}

#Preview {
    NavigationStack {
        ListeningHabitsView(allData: MockListeningData.weekly)
    }
}
