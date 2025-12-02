import Foundation

/// Tessellation patterns for tiling planes.
public enum Tessellation {
    /// Generates a square grid tessellation.
    public static func squareGrid(
        width: Int,
        height: Int,
        cellSize: Double,
        origin: Point2D = .zero
    ) -> [Rectangle] {
        var rectangles: [Rectangle] = []

        for y in 0..<height {
            for x in 0..<width {
                let rect = Rectangle(
                    x: origin.x + Double(x) * cellSize,
                    y: origin.y + Double(y) * cellSize,
                    width: cellSize,
                    height: cellSize
                )
                rectangles.append(rect)
            }
        }

        return rectangles
    }

    /// Generates a hexagonal tessellation.
    public static func hexagonalGrid(
        rows: Int,
        columns: Int,
        radius: Double,
        origin: Point2D = .zero
    ) -> [Polygon] {
        var hexagons: [Polygon] = []

        let width = sqrt(3.0) * radius
        let height = 2.0 * radius
        let verticalSpacing = height * 0.75

        for row in 0..<rows {
            for col in 0..<columns {
                let x = origin.x + Double(col) * width + (row % 2 == 1 ? width / 2.0 : 0)
                let y = origin.y + Double(row) * verticalSpacing

                let center = Point2D(x: x, y: y)
                let hexagon = Polygon.hexagon(radius: radius, center: center)
                hexagons.append(hexagon)
            }
        }

        return hexagons
    }

    /// Generates a triangular tessellation.
    public static func triangularGrid(
        rows: Int,
        columns: Int,
        sideLength: Double,
        origin: Point2D = .zero
    ) -> [Triangle] {
        var triangles: [Triangle] = []

        let height = sideLength * sqrt(3.0) / 2.0
        let width = sideLength / 2.0

        for row in 0..<rows {
            for col in 0..<columns {
                let x = origin.x + Double(col) * sideLength
                let y = origin.y + Double(row) * height

                if (row + col) % 2 == 0 {
                    let p1 = Point2D(x: x, y: y)
                    let p2 = Point2D(x: x + sideLength, y: y)
                    let p3 = Point2D(x: x + width, y: y + height)
                    triangles.append(Triangle(p1: p1, p2: p2, p3: p3))
                } else {
                    let p1 = Point2D(x: x, y: y + height)
                    let p2 = Point2D(x: x + width, y: y)
                    let p3 = Point2D(x: x + sideLength, y: y + height)
                    triangles.append(Triangle(p1: p1, p2: p2, p3: p3))
                }
            }
        }

        return triangles
    }

    /// Generates a brick pattern tessellation.
    public static func brickPattern(
        rows: Int,
        columns: Int,
        brickWidth: Double,
        brickHeight: Double,
        offset: Double = 0.5,
        origin: Point2D = .zero
    ) -> [Rectangle] {
        var rectangles: [Rectangle] = []

        for row in 0..<rows {
            let rowOffset = row % 2 == 1 ? brickWidth * offset : 0

            for col in 0..<columns {
                let x = origin.x + Double(col) * brickWidth + rowOffset
                let y = origin.y + Double(row) * brickHeight

                rectangles.append(Rectangle(
                    x: x,
                    y: y,
                    width: brickWidth,
                    height: brickHeight
                ))
            }
        }

        return rectangles
    }

    /// Generates a Penrose tiling (aperiodic tiling).
    public static func penroseTiling(
        iterations: Int,
        scale: Double,
        center: Point2D = .zero
    ) -> [Triangle] {
        enum TileType {
            case thin
            case thick
        }

        struct PenroseTile {
            let type: TileType
            let vertices: [Point2D]
        }

        let goldenRatio = (1.0 + sqrt(5.0)) / 2.0

        func subdivide(tile: PenroseTile) -> [PenroseTile] {
            let a = tile.vertices[0]
            let b = tile.vertices[1]
            let c = tile.vertices[2]

            switch tile.type {
            case .thin:
                let p = a.lerp(to: b, t: 1.0 / goldenRatio)
                return [
                    PenroseTile(type: .thick, vertices: [c, p, b]),
                    PenroseTile(type: .thin, vertices: [p, c, a])
                ]
            case .thick:
                let q = b.lerp(to: a, t: 1.0 / goldenRatio)
                let r = b.lerp(to: c, t: 1.0 / goldenRatio)
                return [
                    PenroseTile(type: .thick, vertices: [r, c, a]),
                    PenroseTile(type: .thick, vertices: [q, r, b]),
                    PenroseTile(type: .thin, vertices: [r, q, a])
                ]
            }
        }

        var tiles: [PenroseTile] = []
        for i in 0..<10 {
            let angle = 2.0 * .pi * Double(i) / 10.0
            let p1 = center
            let p2 = Point2D(
                x: center.x + scale * cos(angle),
                y: center.y + scale * sin(angle)
            )
            let p3 = Point2D(
                x: center.x + scale * cos(angle + 2.0 * .pi / 10.0),
                y: center.y + scale * sin(angle + 2.0 * .pi / 10.0)
            )
            tiles.append(PenroseTile(type: .thick, vertices: [p1, p2, p3]))
        }

        for _ in 0..<iterations {
            tiles = tiles.flatMap { subdivide(tile: $0) }
        }

        return tiles.map { Triangle(vertices: $0.vertices) }
    }
}
