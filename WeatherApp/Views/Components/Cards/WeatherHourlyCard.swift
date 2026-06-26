//
//  WeatherHourlyCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherHourlyCard: View {
    let items: [Forecast]

    @State private var appeared = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(items) { item in
                    HourlyCell(item: item)
                }
            }
            .padding(.horizontal, 4)
        }
        .slideIn(appeared: appeared, delay: 0.10)
        .onAppear { appeared = true }
    }
}

private struct HourlyCell: View {
    let item: Forecast

    var body: some View {
        VStack(spacing: 6) {
            Text(item.date, format: .dateTime.hour())
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)

            Image(systemName: item.iconCode.weatherSymbolName)
                .symbolRenderingMode(.multicolor)
                .frame(width: 34, height: 34)


            if item.pop > 0 {
                Text("\((item.pop * 100).formatted(.number.precision(.fractionLength(0))))%")
                    .font(.caption2)
                    .foregroundStyle(.cyan)
            } else {
                Color.clear.frame(height: 14)
            }
            
            Text("\(Int(item.temperature))°")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
        }
        .frame(width: 58)
        .padding(.vertical, 4)
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        WeatherHourlyCard(items: ForecastResult.london.hourly)
            .padding()
    }
}
