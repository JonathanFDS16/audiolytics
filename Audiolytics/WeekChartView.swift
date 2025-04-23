//
//  WeekChartView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import SwiftUI
import Charts

struct WeekChartView: View {
    let data: [ListeningData]
    let weekNumber: Int
    @Binding var selectedDay: String?
    @Binding var selectedMinutes: Int?
    @Binding var selectedHourlyData: [HourlyData]
    
    var body: some View {
        VStack {
            Text(formattedWeekRange(from: data))
                .font(.headline)
            
            Chart {
                ForEach(data) { entry in
                    BarMark(
                        x: .value("Day", formattedDay(entry.date)),
                        y: .value("Minutes", entry.minutesListened)
                    )
                    .foregroundStyle(selectedDay == formattedDay(entry.date) ? Color.purple.opacity(1.0) : Color.purple.opacity(0.3))
                    
                    LineMark(
                        x: .value("Day", formattedDay(entry.date)),
                        y: .value("Minutes", entry.minutesListened)
                    )
                    .foregroundStyle(.purple)
                    .symbol(Circle())
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    let location = value.location
                                    if let dayStr: String = proxy.value(atX: location.x),
                                       let match = data.first(where: { formattedDay($0.date) == dayStr }) {
                                        selectedDay = formattedDay(match.date)
                                        selectedMinutes = match.minutesListened
                                        selectedHourlyData = HourlyData.mock(for: match.date)
                                    }
                                }
                        )
                }
            }
            .frame(height: 200)
        }
        .padding()
    }
}

#Preview {
    WeekChartView(
        data: MockListeningData.weekly.first ?? [],
        weekNumber: 1,
        selectedDay: .constant(nil),
        selectedMinutes: .constant(nil),
        selectedHourlyData: .constant([])
    )
}
