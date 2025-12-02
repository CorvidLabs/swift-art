import Foundation

/// A two-dimensional point in Cartesian space.
public struct Point2D: Sendable, Hashable, Codable {
    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    /// The origin point (0, 0).
    public static let zero = Point2D(x: 0, y: 0)

    /// Calculates the Euclidean distance to another point.
    public func distance(to other: Point2D) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx * dx + dy * dy)
    }

    /// Calculates the Manhattan distance to another point.
    public func manhattanDistance(to other: Point2D) -> Double {
        abs(x - other.x) + abs(y - other.y)
    }

    /// Returns the magnitude (length) of this point as a vector from origin.
    public var magnitude: Double {
        sqrt(x * x + y * y)
    }

    /// Returns a normalized version of this point (unit vector).
    public func normalized() -> Point2D {
        let mag = magnitude
        guard mag > 0 else { return .zero }
        return Point2D(x: x / mag, y: y / mag)
    }

    /// Linearly interpolates between this point and another.
    public func lerp(to other: Point2D, t: Double) -> Point2D {
        Point2D(
            x: x + (other.x - x) * t,
            y: y + (other.y - y) * t
        )
    }
}

// MARK: - Operators

extension Point2D {
    public static func + (lhs: Point2D, rhs: Point2D) -> Point2D {
        Point2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: Point2D, rhs: Point2D) -> Point2D {
        Point2D(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func * (lhs: Point2D, rhs: Double) -> Point2D {
        Point2D(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    public static func * (lhs: Double, rhs: Point2D) -> Point2D {
        Point2D(x: lhs * rhs.x, y: lhs * rhs.y)
    }

    public static func / (lhs: Point2D, rhs: Double) -> Point2D {
        Point2D(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

// MARK: - Point3D

/// A three-dimensional point in Cartesian space.
public struct Point3D: Sendable, Hashable, Codable {
    public let x: Double
    public let y: Double
    public let z: Double

    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// The origin point (0, 0, 0).
    public static let zero = Point3D(x: 0, y: 0, z: 0)

    /// Calculates the Euclidean distance to another point.
    public func distance(to other: Point3D) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        let dz = z - other.z
        return sqrt(dx * dx + dy * dy + dz * dz)
    }

    /// Calculates the Manhattan distance to another point.
    public func manhattanDistance(to other: Point3D) -> Double {
        abs(x - other.x) + abs(y - other.y) + abs(z - other.z)
    }

    /// Returns the magnitude (length) of this point as a vector from origin.
    public var magnitude: Double {
        sqrt(x * x + y * y + z * z)
    }

    /// Returns a normalized version of this point (unit vector).
    public func normalized() -> Point3D {
        let mag = magnitude
        guard mag > 0 else { return .zero }
        return Point3D(x: x / mag, y: y / mag, z: z / mag)
    }

    /// Linearly interpolates between this point and another.
    public func lerp(to other: Point3D, t: Double) -> Point3D {
        Point3D(
            x: x + (other.x - x) * t,
            y: y + (other.y - y) * t,
            z: z + (other.z - z) * t
        )
    }

    /// Computes the dot product with another point.
    public func dot(_ other: Point3D) -> Double {
        x * other.x + y * other.y + z * other.z
    }

    /// Computes the cross product with another point.
    public func cross(_ other: Point3D) -> Point3D {
        Point3D(
            x: y * other.z - z * other.y,
            y: z * other.x - x * other.z,
            z: x * other.y - y * other.x
        )
    }
}

// MARK: - Operators

extension Point3D {
    public static func + (lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func - (lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    public static func * (lhs: Point3D, rhs: Double) -> Point3D {
        Point3D(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    public static func * (lhs: Double, rhs: Point3D) -> Point3D {
        Point3D(x: lhs * rhs.x, y: lhs * rhs.y, z: lhs * rhs.z)
    }

    public static func / (lhs: Point3D, rhs: Double) -> Point3D {
        Point3D(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
}
