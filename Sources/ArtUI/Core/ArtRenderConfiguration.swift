import SwiftUI
import Art

/// Configuration for rendering art views.
public struct ArtRenderConfiguration: Sendable {
    /// The background color for the canvas.
    public let backgroundColor: Color

    /// The default stroke color for lines and outlines.
    public let strokeColor: Color

    /// The default stroke width for lines.
    public let strokeWidth: Double

    /// The default size for points/particles.
    public let pointSize: Double

    /// Whether to apply antialiasing.
    public let antialiased: Bool

    /// Creates a new render configuration.
    public init(
        backgroundColor: Color = .black,
        strokeColor: Color = .white,
        strokeWidth: Double = 1.0,
        pointSize: Double = 2.0,
        antialiased: Bool = true
    ) {
        self.backgroundColor = backgroundColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.pointSize = pointSize
        self.antialiased = antialiased
    }

    /// Default configuration with black background and white strokes.
    public static let `default` = ArtRenderConfiguration()

    /// Light mode configuration with white background and black strokes.
    public static let light = ArtRenderConfiguration(
        backgroundColor: .white,
        strokeColor: .black
    )
}
