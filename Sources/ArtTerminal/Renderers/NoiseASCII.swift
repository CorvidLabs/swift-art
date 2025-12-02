import Art

extension NoiseGenerator {
    /// Renders noise to an ASCII string.
    /// - Parameters:
    ///   - width: The width in characters.
    ///   - height: The height in characters.
    ///   - scale: The scale factor for sampling.
    ///   - palette: The character palette to use.
    /// - Returns: A multi-line string of ASCII art.
    public func renderASCII(
        width: Int,
        height: Int,
        scale: Double = 0.1,
        palette: ASCIIPalette = .standard
    ) -> String {
        var result = ""

        for y in 0..<height {
            for x in 0..<width {
                let value = normalized(x: Double(x) * scale, y: Double(y) * scale)
                result.append(palette.character(for: value))
            }
            if y < height - 1 {
                result.append("\n")
            }
        }

        return result
    }

    /// Creates an ASCII canvas with noise rendered to it.
    /// - Parameters:
    ///   - width: The width in characters.
    ///   - height: The height in characters.
    ///   - scale: The scale factor for sampling.
    ///   - palette: The character palette to use.
    /// - Returns: An ASCII canvas with the noise rendered.
    public func toASCIICanvas(
        width: Int,
        height: Int,
        scale: Double = 0.1,
        palette: ASCIIPalette = .standard
    ) -> ASCIICanvas {
        var canvas = ASCIICanvas(width: width, height: height)

        for y in 0..<height {
            for x in 0..<width {
                let value = normalized(x: Double(x) * scale, y: Double(y) * scale)
                let character = palette.character(for: value)
                canvas.set(character: character, at: (x, y))
            }
        }

        return canvas
    }
}
