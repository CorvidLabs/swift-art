import SwiftUI
import Art

extension Art.RGBColor {
    /// Converts this RGBColor to a SwiftUI Color.
    public var swiftUIColor: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension Art.HSLColor {
    /// Converts this HSLColor to a SwiftUI Color via RGB.
    public var swiftUIColor: Color {
        toRGB().swiftUIColor
    }
}

extension Color {
    /// Creates a SwiftUI Color from an RGBColor.
    public init(_ rgbColor: Art.RGBColor) {
        self.init(red: rgbColor.red, green: rgbColor.green, blue: rgbColor.blue, opacity: rgbColor.alpha)
    }

    /// Creates a SwiftUI Color from an HSLColor.
    public init(_ hslColor: Art.HSLColor) {
        self.init(hslColor.toRGB())
    }
}
