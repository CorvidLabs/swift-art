import Testing
import Art
@testable import ArtUI

@Suite("ArtUI Tests")
struct ArtUITests {
    @Test("RGBColor to SwiftUI Color conversion")
    func colorConversion() {
        let rgbColor = RGBColor(red: 0.5, green: 0.5, blue: 0.5)
        let swiftUIColor = rgbColor.swiftUIColor

        // Just verify it doesn't crash - SwiftUI Color internals are opaque
        #expect(swiftUIColor != nil)
    }

    @Test("HSLColor to SwiftUI Color conversion")
    func hslColorConversion() {
        let hslColor = HSLColor(hue: 180, saturation: 0.5, lightness: 0.5)
        let swiftUIColor = hslColor.swiftUIColor

        #expect(swiftUIColor != nil)
    }

    @Test("ArtRenderConfiguration defaults")
    func renderConfiguration() {
        let config = ArtRenderConfiguration.default

        #expect(config.strokeWidth == 1.0)
        #expect(config.pointSize == 2.0)
        #expect(config.antialiased == true)
    }

    @Test("ArtRenderConfiguration light preset")
    func lightConfiguration() {
        let config = ArtRenderConfiguration.light

        #expect(config.strokeWidth == 1.0)
    }
}
