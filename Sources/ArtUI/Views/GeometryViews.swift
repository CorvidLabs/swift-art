import SwiftUI
import Art

/// A SwiftUI view that renders a Voronoi diagram.
public struct VoronoiView: View {
    private let voronoi: Voronoi
    private let bounds: CGRect
    private let colors: [Color]
    private let showSites: Bool
    private let showEdges: Bool
    private let siteColor: Color
    private let edgeColor: Color

    /**
     Creates a Voronoi view.
     - Parameters:
       - voronoi: The Voronoi diagram to render.
       - bounds: The bounds for rendering.
       - colors: Colors for the cells (cycled through).
       - showSites: Whether to show the site points.
       - showEdges: Whether to show cell edges.
       - siteColor: Color for site points.
       - edgeColor: Color for edges.
     */
    public init(
        voronoi: Voronoi,
        bounds: CGRect,
        colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .cyan, .pink],
        showSites: Bool = true,
        showEdges: Bool = true,
        siteColor: Color = .white,
        edgeColor: Color = .black
    ) {
        self.voronoi = voronoi
        self.bounds = bounds
        self.colors = colors
        self.showSites = showSites
        self.showEdges = showEdges
        self.siteColor = siteColor
        self.edgeColor = edgeColor
    }

    public var body: some View {
        Canvas { context, size in
            let scaleX = size.width / bounds.width
            let scaleY = size.height / bounds.height

            // Render cells by nearest-neighbor coloring
            let resolution = 2 // pixels per sample
            for y in stride(from: 0, to: Int(size.height), by: resolution) {
                for x in stride(from: 0, to: Int(size.width), by: resolution) {
                    let point = Point2D(
                        x: bounds.minX + Double(x) / scaleX,
                        y: bounds.minY + Double(y) / scaleY
                    )

                    if let nearest = voronoi.nearestSite(to: point) {
                        let color = colors[nearest.index % colors.count]
                        let rect = CGRect(x: x, y: y, width: resolution, height: resolution)
                        context.fill(Path(rect), with: .color(color.opacity(0.6)))
                    }
                }
            }

            // Draw edges if enabled
            if showEdges {
                // Draw site boundaries (approximated)
                for site in voronoi.sites {
                    let scaledPoint = CGPoint(
                        x: (site.x - bounds.minX) * scaleX,
                        y: (site.y - bounds.minY) * scaleY
                    )

                    // Draw a small circle around each site
                    let circleRect = CGRect(
                        x: scaledPoint.x - 2,
                        y: scaledPoint.y - 2,
                        width: 4,
                        height: 4
                    )
                    context.stroke(
                        Path(ellipseIn: circleRect),
                        with: .color(edgeColor),
                        lineWidth: 1
                    )
                }
            }

            // Draw sites if enabled
            if showSites {
                for site in voronoi.sites {
                    let scaledPoint = CGPoint(
                        x: (site.x - bounds.minX) * scaleX,
                        y: (site.y - bounds.minY) * scaleY
                    )

                    let siteRect = CGRect(
                        x: scaledPoint.x - 4,
                        y: scaledPoint.y - 4,
                        width: 8,
                        height: 8
                    )
                    context.fill(Path(ellipseIn: siteRect), with: .color(siteColor))
                }
            }
        }
        .frame(width: bounds.width, height: bounds.height)
    }
}

/// A SwiftUI view that renders a polygon.
public struct PolygonView: View {
    private let polygon: Art.Polygon
    private let fillColor: Color?
    private let strokeColor: Color
    private let strokeWidth: CGFloat

    /// Creates a polygon view.
    public init(
        polygon: Art.Polygon,
        fillColor: Color? = nil,
        strokeColor: Color = .white,
        strokeWidth: CGFloat = 1.0
    ) {
        self.polygon = polygon
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }

    public var body: some View {
        Canvas { context, size in
            guard !polygon.vertices.isEmpty else { return }

            var path = Path()
            let first = polygon.vertices[0]
            path.move(to: CGPoint(x: first.x, y: first.y))

            for vertex in polygon.vertices.dropFirst() {
                path.addLine(to: CGPoint(x: vertex.x, y: vertex.y))
            }
            path.closeSubpath()

            if let fill = fillColor {
                context.fill(path, with: .color(fill))
            }

            context.stroke(
                path,
                with: .color(strokeColor),
                style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round)
            )
        }
    }
}

/// A SwiftUI view that renders a hexagonal tessellation pattern.
public struct HexagonalTessellationView: View {
    private let rows: Int
    private let columns: Int
    private let radius: Double
    private let colors: [Color]
    private let strokeColor: Color?
    private let strokeWidth: CGFloat

    /// Creates a hexagonal tessellation view.
    public init(
        rows: Int = 5,
        columns: Int = 5,
        radius: Double = 30,
        colors: [Color] = [.blue, .cyan, .teal],
        strokeColor: Color? = .white,
        strokeWidth: CGFloat = 0.5
    ) {
        self.rows = rows
        self.columns = columns
        self.radius = radius
        self.colors = colors
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }

    public var body: some View {
        Canvas { context, size in
            let hexagons = Tessellation.hexagonalGrid(
                rows: rows,
                columns: columns,
                radius: radius,
                origin: Point2D(x: radius, y: radius)
            )

            for (index, polygon) in hexagons.enumerated() {
                guard !polygon.vertices.isEmpty else { continue }

                var path = Path()
                let first = polygon.vertices[0]
                path.move(to: CGPoint(x: first.x, y: first.y))

                for vertex in polygon.vertices.dropFirst() {
                    path.addLine(to: CGPoint(x: vertex.x, y: vertex.y))
                }
                path.closeSubpath()

                let color = colors[index % colors.count]
                context.fill(path, with: .color(color))

                if let stroke = strokeColor {
                    context.stroke(
                        path,
                        with: .color(stroke),
                        style: StrokeStyle(lineWidth: strokeWidth)
                    )
                }
            }
        }
    }
}
