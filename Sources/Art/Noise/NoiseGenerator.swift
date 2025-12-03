import Foundation

/// A protocol for generating noise values at specific coordinates.
public protocol NoiseGenerator: Sendable {
    /**
     Samples the noise function at the given 2D coordinates.
     - Returns: A noise value, typically in the range [-1, 1] or [0, 1] depending on implementation.
     */
    func sample(x: Double, y: Double) -> Double

    /**
     Samples the noise function at the given 3D coordinates.
     - Returns: A noise value, typically in the range [-1, 1] or [0, 1] depending on implementation.
     */
    func sample(x: Double, y: Double, z: Double) -> Double
}

extension NoiseGenerator {
    /// Convenience method to sample at a 2D point.
    public func sample(at point: Point2D) -> Double {
        sample(x: point.x, y: point.y)
    }

    /// Convenience method to sample at a 3D point.
    public func sample(at point: Point3D) -> Double {
        sample(x: point.x, y: point.y, z: point.z)
    }

    /// Maps the noise value from its typical range to [0, 1].
    public func normalized(x: Double, y: Double) -> Double {
        (sample(x: x, y: y) + 1.0) * 0.5
    }

    /// Maps the noise value from its typical range to [0, 1].
    public func normalized(x: Double, y: Double, z: Double) -> Double {
        (sample(x: x, y: y, z: z) + 1.0) * 0.5
    }

    /// Maps the noise value to a custom range.
    public func mapped(x: Double, y: Double, to range: ClosedRange<Double>) -> Double {
        let value = normalized(x: x, y: y)
        return range.lowerBound + value * (range.upperBound - range.lowerBound)
    }

    /// Maps the noise value to a custom range.
    public func mapped(x: Double, y: Double, z: Double, to range: ClosedRange<Double>) -> Double {
        let value = normalized(x: x, y: y, z: z)
        return range.lowerBound + value * (range.upperBound - range.lowerBound)
    }
}
