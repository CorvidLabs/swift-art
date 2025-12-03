import Foundation

/// Fractal noise generator that combines multiple octaves of a base noise function.
public struct FractalNoise: NoiseGenerator, Sendable {
    private let baseNoise: any NoiseGenerator
    private let octaves: Int
    private let persistence: Double
    private let lacunarity: Double
    private let scale: Double

    /**
     Creates a fractal noise generator.
     - Parameters:
       - baseNoise: The underlying noise generator to use.
       - octaves: Number of noise layers to combine (default: 4).
       - persistence: How much each octave contributes (default: 0.5).
       - lacunarity: Frequency multiplier for each octave (default: 2.0).
       - scale: Initial scale/frequency (default: 1.0).
     */
    public init(
        baseNoise: any NoiseGenerator,
        octaves: Int = 4,
        persistence: Double = 0.5,
        lacunarity: Double = 2.0,
        scale: Double = 1.0
    ) {
        self.baseNoise = baseNoise
        self.octaves = max(1, octaves)
        self.persistence = persistence
        self.lacunarity = lacunarity
        self.scale = scale
    }

    /// Convenience initializer with Perlin noise as the base.
    public init(
        octaves: Int = 4,
        persistence: Double = 0.5,
        lacunarity: Double = 2.0,
        scale: Double = 1.0,
        seed: UInt64? = nil
    ) {
        self.init(
            baseNoise: PerlinNoise(seed: seed),
            octaves: octaves,
            persistence: persistence,
            lacunarity: lacunarity,
            scale: scale
        )
    }

    public func sample(x: Double, y: Double) -> Double {
        var total = 0.0
        var amplitude = 1.0
        var frequency = scale
        var maxValue = 0.0

        for _ in 0..<octaves {
            total += baseNoise.sample(x: x * frequency, y: y * frequency) * amplitude
            maxValue += amplitude
            amplitude *= persistence
            frequency *= lacunarity
        }

        return total / maxValue
    }

    public func sample(x: Double, y: Double, z: Double) -> Double {
        var total = 0.0
        var amplitude = 1.0
        var frequency = scale
        var maxValue = 0.0

        for _ in 0..<octaves {
            total += baseNoise.sample(x: x * frequency, y: y * frequency, z: z * frequency) * amplitude
            maxValue += amplitude
            amplitude *= persistence
            frequency *= lacunarity
        }

        return total / maxValue
    }

    /// Generates turbulence by using absolute values of noise.
    public func turbulence(x: Double, y: Double) -> Double {
        var total = 0.0
        var amplitude = 1.0
        var frequency = scale
        var maxValue = 0.0

        for _ in 0..<octaves {
            total += abs(baseNoise.sample(x: x * frequency, y: y * frequency)) * amplitude
            maxValue += amplitude
            amplitude *= persistence
            frequency *= lacunarity
        }

        return total / maxValue
    }

    /// Generates turbulence by using absolute values of noise.
    public func turbulence(x: Double, y: Double, z: Double) -> Double {
        var total = 0.0
        var amplitude = 1.0
        var frequency = scale
        var maxValue = 0.0

        for _ in 0..<octaves {
            total += abs(baseNoise.sample(x: x * frequency, y: y * frequency, z: z * frequency)) * amplitude
            maxValue += amplitude
            amplitude *= persistence
            frequency *= lacunarity
        }

        return total / maxValue
    }

    /// Generates ridged noise (inverted and sharpened).
    public func ridged(x: Double, y: Double) -> Double {
        var total = 0.0
        var amplitude = 1.0
        var frequency = scale
        var maxValue = 0.0

        for _ in 0..<octaves {
            let signal = baseNoise.sample(x: x * frequency, y: y * frequency)
            let ridge = 1.0 - abs(signal)
            total += ridge * amplitude
            maxValue += amplitude
            amplitude *= persistence
            frequency *= lacunarity
        }

        return total / maxValue
    }

    /// Generates ridged noise (inverted and sharpened).
    public func ridged(x: Double, y: Double, z: Double) -> Double {
        var total = 0.0
        var amplitude = 1.0
        var frequency = scale
        var maxValue = 0.0

        for _ in 0..<octaves {
            let signal = baseNoise.sample(x: x * frequency, y: y * frequency, z: z * frequency)
            let ridge = 1.0 - abs(signal)
            total += ridge * amplitude
            maxValue += amplitude
            amplitude *= persistence
            frequency *= lacunarity
        }

        return total / maxValue
    }
}
