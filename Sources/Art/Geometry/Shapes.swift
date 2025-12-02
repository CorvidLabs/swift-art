import Foundation

/// A triangle defined by three vertices.
public struct Triangle: Sendable, Hashable {
    public let vertices: [Point2D]

    public init(vertices: [Point2D]) {
        precondition(vertices.count == 3, "Triangle must have exactly 3 vertices")
        self.vertices = vertices
    }

    public init(p1: Point2D, p2: Point2D, p3: Point2D) {
        self.vertices = [p1, p2, p3]
    }

    /// Calculates the area of the triangle.
    public var area: Double {
        let a = vertices[0]
        let b = vertices[1]
        let c = vertices[2]

        return abs((b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)) / 2.0
    }

    /// Calculates the perimeter of the triangle.
    public var perimeter: Double {
        vertices[0].distance(to: vertices[1]) +
        vertices[1].distance(to: vertices[2]) +
        vertices[2].distance(to: vertices[0])
    }

    /// Calculates the centroid (center of mass) of the triangle.
    public var centroid: Point2D {
        Point2D(
            x: (vertices[0].x + vertices[1].x + vertices[2].x) / 3.0,
            y: (vertices[0].y + vertices[1].y + vertices[2].y) / 3.0
        )
    }

    /// Checks if a point is inside the triangle.
    public func contains(_ point: Point2D) -> Bool {
        let v0 = vertices[2] - vertices[0]
        let v1 = vertices[1] - vertices[0]
        let v2 = point - vertices[0]

        let dot00 = v0.x * v0.x + v0.y * v0.y
        let dot01 = v0.x * v1.x + v0.y * v1.y
        let dot02 = v0.x * v2.x + v0.y * v2.y
        let dot11 = v1.x * v1.x + v1.y * v1.y
        let dot12 = v1.x * v2.x + v1.y * v2.y

        let invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01)
        let u = (dot11 * dot02 - dot01 * dot12) * invDenom
        let v = (dot00 * dot12 - dot01 * dot02) * invDenom

        return (u >= 0) && (v >= 0) && (u + v <= 1)
    }
}

// MARK: - Rectangle

/// A rectangle defined by position and size.
public struct Rectangle: Sendable, Hashable {
    public let origin: Point2D
    public let width: Double
    public let height: Double

    public init(origin: Point2D, width: Double, height: Double) {
        self.origin = origin
        self.width = width
        self.height = height
    }

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.origin = Point2D(x: x, y: y)
        self.width = width
        self.height = height
    }

    /// Center point of the rectangle.
    public var center: Point2D {
        Point2D(
            x: origin.x + width / 2.0,
            y: origin.y + height / 2.0
        )
    }

    /// Area of the rectangle.
    public var area: Double {
        width * height
    }

    /// Perimeter of the rectangle.
    public var perimeter: Double {
        2.0 * (width + height)
    }

    /// Minimum point (bottom-left corner).
    public var minPoint: Point2D {
        origin
    }

    /// Maximum point (top-right corner).
    public var maxPoint: Point2D {
        Point2D(x: origin.x + width, y: origin.y + height)
    }

    /// All four corners of the rectangle.
    public var corners: [Point2D] {
        [
            origin,
            Point2D(x: origin.x + width, y: origin.y),
            Point2D(x: origin.x + width, y: origin.y + height),
            Point2D(x: origin.x, y: origin.y + height)
        ]
    }

    /// Checks if a point is inside the rectangle.
    public func contains(_ point: Point2D) -> Bool {
        point.x >= origin.x &&
        point.x <= origin.x + width &&
        point.y >= origin.y &&
        point.y <= origin.y + height
    }

    /// Checks if this rectangle intersects with another.
    public func intersects(_ other: Rectangle) -> Bool {
        !(maxPoint.x < other.minPoint.x ||
          minPoint.x > other.maxPoint.x ||
          maxPoint.y < other.minPoint.y ||
          minPoint.y > other.maxPoint.y)
    }

    /// Returns the intersection of this rectangle with another.
    public func intersection(_ other: Rectangle) -> Rectangle? {
        guard intersects(other) else { return nil }

        let x = Swift.max(minPoint.x, other.minPoint.x)
        let y = Swift.max(minPoint.y, other.minPoint.y)
        let maxX = Swift.min(maxPoint.x, other.maxPoint.x)
        let maxY = Swift.min(maxPoint.y, other.maxPoint.y)

        return Rectangle(
            x: x,
            y: y,
            width: maxX - x,
            height: maxY - y
        )
    }
}

// MARK: - Line Segment

/// A line segment defined by two endpoints.
public struct LineSegment: Sendable, Hashable {
    public let start: Point2D
    public let end: Point2D

    public init(start: Point2D, end: Point2D) {
        self.start = start
        self.end = end
    }

    /// Length of the line segment.
    public var length: Double {
        start.distance(to: end)
    }

    /// Midpoint of the line segment.
    public var midpoint: Point2D {
        Point2D(
            x: (start.x + end.x) / 2.0,
            y: (start.y + end.y) / 2.0
        )
    }

    /// Direction vector of the line segment.
    public var direction: Point2D {
        end - start
    }

    /// Normalized direction vector.
    public var normalizedDirection: Point2D {
        direction.normalized()
    }

    /// Returns a point at the given parameter t [0, 1] along the line.
    public func point(at t: Double) -> Point2D {
        start.lerp(to: end, t: t)
    }

    /// Calculates the closest point on the line segment to the given point.
    public func closestPoint(to point: Point2D) -> Point2D {
        let dir = direction
        let lengthSquared = dir.x * dir.x + dir.y * dir.y

        guard lengthSquared > 0 else { return start }

        let t = ((point.x - start.x) * dir.x + (point.y - start.y) * dir.y) / lengthSquared
        let clampedT = max(0, min(1, t))

        return self.point(at: clampedT)
    }

    /// Calculates the distance from the line segment to a point.
    public func distance(to point: Point2D) -> Double {
        closestPoint(to: point).distance(to: point)
    }

    /// Checks if this line segment intersects with another.
    public func intersects(_ other: LineSegment) -> Bool {
        intersection(with: other) != nil
    }

    /// Returns the intersection point with another line segment, if any.
    public func intersection(with other: LineSegment) -> Point2D? {
        let p1 = start
        let p2 = end
        let p3 = other.start
        let p4 = other.end

        let d = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)

        guard abs(d) > 1e-10 else { return nil }

        let t = ((p1.x - p3.x) * (p3.y - p4.y) - (p1.y - p3.y) * (p3.x - p4.x)) / d
        let u = ((p1.x - p3.x) * (p1.y - p2.y) - (p1.y - p3.y) * (p1.x - p2.x)) / d

        guard t >= 0 && t <= 1 && u >= 0 && u <= 1 else { return nil }

        return Point2D(
            x: p1.x + t * (p2.x - p1.x),
            y: p1.y + t * (p2.y - p1.y)
        )
    }
}

// MARK: - Circle

/// A circle defined by center and radius.
public struct Circle: Sendable, Hashable {
    public let center: Point2D
    public let radius: Double

    public init(center: Point2D, radius: Double) {
        self.center = center
        self.radius = radius
    }

    /// Area of the circle.
    public var area: Double {
        .pi * radius * radius
    }

    /// Circumference of the circle.
    public var circumference: Double {
        2.0 * .pi * radius
    }

    /// Checks if a point is inside the circle.
    public func contains(_ point: Point2D) -> Bool {
        center.distance(to: point) <= radius
    }

    /// Checks if this circle intersects with another.
    public func intersects(_ other: Circle) -> Bool {
        center.distance(to: other.center) <= radius + other.radius
    }

    /// Returns a point on the circle at the given angle (in radians).
    public func point(at angle: Double) -> Point2D {
        Point2D(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
    }

    /// Returns points evenly distributed around the circle.
    public func points(count: Int) -> [Point2D] {
        (0..<count).map { i in
            let angle = 2.0 * .pi * Double(i) / Double(count)
            return point(at: angle)
        }
    }
}
