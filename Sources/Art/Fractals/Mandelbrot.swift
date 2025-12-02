import Foundation

/// The Mandelbrot set fractal generator.
public struct Mandelbrot: Sendable {
    public let maxIterations: Int

    public init(maxIterations: Int = 100) {
        self.maxIterations = maxIterations
    }

    /// A sample from the Mandelbrot set.
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

    /// Samples the Mandelbrot set at the given complex coordinate.
    public func sample(real: Double, imaginary: Double) -> Sample {
        var zReal = 0.0
        var zImag = 0.0
        var iteration = 0

        while iteration < maxIterations {
            let zRealSquared = zReal * zReal
            let zImagSquared = zImag * zImag

            if zRealSquared + zImagSquared > 4.0 {
                let smoothValue = Double(iteration) + 1.0 - log2(log2(zRealSquared + zImagSquared))
                return Sample(iterations: iteration, escaped: true, smoothValue: smoothValue)
            }

            let newZReal = zRealSquared - zImagSquared + real
            let newZImag = 2.0 * zReal * zImag + imaginary

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

    /// Checks if a point is in the Mandelbrot set.
    public func contains(real: Double, imaginary: Double) -> Bool {
        !sample(real: real, imaginary: imaginary).escaped
    }

    /// Returns a normalized iteration count [0, 1] for coloring.
    public func normalizedIterations(real: Double, imaginary: Double) -> Double {
        let sample = sample(real: real, imaginary: imaginary)
        return sample.smoothValue / Double(maxIterations)
    }

    /// Generates the boundary of the Mandelbrot set using edge detection.
    public func isBoundary(real: Double, imaginary: Double, delta: Double = 0.001) -> Bool {
        let center = contains(real: real, imaginary: imaginary)
        let neighbors = [
            contains(real: real + delta, imaginary: imaginary),
            contains(real: real - delta, imaginary: imaginary),
            contains(real: real, imaginary: imaginary + delta),
            contains(real: real, imaginary: imaginary - delta)
        ]
        return neighbors.contains { $0 != center }
    }
}
