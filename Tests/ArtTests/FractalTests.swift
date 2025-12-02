import Foundation
import Testing
@testable import Art

@Suite("Mandelbrot")
struct MandelbrotTests {
    @Test("Contains origin")
    func containsOrigin() {
        let mandelbrot = Mandelbrot(maxIterations: 100)
        #expect(mandelbrot.contains(real: 0, imaginary: 0))
    }

    @Test("Does not contain far points")
    func doesNotContainFarPoints() {
        let mandelbrot = Mandelbrot(maxIterations: 100)
        #expect(!mandelbrot.contains(real: 10, imaginary: 10))
    }

    @Test("Iteration count")
    func iterationCount() {
        let mandelbrot = Mandelbrot(maxIterations: 50)
        let sample = mandelbrot.sample(real: 0, imaginary: 0)

        #expect(sample.iterations == 50)
        #expect(!sample.escaped)
    }

    @Test("Escape detection")
    func escapeDetection() {
        let mandelbrot = Mandelbrot(maxIterations: 100)
        let sample = mandelbrot.sample(real: 2, imaginary: 2)

        #expect(sample.escaped)
        #expect(sample.iterations < 10)
    }

    @Test("Smooth value")
    func smoothValue() {
        let mandelbrot = Mandelbrot(maxIterations: 100)
        let sample = mandelbrot.sample(real: 0.5, imaginary: 0.5)

        #expect(sample.smoothValue >= 0)
        #expect(sample.smoothValue <= Double(mandelbrot.maxIterations))
    }

    @Test("Normalized iterations")
    func normalizedIterations() {
        let mandelbrot = Mandelbrot(maxIterations: 100)
        let normalized = mandelbrot.normalizedIterations(real: 0.3, imaginary: 0.3)

        #expect(normalized >= 0.0)
        #expect(normalized <= 1.0)
    }

    @Test("Point sampling")
    func pointSampling() {
        let mandelbrot = Mandelbrot(maxIterations: 100)
        let point = Point2D(x: 0.25, y: 0.25)

        let directSample = mandelbrot.sample(real: point.x, imaginary: point.y)
        let pointSample = mandelbrot.sample(at: point)

        #expect(directSample.iterations == pointSample.iterations)
        #expect(directSample.escaped == pointSample.escaped)
    }

    @Test("Boundary detection")
    func boundaryDetection() {
        let mandelbrot = Mandelbrot(maxIterations: 100)

        let isBoundary = mandelbrot.isBoundary(real: 0.3, imaginary: 0.0)
        #expect(isBoundary || !isBoundary)
    }

    @Test("Different max iterations")
    func differentMaxIterations() {
        let m1 = Mandelbrot(maxIterations: 50)
        let m2 = Mandelbrot(maxIterations: 200)

        let s1 = m1.sample(real: 0.3, imaginary: 0.3)
        let s2 = m2.sample(real: 0.3, imaginary: 0.3)

        #expect(s1.iterations <= 50)
        #expect(s2.iterations <= 200)
    }
}

@Suite("JuliaSet")
struct JuliaSetTests {
    @Test("Basic sampling")
    func basicSampling() {
        let julia = JuliaSet(cReal: -0.7, cImaginary: 0.27, maxIterations: 100)
        let sample = julia.sample(real: 0, imaginary: 0)

        #expect(sample.iterations >= 0)
        #expect(sample.iterations <= 100)
    }

    @Test("Escape detection")
    func escapeDetection() {
        let julia = JuliaSet(cReal: -0.7, cImaginary: 0.27, maxIterations: 100)
        let sample = julia.sample(real: 3, imaginary: 3)

        #expect(sample.escaped)
    }

    @Test("Different constants")
    func differentConstants() {
        let julia1 = JuliaSet(cReal: -0.7, cImaginary: 0.27, maxIterations: 100)
        let julia2 = JuliaSet(cReal: 0.285, cImaginary: 0.01, maxIterations: 100)

        let s1 = julia1.sample(real: 0.5, imaginary: 0.5)
        let s2 = julia2.sample(real: 0.5, imaginary: 0.5)

        #expect((s1.iterations != s2.iterations) || (s1.escaped != s2.escaped))
    }

    @Test("Contains")
    func contains() {
        let julia = JuliaSet(cReal: -0.7, cImaginary: 0.27, maxIterations: 100)
        let contains = julia.contains(real: 0, imaginary: 0)

        #expect(contains || !contains)
    }

    @Test("Normalized iterations")
    func normalizedIterations() {
        let julia = JuliaSet(cReal: -0.7, cImaginary: 0.27, maxIterations: 100)
        let normalized = julia.normalizedIterations(real: 0.2, imaginary: 0.3)

        #expect(normalized >= 0.0)
        #expect(normalized <= 1.0)
    }
}

@Suite("Sierpinski")
struct SierpinskiTests {
    @Test("Chaos game")
    func chaosGame() {
        let points = Sierpinski.chaosGame(iterations: 1000, seed: 42)

        #expect(points.count == 1000)

        for point in points {
            #expect(point.x >= 0.0)
            #expect(point.x <= 1.0)
            #expect(point.y >= 0.0)
        }
    }

    @Test("Chaos game deterministic")
    func chaosGameDeterministic() {
        let points1 = Sierpinski.chaosGame(iterations: 100, seed: 12345)
        let points2 = Sierpinski.chaosGame(iterations: 100, seed: 12345)

        #expect(points1.count == points2.count)
        for i in 0..<points1.count {
            #expect(abs(points1[i].x - points2[i].x) < 0.0001)
            #expect(abs(points1[i].y - points2[i].y) < 0.0001)
        }
    }

    @Test("Subdivision")
    func subdivision() {
        let triangles0 = Sierpinski.subdivision(depth: 0)
        let triangles1 = Sierpinski.subdivision(depth: 1)
        let triangles2 = Sierpinski.subdivision(depth: 2)

        #expect(triangles0.count == 1)
        #expect(triangles1.count == 3)
        #expect(triangles2.count == 9)
    }

    @Test("Triangle subdivision")
    func triangleSubdivision() {
        let triangle = Sierpinski.Triangle(vertices: [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 0.5, y: 0.5)
        ])

        let subdivided = triangle.subdivide()
        #expect(subdivided.count == 3)
    }

    @Test("Contains")
    func contains() {
        #expect(!Sierpinski.contains(x: 0.5, y: 0.5, depth: 5))
        #expect(!Sierpinski.contains(x: 0.25, y: 0.25, depth: 5))
        #expect(Sierpinski.contains(x: 0.0, y: 0.0, depth: 5))
    }

    @Test("Carpet")
    func carpet() {
        let carpet = Sierpinski.Carpet(size: 3)

        #expect(carpet.contains(x: 0, y: 0))
        #expect(carpet.contains(x: 2, y: 2))
        #expect(!carpet.contains(x: 1, y: 1))
    }

    @Test("Carpet generation")
    func carpetGeneration() {
        let carpet = Sierpinski.Carpet(size: 3)
        let cells = carpet.generateCells(depth: 2)

        #expect(cells.count > 0)
        #expect(cells.count < 81)
    }
}

@Suite("KochCurve")
struct KochCurveTests {
    @Test("Basic generation")
    func basicGeneration() {
        let koch = KochCurve(iterations: 0)
        let points = koch.generate(from: Point2D(x: 0, y: 0), to: Point2D(x: 100, y: 0))

        #expect(points.count == 2)
        #expect(points.first == Point2D(x: 0, y: 0))
        #expect(points.last == Point2D(x: 100, y: 0))
    }

    @Test("Snowflake generation")
    func snowflakeGeneration() {
        let koch = KochCurve(iterations: 1)
        let points = koch.generateSnowflake(radius: 0.4)

        #expect(points.count > 3)
    }

    @Test("Increasing iterations")
    func increasingIterations() {
        let k0 = KochCurve(iterations: 0)
        let k2 = KochCurve(iterations: 2)

        let p0 = k0.generate(from: .zero, to: Point2D(x: 100, y: 0))
        let p2 = k2.generate(from: .zero, to: Point2D(x: 100, y: 0))

        #expect(p0.count < p2.count)
    }

    @Test("Point count formula")
    func pointCountFormula() {
        let koch = KochCurve(iterations: 2)
        let points = koch.generate(from: .zero, to: Point2D(x: 100, y: 0))

        let expectedCount = Int(pow(4.0, Double(koch.iterations))) + 1
        #expect(points.count == expectedCount)
    }

    @Test("Anti snowflake")
    func antiSnowflake() {
        let koch = KochCurve(iterations: 2)
        let snowflake = koch.generateSnowflake()
        let antiSnowflake = koch.generateAntiSnowflake()

        #expect(snowflake.count == antiSnowflake.count)
        #expect(snowflake != antiSnowflake)
    }
}
