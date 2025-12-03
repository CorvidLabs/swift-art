import SwiftUI
import Art

/// A SwiftUI view that renders and animates a particle system.
public struct ParticleSystemView: View {
    @State private var system: ParticleSystem
    private let particleColor: Color
    private let particleSize: CGFloat
    private let backgroundColor: Color
    private let showTrails: Bool

    /**
     Creates a particle system view.
     - Parameters:
       - system: The particle system to animate.
       - particleColor: The color for particles.
       - particleSize: The size of each particle.
       - backgroundColor: The background color.
       - showTrails: Whether to show particle trails.
     */
    public init(
        system: ParticleSystem,
        particleColor: Color = .white,
        particleSize: CGFloat = 3.0,
        backgroundColor: Color = .black,
        showTrails: Bool = false
    ) {
        self._system = State(initialValue: system)
        self.particleColor = particleColor
        self.particleSize = particleSize
        self.backgroundColor = backgroundColor
        self.showTrails = showTrails
    }

    public var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                // Fill background (with optional trail effect)
                if showTrails {
                    context.fill(
                        Path(CGRect(origin: .zero, size: size)),
                        with: .color(backgroundColor.opacity(0.1))
                    )
                } else {
                    context.fill(
                        Path(CGRect(origin: .zero, size: size)),
                        with: .color(backgroundColor)
                    )
                }

                // Draw particles
                for particle in system.particles {
                    let opacity = 1.0 - (particle.age / particle.lifetime)
                    let size = particleSize * (1.0 - particle.age / particle.lifetime * 0.5)

                    let rect = CGRect(
                        x: particle.position.x - size / 2,
                        y: particle.position.y - size / 2,
                        width: size,
                        height: size
                    )

                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(particleColor.opacity(opacity))
                    )
                }
            }
            .onAppear {
                // Animation is handled by TimelineView redrawing
            }
            .task {
                // Update system on each frame
                while !Task.isCancelled {
                    system.update(deltaTime: 1.0 / 60.0)
                    try? await Task.sleep(nanoseconds: 16_666_666) // ~60fps
                }
            }
        }
    }
}

/// A static particle system view (renders current state without animation).
public struct ParticleSystemStaticView: View {
    private let system: ParticleSystem
    private let particleColor: Color
    private let particleSize: CGFloat
    private let backgroundColor: Color

    public init(
        system: ParticleSystem,
        particleColor: Color = .white,
        particleSize: CGFloat = 3.0,
        backgroundColor: Color = .black
    ) {
        self.system = system
        self.particleColor = particleColor
        self.particleSize = particleSize
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Canvas { context, size in
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(backgroundColor)
            )

            for particle in system.particles {
                let opacity = 1.0 - (particle.age / particle.lifetime)

                let rect = CGRect(
                    x: particle.position.x - particleSize / 2,
                    y: particle.position.y - particleSize / 2,
                    width: particleSize,
                    height: particleSize
                )

                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(particleColor.opacity(opacity))
                )
            }
        }
    }
}
