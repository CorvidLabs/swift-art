import Testing
@testable import ArtTerminal

@Suite("ArtTerminal Tests")
struct ArtTerminalTests {
    @Test("ASCIIPalette character selection")
    func paletteCharacterSelection() {
        let palette = ASCIIPalette.standard

        // Lowest brightness should return first character
        let darkChar = palette.character(for: 0.0)
        #expect(darkChar == " ")

        // Highest brightness should return last character
        let brightChar = palette.character(for: 1.0)
        #expect(brightChar == "@")
    }

    @Test("ASCIIPalette clamping")
    func paletteClamping() {
        let palette = ASCIIPalette.binary

        // Values outside [0, 1] should be clamped
        let underflow = palette.character(for: -0.5)
        #expect(underflow == " ")

        let overflow = palette.character(for: 1.5)
        #expect(overflow == "█")
    }

    @Test("Noise ASCII rendering")
    func noiseASCIIRendering() {
        let noise = PerlinNoise(seed: 42)
        let ascii = noise.renderASCII(width: 10, height: 5, scale: 0.1)

        let lines = ascii.split(separator: "\n")
        #expect(lines.count == 5)
        #expect(lines[0].count == 10)
    }

    @Test("Mandelbrot ASCII rendering")
    func mandelbrotASCIIRendering() {
        let mandelbrot = Mandelbrot(maxIterations: 20)
        let ascii = mandelbrot.renderASCII(width: 20, height: 10)

        let lines = ascii.split(separator: "\n")
        #expect(lines.count == 10)
        #expect(lines[0].count == 20)
    }

    @Test("Game of Life ASCII rendering")
    func gameOfLifeASCIIRendering() {
        var game = GameOfLife(width: 5, height: 5)
        game.setCell(x: 2, y: 2, alive: true)

        let ascii = game.renderASCII()
        let lines = ascii.split(separator: "\n")

        #expect(lines.count == 5)
        #expect(lines[2].contains("█"))
    }

    @Test("Elementary CA history rendering")
    func elementaryCAHistoryRendering() {
        var ca = ElementaryCA.wellKnown(.rule30, size: 11)
        ca.setSingleCenterCell()

        let ascii = ca.renderHistoryASCII(generations: 5)
        let lines = ascii.split(separator: "\n")

        #expect(lines.count == 6) // Initial + 5 generations
    }
}
