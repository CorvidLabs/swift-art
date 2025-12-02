import Art

/// A protocol for types that can render themselves to an ASCII canvas.
public protocol ASCIIRenderable {
    /// Renders this type to an ASCII canvas.
    /// - Parameters:
    ///   - canvas: The canvas to render to.
    ///   - config: The render configuration.
    func render(to canvas: inout ASCIICanvas, config: ASCIIRenderConfig)
}

/// Configuration for ASCII rendering.
public struct ASCIIRenderConfig: Sendable {
    /// The character palette for different brightness levels.
    public let palette: ASCIIPalette

    /// Whether to invert the Y axis.
    public let invertY: Bool

    /// Creates a render configuration.
    public init(
        palette: ASCIIPalette = .standard,
        invertY: Bool = false
    ) {
        self.palette = palette
        self.invertY = invertY
    }

    /// Default configuration.
    public static let `default` = ASCIIRenderConfig()
}

/// A palette of characters for ASCII rendering, ordered by "brightness".
public struct ASCIIPalette: Sendable {
    /// Characters ordered from darkest to brightest.
    public let characters: [Character]

    /// Creates a palette from an array of characters.
    public init(characters: [Character]) {
        self.characters = characters.isEmpty ? [" "] : characters
    }

    /// Creates a palette from a string.
    public init(_ string: String) {
        self.characters = Array(string)
    }

    /// Returns the character for a given brightness value [0, 1].
    public func character(for brightness: Double) -> Character {
        let clamped = max(0, min(1, brightness))
        let index = Int(clamped * Double(characters.count - 1))
        return characters[index]
    }

    // MARK: - Preset Palettes

    /// Standard ASCII palette using common punctuation.
    public static let standard = ASCIIPalette(" .:-=+*#%@")

    /// Block characters for solid fills.
    public static let blocks = ASCIIPalette(" ░▒▓█")

    /// Minimal palette with just a few levels.
    public static let minimal = ASCIIPalette(" .oO@")

    /// Binary palette (just on/off).
    public static let binary = ASCIIPalette(" █")

    /// Dots palette.
    public static let dots = ASCIIPalette(" ·•●")

    /// Extended grayscale using more characters.
    public static let extended = ASCIIPalette(" .'`^\",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$")
}
