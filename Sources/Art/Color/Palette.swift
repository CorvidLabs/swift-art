import Foundation

/// A collection of colors that can be sampled and manipulated.
public struct Palette: Sendable {
    public let colors: [RGBColor]

    public init(colors: [RGBColor]) {
        self.colors = colors
    }

    /// Creates a palette from hex color strings.
    public init?(hexColors: [String]) {
        let parsed = hexColors.compactMap { RGBColor(hex: $0) }
        guard parsed.count == hexColors.count else { return nil }
        self.colors = parsed
    }

    /// Returns a color at the specified index (wraps around).
    public func color(at index: Int) -> RGBColor {
        guard !colors.isEmpty else { return .black }
        let wrappedIndex = index % colors.count
        return colors[wrappedIndex]
    }

    /// Samples a color from the palette using a value in [0, 1].
    public func sample(at t: Double) -> RGBColor {
        guard !colors.isEmpty else { return .black }
        guard colors.count > 1 else { return colors[0] }

        let t = t.clamped(to: 0...1)
        let scaledT = t * Double(colors.count - 1)
        let index = Int(scaledT)
        let fraction = scaledT - Double(index)

        guard index < colors.count - 1 else { return colors[colors.count - 1] }

        return colors[index].lerp(to: colors[index + 1], t: fraction)
    }

    /// Returns a random color from the palette.
    public func randomColor(using rng: inout RandomSource) -> RGBColor {
        guard !colors.isEmpty else { return .black }
        let index = rng.nextInt(upperBound: colors.count)
        return colors[index]
    }

    /// Returns the number of colors in the palette.
    public var count: Int {
        colors.count
    }

    /// Creates a new palette with reversed colors.
    public func reversed() -> Palette {
        Palette(colors: colors.reversed())
    }

    /// Creates a new palette with shuffled colors.
    public func shuffled(using rng: inout RandomSource) -> Palette {
        Palette(colors: rng.shuffled(colors))
    }
}

// MARK: - Preset Palettes

extension Palette {
    /// Grayscale palette.
    public static let grayscale = Palette(colors: [
        .black,
        RGBColor(red: 0.25, green: 0.25, blue: 0.25),
        RGBColor(red: 0.5, green: 0.5, blue: 0.5),
        RGBColor(red: 0.75, green: 0.75, blue: 0.75),
        .white
    ])

    /// Rainbow palette.
    public static let rainbow = Palette(colors: [
        .red,
        .orange,
        .yellow,
        .green,
        .cyan,
        .blue,
        .purple,
        .magenta
    ])

    /// Warm colors palette.
    public static let warm = Palette(colors: [
        RGBColor(red: 1.0, green: 0.0, blue: 0.0),
        RGBColor(red: 1.0, green: 0.5, blue: 0.0),
        RGBColor(red: 1.0, green: 1.0, blue: 0.0),
        RGBColor(red: 1.0, green: 0.3, blue: 0.0)
    ])

    /// Cool colors palette.
    public static let cool = Palette(colors: [
        RGBColor(red: 0.0, green: 0.5, blue: 1.0),
        RGBColor(red: 0.0, green: 0.8, blue: 1.0),
        RGBColor(red: 0.3, green: 0.3, blue: 1.0),
        RGBColor(red: 0.5, green: 0.0, blue: 1.0)
    ])

    /// Sunset palette.
    public static let sunset = Palette(colors: [
        RGBColor(red: 0.2, green: 0.1, blue: 0.4),
        RGBColor(red: 0.8, green: 0.2, blue: 0.4),
        RGBColor(red: 1.0, green: 0.5, blue: 0.2),
        RGBColor(red: 1.0, green: 0.8, blue: 0.3)
    ])

    /// Ocean palette.
    public static let ocean = Palette(colors: [
        RGBColor(red: 0.0, green: 0.1, blue: 0.3),
        RGBColor(red: 0.0, green: 0.3, blue: 0.6),
        RGBColor(red: 0.0, green: 0.5, blue: 0.8),
        RGBColor(red: 0.3, green: 0.7, blue: 0.9)
    ])

    /// Forest palette.
    public static let forest = Palette(colors: [
        RGBColor(red: 0.1, green: 0.2, blue: 0.1),
        RGBColor(red: 0.2, green: 0.4, blue: 0.2),
        RGBColor(red: 0.3, green: 0.6, blue: 0.3),
        RGBColor(red: 0.5, green: 0.8, blue: 0.5)
    ])

    /// Pastel palette.
    public static let pastel = Palette(colors: [
        RGBColor(red: 1.0, green: 0.7, blue: 0.8),
        RGBColor(red: 0.8, green: 0.7, blue: 1.0),
        RGBColor(red: 0.7, green: 0.9, blue: 1.0),
        RGBColor(red: 0.7, green: 1.0, blue: 0.8),
        RGBColor(red: 1.0, green: 1.0, blue: 0.7)
    ])

    /// Neon palette.
    public static let neon = Palette(colors: [
        RGBColor(red: 1.0, green: 0.0, blue: 0.5),
        RGBColor(red: 1.0, green: 0.5, blue: 0.0),
        RGBColor(red: 0.0, green: 1.0, blue: 0.5),
        RGBColor(red: 0.0, green: 0.5, blue: 1.0),
        RGBColor(red: 0.5, green: 0.0, blue: 1.0)
    ])

    /// Fire palette.
    public static let fire = Palette(colors: [
        .black,
        RGBColor(red: 0.5, green: 0.0, blue: 0.0),
        RGBColor(red: 1.0, green: 0.0, blue: 0.0),
        RGBColor(red: 1.0, green: 0.5, blue: 0.0),
        RGBColor(red: 1.0, green: 1.0, blue: 0.0),
        .white
    ])

    /// Ice palette.
    public static let ice = Palette(colors: [
        RGBColor(red: 0.1, green: 0.1, blue: 0.3),
        RGBColor(red: 0.3, green: 0.5, blue: 0.8),
        RGBColor(red: 0.5, green: 0.8, blue: 1.0),
        RGBColor(red: 0.8, green: 0.95, blue: 1.0),
        .white
    ])
}

// MARK: - Helper

extension Double {
    fileprivate func clamped(to range: ClosedRange<Double>) -> Double {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
