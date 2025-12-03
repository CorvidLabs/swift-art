import SwiftUI
import Art

/// A SwiftUI view that renders noise from any NoiseGenerator.
public struct NoiseView<Generator: NoiseGenerator>: View {
    private let generator: Generator
    private let scale: Double
    private let gradient: Art.Gradient

    /**
     Creates a noise view.
     - Parameters:
       - generator: The noise generator to use.
       - scale: The scale factor for sampling (smaller = more zoomed in).
       - gradient: The color gradient to map noise values to.
     */
    public init(
        generator: Generator,
        scale: Double = 0.02,
        gradient: Art.Gradient = .grayscale
    ) {
        self.generator = generator
        self.scale = scale
        self.gradient = gradient
    }

    public var body: some View {
        Canvas { context, size in
            let width = Int(size.width)
            let height = Int(size.height)

            for y in 0..<height {
                for x in 0..<width {
                    let noiseValue = generator.normalized(
                        x: Double(x) * scale,
                        y: Double(y) * scale
                    )
                    let color: Art.RGBColor = gradient.sample(at: noiseValue)

                    let rect = CGRect(x: x, y: y, width: 1, height: 1)
                    context.fill(Path(rect), with: .color(color.swiftUIColor))
                }
            }
        }
    }
}

/// An animated noise view that evolves over time using the z-axis.
public struct AnimatedNoiseView<Generator: NoiseGenerator>: View {
    private let generator: Generator
    private let scale: Double
    private let timeScale: Double
    private let gradient: Art.Gradient

    /**
     Creates an animated noise view.
     - Parameters:
       - generator: The noise generator to use.
       - scale: The spatial scale factor.
       - timeScale: The temporal scale factor (speed of animation).
       - gradient: The color gradient to map noise values to.
     */
    public init(
        generator: Generator,
        scale: Double = 0.02,
        timeScale: Double = 0.5,
        gradient: Art.Gradient = .grayscale
    ) {
        self.generator = generator
        self.scale = scale
        self.timeScale = timeScale
        self.gradient = gradient
    }

    public var body: some View {
        TimelineView(.animation) { (timeline: TimelineViewDefaultContext) in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate * timeScale
                let width = Int(size.width)
                let height = Int(size.height)

                for y in 0..<height {
                    for x in 0..<width {
                        let noiseValue = generator.normalized(
                            x: Double(x) * scale,
                            y: Double(y) * scale,
                            z: time
                        )
                        let color: Art.RGBColor = gradient.sample(at: noiseValue)

                        let rect = CGRect(x: x, y: y, width: 1, height: 1)
                        context.fill(Path(rect), with: .color(color.swiftUIColor))
                    }
                }
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct NoiseView_Previews: PreviewProvider {
    static var previews: some View {
        NoiseView(generator: PerlinNoise(seed: 42), gradient: .viridis)
            .frame(width: 200, height: 200)
    }
}
#endif
