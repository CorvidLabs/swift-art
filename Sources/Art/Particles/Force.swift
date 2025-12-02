import Foundation

/// A protocol for forces that can be applied to particles.
public protocol Force: Sendable {
    /// Calculates the force to apply to a particle at the given position.
    func calculate(for particle: Particle) -> Point2D
}

/// A protocol for 3D forces.
public protocol Force3D: Sendable {
    /// Calculates the force to apply to a 3D particle.
    func calculate(for particle: Particle3D) -> Point3D
}

// MARK: - Gravity

/// A constant downward gravity force.
public struct Gravity: Force, Sendable {
    public let strength: Double

    public init(strength: Double = 9.8) {
        self.strength = strength
    }

    public func calculate(for particle: Particle) -> Point2D {
        Point2D(x: 0, y: -strength * particle.mass)
    }
}

/// A 3D gravity force.
public struct Gravity3D: Force3D, Sendable {
    public let direction: Point3D
    public let strength: Double

    public init(direction: Point3D = Point3D(x: 0, y: -1, z: 0), strength: Double = 9.8) {
        self.direction = direction.normalized()
        self.strength = strength
    }

    public func calculate(for particle: Particle3D) -> Point3D {
        direction * (strength * particle.mass)
    }
}

// MARK: - Wind

/// A wind force with optional turbulence.
public struct Wind: Force, Sendable {
    public let direction: Point2D
    public let strength: Double
    public let turbulence: Double

    public init(direction: Point2D, strength: Double = 1.0, turbulence: Double = 0.0) {
        self.direction = direction.normalized()
        self.strength = strength
        self.turbulence = turbulence
    }

    public func calculate(for particle: Particle) -> Point2D {
        let base = direction * strength
        if turbulence > 0 {
            var rng = RandomSource(seed: UInt64(bitPattern: Int64(particle.id.hashValue)))
            let noise = Point2D(
                x: (rng.nextDouble() - 0.5) * turbulence,
                y: (rng.nextDouble() - 0.5) * turbulence
            )
            return base + noise
        }
        return base
    }
}

// MARK: - Drag

/// A drag force that opposes motion.
public struct Drag: Force, Sendable {
    public let coefficient: Double

    public init(coefficient: Double = 0.1) {
        self.coefficient = coefficient
    }

    public func calculate(for particle: Particle) -> Point2D {
        let speed = particle.velocity.magnitude
        guard speed > 0 else { return .zero }

        let dragMagnitude = coefficient * speed * speed
        let dragDirection = particle.velocity.normalized() * -1
        return dragDirection * dragMagnitude
    }
}

/// A 3D drag force.
public struct Drag3D: Force3D, Sendable {
    public let coefficient: Double

    public init(coefficient: Double = 0.1) {
        self.coefficient = coefficient
    }

    public func calculate(for particle: Particle3D) -> Point3D {
        let speed = particle.velocity.magnitude
        guard speed > 0 else { return .zero }

        let dragMagnitude = coefficient * speed * speed
        let dragDirection = particle.velocity.normalized() * -1
        return dragDirection * dragMagnitude
    }
}

// MARK: - Attractor

/// An attractor force that pulls particles toward a point.
public struct Attractor: Force, Sendable {
    public let position: Point2D
    public let strength: Double
    public let minDistance: Double
    public let maxDistance: Double?

    public init(
        position: Point2D,
        strength: Double = 10.0,
        minDistance: Double = 1.0,
        maxDistance: Double? = nil
    ) {
        self.position = position
        self.strength = strength
        self.minDistance = minDistance
        self.maxDistance = maxDistance
    }

    public func calculate(for particle: Particle) -> Point2D {
        let direction = position - particle.position
        let distance = max(direction.magnitude, minDistance)

        if let maxDist = maxDistance, distance > maxDist {
            return .zero
        }

        let forceMagnitude = strength / (distance * distance)
        return direction.normalized() * forceMagnitude
    }
}

/// A 3D attractor force.
public struct Attractor3D: Force3D, Sendable {
    public let position: Point3D
    public let strength: Double
    public let minDistance: Double
    public let maxDistance: Double?

    public init(
        position: Point3D,
        strength: Double = 10.0,
        minDistance: Double = 1.0,
        maxDistance: Double? = nil
    ) {
        self.position = position
        self.strength = strength
        self.minDistance = minDistance
        self.maxDistance = maxDistance
    }

    public func calculate(for particle: Particle3D) -> Point3D {
        let direction = position - particle.position
        let distance = max(direction.magnitude, minDistance)

        if let maxDist = maxDistance, distance > maxDist {
            return .zero
        }

        let forceMagnitude = strength / (distance * distance)
        return direction.normalized() * forceMagnitude
    }
}

// MARK: - Repeller

/// A repeller force that pushes particles away from a point.
public struct Repeller: Force, Sendable {
    public let position: Point2D
    public let strength: Double
    public let minDistance: Double
    public let maxDistance: Double?

    public init(
        position: Point2D,
        strength: Double = 10.0,
        minDistance: Double = 1.0,
        maxDistance: Double? = nil
    ) {
        self.position = position
        self.strength = strength
        self.minDistance = minDistance
        self.maxDistance = maxDistance
    }

    public func calculate(for particle: Particle) -> Point2D {
        let direction = particle.position - position
        let distance = max(direction.magnitude, minDistance)

        if let maxDist = maxDistance, distance > maxDist {
            return .zero
        }

        let forceMagnitude = strength / (distance * distance)
        return direction.normalized() * forceMagnitude
    }
}

// MARK: - Vortex

/// A vortex force that creates a spinning motion around a point.
public struct Vortex: Force, Sendable {
    public let center: Point2D
    public let strength: Double
    public let radius: Double

    public init(center: Point2D, strength: Double = 1.0, radius: Double = 10.0) {
        self.center = center
        self.strength = strength
        self.radius = radius
    }

    public func calculate(for particle: Particle) -> Point2D {
        let direction = particle.position - center
        let distance = direction.magnitude

        guard distance > 0 && distance < radius else { return .zero }

        let tangent = Point2D(x: -direction.y, y: direction.x).normalized()
        let forceMagnitude = strength * (1.0 - distance / radius)
        return tangent * forceMagnitude
    }
}
