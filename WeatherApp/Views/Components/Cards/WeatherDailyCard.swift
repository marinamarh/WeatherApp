//
//  WeatherDailyCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherDailyCard: View {
    let days: [DailyForecast]
    let fg: Color
    let secondary: Color

    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(icon: "calendar", title: "7-DAY FORECAST", color: secondary)
            Divider().overlay(fg.opacity(0.2))

            VStack(spacing: 0) {
                ForEach(Array(days.enumerated()), id: \.element.id) { idx, day in
                    DailyRow(day: day, fg: fg, secondary: secondary)
                    if idx < days.count - 1 {
                        Divider().overlay(fg.opacity(0.12)).padding(.vertical, 8)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
        .slideIn(appeared: appeared, delay: 0.20)
        .onAppear { appeared = true }
    }
}

private struct DailyRow: View {
    let day: DailyForecast
    let fg: Color
    let secondary: Color

    var body: some View {
        HStack(spacing: 8) {
            Text(day.date, format: .dateTime.weekday(.wide))
                .font(.body.weight(.medium))
                .foregroundStyle(fg)
                .frame(maxWidth: .infinity, alignment: .leading)

            if day.pop > 0.1 {
                Label(String(format: "%d%%", Int(day.pop * 100)), systemImage: "drop.fill")
                    .font(.caption)
                    .foregroundStyle(Color(hex: "90CAF9"))
                    .fixedSize()
            }

            Image(systemName: day.iconCode.weatherSymbolName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 22))
                .frame(width: 30)

            Text("\(Int(day.tempMin))° / \(Int(day.tempMax))°")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(fg)
                .fixedSize()
        }
    }
}

#Preview {
    ZStack {
        Color(hex: "283593").ignoresSafeArea()
        WeatherDailyCard(
            days: ForecastResult.london.daily,
            fg: .white,
            secondary: .white.opacity(0.7)
        )
        .padding()
    }
}
