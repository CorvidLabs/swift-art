import Foundation

/// The Julia set fractal generator.
public struct JuliaSet: Sendable {
    public let cReal: Double
    public let cImaginary: Double
    public let maxIterations: Int

    /// Creates a Julia set with the given complex constant c.
    public init(cReal: Double, cImaginary: Double, maxIterations: Int = 100) {
        self.cReal = cReal
        self.cImaginary = cImaginary
        self.maxIterations = maxIterations
    }

    /// A sample from the Julia set.
    public struct Sample: Sendable {
        /// Number of iterations before escape.
        public let iterations: Int
        /// Whether the point escaped to infinity.
        public let escaped: Bool
        /// Smooth coloring value for anti-aliasing.
        public let smoothValue: Double

        public init(iterations: Int, escaped: Bool, smoothValue: Double) {
            self.iterations = iterations
            self.escaped = escaped
            self.smoothValue = smoothValue
        }
    }

    /// Samples the Julia set at the given complex coordinate.
    public func sample(real: Double, imaginary: Double) -> Sample {
        var zReal = real
        var zImag = imaginary
        var iteration = 0

        while iteration < maxIterations {
            let zRealSquared = zReal * zReal
            let zImagSquared = zImag * zImag

            if zRealSquared + zImagSquared > 4.0 {
                let smoothValue = Double(iteration) + 1.0 - log2(log2(zRealSquared + zImagSquared))
                return Sample(iterations: iteration, escaped: true, smoothValue: smoothValue)
            }

            let newZReal = zRealSquared - zImagSquared + cReal
            let newZImag = 2.0 * zReal * zImag + cImaginary

            zReal = newZReal
            zImag = newZImag
            iteration += 1
        }

        return Sample(iterations: iteration, escaped: false, smoothValue: Double(iteration))
    }

    /// Samples at a Point2D, interpreting x as real and y as imaginary.
    public func sample(at point: Point2D) -> Sample {
        sample(real: point.x, imaginary: point.y)
    }

    /// Checks if a point is in the Julia set.
    public func contains(real: Double, imaginary: Double) -> Bool {
        !sample(real: real, imaginary: imaginary).escaped
    }

    /// Returns a normalized iteration count [0, 1] for coloring.
    public func normalizedIterations(real: Double, imaginary: Double) -> Double {
        let sample = sample(real: real, imaginary: imaginary)
        return sample.smoothValue / Double(maxIterations)
    }
}

// MARK: - Presets

extension JuliaSet {
    /// Classic Julia set with interesting structure.
    public static let classic = JuliaSet(cReal: -0.7, cImaginary: 0.27015)

    /// Dragon-like Julia set.
    public static let dragon = JuliaSet(cReal: -0.8, cImaginary: 0.156)

    /// Dendrite Julia set with branching patterns.
    public static let dendrite = JuliaSet(cReal: 0.0, cImaginary: 1.0)

    /// Spiral Julia set.
    public static let spiral = JuliaSet(cReal: -0.4, cImaginary: 0.6)

    /// Douady rabbit Julia set.
    public static let douadyRabbit = JuliaSet(cReal: -0.123, cImaginary: 0.745)

    /// San Marco Julia set.
    public static let sanMarco = JuliaSet(cReal: -0.75, cImaginary: 0.0)
}
