import Testing
@testable import Art

@Suite("Polygon")
struct PolygonTests {
    @Test("Initialization")
    func initialization() {
        let vertices = [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 0.5, y: 1)
        ]
        let polygon = Polygon(vertices: vertices)

        #expect(polygon.vertexCount == 3)
    }

    @Test("Perimeter")
    func perimeter() {
        let vertices = [
            Point2D(x: 0, y: 0),
            Point2D(x: 4, y: 0),
            Point2D(x: 4, y: 3),
            Point2D(x: 0, y: 3)
        ]
        let polygon = Polygon(vertices: vertices)

        #expect(abs(polygon.perimeter - 14.0) < 0.001)
    }

    @Test("Area")
    func area() {
        let vertices = [
            Point2D(x: 0, y: 0),
            Point2D(x: 4, y: 0),
            Point2D(x: 4, y: 3),
            Point2D(x: 0, y: 3)
        ]
        let polygon = Polygon(vertices: vertices)

        #expect(abs(polygon.area - 12.0) < 0.001)
    }

    @Test("Triangle area")
    func triangleArea() {
        let vertices = [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 0, y: 1)
        ]
        let polygon = Polygon(vertices: vertices)

        #expect(abs(polygon.area - 0.5) < 0.001)
    }

    @Test("Centroid")
    func centroid() {
        let vertices = [
            Point2D(x: 0, y: 0),
            Point2D(x: 2, y: 0),
            Point2D(x: 2, y: 2),
            Point2D(x: 0, y: 2)
        ]
        let polygon = Polygon(vertices: vertices)

        let centroid = polygon.centroid
        #expect(abs(centroid.x - 1.0) < 0.001)
        #expect(abs(centroid.y - 1.0) < 0.001)
    }

    @Test("Contains")
    func contains() {
        let vertices = [
            Point2D(x: 0, y: 0),
            Point2D(x: 10, y: 0),
            Point2D(x: 10, y: 10),
            Point2D(x: 0, y: 10)
        ]
        let polygon = Polygon(vertices: vertices)

        #expect(polygon.contains(Point2D(x: 5, y: 5)))
        #expect(!polygon.contains(Point2D(x: 15, y: 15)))
        #expect(!polygon.contains(Point2D(x: -1, y: 5)))
    }

    @Test("Regular polygon")
    func regularPolygon() {
        let square = Polygon.regular(sides: 4, radius: 1.0)
        #expect(square.vertexCount == 4)

        let hexagon = Polygon.regular(sides: 6, radius: 1.0)
        #expect(hexagon.vertexCount == 6)
    }

    @Test("Star")
    func star() {
        let star = Polygon.star(points: 5, outerRadius: 2.0, innerRadius: 1.0)
        #expect(star.vertexCount == 10)
    }

    @Test("Triangle")
    func triangle() {
        let triangle = Polygon.triangle(radius: 1.0)
        #expect(triangle.vertexCount == 3)
    }

    @Test("Square")
    func square() {
        let square = Polygon.square(size: 2.0)
        #expect(square.vertexCount == 4)

        let area = square.area
        #expect(abs(area - 4.0) < 0.1)
    }

    @Test("Hexagon")
    func hexagon() {
        let hexagon = Polygon.hexagon(radius: 1.0)
        #expect(hexagon.vertexCount == 6)
    }

    @Test("Edges")
    func edges() {
        let vertices = [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 1, y: 1)
        ]
        let polygon = Polygon(vertices: vertices)
        let edges = polygon.edges

        #expect(edges.count == 3)
    }
}

@Suite("Tessellation")
struct TessellationTests {
    @Test("Square grid")
    func squareGrid() {
        let grid = Tessellation.squareGrid(
            width: 5,
            height: 5,
            cellSize: 10.0
        )

        #expect(grid.count == 25)
    }

    @Test("Hex grid")
    func hexGrid() {
        let hexes = Tessellation.hexagonalGrid(
            rows: 3,
            columns: 4,
            radius: 1.0
        )

        #expect(hexes.count == 12)
    }

    @Test("Triangular grid")
    func triangularGrid() {
        let triangles = Tessellation.triangularGrid(
            rows: 2,
            columns: 3,
            sideLength: 10.0
        )

        #expect(triangles.count == 6)
    }

    @Test("Brick pattern")
    func brickPattern() {
        let bricks = Tessellation.brickPattern(
            rows: 3,
            columns: 4,
            brickWidth: 10.0,
            brickHeight: 5.0
        )

        #expect(bricks.count == 12)
    }

    @Test("Penrose tiling")
    func penroseTiling() {
        let tiles = Tessellation.penroseTiling(
            iterations: 2,
            scale: 10.0
        )

        #expect(tiles.count > 0)
    }
}

@Suite("Subdivision")
struct SubdivisionTests {
    @Test("Triangle subdivision")
    func triangleSubdivision() {
        let triangle = Triangle(vertices: [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 0.5, y: 1)
        ])

        let subdivided = Subdivision.subdivideTriangle(triangle)

        #expect(subdivided.count == 4)
    }

    @Test("Multiple iterations")
    func multipleIterations() {
        let triangle = Triangle(vertices: [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 0.5, y: 1)
        ])

        let once = Subdivision.subdivideTriangles([triangle], iterations: 1)
        let twice = Subdivision.subdivideTriangles([triangle], iterations: 2)

        #expect(once.count < twice.count)
    }

    @Test("Catmull Clark")
    func catmullClark() {
        let vertices = [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 1, y: 1),
            Point2D(x: 0, y: 1)
        ]
        let faces = [[0, 1, 2, 3]]

        let result = Subdivision.catmullClark(vertices: vertices, faces: faces)

        #expect(result.vertices.count > vertices.count)
    }

    @Test("Quadtree")
    func quadtree() {
        let bounds = Rectangle(x: 0, y: 0, width: 100, height: 100)
        let quadtree = Subdivision.quadtree(bounds: bounds, maxDepth: 3)

        #expect(quadtree.depth == 0)
        #expect(quadtree.children != nil)
    }
}

@Suite("Voronoi")
struct VoronoiTests {
    @Test("Generation")
    func generation() {
        var rng = RandomSource(seed: 42)
        let sites = (0..<20).map { _ in
            rng.nextPoint2D(xRange: 0...100, yRange: 0...100)
        }

        let voronoi = Voronoi(sites: sites)

        #expect(voronoi.sites.count == 20)
    }

    @Test("Nearest site")
    func nearestSite() {
        let sites = [
            Point2D(x: 0, y: 0),
            Point2D(x: 10, y: 0),
            Point2D(x: 0, y: 10)
        ]

        let voronoi = Voronoi(sites: sites)
        let nearest = voronoi.nearestSite(to: Point2D(x: 1, y: 1))

        #expect(nearest != nil)
        if let nearest = nearest {
            #expect(nearest.site == Point2D(x: 0, y: 0))
            #expect(nearest.index == 0)
        }
    }

    @Test("Cell index")
    func cellIndex() {
        let sites = [
            Point2D(x: 25, y: 25),
            Point2D(x: 75, y: 25),
            Point2D(x: 50, y: 75)
        ]

        let voronoi = Voronoi(sites: sites)
        let index = voronoi.cellIndex(for: Point2D(x: 20, y: 20))

        #expect(index == 0)
    }

    @Test("Rasterize")
    func rasterize() {
        let sites = [
            Point2D(x: 25, y: 25),
            Point2D(x: 75, y: 75)
        ]

        let voronoi = Voronoi(sites: sites)
        let bounds = Rectangle(x: 0, y: 0, width: 100, height: 100)
        let grid = voronoi.rasterize(width: 10, height: 10, bounds: bounds)

        #expect(grid.count == 10)
        #expect(grid[0].count == 10)
    }

    @Test("Distance field")
    func distanceField() {
        let sites = [Point2D(x: 0, y: 0), Point2D(x: 100, y: 100)]
        let voronoi = Voronoi(sites: sites)

        let distance = voronoi.distanceField(at: Point2D(x: 10, y: 10))

        #expect(distance > 0)
    }

    @Test("Random")
    func random() {
        let bounds = Rectangle(x: 0, y: 0, width: 100, height: 100)
        let voronoi = Voronoi.random(siteCount: 10, bounds: bounds, seed: 42)

        #expect(voronoi.sites.count == 10)
    }
}

@Suite("Triangle")
struct TriangleTests {
    @Test("Initialization")
    func initialization() {
        let triangle = Triangle(vertices: [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 0.5, y: 1)
        ])

        #expect(triangle.vertices.count == 3)
    }

    @Test("Convenience init")
    func convenienceInit() {
        let triangle = Triangle(
            p1: Point2D(x: 0, y: 0),
            p2: Point2D(x: 1, y: 0),
            p3: Point2D(x: 0.5, y: 1)
        )

        #expect(triangle.vertices.count == 3)
    }

    @Test("Area")
    func area() {
        let triangle = Triangle(vertices: [
            Point2D(x: 0, y: 0),
            Point2D(x: 1, y: 0),
            Point2D(x: 0, y: 1)
        ])

        let area = triangle.area
        #expect(abs(area - 0.5) < 0.001)
    }
}

@Suite("Rectangle")
struct RectangleTests {
    @Test("Initialization")
    func initialization() {
        let rect = Rectangle(x: 10, y: 20, width: 30, height: 40)

        #expect(rect.origin.x == 10)
        #expect(rect.origin.y == 20)
        #expect(rect.width == 30)
        #expect(rect.height == 40)
    }

    @Test("Area")
    func area() {
        let rect = Rectangle(x: 0, y: 0, width: 10, height: 20)
        #expect(rect.area == 200.0)
    }

    @Test("Contains")
    func contains() {
        let rect = Rectangle(x: 0, y: 0, width: 10, height: 10)

        #expect(rect.contains(Point2D(x: 5, y: 5)))
        #expect(!rect.contains(Point2D(x: 15, y: 5)))
    }

    @Test("Perimeter")
    func perimeter() {
        let rect = Rectangle(x: 0, y: 0, width: 10, height: 20)
        let perimeter = rect.perimeter

        #expect(abs(perimeter - 60.0) < 0.001)
    }
}

@Suite("Circle")
struct CircleTests {
    @Test("Initialization")
    func initialization() {
        let circle = Circle(center: Point2D(x: 5, y: 5), radius: 10)

        #expect(circle.center.x == 5)
        #expect(circle.radius == 10)
    }

    @Test("Area")
    func area() {
        let circle = Circle(center: .zero, radius: 10)
        let area = circle.area

        #expect(abs(area - .pi * 100) < 0.001)
    }

    @Test("Contains")
    func contains() {
        let circle = Circle(center: .zero, radius: 10)

        #expect(circle.contains(Point2D(x: 5, y: 0)))
        #expect(!circle.contains(Point2D(x: 15, y: 0)))
    }

    @Test("Circumference")
    func circumference() {
        let circle = Circle(center: .zero, radius: 10)
        let circumference = circle.circumference

        #expect(abs(circumference - 2 * .pi * 10) < 0.001)
    }
}

@Suite("LineSegment")
struct LineSegmentTests {
    @Test("Length")
    func length() {
        let segment = LineSegment(
            start: Point2D(x: 0, y: 0),
            end: Point2D(x: 3, y: 4)
        )

        #expect(abs(segment.length - 5.0) < 0.001)
    }

    @Test("Midpoint")
    func midpoint() {
        let segment = LineSegment(
            start: Point2D(x: 0, y: 0),
            end: Point2D(x: 10, y: 10)
        )

        let midpoint = segment.midpoint
        #expect(midpoint.x == 5.0)
        #expect(midpoint.y == 5.0)
    }

    @Test("Point at parameter")
    func pointAtParameter() {
        let segment = LineSegment(
            start: Point2D(x: 0, y: 0),
            end: Point2D(x: 100, y: 0)
        )

        let point = segment.point(at: 0.25)

        #expect(point.x == 25.0)
        #expect(point.y == 0.0)
    }

    @Test("Intersection")
    func intersection() {
        let segment1 = LineSegment(
            start: Point2D(x: 0, y: 5),
            end: Point2D(x: 10, y: 5)
        )

        let segment2 = LineSegment(
            start: Point2D(x: 5, y: 0),
            end: Point2D(x: 5, y: 10)
        )

        let intersection = segment1.intersection(with: segment2)

        #expect(intersection != nil)
        if let intersection = intersection {
            #expect(abs(intersection.x - 5.0) < 0.001)
            #expect(abs(intersection.y - 5.0) < 0.001)
        }
    }

    @Test("No intersection")
    func noIntersection() {
        let segment1 = LineSegment(
            start: Point2D(x: 0, y: 0),
            end: Point2D(x: 5, y: 0)
        )

        let segment2 = LineSegment(
            start: Point2D(x: 0, y: 10),
            end: Point2D(x: 5, y: 10)
        )

        let intersection = segment1.intersection(with: segment2)

        #expect(intersection == nil)
    }
}
