import Foundation

/// A complete particle system with emission, forces, and updates.
public struct ParticleSystem: Sendable {
    public var particles: [Particle]
    public var emitters: [Emitter]
    public var forces: [any Force]
    public var maxParticles: Int

    public init(
        maxParticles: Int = 1000,
        emitters: [Emitter] = [],
        forces: [any Force] = []
    ) {
        self.particles = []
        self.emitters = emitters
        self.forces = forces
        self.maxParticles = maxParticles
    }

    /// Updates the particle system by the given time delta.
    public mutating func update(deltaTime: Double) {
        emitParticles(deltaTime: deltaTime)
        applyForcesToParticles()
        updateParticles(deltaTime: deltaTime)
        removeDeadParticles()
        enforceMaxParticles()
    }

    /// Emits particles from all emitters.
    private mutating func emitParticles(deltaTime: Double) {
        for i in 0..<emitters.count {
            let newParticles = emitters[i].emit(deltaTime: deltaTime)
            particles.append(contentsOf: newParticles)
        }
    }

    /// Applies all forces to all particles.
    private mutating func applyForcesToParticles() {
        for i in 0..<particles.count {
            particles[i].resetAcceleration()

            for force in forces {
                let forceVector = force.calculate(for: particles[i])
                particles[i].applyForce(forceVector)
            }
        }
    }

    /// Updates all particles.
    private mutating func updateParticles(deltaTime: Double) {
        for i in 0..<particles.count {
            particles[i].update(deltaTime: deltaTime)
        }
    }

    /// Removes dead particles.
    private mutating func removeDeadParticles() {
        particles.removeAll { !$0.isAlive }
    }

    /// Enforces the maximum particle count.
    private mutating func enforceMaxParticles() {
        if particles.count > maxParticles {
            particles.removeFirst(particles.count - maxParticles)
        }
    }

    /// Adds an emitter to the system.
    public mutating func addEmitter(_ emitter: Emitter) {
        emitters.append(emitter)
    }

    /// Adds a force to the system.
    public mutating func addForce(_ force: any Force) {
        forces.append(force)
    }

    /// Removes all emitters.
    public mutating func removeAllEmitters() {
        emitters.removeAll()
    }

    /// Removes all forces.
    public mutating func removeAllForces() {
        forces.removeAll()
    }

    /// Clears all particles.
    public mutating func clearParticles() {
        particles.removeAll()
    }

    /// Resets the entire system.
    public mutating func reset() {
        particles.removeAll()
        emitters.removeAll()
        forces.removeAll()
    }

    /// Number of living particles.
    public var particleCount: Int {
        particles.count
    }

    /// Returns particles in a specific age range.
    public func particles(inAgeRange range: ClosedRange<Double>) -> [Particle] {
        particles.filter { range.contains($0.normalizedAge) }
    }

    /// Returns particles within a bounding box.
    public func particles(inBounds min: Point2D, max: Point2D) -> [Particle] {
        particles.filter { particle in
            particle.position.x >= min.x &&
            particle.position.x <= max.x &&
            particle.position.y >= min.y &&
            particle.position.y <= max.y
        }
    }
}

// MARK: - 3D Particle System

/// A 3D particle system.
public struct ParticleSystem3D: Sendable {
    public var particles: [Particle3D]
    public var forces: [any Force3D]
    public var maxParticles: Int

    public init(
        maxParticles: Int = 1000,
        forces: [any Force3D] = []
    ) {
        self.particles = []
        self.forces = forces
        self.maxParticles = maxParticles
    }

    /// Updates the particle system by the given time delta.
    public mutating func update(deltaTime: Double) {
        applyForcesToParticles()
        updateParticles(deltaTime: deltaTime)
        removeDeadParticles()
        enforceMaxParticles()
    }

    /// Applies all forces to all particles.
    private mutating func applyForcesToParticles() {
        for i in 0..<particles.count {
            particles[i].resetAcceleration()

            for force in forces {
                let forceVector = force.calculate(for: particles[i])
                particles[i].applyForce(forceVector)
            }
        }
    }

    /// Updates all particles.
    private mutating func updateParticles(deltaTime: Double) {
        for i in 0..<particles.count {
            particles[i].update(deltaTime: deltaTime)
        }
    }

    /// Removes dead particles.
    private mutating func removeDeadParticles() {
        particles.removeAll { !$0.isAlive }
    }

    /// Enforces the maximum particle count.
    private mutating func enforceMaxParticles() {
        if particles.count > maxParticles {
            particles.removeFirst(particles.count - maxParticles)
        }
    }

    /// Adds a particle to the system.
    public mutating func addParticle(_ particle: Particle3D) {
        particles.append(particle)
    }

    /// Adds a force to the system.
    public mutating func addForce(_ force: any Force3D) {
        forces.append(force)
    }

    /// Removes all forces.
    public mutating func removeAllForces() {
        forces.removeAll()
    }

    /// Clears all particles.
    public mutating func clearParticles() {
        particles.removeAll()
    }

    /// Resets the entire system.
    public mutating func reset() {
        particles.removeAll()
        forces.removeAll()
    }

    /// Number of living particles.
    public var particleCount: Int {
        particles.count
    }
}
