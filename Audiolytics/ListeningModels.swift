//
//  ListeningModels.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/21/25.
//
import Foundation

struct ListeningData: Identifiable {
    let id = UUID()
    let date: Date
    let minutesListened: Int
}

struct HourlyData: Identifiable {
    let id = UUID()
    let hour: Int
    let minutesListened: Int

    static func mock(for date: Date) -> [HourlyData] {
        (0..<24).map { hour in
            HourlyData(hour: hour, minutesListened: Int.random(in: 0...15))
        }
    }
}

func formattedWeekRange(from data: [ListeningData]) -> String {
    guard let first = data.first?.date, let last = data.last?.date else {
        return "Week"
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"

    return "\(formatter.string(from: first)) – \(formatter.string(from: last))"
}

func formattedDay(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    return formatter.string(from: date)
}

//Solely for testing out charts without user data
struct MockListeningData {
    static let weekly: [[ListeningData]] = [
        makeWeek(starting: DateComponents(calendar: .current, year: 2025, month: 4, day: 14)),
        makeWeek(starting: DateComponents(calendar: .current, year: 2025, month: 4, day: 21))
    ]

    static func makeWeek(starting startComponents: DateComponents) -> [ListeningData] {
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: startComponents) else { return [] }

        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startDate) else { return nil }
            return ListeningData(date: date, minutesListened: Int.random(in: 30...120))
        }
    }
}

