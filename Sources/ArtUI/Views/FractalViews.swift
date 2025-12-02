import SwiftUI
import Art

/// A SwiftUI view that renders the Mandelbrot set.
public struct MandelbrotView: View {
    private let mandelbrot: Mandelbrot
    private let bounds: MandelbrotBounds
    private let gradient: Art.Gradient

    /// Bounds for the complex plane to render.
    public struct MandelbrotBounds: Sendable {
        public let minReal: Double
        public let maxReal: Double
        public let minImaginary: Double
        public let maxImaginary: Double

        public init(
            minReal: Double = -2.5,
            maxReal: Double = 1.0,
            minImaginary: Double = -1.5,
            maxImaginary: Double = 1.5
        ) {
            self.minReal = minReal
            self.maxReal = maxReal
            self.minImaginary = minImaginary
            self.maxImaginary = maxImaginary
        }

        /// Default bounds showing the full Mandelbrot set.
        public static let `default` = MandelbrotBounds()

        /// Zoomed view of the seahorse valley.
        public static let seahorseValley = MandelbrotBounds(
            minReal: -0.8,
            maxReal: -0.7,
            minImaginary: 0.05,
            maxImaginary: 0.15
        )
    }

    /// Creates a Mandelbrot view.
    /// - Parameters:
    ///   - mandelbrot: The Mandelbrot generator to use.
    ///   - bounds: The complex plane bounds to render.
    ///   - gradient: The color gradient for coloring escape times.
    public init(
        mandelbrot: Mandelbrot = Mandelbrot(),
        bounds: MandelbrotBounds = .default,
        gradient: Art.Gradient = .viridis
    ) {
        self.mandelbrot = mandelbrot
        self.bounds = bounds
        self.gradient = gradient
    }

    public var body: some View {
        Canvas { context, size in
            let width = Int(size.width)
            let height = Int(size.height)

            for y in 0..<height {
                for x in 0..<width {
                    let real = bounds.minReal + (Double(x) / Double(width)) * (bounds.maxReal - bounds.minReal)
                    let imag = bounds.minImaginary + (Double(y) / Double(height)) * (bounds.maxImaginary - bounds.minImaginary)

                    let sample = mandelbrot.sample(real: real, imaginary: imag)
                    let color: Art.RGBColor

                    if sample.escaped {
                        let t = sample.smoothValue / Double(mandelbrot.maxIterations)
                        color = gradient.sample(at: t)
                    } else {
                        color = .black
                    }

                    let rect = CGRect(x: x, y: y, width: 1, height: 1)
                    context.fill(Path(rect), with: .color(color.swiftUIColor))
                }
            }
        }
    }
}

/// A SwiftUI view that renders a Julia set.
public struct JuliaSetView: View {
    private let juliaSet: JuliaSet
    private let bounds: JuliaBounds
    private let gradient: Art.Gradient

    /// Bounds for the complex plane to render.
    public struct JuliaBounds: Sendable {
        public let minReal: Double
        public let maxReal: Double
        public let minImaginary: Double
        public let maxImaginary: Double

        public init(
            minReal: Double = -2.0,
            maxReal: Double = 2.0,
            minImaginary: Double = -2.0,
            maxImaginary: Double = 2.0
        ) {
            self.minReal = minReal
            self.maxReal = maxReal
            self.minImaginary = minImaginary
            self.maxImaginary = maxImaginary
        }

        public static let `default` = JuliaBounds()
    }

    /// Creates a Julia set view.
    public init(
        juliaSet: JuliaSet,
        bounds: JuliaBounds = .default,
        gradient: Art.Gradient = .plasma
    ) {
        self.juliaSet = juliaSet
        self.bounds = bounds
        self.gradient = gradient
    }

    public var body: some View {
        Canvas { context, size in
            let width = Int(size.width)
            let height = Int(size.height)

            for y in 0..<height {
                for x in 0..<width {
                    let real = bounds.minReal + (Double(x) / Double(width)) * (bounds.maxReal - bounds.minReal)
                    let imag = bounds.minImaginary + (Double(y) / Double(height)) * (bounds.maxImaginary - bounds.minImaginary)

                    let sample = juliaSet.sample(real: real, imaginary: imag)
                    let color: Art.RGBColor

                    if sample.escaped {
                        let t = sample.smoothValue / Double(juliaSet.maxIterations)
                        color = gradient.sample(at: t)
                    } else {
                        color = .black
                    }

                    let rect = CGRect(x: x, y: y, width: 1, height: 1)
                    context.fill(Path(rect), with: .color(color.swiftUIColor))
                }
            }
        }
    }
}

/// A SwiftUI view that renders a Sierpinski triangle.
public struct SierpinskiView: View {
    private let depth: Int
    private let fillColor: Color
    private let strokeColor: Color?

    /// Creates a Sierpinski view.
    public init(
        depth: Int = 5,
        fillColor: Color = .white,
        strokeColor: Color? = nil
    ) {
        self.depth = depth
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }

    public var body: some View {
        Canvas { context, size in
            let triangles = Sierpinski.subdivision(depth: depth)

            // Scale triangles to fit the view
            let scale = min(size.width, size.height * 2 / sqrt(3))
            let offsetX = (size.width - scale) / 2
            let offsetY = size.height - (scale * sqrt(3) / 2)

            for triangle in triangles {
                guard triangle.vertices.count == 3 else { continue }

                var path = Path()
                let v0 = triangle.vertices[0]
                let v1 = triangle.vertices[1]
                let v2 = triangle.vertices[2]

                path.move(to: CGPoint(
                    x: v0.x * scale + offsetX,
                    y: size.height - v0.y * scale - offsetY
                ))
                path.addLine(to: CGPoint(
                    x: v1.x * scale + offsetX,
                    y: size.height - v1.y * scale - offsetY
                ))
                path.addLine(to: CGPoint(
                    x: v2.x * scale + offsetX,
                    y: size.height - v2.y * scale - offsetY
                ))
                path.closeSubpath()

                context.fill(path, with: .color(fillColor))

                if let stroke = strokeColor {
                    context.stroke(path, with: .color(stroke), lineWidth: 1)
                }
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct FractalViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MandelbrotView()
                .frame(width: 200, height: 200)

            SierpinskiView(depth: 4, fillColor: .blue)
                .frame(width: 200, height: 200)
        }
    }
}
#endif
