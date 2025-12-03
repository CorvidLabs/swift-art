import Art

extension Mandelbrot {
    /**
     Renders the Mandelbrot set to an ASCII string.
     - Parameters:
       - width: The width in characters.
       - height: The height in characters.
       - bounds: The complex plane bounds.
       - palette: The character palette to use.
     - Returns: A multi-line string of ASCII art.
     */
    public func renderASCII(
        width: Int,
        height: Int,
        minReal: Double = -2.5,
        maxReal: Double = 1.0,
        minImaginary: Double = -1.5,
        maxImaginary: Double = 1.5,
        palette: ASCIIPalette = .standard
    ) -> String {
        var result = ""

        for y in 0..<height {
            for x in 0..<width {
                let real = minReal + (Double(x) / Double(width)) * (maxReal - minReal)
                let imag = minImaginary + (Double(y) / Double(height)) * (maxImaginary - minImaginary)

                let sample = sample(real: real, imaginary: imag)

                if sample.escaped {
                    let brightness = sample.smoothValue / Double(maxIterations)
                    result.append(palette.character(for: brightness))
                } else {
                    result.append(palette.characters.first ?? " ")
                }
            }
            if y < height - 1 {
                result.append("\n")
            }
        }

        return result
    }

    /// Creates an ASCII canvas with the Mandelbrot set rendered.
    public func toASCIICanvas(
        width: Int,
        height: Int,
        minReal: Double = -2.5,
        maxReal: Double = 1.0,
        minImaginary: Double = -1.5,
        maxImaginary: Double = 1.5,
        palette: ASCIIPalette = .standard
    ) -> ASCIICanvas {
        var canvas = ASCIICanvas(width: width, height: height)

        for y in 0..<height {
            for x in 0..<width {
                let real = minReal + (Double(x) / Double(width)) * (maxReal - minReal)
                let imag = minImaginary + (Double(y) / Double(height)) * (maxImaginary - minImaginary)

                let sample = sample(real: real, imaginary: imag)
                let character: Character

                if sample.escaped {
                    let brightness = sample.smoothValue / Double(maxIterations)
                    character = palette.character(for: brightness)
                } else {
                    character = palette.characters.first ?? " "
                }

                canvas.set(character: character, at: (x, y))
            }
        }

        return canvas
    }
}

extension JuliaSet {
    /// Renders the Julia set to an ASCII string.
    public func renderASCII(
        width: Int,
        height: Int,
        minReal: Double = -2.0,
        maxReal: Double = 2.0,
        minImaginary: Double = -2.0,
        maxImaginary: Double = 2.0,
        palette: ASCIIPalette = .standard
    ) -> String {
        var result = ""

        for y in 0..<height {
            for x in 0..<width {
                let real = minReal + (Double(x) / Double(width)) * (maxReal - minReal)
                let imag = minImaginary + (Double(y) / Double(height)) * (maxImaginary - minImaginary)

                let sample = sample(real: real, imaginary: imag)

                if sample.escaped {
                    let brightness = sample.smoothValue / Double(maxIterations)
                    result.append(palette.character(for: brightness))
                } else {
                    result.append(palette.characters.first ?? " ")
                }
            }
            if y < height - 1 {
                result.append("\n")
            }
        }

        return result
    }
}
