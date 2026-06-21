//
//  StickySection.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 21.06.2026.
//

import SwiftUI

struct StickySectionPreview: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .pink], startPoint: .top, endPoint: .bottom)
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    StickySection {
                        HStack(spacing: 10) {
                            Image(systemName: "cloud.fill")
                            
                            Text("Scattered light rain from 10 pm to 12 pm.")
                        }
                        .padding(.vertical, 10)
                    } header: {
                        HStack {
                            Text("Highlights")
                                .fontWeight(.semibold)
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "exclamationmark.bubble.fill")
                                .font(.callout)
                        }
                    } minimisedHeader: {
                        HStack(spacing: 6) {
                            Image(systemName: "text.menu")
                            Text("HIGHLIGHTS")
                            
                            Spacer(minLength: 0)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    
                }
            }
        }
        .safeAreaPadding(15)
    }
}

struct StickySection<Content: View, Header: View, MinimisedHeader: View>: View {    var config: Config = .init()
    var spacing: CGFloat = 10
    @ViewBuilder var content: Content
    @ViewBuilder var header: Header
    @ViewBuilder var minimisedHeader: MinimisedHeader
    
    @State private var headerSize: CGSize = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            header
                .visualEffect { content, proxy in
                    let rect = proxy.frame(in: .named("SECTION"))
                    let minY = max(rect.minY - config.sectionPadding, 0)
                    let progress = max(min(minY / config.headerFadeDistance, 1), 0)
                    
                    return content
                        .opacity(1 - progress)
                }
                .background {
                    minimisedHeader
                        .frame(maxHeight: .infinity)
                        .offset(y: config.minimisedHeaderOffset / 2)
                        .visualEffect { content, proxy in
                            let rect = proxy.frame(in: .named("SECTION"))
                            let minY = max(rect.minY - config.sectionPadding - config.headerFadeDistance, 0)
                            let progress = max(min(minY / config.headerFadeDistance, 1), 0)
                            
                            return content
                                .opacity(progress)
                        }
                }
                .padding([.horizontal, .top], config.sectionPadding)
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { newValue in
                    headerSize = newValue
                }

            
            content
                .visualEffect { content, proxy in
                    let rect = proxy.frame(in: .named("SECTION"))
                    let scrollMinY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                    let minY = max(rect.minY - scrollMinY, 0)
                    
                    return content
                        .offset(y: minY)
                }
                .padding([.horizontal, .bottom], config.sectionPadding)
        }
        .mask {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named("SECTION"))
                let viewHeight = proxy.size.height
                let headerHeight = headerSize.height + config.sectionPadding + config.minimisedHeaderOffset
                let bottomPadding = min(max(rect.minY, 0), viewHeight - headerHeight)
                
                RoundedRectangle(cornerRadius: config.cornerRadius)
                    .padding(.bottom, bottomPadding)
            }
        }
        .background {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named("SECTION"))
                let viewHeight = proxy.size.height
                let headerHeight = headerSize.height + config.sectionPadding + config.minimisedHeaderOffset
                let bottomPadding = min(max(rect.minY, 0), viewHeight - headerHeight)
                
                Group {
                    if config.isGlassBackground {
                        Rectangle()
                            .fill(.clear)
                            .glassEffect(.clear, in: .rect(cornerRadius: config.cornerRadius))
                    } else {
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .fill(config.background)
                    }
                }
                .padding(.bottom, bottomPadding)
            }
        }
        .compositingGroup()
        .visualEffect { [headerSize] content, proxy in
            let rect = proxy.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            let headerHeight = headerSize.height + config.sectionPadding + config.minimisedHeaderOffset
            let cutoffHeight = proxy.size.height - headerHeight
            let distance = abs(min(cutoffHeight + minY, 0))
            let progress = max(min(distance / config.fadeDistance, 1), 0)
            let scale = 1 - (progress * config.fadeScale)
            let opacity = 1 - progress
            
            return content
                .scaleEffect(scale, anchor: .top)
                .opacity(opacity)
                .offset(y: minY < 0 ? -minY : 0)
        }
        .coordinateSpace(.named("SECTION"))
    }
    
    struct Config {
        var sectionPadding: CGFloat = 15
        var cornerRadius: CGFloat = 20
        var background: AnyShapeStyle = .init(.fill.tertiary)
        var isGlassBackground: Bool = true
        
        var minimisedHeaderOffset: CGFloat = -10
        var headerFadeDistance: CGFloat = 15
        var fadeDistance: CGFloat = 45
        var fadeScale: CGFloat = 0.05
    }
}

#Preview {
    StickySectionPreview()
}
