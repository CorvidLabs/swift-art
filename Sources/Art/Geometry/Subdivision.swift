import Foundation

/// Subdivision algorithms for refining geometric shapes.
public enum Subdivision {
    /// Subdivides a triangle using the midpoint subdivision method.
    public static func subdivideTriangle(_ triangle: Triangle) -> [Triangle] {
        let v0 = triangle.vertices[0]
        let v1 = triangle.vertices[1]
        let v2 = triangle.vertices[2]

        let m01 = Point2D(x: (v0.x + v1.x) / 2.0, y: (v0.y + v1.y) / 2.0)
        let m12 = Point2D(x: (v1.x + v2.x) / 2.0, y: (v1.y + v2.y) / 2.0)
        let m20 = Point2D(x: (v2.x + v0.x) / 2.0, y: (v2.y + v0.y) / 2.0)

        return [
            Triangle(p1: v0, p2: m01, p3: m20),
            Triangle(p1: m01, p2: v1, p3: m12),
            Triangle(p1: m20, p2: m12, p3: v2),
            Triangle(p1: m01, p2: m12, p3: m20)
        ]
    }

    /// Subdivides triangles recursively.
    public static func subdivideTriangles(_ triangles: [Triangle], iterations: Int) -> [Triangle] {
        guard iterations > 0 else { return triangles }

        var result = triangles
        for _ in 0..<iterations {
            result = result.flatMap { subdivideTriangle($0) }
        }
        return result
    }

    /// Catmull-Clark subdivision for quadrilaterals.
    public static func catmullClark(vertices: [Point2D], faces: [[Int]], iterations: Int = 1) -> (vertices: [Point2D], faces: [[Int]]) {
        var currentVertices = vertices
        var currentFaces = faces

        for _ in 0..<iterations {
            var newVertices: [Point2D] = []
            var newFaces: [[Int]] = []

            let facePoints: [Point2D] = currentFaces.map { face in
                let faceVertices = face.map { currentVertices[$0] }
                let sumX = faceVertices.reduce(0.0) { $0 + $1.x }
                let sumY = faceVertices.reduce(0.0) { $0 + $1.y }
                return Point2D(x: sumX / Double(faceVertices.count), y: sumY / Double(faceVertices.count))
            }

            var edgePoints: [Set<Int>: Point2D] = [:]
            for face in currentFaces {
                for i in 0..<face.count {
                    let v1 = face[i]
                    let v2 = face[(i + 1) % face.count]
                    let edge = Set([v1, v2])

                    if edgePoints[edge] == nil {
                        let midpoint = Point2D(
                            x: (currentVertices[v1].x + currentVertices[v2].x) / 2.0,
                            y: (currentVertices[v1].y + currentVertices[v2].y) / 2.0
                        )
                        edgePoints[edge] = midpoint
                    }
                }
            }

            newVertices.append(contentsOf: currentVertices)
            let vertexOffset = newVertices.count

            newVertices.append(contentsOf: facePoints)
            let facePointOffset = vertexOffset

            let edgePointsArray = Array(edgePoints.keys)
            newVertices.append(contentsOf: edgePoints.values)
            let edgePointOffset = vertexOffset + facePoints.count

            for (faceIndex, face) in currentFaces.enumerated() {
                for i in 0..<face.count {
                    let v1 = face[i]
                    let v2 = face[(i + 1) % face.count]
                    let facePoint = facePointOffset + faceIndex
                    let edge1 = Set([v1, v2])
                    let edge2 = Set([face[(i - 1 + face.count) % face.count], v1])

                    if let ep1Idx = edgePointsArray.firstIndex(of: edge1),
                       let ep2Idx = edgePointsArray.firstIndex(of: edge2) {
                        newFaces.append([v1, edgePointOffset + ep1Idx, facePoint, edgePointOffset + ep2Idx])
                    }
                }
            }

            currentVertices = newVertices
            currentFaces = newFaces
        }

        return (currentVertices, currentFaces)
    }

    /// Quadtree subdivision for spatial partitioning.
    public struct QuadtreeNode: Sendable {
        public let bounds: Rectangle
        public let depth: Int
        public let children: [QuadtreeNode]?

        public init(bounds: Rectangle, depth: Int, maxDepth: Int) {
            self.bounds = bounds
            self.depth = depth

            if depth < maxDepth {
                let halfWidth = bounds.width / 2.0
                let halfHeight = bounds.height / 2.0

                self.children = [
                    QuadtreeNode(
                        bounds: Rectangle(x: bounds.origin.x, y: bounds.origin.y, width: halfWidth, height: halfHeight),
                        depth: depth + 1,
                        maxDepth: maxDepth
                    ),
                    QuadtreeNode(
                        bounds: Rectangle(x: bounds.origin.x + halfWidth, y: bounds.origin.y, width: halfWidth, height: halfHeight),
                        depth: depth + 1,
                        maxDepth: maxDepth
                    ),
                    QuadtreeNode(
                        bounds: Rectangle(x: bounds.origin.x, y: bounds.origin.y + halfHeight, width: halfWidth, height: halfHeight),
                        depth: depth + 1,
                        maxDepth: maxDepth
                    ),
                    QuadtreeNode(
                        bounds: Rectangle(x: bounds.origin.x + halfWidth, y: bounds.origin.y + halfHeight, width: halfWidth, height: halfHeight),
                        depth: depth + 1,
                        maxDepth: maxDepth
                    )
                ]
            } else {
                self.children = nil
            }
        }

        /// Returns all leaf nodes.
        public var leaves: [QuadtreeNode] {
            if let children = children {
                return children.flatMap { $0.leaves }
            } else {
                return [self]
            }
        }

        /// Returns all rectangles at the maximum depth.
        public var rectangles: [Rectangle] {
            leaves.map { $0.bounds }
        }
    }

    /// Creates a quadtree subdivision of a rectangle.
    public static func quadtree(bounds: Rectangle, maxDepth: Int) -> QuadtreeNode {
        QuadtreeNode(bounds: bounds, depth: 0, maxDepth: maxDepth)
    }

    /// Adaptive quadtree subdivision based on a condition function.
    public static func adaptiveQuadtree(
        bounds: Rectangle,
        maxDepth: Int,
        shouldSubdivide: (Rectangle, Int) -> Bool
    ) -> [Rectangle] {
        func subdivide(rect: Rectangle, depth: Int) -> [Rectangle] {
            guard depth < maxDepth && shouldSubdivide(rect, depth) else {
                return [rect]
            }

            let halfWidth = rect.width / 2.0
            let halfHeight = rect.height / 2.0

            let quads = [
                Rectangle(x: rect.origin.x, y: rect.origin.y, width: halfWidth, height: halfHeight),
                Rectangle(x: rect.origin.x + halfWidth, y: rect.origin.y, width: halfWidth, height: halfHeight),
                Rectangle(x: rect.origin.x, y: rect.origin.y + halfHeight, width: halfWidth, height: halfHeight),
                Rectangle(x: rect.origin.x + halfWidth, y: rect.origin.y + halfHeight, width: halfWidth, height: halfHeight)
            ]

            return quads.flatMap { subdivide(rect: $0, depth: depth + 1) }
        }

        return subdivide(rect: bounds, depth: 0)
    }
}
