import Foundation

/// A color represented in RGB color space with components in the range [0, 1].
public struct RGBColor: Sendable, Hashable, Codable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double

    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red.clamped(to: 0...1)
        self.green = green.clamped(to: 0...1)
        self.blue = blue.clamped(to: 0...1)
        self.alpha = alpha.clamped(to: 0...1)
    }

    /// Creates a color from 8-bit RGB values (0-255).
    public init(red255: Int, green255: Int, blue255: Int, alpha: Double = 1.0) {
        self.red = Double(red255.clamped(to: 0...255)) / 255.0
        self.green = Double(green255.clamped(to: 0...255)) / 255.0
        self.blue = Double(blue255.clamped(to: 0...255)) / 255.0
        self.alpha = alpha.clamped(to: 0...1)
    }

    /// Creates a color from a hex string (e.g., "#FF5733" or "FF5733").
    public init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard hex.count == 6 else { return nil }

        var int: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&int) else { return nil }

        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    /// Converts to hex string representation.
    public var hexString: String {
        let r = Int((red * 255).rounded())
        let g = Int((green * 255).rounded())
        let b = Int((blue * 255).rounded())
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    /// Converts to HSL color space.
    public func toHSL() -> HSLColor {
        let maxC = max(red, green, blue)
        let minC = min(red, green, blue)
        let delta = maxC - minC

        let lightness = (maxC + minC) / 2.0

        guard delta > 0 else {
            return HSLColor(hue: 0, saturation: 0, lightness: lightness, alpha: alpha)
        }

        let saturation = delta / (1.0 - abs(2.0 * lightness - 1.0))

        let hue: Double
        if maxC == red {
            hue = ((green - blue) / delta).truncatingRemainder(dividingBy: 6.0)
        } else if maxC == green {
            hue = (blue - red) / delta + 2.0
        } else {
            hue = (red - green) / delta + 4.0
        }

        return HSLColor(
            hue: (hue * 60.0).truncatingRemainder(dividingBy: 360.0),
            saturation: saturation,
            lightness: lightness,
            alpha: alpha
        )
    }

    /// Linearly interpolates between this color and another.
    public func lerp(to other: RGBColor, t: Double) -> RGBColor {
        let t = t.clamped(to: 0...1)
        return RGBColor(
            red: red + (other.red - red) * t,
            green: green + (other.green - green) * t,
            blue: blue + (other.blue - blue) * t,
            alpha: alpha + (other.alpha - alpha) * t
        )
    }
}

// MARK: - Common Colors

extension RGBColor {
    public static let black = RGBColor(red: 0, green: 0, blue: 0)
    public static let white = RGBColor(red: 1, green: 1, blue: 1)
    public static let red = RGBColor(red: 1, green: 0, blue: 0)
    public static let green = RGBColor(red: 0, green: 1, blue: 0)
    public static let blue = RGBColor(red: 0, green: 0, blue: 1)
    public static let yellow = RGBColor(red: 1, green: 1, blue: 0)
    public static let cyan = RGBColor(red: 0, green: 1, blue: 1)
    public static let magenta = RGBColor(red: 1, green: 0, blue: 1)
    public static let orange = RGBColor(red: 1, green: 0.5, blue: 0)
    public static let purple = RGBColor(red: 0.5, green: 0, blue: 0.5)
    public static let gray = RGBColor(red: 0.5, green: 0.5, blue: 0.5)
    public static let clear = RGBColor(red: 0, green: 0, blue: 0, alpha: 0)
}

// MARK: - HSL Color

/// A color represented in HSL (Hue, Saturation, Lightness) color space.
public struct HSLColor: Sendable, Hashable, Codable {
    /// Hue in degrees [0, 360).
    public let hue: Double
    /// Saturation in range [0, 1].
    public let saturation: Double
    /// Lightness in range [0, 1].
    public let lightness: Double
    /// Alpha in range [0, 1].
    public let alpha: Double

    public init(hue: Double, saturation: Double, lightness: Double, alpha: Double = 1.0) {
        self.hue = hue.truncatingRemainder(dividingBy: 360.0)
        self.saturation = saturation.clamped(to: 0...1)
        self.lightness = lightness.clamped(to: 0...1)
        self.alpha = alpha.clamped(to: 0...1)
    }

    /// Converts to RGB color space.
    public func toRGB() -> RGBColor {
        guard saturation > 0 else {
            return RGBColor(red: lightness, green: lightness, blue: lightness, alpha: alpha)
        }

        let c = (1.0 - abs(2.0 * lightness - 1.0)) * saturation
        let h = hue / 60.0
        let x = c * (1.0 - abs(h.truncatingRemainder(dividingBy: 2.0) - 1.0))
        let m = lightness - c / 2.0

        let (r, g, b): (Double, Double, Double)
        switch h {
        case 0..<1: (r, g, b) = (c, x, 0)
        case 1..<2: (r, g, b) = (x, c, 0)
        case 2..<3: (r, g, b) = (0, c, x)
        case 3..<4: (r, g, b) = (0, x, c)
        case 4..<5: (r, g, b) = (x, 0, c)
        default: (r, g, b) = (c, 0, x)
        }

        return RGBColor(
            red: r + m,
            green: g + m,
            blue: b + m,
            alpha: alpha
        )
    }
}

// MARK: - Helpers

extension Double {
    fileprivate func clamped(to range: ClosedRange<Double>) -> Double {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

extension Int {
    fileprivate func clamped(to range: ClosedRange<Int>) -> Int {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
