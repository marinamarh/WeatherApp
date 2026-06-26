//
//  WeatherDailyCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherDailyCard: View {
    let days: [DailyForecast]
    
    @State private var appeared = false
    
    private var globalMin: Double { days.map(\.tempMin).min() ?? 0 }
    private var globalMax: Double { days.map(\.tempMax).max() ?? 0 }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(days.enumerated()), id: \.element.id) { idx, day in
                DailyRow(day: day, globalMin: globalMin, globalMax: globalMax)
                if idx < days.count - 1 {
                    Divider().overlay(.white.opacity(0.12)).padding(.vertical, 8)
                }
            }
        }
        .slideIn(appeared: appeared, delay: 0.20)
        .onAppear { appeared = true }
    }
}

private struct DailyRow: View {
    let day: DailyForecast
    let globalMin: Double
    let globalMax: Double
    
    @State private var barWidth: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 8) {
            Text(day.date, format: .dateTime.weekday(.abbreviated))
                .font(.title3.weight(.medium))
                .foregroundStyle(.white)
                .frame(width: 42, alignment: .leading)
            
            if day.pop > 0.1 {
                VStack(spacing: 2) {
                    Image(systemName: day.iconCode.weatherSymbolName)
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 20))
                    
                    Text("\((day.pop * 100).formatted(.number.precision(.fractionLength(0))))%")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.cyan)
                }
                .frame(width: 30)
            } else {
                Image(systemName: day.iconCode.weatherSymbolName)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 20))
                    .frame(width: 30)
            }
            
            Text("\(Int(day.tempMin))°")
                .font(.title3.weight(.medium))
                .monospacedDigit()
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 36, alignment: .trailing)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.white.opacity(0.15))
                .frame(height: 5)
                .onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.size.width
                } action: { newWidth in
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        barWidth = newWidth
                    }
                }
                .overlay {
                    let range = globalMax - globalMin
                    
                    if range > 0 {
                        let factor = barWidth / range
                        let fillWidth = (day.tempMax - day.tempMin) * factor
                        let offset = (day.tempMin - globalMin) * factor
                        
                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 0.2, green: 0.5, blue: 1.0), location: 0.0),
                                .init(color: Color(red: 0.4, green: 0.8, blue: 1.0), location: 0.2),
                                .init(color: Color(red: 0.6, green: 0.9, blue: 0.4), location: 0.4),
                                .init(color: Color(red: 1.0, green: 0.85, blue: 0.0), location: 0.6),
                                .init(color: Color(red: 1.0, green: 0.5, blue: 0.1), location: 0.8),
                                .init(color: Color(red: 1.0, green: 0.2, blue: 0.1), location: 1.0),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 5)
                        .mask {
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: fillWidth, height: 5)
                                Spacer(minLength: 0)
                            }
                            .offset(x: offset)
                        }
                    }
                }
            
            Text("\(Int(day.tempMax))°")
                .font(.title3.weight(.medium))
                .monospacedDigit()
                .foregroundStyle(.white)
                .frame(width: 36, alignment: .leading)
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        WeatherDailyCard(days: ForecastResult.london.daily)
            .padding()
    }
}
