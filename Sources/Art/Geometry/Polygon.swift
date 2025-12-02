import Foundation

/// A polygon defined by a list of vertices.
public struct Polygon: Sendable, Hashable {
    public let vertices: [Point2D]

    public init(vertices: [Point2D]) {
        self.vertices = vertices
    }

    /// Number of vertices/sides.
    public var vertexCount: Int {
        vertices.count
    }

    /// Calculates the perimeter of the polygon.
    public var perimeter: Double {
        guard vertices.count >= 2 else { return 0 }

        var total = 0.0
        for i in 0..<vertices.count {
            let next = (i + 1) % vertices.count
            total += vertices[i].distance(to: vertices[next])
        }
        return total
    }

    /// Calculates the area of the polygon using the shoelace formula.
    public var area: Double {
        guard vertices.count >= 3 else { return 0 }

        var sum = 0.0
        for i in 0..<vertices.count {
            let next = (i + 1) % vertices.count
            sum += vertices[i].x * vertices[next].y
            sum -= vertices[next].x * vertices[i].y
        }
        return abs(sum) / 2.0
    }

    /// Calculates the centroid of the polygon.
    public var centroid: Point2D {
        guard !vertices.isEmpty else { return .zero }

        let sumX = vertices.reduce(0.0) { $0 + $1.x }
        let sumY = vertices.reduce(0.0) { $0 + $1.y }

        return Point2D(
            x: sumX / Double(vertices.count),
            y: sumY / Double(vertices.count)
        )
    }

    /// Returns the line segments that make up the polygon.
    public var edges: [LineSegment] {
        guard vertices.count >= 2 else { return [] }

        return (0..<vertices.count).map { i in
            let next = (i + 1) % vertices.count
            return LineSegment(start: vertices[i], end: vertices[next])
        }
    }

    /// Checks if a point is inside the polygon using ray casting.
    public func contains(_ point: Point2D) -> Bool {
        guard vertices.count >= 3 else { return false }

        var inside = false
        var j = vertices.count - 1

        for i in 0..<vertices.count {
            let vi = vertices[i]
            let vj = vertices[j]

            if ((vi.y > point.y) != (vj.y > point.y)) &&
               (point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x) {
                inside.toggle()
            }
            j = i
        }

        return inside
    }
}

// MARK: - Regular Polygon Generation

extension Polygon {
    /// Creates a regular polygon with the given number of sides.
    public static func regular(
        sides: Int,
        radius: Double,
        center: Point2D = .zero,
        rotation: Double = 0
    ) -> Polygon {
        precondition(sides >= 3, "Polygon must have at least 3 sides")

        let vertices = (0..<sides).map { i in
            let angle = 2.0 * .pi * Double(i) / Double(sides) + rotation
            return Point2D(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
        }

        return Polygon(vertices: vertices)
    }

    /// Creates a regular star polygon.
    public static func star(
        points: Int,
        outerRadius: Double,
        innerRadius: Double,
        center: Point2D = .zero,
        rotation: Double = 0
    ) -> Polygon {
        precondition(points >= 3, "Star must have at least 3 points")

        let vertices = (0..<(points * 2)).map { i in
            let angle = .pi * Double(i) / Double(points) + rotation
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            return Point2D(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
        }

        return Polygon(vertices: vertices)
    }
}

// MARK: - Common Polygons

extension Polygon {
    /// An equilateral triangle.
    public static func triangle(radius: Double, center: Point2D = .zero, rotation: Double = 0) -> Polygon {
        regular(sides: 3, radius: radius, center: center, rotation: rotation)
    }

    /// A square.
    public static func square(size: Double, center: Point2D = .zero, rotation: Double = 0) -> Polygon {
        let radius = size / sqrt(2.0)
        return regular(sides: 4, radius: radius, center: center, rotation: rotation + .pi / 4)
    }

    /// A regular pentagon.
    public static func pentagon(radius: Double, center: Point2D = .zero, rotation: Double = 0) -> Polygon {
        regular(sides: 5, radius: radius, center: center, rotation: rotation)
    }

    /// A regular hexagon.
    public static func hexagon(radius: Double, center: Point2D = .zero, rotation: Double = 0) -> Polygon {
        regular(sides: 6, radius: radius, center: center, rotation: rotation)
    }

    /// A regular octagon.
    public static func octagon(radius: Double, center: Point2D = .zero, rotation: Double = 0) -> Polygon {
        regular(sides: 8, radius: radius, center: center, rotation: rotation)
    }
}
