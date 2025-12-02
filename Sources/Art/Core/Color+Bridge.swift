import Color

// MARK: - RGBColor <-> Color Bridge

extension RGBColor {
    /// Convert to swift-color's Color type.
    public var asColor: Color {
        Color(r: red, g: green, b: blue, a: alpha)
    }

    /// Create from swift-color's Color type.
    public init(_ color: Color) {
        self.init(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }
}

extension Color {
    /// Convert to swift-art's RGBColor type.
    public var asRGBColor: RGBColor {
        RGBColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - HSLColor <-> HSL Bridge

extension HSLColor {
    /// Convert to swift-color's HSL type.
    public var asHSL: HSL {
        HSL(h: hue, s: saturation, l: lightness)
    }

    /// Create from swift-color's HSL type.
    public init(_ hsl: HSL, alpha: Double = 1.0) {
        self.init(hue: hsl.hue, saturation: hsl.saturation, lightness: hsl.lightness, alpha: alpha)
    }
}

extension HSL {
    /// Convert to swift-art's HSLColor type.
    public func asHSLColor(alpha: Double = 1.0) -> HSLColor {
        HSLColor(hue: hue, saturation: saturation, lightness: lightness, alpha: alpha)
    }
}
