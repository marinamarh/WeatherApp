//
//  WeatherCardModifier.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

extension View {
    func slideIn(appeared: Bool, delay: Double) -> some View {
        self
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 28)
            .animation(.spring(duration: 0.55, bounce: 0.08).delay(delay), value: appeared)
    }
}

struct CardHeader: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.semibold))
            .tracking(0.5)
            .foregroundStyle(color)
    }
}
