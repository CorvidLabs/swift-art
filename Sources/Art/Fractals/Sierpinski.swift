import Foundation

/// Sierpinski triangle and carpet fractals.
public enum Sierpinski: Sendable {
    /// Generates points for the Sierpinski triangle using the chaos game method.
    public static func chaosGame(iterations: Int, seed: UInt64? = nil) -> [Point2D] {
        var rng = RandomSource(seed: seed ?? UInt64(Date().timeIntervalSince1970 * 1_000_000))
        var points: [Point2D] = []

        let vertices = [
            Point2D(x: 0.0, y: 0.0),
            Point2D(x: 1.0, y: 0.0),
            Point2D(x: 0.5, y: sqrt(3.0) / 2.0)
        ]

        var current = Point2D(x: rng.nextDouble(), y: rng.nextDouble())

        for _ in 0..<iterations {
            guard let vertex = rng.nextElement(from: vertices) else { continue }
            current = Point2D(
                x: (current.x + vertex.x) / 2.0,
                y: (current.y + vertex.y) / 2.0
            )
            points.append(current)
        }

        return points
    }

    /// Generates triangles for the Sierpinski triangle using subdivision.
    public struct Triangle: Sendable {
        public let vertices: [Point2D]

        public init(vertices: [Point2D]) {
            self.vertices = vertices
        }

        public func subdivide() -> [Triangle] {
            guard vertices.count == 3 else { return [] }

            let mid01 = Point2D(
                x: (vertices[0].x + vertices[1].x) / 2.0,
                y: (vertices[0].y + vertices[1].y) / 2.0
            )
            let mid12 = Point2D(
                x: (vertices[1].x + vertices[2].x) / 2.0,
                y: (vertices[1].y + vertices[2].y) / 2.0
            )
            let mid20 = Point2D(
                x: (vertices[2].x + vertices[0].x) / 2.0,
                y: (vertices[2].y + vertices[0].y) / 2.0
            )

            return [
                Triangle(vertices: [vertices[0], mid01, mid20]),
                Triangle(vertices: [mid01, vertices[1], mid12]),
                Triangle(vertices: [mid20, mid12, vertices[2]])
            ]
        }
    }

    /// Generates Sierpinski triangle using recursive subdivision.
    public static func subdivision(depth: Int) -> [Triangle] {
        let initialTriangle = Triangle(vertices: [
            Point2D(x: 0.0, y: 0.0),
            Point2D(x: 1.0, y: 0.0),
            Point2D(x: 0.5, y: sqrt(3.0) / 2.0)
        ])

        guard depth > 0 else { return [initialTriangle] }

        var triangles = [initialTriangle]

        for _ in 0..<depth {
            triangles = triangles.flatMap { $0.subdivide() }
        }

        return triangles
    }

    /// Checks if a point is in the Sierpinski triangle using recursive subdivision test.
    public static func contains(x: Double, y: Double, depth: Int = 8) -> Bool {
        var currentX = x
        var currentY = y

        for _ in 0..<depth {
            currentX *= 2.0
            currentY *= 2.0

            if currentX >= 1.0 && currentY >= 1.0 {
                return false
            }

            if currentX >= 1.0 {
                currentX -= 1.0
            }
            if currentY >= 1.0 {
                currentY -= 1.0
            }
        }

        return true
    }

    /// Sierpinski carpet generation and testing.
    public struct Carpet: Sendable {
        public let size: Int

        public init(size: Int = 3) {
            self.size = size
        }

        /// Checks if a coordinate is in the Sierpinski carpet.
        public func contains(x: Int, y: Int) -> Bool {
            var currentX = x
            var currentY = y

            while currentX > 0 || currentY > 0 {
                if currentX % 3 == 1 && currentY % 3 == 1 {
                    return false
                }
                currentX /= 3
                currentY /= 3
            }

            return true
        }

        /// Generates coordinates for all filled cells at the given depth.
        public func generateCells(depth: Int) -> [Point2D] {
            let gridSize = Int(pow(Double(size), Double(depth)))
            var cells: [Point2D] = []

            for y in 0..<gridSize {
                for x in 0..<gridSize {
                    if contains(x: x, y: y) {
                        cells.append(Point2D(
                            x: Double(x) / Double(gridSize),
                            y: Double(y) / Double(gridSize)
                        ))
                    }
                }
            }

            return cells
        }
    }
}
