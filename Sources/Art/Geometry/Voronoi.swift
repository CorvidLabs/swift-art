import Foundation

/// Voronoi diagram generation and querying.
public struct Voronoi: Sendable {
    public let sites: [Point2D]

    public init(sites: [Point2D]) {
        self.sites = sites
    }

    /// Finds the nearest site to the given point.
    public func nearestSite(to point: Point2D) -> (index: Int, site: Point2D)? {
        guard !sites.isEmpty else { return nil }

        var minDistance = Double.infinity
        var nearestIndex = 0

        for (index, site) in sites.enumerated() {
            let distance = point.distance(to: site)
            if distance < minDistance {
                minDistance = distance
                nearestIndex = index
            }
        }

        return (nearestIndex, sites[nearestIndex])
    }

    /// Returns the index of the cell containing the given point.
    public func cellIndex(for point: Point2D) -> Int? {
        nearestSite(to: point)?.index
    }

    /// Generates a rasterized Voronoi diagram.
    public func rasterize(width: Int, height: Int, bounds: Rectangle) -> [[Int]] {
        var grid = Array(repeating: Array(repeating: 0, count: width), count: height)

        for y in 0..<height {
            for x in 0..<width {
                let point = Point2D(
                    x: bounds.origin.x + (Double(x) / Double(width)) * bounds.width,
                    y: bounds.origin.y + (Double(y) / Double(height)) * bounds.height
                )

                if let index = cellIndex(for: point) {
                    grid[y][x] = index
                }
            }
        }

        return grid
    }

    /// Generates cell boundaries using edge detection.
    public func generateEdges(width: Int, height: Int, bounds: Rectangle) -> [LineSegment] {
        let grid = rasterize(width: width, height: height, bounds: bounds)
        var edges: [LineSegment] = []

        for y in 0..<height - 1 {
            for x in 0..<width - 1 {
                let current = grid[y][x]

                if grid[y][x + 1] != current {
                    let start = Point2D(
                        x: bounds.origin.x + (Double(x + 1) / Double(width)) * bounds.width,
                        y: bounds.origin.y + (Double(y) / Double(height)) * bounds.height
                    )
                    let end = Point2D(
                        x: bounds.origin.x + (Double(x + 1) / Double(width)) * bounds.width,
                        y: bounds.origin.y + (Double(y + 1) / Double(height)) * bounds.height
                    )
                    edges.append(LineSegment(start: start, end: end))
                }

                if grid[y + 1][x] != current {
                    let start = Point2D(
                        x: bounds.origin.x + (Double(x) / Double(width)) * bounds.width,
                        y: bounds.origin.y + (Double(y + 1) / Double(height)) * bounds.height
                    )
                    let end = Point2D(
                        x: bounds.origin.x + (Double(x + 1) / Double(width)) * bounds.width,
                        y: bounds.origin.y + (Double(y + 1) / Double(height)) * bounds.height
                    )
                    edges.append(LineSegment(start: start, end: end))
                }
            }
        }

        return edges
    }

    /// Computes the distance to the nearest site at the given point.
    public func distanceField(at point: Point2D) -> Double {
        guard let (_, site) = nearestSite(to: point) else { return 0 }
        return point.distance(to: site)
    }

    /// Generates a random Voronoi diagram with the specified number of sites.
    public static func random(
        siteCount: Int,
        bounds: Rectangle,
        seed: UInt64? = nil
    ) -> Voronoi {
        var rng = RandomSource(seed: seed ?? UInt64(Date().timeIntervalSince1970 * 1_000_000))

        let sites = (0..<siteCount).map { _ in
            Point2D(
                x: bounds.origin.x + rng.nextDouble() * bounds.width,
                y: bounds.origin.y + rng.nextDouble() * bounds.height
            )
        }

        return Voronoi(sites: sites)
    }

    /// Lloyd's relaxation algorithm for more evenly distributed sites.
    public func relax(iterations: Int, bounds: Rectangle, samplesPerCell: Int = 100) -> Voronoi {
        var currentSites = sites

        for _ in 0..<iterations {
            var cellPoints: [[Point2D]] = Array(repeating: [], count: currentSites.count)

            for _ in 0..<(samplesPerCell * currentSites.count) {
                var rng = RandomSource(seed: UInt64(Date().timeIntervalSince1970 * 1_000_000))
                let point = Point2D(
                    x: bounds.origin.x + rng.nextDouble() * bounds.width,
                    y: bounds.origin.y + rng.nextDouble() * bounds.height
                )

                let voronoi = Voronoi(sites: currentSites)
                if let index = voronoi.cellIndex(for: point) {
                    cellPoints[index].append(point)
                }
            }

            currentSites = cellPoints.map { points in
                guard !points.isEmpty else { return .zero }
                let sumX = points.reduce(0.0) { $0 + $1.x }
                let sumY = points.reduce(0.0) { $0 + $1.y }
                return Point2D(x: sumX / Double(points.count), y: sumY / Double(points.count))
            }
        }

        return Voronoi(sites: currentSites)
    }
}

// MARK: - Voronoi Cell

/// Represents a single cell in a Voronoi diagram.
public struct VoronoiCell: Sendable {
    public let site: Point2D
    public let vertices: [Point2D]

    public init(site: Point2D, vertices: [Point2D]) {
        self.site = site
        self.vertices = vertices
    }

    /// Area of the cell.
    public var area: Double {
        guard vertices.count >= 3 else { return 0 }
        return Polygon(vertices: vertices).area
    }

    /// Perimeter of the cell.
    public var perimeter: Double {
        Polygon(vertices: vertices).perimeter
    }

    /// Centroid of the cell.
    public var centroid: Point2D {
        Polygon(vertices: vertices).centroid
    }
}
