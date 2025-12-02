import Foundation

/// Color harmony generation based on color theory.
public enum Harmony: Sendable {
    /// Generates a complementary color (opposite on the color wheel).
    public static func complementary(of color: RGBColor) -> [RGBColor] {
        let hsl = color.toHSL()
        let complementHue = (hsl.hue + 180).truncatingRemainder(dividingBy: 360)

        let complement = HSLColor(
            hue: complementHue,
            saturation: hsl.saturation,
            lightness: hsl.lightness,
            alpha: hsl.alpha
        ).toRGB()

        return [color, complement]
    }

    /// Generates a triadic color scheme (3 colors evenly spaced on the color wheel).
    public static func triadic(of color: RGBColor) -> [RGBColor] {
        let hsl = color.toHSL()

        let colors = [0, 120, 240].map { offset in
            let hue = (hsl.hue + Double(offset)).truncatingRemainder(dividingBy: 360)
            return HSLColor(
                hue: hue,
                saturation: hsl.saturation,
                lightness: hsl.lightness,
                alpha: hsl.alpha
            ).toRGB()
        }

        return colors
    }

    /// Generates a tetradic color scheme (4 colors in a rectangle on the color wheel).
    public static func tetradic(of color: RGBColor) -> [RGBColor] {
        let hsl = color.toHSL()

        let colors = [0, 90, 180, 270].map { offset in
            let hue = (hsl.hue + Double(offset)).truncatingRemainder(dividingBy: 360)
            return HSLColor(
                hue: hue,
                saturation: hsl.saturation,
                lightness: hsl.lightness,
                alpha: hsl.alpha
            ).toRGB()
        }

        return colors
    }

    /// Generates an analogous color scheme (adjacent colors on the color wheel).
    public static func analogous(of color: RGBColor, angle: Double = 30, count: Int = 3) -> [RGBColor] {
        let hsl = color.toHSL()
        let halfCount = count / 2

        return (-halfCount...halfCount).map { offset in
            let hue = (hsl.hue + Double(offset) * angle).truncatingRemainder(dividingBy: 360)
            return HSLColor(
                hue: hue,
                saturation: hsl.saturation,
                lightness: hsl.lightness,
                alpha: hsl.alpha
            ).toRGB()
        }
    }

    /// Generates a split complementary color scheme.
    public static func splitComplementary(of color: RGBColor, angle: Double = 30) -> [RGBColor] {
        let hsl = color.toHSL()
        let complementHue = (hsl.hue + 180).truncatingRemainder(dividingBy: 360)

        let colors = [
            color,
            HSLColor(
                hue: (complementHue - angle).truncatingRemainder(dividingBy: 360),
                saturation: hsl.saturation,
                lightness: hsl.lightness,
                alpha: hsl.alpha
            ).toRGB(),
            HSLColor(
                hue: (complementHue + angle).truncatingRemainder(dividingBy: 360),
                saturation: hsl.saturation,
                lightness: hsl.lightness,
                alpha: hsl.alpha
            ).toRGB()
        ]

        return colors
    }

    /// Generates a monochromatic color scheme (same hue, different saturation/lightness).
    public static func monochromatic(of color: RGBColor, count: Int = 5) -> [RGBColor] {
        let hsl = color.toHSL()

        return (0..<count).map { i in
            let t = Double(i) / Double(max(count - 1, 1))
            let lightness = 0.2 + t * 0.6

            return HSLColor(
                hue: hsl.hue,
                saturation: hsl.saturation,
                lightness: lightness,
                alpha: hsl.alpha
            ).toRGB()
        }
    }

    /// Generates a shade variation (darker versions).
    public static func shades(of color: RGBColor, count: Int = 5) -> [RGBColor] {
        let hsl = color.toHSL()

        return (0..<count).map { i in
            let t = Double(i) / Double(max(count - 1, 1))
            let lightness = hsl.lightness * (1.0 - t)

            return HSLColor(
                hue: hsl.hue,
                saturation: hsl.saturation,
                lightness: lightness,
                alpha: hsl.alpha
            ).toRGB()
        }
    }

    /// Generates a tint variation (lighter versions).
    public static func tints(of color: RGBColor, count: Int = 5) -> [RGBColor] {
        let hsl = color.toHSL()

        return (0..<count).map { i in
            let t = Double(i) / Double(max(count - 1, 1))
            let lightness = hsl.lightness + (1.0 - hsl.lightness) * t

            return HSLColor(
                hue: hsl.hue,
                saturation: hsl.saturation,
                lightness: lightness,
                alpha: hsl.alpha
            ).toRGB()
        }
    }

    /// Generates a tone variation (grayed versions).
    public static func tones(of color: RGBColor, count: Int = 5) -> [RGBColor] {
        let hsl = color.toHSL()

        return (0..<count).map { i in
            let t = Double(i) / Double(max(count - 1, 1))
            let saturation = hsl.saturation * (1.0 - t)

            return HSLColor(
                hue: hsl.hue,
                saturation: saturation,
                lightness: hsl.lightness,
                alpha: hsl.alpha
            ).toRGB()
        }
    }

    /// Generates a palette from the given color using a harmony type.
    public static func palette(from color: RGBColor, type: HarmonyType) -> Palette {
        let colors: [RGBColor]

        switch type {
        case .complementary:
            colors = complementary(of: color)
        case .triadic:
            colors = triadic(of: color)
        case .tetradic:
            colors = tetradic(of: color)
        case .analogous(let angle, let count):
            colors = analogous(of: color, angle: angle, count: count)
        case .splitComplementary(let angle):
            colors = splitComplementary(of: color, angle: angle)
        case .monochromatic(let count):
            colors = monochromatic(of: color, count: count)
        case .shades(let count):
            colors = shades(of: color, count: count)
        case .tints(let count):
            colors = tints(of: color, count: count)
        case .tones(let count):
            colors = tones(of: color, count: count)
        }

        return Palette(colors: colors)
    }
}

// MARK: - Harmony Type

public enum HarmonyType: Sendable {
    case complementary
    case triadic
    case tetradic
    case analogous(angle: Double = 30, count: Int = 3)
    case splitComplementary(angle: Double = 30)
    case monochromatic(count: Int = 5)
    case shades(count: Int = 5)
    case tints(count: Int = 5)
    case tones(count: Int = 5)
}
