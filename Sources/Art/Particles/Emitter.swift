import Foundation

/// Configuration for a particle emitter.
public struct EmitterConfig: Sendable {
    public var position: Point2D
    public var emissionRate: Double
    public var particleLifetime: ClosedRange<Double>
    public var particleVelocity: ClosedRange<Double>
    public var emissionAngle: ClosedRange<Double>
    public var particleMass: ClosedRange<Double>
    public var particleColor: RGBColor
    public var colorVariation: Double

    public init(
        position: Point2D = .zero,
        emissionRate: Double = 10.0,
        particleLifetime: ClosedRange<Double> = 1.0...3.0,
        particleVelocity: ClosedRange<Double> = 1.0...5.0,
        emissionAngle: ClosedRange<Double> = 0...(.pi * 2),
        particleMass: ClosedRange<Double> = 1.0...1.0,
        particleColor: RGBColor = .white,
        colorVariation: Double = 0.0
    ) {
        self.position = position
        self.emissionRate = emissionRate
        self.particleLifetime = particleLifetime
        self.particleVelocity = particleVelocity
        self.emissionAngle = emissionAngle
        self.particleMass = particleMass
        self.particleColor = particleColor
        self.colorVariation = colorVariation
    }
}

/// A particle emitter that creates particles over time.
public struct Emitter: Sendable {
    public var config: EmitterConfig
    private var accumulatedTime: Double
    private var randomSource: RandomSource

    public init(config: EmitterConfig, seed: UInt64? = nil) {
        self.config = config
        self.accumulatedTime = 0
        self.randomSource = RandomSource(seed: seed ?? UInt64(Date().timeIntervalSince1970 * 1_000_000))
    }

    /// Emits particles based on elapsed time.
    public mutating func emit(deltaTime: Double) -> [Particle] {
        accumulatedTime += deltaTime
        let interval = 1.0 / config.emissionRate
        var particles: [Particle] = []

        while accumulatedTime >= interval {
            particles.append(createParticle())
            accumulatedTime -= interval
        }

        return particles
    }

    /// Creates a single particle based on the emitter configuration.
    private mutating func createParticle() -> Particle {
        let angle = randomSource.nextDouble(in: config.emissionAngle)
        let speed = randomSource.nextDouble(in: config.particleVelocity)
        let velocity = Point2D(
            x: cos(angle) * speed,
            y: sin(angle) * speed
        )

        let lifetime = randomSource.nextDouble(in: config.particleLifetime)
        let mass = randomSource.nextDouble(in: config.particleMass)

        var color = config.particleColor
        if config.colorVariation > 0 {
            let variation = config.colorVariation
            color = RGBColor(
                red: (color.red + (randomSource.nextDouble() - 0.5) * variation).clamped(to: 0...1),
                green: (color.green + (randomSource.nextDouble() - 0.5) * variation).clamped(to: 0...1),
                blue: (color.blue + (randomSource.nextDouble() - 0.5) * variation).clamped(to: 0...1),
                alpha: color.alpha
            )
        }

        return Particle(
            position: config.position,
            velocity: velocity,
            lifetime: lifetime,
            mass: mass,
            color: color
        )
    }

    /// Emits a burst of particles.
    public mutating func burst(count: Int) -> [Particle] {
        (0..<count).map { _ in createParticle() }
    }

    /// Resets the accumulated time.
    public mutating func reset() {
        accumulatedTime = 0
    }
}

// MARK: - Presets

extension EmitterConfig {
    /// Fountain-like particle emitter.
    public static let fountain = EmitterConfig(
        emissionRate: 50,
        particleLifetime: 2.0...4.0,
        particleVelocity: 5.0...10.0,
        emissionAngle: (.pi / 3)...(.pi * 2 / 3),
        particleColor: RGBColor(red: 0.3, green: 0.6, blue: 1.0),
        colorVariation: 0.1
    )

    /// Explosion-like particle emitter.
    public static let explosion = EmitterConfig(
        emissionRate: 0,
        particleLifetime: 0.5...1.5,
        particleVelocity: 10.0...20.0,
        emissionAngle: 0...(.pi * 2),
        particleColor: RGBColor(red: 1.0, green: 0.5, blue: 0.0),
        colorVariation: 0.2
    )

    /// Smoke-like particle emitter.
    public static let smoke = EmitterConfig(
        emissionRate: 20,
        particleLifetime: 3.0...5.0,
        particleVelocity: 0.5...2.0,
        emissionAngle: (.pi / 4)...(.pi * 3 / 4),
        particleColor: RGBColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5),
        colorVariation: 0.1
    )

    /// Fire-like particle emitter.
    public static let fire = EmitterConfig(
        emissionRate: 40,
        particleLifetime: 0.5...1.5,
        particleVelocity: 2.0...5.0,
        emissionAngle: (.pi / 3)...(.pi * 2 / 3),
        particleColor: RGBColor(red: 1.0, green: 0.3, blue: 0.0),
        colorVariation: 0.2
    )

    /// Sparkle-like particle emitter.
    public static let sparkle = EmitterConfig(
        emissionRate: 30,
        particleLifetime: 0.3...1.0,
        particleVelocity: 1.0...3.0,
        emissionAngle: 0...(.pi * 2),
        particleColor: .white,
        colorVariation: 0.3
    )
}

// MARK: - Helper

extension Double {
    fileprivate func clamped(to range: ClosedRange<Double>) -> Double {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
