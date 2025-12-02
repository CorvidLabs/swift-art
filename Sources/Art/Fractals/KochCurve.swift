import Foundation

/// Koch curve and snowflake fractals.
public struct KochCurve: Sendable {
    public let iterations: Int

    public init(iterations: Int = 4) {
        self.iterations = iterations
    }

    /// Generates points for the Koch curve between two points.
    public func generate(from start: Point2D, to end: Point2D) -> [Point2D] {
        var points = [start, end]

        for _ in 0..<iterations {
            points = subdivide(points: points)
        }

        return points
    }

    /// Subdivides a line segment into the Koch curve pattern.
    private func subdivide(points: [Point2D]) -> [Point2D] {
        var result: [Point2D] = []

        for i in 0..<(points.count - 1) {
            let p1 = points[i]
            let p2 = points[i + 1]

            let oneThird = Point2D(
                x: p1.x + (p2.x - p1.x) / 3.0,
                y: p1.y + (p2.y - p1.y) / 3.0
            )

            let twoThirds = Point2D(
                x: p1.x + 2.0 * (p2.x - p1.x) / 3.0,
                y: p1.y + 2.0 * (p2.y - p1.y) / 3.0
            )

            let dx = twoThirds.x - oneThird.x
            let dy = twoThirds.y - oneThird.y

            let peak = Point2D(
                x: oneThird.x + dx * cos(.pi / 3.0) - dy * sin(.pi / 3.0),
                y: oneThird.y + dx * sin(.pi / 3.0) + dy * cos(.pi / 3.0)
            )

            result.append(p1)
            result.append(oneThird)
            result.append(peak)
            result.append(twoThirds)
        }

        result.append(points[points.count - 1])
        return result
    }

    /// Generates a Koch snowflake (three Koch curves forming a triangle).
    public func generateSnowflake(center: Point2D = Point2D(x: 0.5, y: 0.5), radius: Double = 0.4) -> [Point2D] {
        let angle1 = -.pi / 2.0
        let angle2 = angle1 + 2.0 * .pi / 3.0
        let angle3 = angle2 + 2.0 * .pi / 3.0

        let p1 = Point2D(
            x: center.x + radius * cos(angle1),
            y: center.y + radius * sin(angle1)
        )
        let p2 = Point2D(
            x: center.x + radius * cos(angle2),
            y: center.y + radius * sin(angle2)
        )
        let p3 = Point2D(
            x: center.x + radius * cos(angle3),
            y: center.y + radius * sin(angle3)
        )

        let side1 = generate(from: p1, to: p2)
        let side2 = generate(from: p2, to: p3)
        let side3 = generate(from: p3, to: p1)

        return side1 + side2.dropFirst() + side3.dropFirst()
    }

    /// Generates an anti-snowflake (inverted Koch snowflake).
    public func generateAntiSnowflake(center: Point2D = Point2D(x: 0.5, y: 0.5), radius: Double = 0.4) -> [Point2D] {
        let angle1 = -.pi / 2.0
        let angle2 = angle1 + 2.0 * .pi / 3.0
        let angle3 = angle2 + 2.0 * .pi / 3.0

        let p1 = Point2D(
            x: center.x + radius * cos(angle1),
            y: center.y + radius * sin(angle1)
        )
        let p2 = Point2D(
            x: center.x + radius * cos(angle2),
            y: center.y + radius * sin(angle2)
        )
        let p3 = Point2D(
            x: center.x + radius * cos(angle3),
            y: center.y + radius * sin(angle3)
        )

        let side1 = generate(from: p2, to: p1).reversed()
        let side2 = generate(from: p3, to: p2).reversed()
        let side3 = generate(from: p1, to: p3).reversed()

        return Array(side1) + Array(side2.dropFirst()) + Array(side3.dropFirst())
    }
}
