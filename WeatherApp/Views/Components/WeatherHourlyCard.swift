//
//  WeatherHourlyCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherHourlyCard: View {
    let items: [Forecast]
    let fg: Color
    let secondary: Color

    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(icon: "clock", title: "HOURLY FORECAST", color: secondary)
            Divider().overlay(fg.opacity(0.2))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        HourlyCell(item: item, fg: fg, secondary: secondary)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
        .slideIn(appeared: appeared, delay: 0.10)
        .onAppear { appeared = true }
    }
}

private struct HourlyCell: View {
    let item: Forecast
    let fg: Color
    let secondary: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(item.date, format: .dateTime.hour())
                .font(.caption.weight(.medium))
                .foregroundStyle(secondary)

            Image(systemName: weatherSymbol(for: item.iconCode))
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 26))
                .frame(width: 34, height: 34)

            Text("\(Int(item.temperature))°")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(fg)

            if item.pop > 0.1 {
                Label(String(format: "%d%%", Int(item.pop * 100)), systemImage: "drop.fill")
                    .font(.caption2)
                    .foregroundStyle(Color(hex: "90CAF9"))
            } else {
                Color.clear.frame(height: 14)
            }
        }
        .frame(width: 58)
        .padding(.vertical, 4)
    }
}

#Preview {
    ZStack {
        Color(hex: "1A237E").ignoresSafeArea()
        WeatherHourlyCard(
            items: ForecastResult.london.hourly,
            fg: .white,
            secondary: .white.opacity(0.7)
        )
        .padding()
    }
}
