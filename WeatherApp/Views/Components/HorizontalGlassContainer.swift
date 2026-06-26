//
//  HorizontalGlassContainer.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 24.06.2026.
//

import SwiftUI

struct HorizontalGlassContainerPreview: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        List {
            Section("Preview") {
                ZStack {
                    HorizontalGlassContainer(size: .init(width: 70, height: 55) , progress: progress) {
                        Image(systemName: "suit.heart.fill")
                            .containerValue(\.unionID, "0")
                            .containerValue(\.contentPadding, -7.5)

                        Image(systemName: "square.and.arrow.up.fill")
                            .containerValue(\.contentPadding, -7.5)

                    } label: {
                        ZStack {
                            Image(systemName: "ellipsis")
                                .opacity(1 - progress)
                            
                            Image(systemName: "xmark")
                                .opacity(progress)
                        }
                    }
                    .font(.title3)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .background {
                    Image(.bgClearDay)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .clipShape(.rect(cornerRadius: 25))
            }
            
            Section("Properties") {
                Slider(value: $progress)
                
                Button("Toggle Actions") {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                        progress = progress == 0 ? 1 : 0
                    }
                }
                .buttonStyle(.glassProminent)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct HorizontalGlassContainer<Content: View, Label: View>: View, Animatable {
    var placeAtLeading: Bool = false
    var isInteractive: Bool = true
    var size: CGSize = .init(width: 55, height: 55)
    var progress: CGFloat
    
    @ViewBuilder var content: Content
    @ViewBuilder var label: Label
    
    @State private var labelPosition: CGRect = .zero
    @Namespace private var animation
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    var body: some View {
        GlassEffectContainer(spacing: spacing) {
            HStack(spacing: spacing) {
                if placeAtLeading {
                    LabelView()
                }
                
                ForEach(subviews: content) { subview in
                    let unionID = subview.containerValues.unionID
                    let contentPadding = subview.containerValues.contentPadding
                    let width = size.width + (contentPadding * 2)
                    
                    subview
                        .blur(radius: 15 * scaleProgress)
                        .opacity(progress)
                        .frame(width: width, height: size.height)
                        .glassEffect(.clear.interactive(isInteractive), in: .capsule)
                        .glassEffectUnion(id: unionID, namespace: animation)
                        .allowsHitTesting(progress == 1)
                        .visualEffect { [labelPosition] content, proxy in
                            content
                                .offset(x: offsetX(proxy: proxy, labelPosition: labelPosition))
                        }
                        .fixedSize()
                        .frame(width: width * progress)
                }
                
                if !placeAtLeading {
                    LabelView()
                }
            }
        }
        .coordinateSpace(.named("CONTAINER"))
        
        //Custom as need
        .scaleEffect(
            x: 1 + (scaleProgress * 0.3),
            y: 1 - (scaleProgress * 0.35),
            anchor: .center
        )
    }
    
    @ViewBuilder
    private func LabelView() -> some View {
        label
            .compositingGroup()
            .blur(radius: 15 * scaleProgress)
            .frame(width: size.width, height: size.height)
            .glassEffect(.clear.interactive(isInteractive), in: .capsule)
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .named("CONTAINER"))
            } action: { newValue in
                labelPosition = newValue
            }

    }
    
    nonisolated
    func offsetX(proxy: GeometryProxy, labelPosition: CGRect) -> CGFloat {
        let minX = labelPosition.minX - proxy.frame(in: .named("CONTAINER")).minX
        return minX - (minX * progress)
    }
    
    var spacing: CGFloat {
        10.0 * progress
    }
    
    var scaleProgress: CGFloat {
        return progress > 0.5 ? (1 - progress) / 0.5 : (progress / 0.5)
    }
}

extension ContainerValues {
    @Entry var unionID: String? = nil
    @Entry var contentPadding: CGFloat = 0
}

#Preview {
    HorizontalGlassContainerPreview()
}
