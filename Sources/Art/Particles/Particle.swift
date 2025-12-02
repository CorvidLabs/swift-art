import Foundation

/// A particle with position, velocity, and lifetime.
public struct Particle: Sendable, Identifiable {
    public let id: UUID
    public var position: Point2D
    public var velocity: Point2D
    public var acceleration: Point2D
    public var age: Double
    public var lifetime: Double
    public var mass: Double
    public var color: RGBColor

    public init(
        id: UUID = UUID(),
        position: Point2D,
        velocity: Point2D = .zero,
        acceleration: Point2D = .zero,
        age: Double = 0,
        lifetime: Double = 1.0,
        mass: Double = 1.0,
        color: RGBColor = .white
    ) {
        self.id = id
        self.position = position
        self.velocity = velocity
        self.acceleration = acceleration
        self.age = age
        self.lifetime = lifetime
        self.mass = mass
        self.color = color
    }

    /// Whether the particle is still alive.
    public var isAlive: Bool {
        age < lifetime
    }

    /// Normalized age [0, 1].
    public var normalizedAge: Double {
        guard lifetime > 0 else { return 1.0 }
        return min(age / lifetime, 1.0)
    }

    /// Updates the particle by the given time delta.
    public mutating func update(deltaTime: Double) {
        velocity = velocity + acceleration * deltaTime
        position = position + velocity * deltaTime
        age += deltaTime
    }

    /// Applies a force to the particle.
    public mutating func applyForce(_ force: Point2D) {
        guard mass > 0 else { return }
        acceleration = acceleration + (force / mass)
    }

    /// Resets the acceleration (typically done each frame).
    public mutating func resetAcceleration() {
        acceleration = .zero
    }
}

// MARK: - 3D Particle

/// A particle in 3D space.
public struct Particle3D: Sendable, Identifiable {
    public let id: UUID
    public var position: Point3D
    public var velocity: Point3D
    public var acceleration: Point3D
    public var age: Double
    public var lifetime: Double
    public var mass: Double
    public var color: RGBColor

    public init(
        id: UUID = UUID(),
        position: Point3D,
        velocity: Point3D = .zero,
        acceleration: Point3D = .zero,
        age: Double = 0,
        lifetime: Double = 1.0,
        mass: Double = 1.0,
        color: RGBColor = .white
    ) {
        self.id = id
        self.position = position
        self.velocity = velocity
        self.acceleration = acceleration
        self.age = age
        self.lifetime = lifetime
        self.mass = mass
        self.color = color
    }

    /// Whether the particle is still alive.
    public var isAlive: Bool {
        age < lifetime
    }

    /// Normalized age [0, 1].
    public var normalizedAge: Double {
        guard lifetime > 0 else { return 1.0 }
        return min(age / lifetime, 1.0)
    }

    /// Updates the particle by the given time delta.
    public mutating func update(deltaTime: Double) {
        velocity = velocity + acceleration * deltaTime
        position = position + velocity * deltaTime
        age += deltaTime
    }

    /// Applies a force to the particle.
    public mutating func applyForce(_ force: Point3D) {
        guard mass > 0 else { return }
        acceleration = acceleration + (force / mass)
    }

    /// Resets the acceleration (typically done each frame).
    public mutating func resetAcceleration() {
        acceleration = .zero
    }
}
