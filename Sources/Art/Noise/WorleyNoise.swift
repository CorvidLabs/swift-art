import Foundation

/// Cellular/Voronoi noise using Worley noise algorithm.
public struct WorleyNoise: NoiseGenerator, Sendable {
    private let seed: UInt64
    private let distanceFunction: DistanceFunction

    public enum DistanceFunction: Sendable {
        case euclidean
        case manhattan
        case chebyshev
        case minkowski(p: Double)

        func distance(from p1: Point2D, to p2: Point2D) -> Double {
            switch self {
            case .euclidean:
                return p1.distance(to: p2)
            case .manhattan:
                return p1.manhattanDistance(to: p2)
            case .chebyshev:
                return max(abs(p1.x - p2.x), abs(p1.y - p2.y))
            case .minkowski(let p):
                let dx = abs(p1.x - p2.x)
                let dy = abs(p1.y - p2.y)
                return pow(pow(dx, p) + pow(dy, p), 1.0 / p)
            }
        }

        func distance(from p1: Point3D, to p2: Point3D) -> Double {
            switch self {
            case .euclidean:
                return p1.distance(to: p2)
            case .manhattan:
                return p1.manhattanDistance(to: p2)
            case .chebyshev:
                return max(abs(p1.x - p2.x), abs(p1.y - p2.y), abs(p1.z - p2.z))
            case .minkowski(let p):
                let dx = abs(p1.x - p2.x)
                let dy = abs(p1.y - p2.y)
                let dz = abs(p1.z - p2.z)
                return pow(pow(dx, p) + pow(dy, p) + pow(dz, p), 1.0 / p)
            }
        }
    }

    public init(seed: UInt64? = nil, distanceFunction: DistanceFunction = .euclidean) {
        self.seed = seed ?? UInt64(Date().timeIntervalSince1970 * 1_000_000)
        self.distanceFunction = distanceFunction
    }

    public func sample(x: Double, y: Double) -> Double {
        let cellX = Int(floor(x))
        let cellY = Int(floor(y))

        var minDistance = Double.infinity

        for offsetY in -1...1 {
            for offsetX in -1...1 {
                let neighborX = cellX + offsetX
                let neighborY = cellY + offsetY

                let featurePoint = getFeaturePoint2D(cellX: neighborX, cellY: neighborY)
                let point = Point2D(
                    x: Double(neighborX) + featurePoint.x,
                    y: Double(neighborY) + featurePoint.y
                )

                let distance = distanceFunction.distance(
                    from: Point2D(x: x, y: y),
                    to: point
                )
                minDistance = min(minDistance, distance)
            }
        }

        return minDistance
    }

    public func sample(x: Double, y: Double, z: Double) -> Double {
        let cellX = Int(floor(x))
        let cellY = Int(floor(y))
        let cellZ = Int(floor(z))

        var minDistance = Double.infinity

        for offsetZ in -1...1 {
            for offsetY in -1...1 {
                for offsetX in -1...1 {
                    let neighborX = cellX + offsetX
                    let neighborY = cellY + offsetY
                    let neighborZ = cellZ + offsetZ

                    let featurePoint = getFeaturePoint3D(cellX: neighborX, cellY: neighborY, cellZ: neighborZ)
                    let point = Point3D(
                        x: Double(neighborX) + featurePoint.x,
                        y: Double(neighborY) + featurePoint.y,
                        z: Double(neighborZ) + featurePoint.z
                    )

                    let distance = distanceFunction.distance(
                        from: Point3D(x: x, y: y, z: z),
                        to: point
                    )
                    minDistance = min(minDistance, distance)
                }
            }
        }

        return minDistance
    }

    /// Returns multiple closest distances for more advanced effects.
    public func sampleDistances(x: Double, y: Double, count: Int = 2) -> [Double] {
        let cellX = Int(floor(x))
        let cellY = Int(floor(y))

        var distances: [Double] = []

        for offsetY in -1...1 {
            for offsetX in -1...1 {
                let neighborX = cellX + offsetX
                let neighborY = cellY + offsetY

                let featurePoint = getFeaturePoint2D(cellX: neighborX, cellY: neighborY)
                let point = Point2D(
                    x: Double(neighborX) + featurePoint.x,
                    y: Double(neighborY) + featurePoint.y
                )

                let distance = distanceFunction.distance(
                    from: Point2D(x: x, y: y),
                    to: point
                )
                distances.append(distance)
            }
        }

        return distances.sorted().prefix(count).map { $0 }
    }

    private func getFeaturePoint2D(cellX: Int, cellY: Int) -> Point2D {
        let hash = hashCoordinates(x: cellX, y: cellY, seed: seed)
        var rng = RandomSource(seed: hash)
        return Point2D(x: rng.nextDouble(), y: rng.nextDouble())
    }

    private func getFeaturePoint3D(cellX: Int, cellY: Int, cellZ: Int) -> Point3D {
        let hash = hashCoordinates3D(x: cellX, y: cellY, z: cellZ, seed: seed)
        var rng = RandomSource(seed: hash)
        return Point3D(x: rng.nextDouble(), y: rng.nextDouble(), z: rng.nextDouble())
    }

    private func hashCoordinates(x: Int, y: Int, seed: UInt64) -> UInt64 {
        var hash = seed
        hash ^= UInt64(bitPattern: Int64(x)) &* 0x9e3779b97f4a7c15
        hash ^= UInt64(bitPattern: Int64(y)) &* 0xbf58476d1ce4e5b9
        hash ^= hash >> 27
        hash &*= 0x94d049bb133111eb
        return hash
    }

    private func hashCoordinates3D(x: Int, y: Int, z: Int, seed: UInt64) -> UInt64 {
        var hash = seed
        hash ^= UInt64(bitPattern: Int64(x)) &* 0x9e3779b97f4a7c15
        hash ^= UInt64(bitPattern: Int64(y)) &* 0xbf58476d1ce4e5b9
        hash ^= UInt64(bitPattern: Int64(z)) &* 0x94d049bb133111eb
        hash ^= hash >> 27
        hash &*= 0x6c62272e07bb0142
        return hash
    }
}
