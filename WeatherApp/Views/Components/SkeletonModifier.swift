//
//  SkeletonModifier.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 17.06.2026.
//

import SwiftUI

extension View {
    func skeleton(isRedacted: Bool) -> some View {
        self.modifier(SkeletonModifier(isRedacted: isRedacted))
    }
}

struct SkeletonModifier: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    @State private var isAnimating: Bool = false

    var isRedacted: Bool

    func body(content: Content) -> some View {
        content
            .redacted(reason: isRedacted ? .placeholder : [])
            .overlay {
                if isRedacted {
                    GeometryReader { proxy in
                        let size = proxy.size
                        let skeletonWidth = size.width / 2
                        let blurRadius = max(skeletonWidth / 2, 30)
                        let blurDiameter = blurRadius * 2
                        let minX = -(skeletonWidth + blurDiameter)
                        let maxX = size.width + skeletonWidth + blurDiameter

                        Rectangle()
                            .fill(scheme == .dark ? Color.white : Color.black)
                            .frame(width: skeletonWidth, height: size.height * 2)
                            .frame(height: size.height)
                            .blur(radius: blurRadius)
                            .rotationEffect(.degrees(5))
                            .offset(x: isAnimating ? maxX : minX)
                    }
                    .mask {
                        content.redacted(reason: .placeholder)
                    }
                    .blendMode(.softLight)
                    .task {
                        guard !isAnimating else { return }
                        withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                            isAnimating = true
                        }
                    }
                    .onDisappear {
                        isAnimating = false
                    }
                    .transaction {
                        if $0.animation != .easeOut(duration: 1.5).repeatForever(autoreverses: false) {
                            $0.animation = .none
                        }
                    }
                }
            }
    }
}
