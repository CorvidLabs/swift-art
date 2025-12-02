import Testing
@testable import Art

@Suite("PerlinNoise")
struct PerlinNoiseTests {
    @Test("Deterministic output")
    func deterministicOutput() {
        let noise1 = PerlinNoise(seed: 12345)
        let noise2 = PerlinNoise(seed: 12345)

        for x in stride(from: 0.0, to: 10.0, by: 0.5) {
            for y in stride(from: 0.0, to: 10.0, by: 0.5) {
                #expect(abs(noise1.sample(x: x, y: y) - noise2.sample(x: x, y: y)) < 0.0001)
            }
        }
    }

    @Test("Value range 2D")
    func valueRange2D() {
        let noise = PerlinNoise(seed: 42)

        for x in stride(from: 0.0, to: 20.0, by: 0.5) {
            for y in stride(from: 0.0, to: 20.0, by: 0.5) {
                let value = noise.sample(x: x, y: y)
                #expect(value >= -1.0)
                #expect(value <= 1.0)
            }
        }
    }

    @Test("Value range 3D")
    func valueRange3D() {
        let noise = PerlinNoise(seed: 42)

        for x in stride(from: 0.0, to: 10.0, by: 1.0) {
            for y in stride(from: 0.0, to: 10.0, by: 1.0) {
                for z in stride(from: 0.0, to: 10.0, by: 1.0) {
                    let value = noise.sample(x: x, y: y, z: z)
                    #expect(value >= -1.0)
                    #expect(value <= 1.0)
                }
            }
        }
    }

    @Test("Continuity")
    func continuity() {
        let noise = PerlinNoise(seed: 42)
        let x = 5.0
        let y = 5.0

        let value1 = noise.sample(x: x, y: y)
        let value2 = noise.sample(x: x + 0.0001, y: y)

        #expect(abs(value1 - value2) < 0.01)
    }

    @Test("Point sampling")
    func pointSampling() {
        let noise = PerlinNoise(seed: 42)
        let point = Point2D(x: 3.5, y: 7.2)

        let directValue = noise.sample(x: point.x, y: point.y)
        let pointValue = noise.sample(at: point)

        #expect(directValue == pointValue)
    }

    @Test("Normalized")
    func normalized() {
        let noise = PerlinNoise(seed: 42)

        for x in stride(from: 0.0, to: 10.0, by: 1.0) {
            for y in stride(from: 0.0, to: 10.0, by: 1.0) {
                let normalized = noise.normalized(x: x, y: y)
                #expect(normalized >= 0.0)
                #expect(normalized <= 1.0)
            }
        }
    }

    @Test("Mapped")
    func mapped() {
        let noise = PerlinNoise(seed: 42)
        let range = 10.0...20.0

        for x in stride(from: 0.0, to: 10.0, by: 1.0) {
            for y in stride(from: 0.0, to: 10.0, by: 1.0) {
                let mapped = noise.mapped(x: x, y: y, to: range)
                #expect(mapped >= 10.0)
                #expect(mapped <= 20.0)
            }
        }
    }

    @Test("Different seeds produce different results")
    func differentSeedsProduceDifferentResults() {
        let noise1 = PerlinNoise(seed: 111)
        let noise2 = PerlinNoise(seed: 222)

        let value1 = noise1.sample(x: 5.5, y: 3.3)
        let value2 = noise2.sample(x: 5.5, y: 3.3)

        #expect(value1 != value2)
    }
}

@Suite("SimplexNoise")
struct SimplexNoiseTests {
    @Test("Deterministic output")
    func deterministicOutput() {
        let noise1 = SimplexNoise(seed: 12345)
        let noise2 = SimplexNoise(seed: 12345)

        for x in stride(from: 0.0, to: 10.0, by: 0.5) {
            for y in stride(from: 0.0, to: 10.0, by: 0.5) {
                #expect(abs(noise1.sample(x: x, y: y) - noise2.sample(x: x, y: y)) < 0.0001)
            }
        }
    }

    @Test("Value range")
    func valueRange() {
        let noise = SimplexNoise(seed: 42)

        for x in stride(from: 0.0, to: 20.0, by: 0.5) {
            for y in stride(from: 0.0, to: 20.0, by: 0.5) {
                let value = noise.sample(x: x, y: y)
                #expect(value >= -1.0)
                #expect(value <= 1.0)
            }
        }
    }

    @Test("Normalized")
    func normalized() {
        let noise = SimplexNoise(seed: 42)

        for x in stride(from: 0.0, to: 10.0, by: 1.0) {
            for y in stride(from: 0.0, to: 10.0, by: 1.0) {
                let normalized = noise.normalized(x: x, y: y)
                #expect(normalized >= 0.0)
                #expect(normalized <= 1.0)
            }
        }
    }
}

@Suite("WorleyNoise")
struct WorleyNoiseTests {
    @Test("Deterministic output")
    func deterministicOutput() {
        let noise1 = WorleyNoise(seed: 12345)
        let noise2 = WorleyNoise(seed: 12345)

        for x in stride(from: 0.0, to: 10.0, by: 0.5) {
            for y in stride(from: 0.0, to: 10.0, by: 0.5) {
                #expect(abs(noise1.sample(x: x, y: y) - noise2.sample(x: x, y: y)) < 0.0001)
            }
        }
    }

    @Test("Value range")
    func valueRange() {
        let noise = WorleyNoise(seed: 42)

        for x in stride(from: 0.0, to: 20.0, by: 1.0) {
            for y in stride(from: 0.0, to: 20.0, by: 1.0) {
                let value = noise.sample(x: x, y: y)
                #expect(value >= 0.0)
                #expect(value <= 2.0)
            }
        }
    }

    @Test("Different distance functions")
    func differentDistanceFunctions() {
        let euclidean = WorleyNoise(seed: 42, distanceFunction: .euclidean)
        let manhattan = WorleyNoise(seed: 42, distanceFunction: .manhattan)
        let chebyshev = WorleyNoise(seed: 42, distanceFunction: .chebyshev)

        let x = 5.5
        let y = 3.3

        let v1 = euclidean.sample(x: x, y: y)
        let v2 = manhattan.sample(x: x, y: y)
        let v3 = chebyshev.sample(x: x, y: y)

        #expect(v1 != v2)
        #expect(v2 != v3)
        #expect(v1 != v3)
    }

    @Test("Sample distances")
    func sampleDistances() {
        let noise = WorleyNoise(seed: 42)
        let distances = noise.sampleDistances(x: 5.5, y: 3.3, count: 3)

        #expect(distances.count == 3)

        for i in 0..<(distances.count - 1) {
            #expect(distances[i] <= distances[i + 1])
        }
    }

    @Test("Minkowski distance")
    func minkowskiDistance() {
        let noise = WorleyNoise(seed: 42, distanceFunction: .minkowski(p: 3.0))
        let value = noise.sample(x: 5.5, y: 3.3)

        #expect(value >= 0.0)
    }
}

@Suite("FractalNoise")
struct FractalNoiseTests {
    @Test("Deterministic output")
    func deterministicOutput() {
        let baseNoise = PerlinNoise(seed: 12345)
        let fractal1 = FractalNoise(baseNoise: baseNoise, octaves: 4)
        let fractal2 = FractalNoise(baseNoise: baseNoise, octaves: 4)

        for x in stride(from: 0.0, to: 10.0, by: 0.5) {
            for y in stride(from: 0.0, to: 10.0, by: 0.5) {
                #expect(abs(fractal1.sample(x: x, y: y) - fractal2.sample(x: x, y: y)) < 0.0001)
            }
        }
    }

    @Test("Octave effect")
    func octaveEffect() {
        let baseNoise = PerlinNoise(seed: 42)
        let fractal1 = FractalNoise(baseNoise: baseNoise, octaves: 1)
        let fractal4 = FractalNoise(baseNoise: baseNoise, octaves: 4)

        let x = 5.5
        let y = 3.3

        let value1 = fractal1.sample(x: x, y: y)
        let value4 = fractal4.sample(x: x, y: y)

        #expect(value1 != value4)
    }

    @Test("Lacunarity effect")
    func lacunarityEffect() {
        let baseNoise = PerlinNoise(seed: 42)
        let fractal1 = FractalNoise(baseNoise: baseNoise, octaves: 4, lacunarity: 2.0)
        let fractal2 = FractalNoise(baseNoise: baseNoise, octaves: 4, lacunarity: 3.0)

        let x = 5.5
        let y = 3.3

        let value1 = fractal1.sample(x: x, y: y)
        let value2 = fractal2.sample(x: x, y: y)

        #expect(value1 != value2)
    }

    @Test("Persistence effect")
    func persistenceEffect() {
        let baseNoise = PerlinNoise(seed: 42)
        let fractal1 = FractalNoise(baseNoise: baseNoise, octaves: 4, persistence: 0.5)
        let fractal2 = FractalNoise(baseNoise: baseNoise, octaves: 4, persistence: 0.7)

        let x = 5.5
        let y = 3.3

        let value1 = fractal1.sample(x: x, y: y)
        let value2 = fractal2.sample(x: x, y: y)

        #expect(value1 != value2)
    }

    @Test("Value range")
    func valueRange() {
        let baseNoise = PerlinNoise(seed: 42)
        let fractal = FractalNoise(baseNoise: baseNoise, octaves: 6)

        for x in stride(from: 0.0, to: 20.0, by: 1.0) {
            for y in stride(from: 0.0, to: 20.0, by: 1.0) {
                let value = fractal.sample(x: x, y: y)
                #expect(value >= -2.0)
                #expect(value <= 2.0)
            }
        }
    }

    @Test("Turbulence")
    func turbulence() {
        let fractal = FractalNoise(octaves: 4, seed: 42)
        let turbulence = fractal.turbulence(x: 5.5, y: 3.3)

        #expect(turbulence >= 0.0)
    }

    @Test("Ridged")
    func ridged() {
        let fractal = FractalNoise(octaves: 4, seed: 42)
        let ridged = fractal.ridged(x: 5.5, y: 3.3)

        #expect(ridged >= 0.0)
        #expect(ridged <= 1.0)
    }
}
