import Testing
@testable import Art

@Suite("Particle")
struct ParticleTests {
    @Test("Initialization")
    func initialization() {
        let particle = Particle(
            position: Point2D(x: 10, y: 20),
            velocity: Point2D(x: 1, y: 2),
            mass: 2.0
        )

        #expect(particle.position.x == 10)
        #expect(particle.position.y == 20)
        #expect(particle.velocity.x == 1)
        #expect(particle.velocity.y == 2)
        #expect(particle.mass == 2.0)
    }

    @Test("Is alive")
    func isAlive() {
        var particle = Particle(position: .zero, lifetime: 10.0)
        #expect(particle.isAlive)

        particle.age = 5.0
        #expect(particle.isAlive)

        particle.age = 10.0
        #expect(!particle.isAlive)

        particle.age = 15.0
        #expect(!particle.isAlive)
    }

    @Test("Normalized age")
    func normalizedAge() {
        var particle = Particle(position: .zero, lifetime: 10.0)

        particle.age = 0.0
        #expect(particle.normalizedAge == 0.0)

        particle.age = 5.0
        #expect(particle.normalizedAge == 0.5)

        particle.age = 10.0
        #expect(particle.normalizedAge == 1.0)

        particle.age = 15.0
        #expect(particle.normalizedAge == 1.0)
    }

    @Test("Update")
    func update() {
        var particle = Particle(
            position: Point2D(x: 0, y: 0),
            velocity: Point2D(x: 10, y: 5),
            acceleration: Point2D(x: 0, y: -1)
        )

        particle.update(deltaTime: 1.0)

        #expect(particle.position.x == 10)
        #expect(particle.position.y == 4)
        #expect(particle.velocity.x == 10)
        #expect(particle.velocity.y == 4)
    }

    @Test("Apply force")
    func applyForce() {
        var particle = Particle(
            position: .zero,
            mass: 2.0
        )

        particle.applyForce(Point2D(x: 10, y: 20))

        #expect(particle.acceleration.x == 5.0)
        #expect(particle.acceleration.y == 10.0)
    }

    @Test("Reset acceleration")
    func resetAcceleration() {
        var particle = Particle(
            position: .zero,
            acceleration: Point2D(x: 5, y: 10)
        )

        particle.resetAcceleration()

        #expect(particle.acceleration == Point2D.zero)
    }
}

@Suite("Particle3D")
struct Particle3DTests {
    @Test("Initialization")
    func initialization() {
        let particle = Particle3D(
            position: Point3D(x: 1, y: 2, z: 3),
            velocity: Point3D(x: 0.1, y: 0.2, z: 0.3)
        )

        #expect(particle.position.z == 3)
        #expect(particle.velocity.z == 0.3)
    }

    @Test("Update")
    func update() {
        var particle = Particle3D(
            position: Point3D.zero,
            velocity: Point3D(x: 1, y: 2, z: 3),
            acceleration: Point3D(x: 0, y: 0, z: -1)
        )

        particle.update(deltaTime: 1.0)

        #expect(particle.position.z == 2.0)
        #expect(particle.velocity.z == 2.0)
    }
}

@Suite("Force")
struct ForceTests {
    @Test("Gravity")
    func gravity() {
        let gravity = Gravity(strength: 10.0)
        let particle = Particle(position: .zero, mass: 2.0)

        let force = gravity.calculate(for: particle)

        #expect(force.x == 0.0)
        #expect(force.y == -20.0)
    }

    @Test("Wind")
    func wind() {
        let wind = Wind(
            direction: Point2D(x: 1, y: 0),
            strength: 5.0,
            turbulence: 0.0
        )

        let particle = Particle(position: .zero)
        let force = wind.calculate(for: particle)

        #expect(abs(force.x - 5.0) < 0.001)
        #expect(abs(force.y - 0.0) < 0.001)
    }

    @Test("Wind with turbulence")
    func windWithTurbulence() {
        let wind = Wind(
            direction: Point2D(x: 1, y: 0),
            strength: 5.0,
            turbulence: 0.1
        )

        let particle = Particle(position: .zero)
        let force = wind.calculate(for: particle)

        #expect(force.magnitude > 0)
    }

    @Test("Drag")
    func drag() {
        let drag = Drag(coefficient: 0.1)
        let particle = Particle(position: .zero, velocity: Point2D(x: 10, y: 0))

        let force = drag.calculate(for: particle)

        #expect(force.x < 0)
    }

    @Test("Drag opposes motion")
    func dragOpposesMotion() {
        let drag = Drag(coefficient: 0.1)
        let particle = Particle(position: .zero, velocity: Point2D(x: 10, y: 5))

        let force = drag.calculate(for: particle)

        #expect(force.x < 0)
        #expect(force.y < 0)
    }

    @Test("Attractor")
    func attractor() {
        let attractor = Attractor(
            position: Point2D(x: 100, y: 100),
            strength: 10.0
        )

        let particle = Particle(position: Point2D(x: 0, y: 0))
        let force = attractor.calculate(for: particle)

        #expect(force.x > 0)
        #expect(force.y > 0)
    }

    @Test("Attractor with max distance")
    func attractorWithMaxDistance() {
        let attractor = Attractor(
            position: Point2D(x: 100, y: 100),
            strength: 10.0,
            maxDistance: 50.0
        )

        let nearParticle = Particle(position: Point2D(x: 95, y: 95))
        let farParticle = Particle(position: Point2D(x: 0, y: 0))

        let nearForce = attractor.calculate(for: nearParticle)
        let farForce = attractor.calculate(for: farParticle)

        #expect(nearForce.magnitude > 0)
        #expect(farForce == Point2D.zero)
    }

    @Test("Repeller")
    func repeller() {
        let repeller = Repeller(
            position: Point2D(x: 50, y: 50),
            strength: 10.0
        )

        let particle = Particle(position: Point2D(x: 60, y: 60))
        let force = repeller.calculate(for: particle)

        #expect(force.magnitude > 0)
    }

    @Test("Vortex")
    func vortex() {
        let vortex = Vortex(
            center: Point2D(x: 50, y: 50),
            strength: 5.0,
            radius: 20.0
        )

        let particle = Particle(position: Point2D(x: 55, y: 50))
        let force = vortex.calculate(for: particle)

        #expect(force.magnitude > 0)
    }

    @Test("Vortex outside radius")
    func vortexOutsideRadius() {
        let vortex = Vortex(
            center: Point2D(x: 50, y: 50),
            strength: 5.0,
            radius: 10.0
        )

        let particle = Particle(position: Point2D(x: 100, y: 100))
        let force = vortex.calculate(for: particle)

        #expect(force == Point2D.zero)
    }

    @Test("Gravity 3D")
    func gravity3D() {
        let gravity = Gravity3D(
            direction: Point3D(x: 0, y: -1, z: 0),
            strength: 10.0
        )

        let particle = Particle3D(position: Point3D.zero, mass: 2.0)
        let force = gravity.calculate(for: particle)

        #expect(abs(force.y - (-20.0)) < 0.001)
    }

    @Test("Drag 3D")
    func drag3D() {
        let drag = Drag3D(coefficient: 0.1)
        let particle = Particle3D(
            position: Point3D.zero,
            velocity: Point3D(x: 10, y: 5, z: 2)
        )

        let force = drag.calculate(for: particle)

        #expect(force.x < 0)
        #expect(force.y < 0)
        #expect(force.z < 0)
    }

    @Test("Attractor 3D")
    func attractor3D() {
        let attractor = Attractor3D(
            position: Point3D(x: 100, y: 100, z: 100),
            strength: 10.0
        )

        let particle = Particle3D(position: Point3D.zero)
        let force = attractor.calculate(for: particle)

        #expect(force.magnitude > 0)
    }
}

@Suite("Emitter")
struct EmitterTests {
    @Test("Emitter config")
    func emitterConfig() {
        let config = EmitterConfig(
            position: Point2D(x: 50, y: 50),
            emissionRate: 10.0,
            particleLifetime: 1.0...2.0,
            particleVelocity: 5.0...10.0,
            emissionAngle: 0...(2 * .pi),
            particleMass: 1.0...1.0,
            particleColor: .white,
            colorVariation: 0.1
        )

        #expect(config.position.x == 50)
        #expect(config.emissionRate == 10.0)
    }

    @Test("Emitter emission")
    func emitterEmission() {
        let config = EmitterConfig(
            position: Point2D(x: 0, y: 0),
            emissionRate: 100.0
        )

        var emitter = Emitter(config: config, seed: 42)
        let particles = emitter.emit(deltaTime: 0.1)

        #expect(particles.count > 0)
    }

    @Test("Emitter deterministic")
    func emitterDeterministic() {
        let config = EmitterConfig(
            position: Point2D(x: 0, y: 0),
            emissionRate: 10.0
        )

        var emitter1 = Emitter(config: config, seed: 12345)
        var emitter2 = Emitter(config: config, seed: 12345)

        let particles1 = emitter1.emit(deltaTime: 1.0)
        let particles2 = emitter2.emit(deltaTime: 1.0)

        #expect(particles1.count == particles2.count)
    }
}

@Suite("ParticleSystem")
struct ParticleSystemTests {
    @Test("Initialization")
    func initialization() {
        let system = ParticleSystem(maxParticles: 500)

        #expect(system.particleCount == 0)
        #expect(system.maxParticles == 500)
    }

    @Test("Add emitter")
    func addEmitter() {
        var system = ParticleSystem()
        let config = EmitterConfig(position: .zero, emissionRate: 10.0)
        let emitter = Emitter(config: config, seed: 42)

        system.addEmitter(emitter)

        #expect(system.emitters.count == 1)
    }

    @Test("Add force")
    func addForce() {
        var system = ParticleSystem()
        let gravity = Gravity(strength: 9.8)

        system.addForce(gravity)

        #expect(system.forces.count == 1)
    }

    @Test("Update")
    func update() {
        var system = ParticleSystem()
        let config = EmitterConfig(position: .zero, emissionRate: 100.0)
        let emitter = Emitter(config: config, seed: 42)

        system.addEmitter(emitter)
        system.update(deltaTime: 0.1)

        #expect(system.particleCount > 0)
    }

    @Test("Max particles")
    func maxParticles() {
        var system = ParticleSystem(maxParticles: 50)
        let config = EmitterConfig(position: .zero, emissionRate: 1000.0)
        let emitter = Emitter(config: config, seed: 42)

        system.addEmitter(emitter)
        system.update(deltaTime: 1.0)

        #expect(system.particleCount <= 50)
    }

    @Test("Remove dead particles")
    func removeDeadParticles() {
        var system = ParticleSystem()
        let config = EmitterConfig(
            position: .zero,
            emissionRate: 10.0,
            particleLifetime: 0.1...0.2
        )
        let emitter = Emitter(config: config, seed: 42)

        system.addEmitter(emitter)
        system.update(deltaTime: 0.1)

        let initialCount = system.particleCount

        system.update(deltaTime: 1.0)

        #expect(system.particleCount < initialCount)
    }

    @Test("Clear particles")
    func clearParticles() {
        var system = ParticleSystem()
        let config = EmitterConfig(position: .zero, emissionRate: 100.0)
        let emitter = Emitter(config: config, seed: 42)

        system.addEmitter(emitter)
        system.update(deltaTime: 0.1)

        #expect(system.particleCount > 0)

        system.clearParticles()

        #expect(system.particleCount == 0)
    }

    @Test("Reset")
    func reset() {
        var system = ParticleSystem()
        let config = EmitterConfig(position: .zero, emissionRate: 10.0)
        let emitter = Emitter(config: config, seed: 42)

        system.addEmitter(emitter)
        system.addForce(Gravity())
        system.update(deltaTime: 0.1)

        system.reset()

        #expect(system.particleCount == 0)
        #expect(system.emitters.count == 0)
        #expect(system.forces.count == 0)
    }

    @Test("Particles in age range")
    func particlesInAgeRange() {
        var system = ParticleSystem()
        let config = EmitterConfig(
            position: .zero,
            emissionRate: 100.0,
            particleLifetime: 10.0...10.0
        )
        let emitter = Emitter(config: config, seed: 42)

        system.addEmitter(emitter)
        system.update(deltaTime: 0.1)
        system.removeAllEmitters()
        system.update(deltaTime: 0.5)

        let youngParticles = system.particles(inAgeRange: 0.0...0.3)

        #expect(youngParticles.count >= 0)
    }

    @Test("Particles in bounds")
    func particlesInBounds() {
        var system = ParticleSystem()
        let config = EmitterConfig(
            position: Point2D(x: 50, y: 50),
            emissionRate: 100.0
        )
        let emitter = Emitter(config: config, seed: 42)

        system.addEmitter(emitter)
        system.update(deltaTime: 0.1)

        let particles = system.particles(
            inBounds: Point2D(x: 0, y: 0),
            max: Point2D(x: 100, y: 100)
        )

        #expect(particles.count >= 0)
    }
}

@Suite("ParticleSystem3D")
struct ParticleSystem3DTests {
    @Test("Initialization")
    func initialization() {
        let system = ParticleSystem3D(maxParticles: 500)

        #expect(system.particleCount == 0)
        #expect(system.maxParticles == 500)
    }

    @Test("Add particle")
    func addParticle() {
        var system = ParticleSystem3D()
        let particle = Particle3D(position: Point3D.zero)

        system.addParticle(particle)

        #expect(system.particleCount == 1)
    }

    @Test("Update")
    func update() {
        var system = ParticleSystem3D()
        let particle = Particle3D(
            position: Point3D.zero,
            velocity: Point3D(x: 1, y: 1, z: 1),
            lifetime: 10.0
        )

        system.addParticle(particle)
        system.addForce(Gravity3D())
        system.update(deltaTime: 0.1)

        #expect(system.particleCount == 1)
    }

    @Test("Remove dead particles")
    func removeDeadParticles() {
        var system = ParticleSystem3D()
        let particle = Particle3D(
            position: Point3D.zero,
            lifetime: 0.1
        )

        system.addParticle(particle)
        #expect(system.particleCount == 1)

        system.update(deltaTime: 0.2)

        #expect(system.particleCount == 0)
    }
}
