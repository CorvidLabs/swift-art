import Testing
@testable import Art

@Suite("Harmony")
struct HarmonyTests {
    @Test("Complementary")
    func complementary() {
        let base = RGBColor.red
        let colors = Harmony.complementary(of: base)

        #expect(colors.count == 2)
        #expect(colors[0] == base)

        let hsl = colors[1].toHSL()
        #expect(abs(hsl.hue - 180.0) < 1.0)
    }

    @Test("Triadic")
    func triadic() {
        let base = RGBColor.red
        let colors = Harmony.triadic(of: base)

        #expect(colors.count == 3)

        let hues = colors.map { $0.toHSL().hue }
        for i in 0..<hues.count {
            let nextIndex = (i + 1) % hues.count
            let hueDiff = abs(hues[nextIndex] - hues[i])
            let normalizedDiff = min(hueDiff, 360 - hueDiff)
            #expect(abs(normalizedDiff - 120.0) < 2.0)
        }
    }

    @Test("Tetradic")
    func tetradic() {
        let base = RGBColor.blue
        let colors = Harmony.tetradic(of: base)

        #expect(colors.count == 4)
    }

    @Test("Analogous")
    func analogous() {
        let base = RGBColor.green
        let colors = Harmony.analogous(of: base, angle: 30, count: 5)

        #expect(colors.count == 5)

        let baseHue = base.toHSL().hue
        let middleHue = colors[2].toHSL().hue

        #expect(abs(baseHue - middleHue) < 1.0)
    }

    @Test("Split complementary")
    func splitComplementary() {
        let base = RGBColor.red
        let colors = Harmony.splitComplementary(of: base, angle: 30)

        #expect(colors.count == 3)
        #expect(colors[0] == base)
    }

    @Test("Monochromatic")
    func monochromatic() {
        let base = RGBColor.blue
        let colors = Harmony.monochromatic(of: base, count: 5)

        #expect(colors.count == 5)

        let baseHue = base.toHSL().hue
        for color in colors {
            let hue = color.toHSL().hue
            #expect(abs(hue - baseHue) < 1.0)
        }
    }

    @Test("Shades")
    func shades() {
        let base = RGBColor(red: 0.5, green: 0.5, blue: 0.5)
        let colors = Harmony.shades(of: base, count: 5)

        #expect(colors.count == 5)

        for i in 0..<(colors.count - 1) {
            let current = colors[i].toHSL().lightness
            let next = colors[i + 1].toHSL().lightness
            #expect(current >= next)
        }
    }

    @Test("Tints")
    func tints() {
        let base = RGBColor(red: 0.3, green: 0.3, blue: 0.3)
        let colors = Harmony.tints(of: base, count: 5)

        #expect(colors.count == 5)

        for i in 0..<(colors.count - 1) {
            let current = colors[i].toHSL().lightness
            let next = colors[i + 1].toHSL().lightness
            #expect(current <= next)
        }
    }

    @Test("Tones")
    func tones() {
        let base = RGBColor.blue
        let colors = Harmony.tones(of: base, count: 5)

        #expect(colors.count == 5)

        for i in 0..<(colors.count - 1) {
            let current = colors[i].toHSL().saturation
            let next = colors[i + 1].toHSL().saturation
            #expect(current >= next)
        }
    }

    @Test("Palette")
    func palette() {
        let base = RGBColor.red
        let palette = Harmony.palette(from: base, type: .complementary)

        #expect(palette.colors.count > 0)
    }

    @Test("Harmony types")
    func harmonyTypes() {
        let base = RGBColor.green

        let types: [HarmonyType] = [
            .complementary,
            .triadic,
            .tetradic,
            .analogous(angle: 30, count: 5),
            .splitComplementary(angle: 30),
            .monochromatic(count: 5),
            .shades(count: 5),
            .tints(count: 5),
            .tones(count: 5)
        ]

        for type in types {
            let palette = Harmony.palette(from: base, type: type)
            #expect(palette.colors.count > 0)
        }
    }
}

@Suite("Palette")
struct PaletteTests {
    @Test("Initialization")
    func initialization() {
        let colors = [RGBColor.red, RGBColor.green, RGBColor.blue]
        let palette = Palette(colors: colors)

        #expect(palette.colors.count == 3)
    }

    @Test("Color at")
    func colorAt() {
        let colors = [RGBColor.red, RGBColor.green, RGBColor.blue]
        let palette = Palette(colors: colors)

        #expect(palette.color(at: 0) == RGBColor.red)
        #expect(palette.color(at: 1) == RGBColor.green)
        #expect(palette.color(at: 2) == RGBColor.blue)
    }

    @Test("Color at wrapped")
    func colorAtWrapped() {
        let colors = [RGBColor.red, RGBColor.green]
        let palette = Palette(colors: colors)

        #expect(palette.color(at: 2) == RGBColor.red)
        #expect(palette.color(at: 3) == RGBColor.green)
    }

    @Test("Sample")
    func sample() {
        let colors = [RGBColor.black, RGBColor.white]
        let palette = Palette(colors: colors)

        let start = palette.sample(at: 0.0)
        let mid = palette.sample(at: 0.5)
        let end = palette.sample(at: 1.0)

        #expect(start == RGBColor.black)
        #expect(end == RGBColor.white)

        #expect(abs(mid.red - 0.5) < 0.01)
        #expect(abs(mid.green - 0.5) < 0.01)
        #expect(abs(mid.blue - 0.5) < 0.01)
    }

    @Test("Reversed")
    func reversed() {
        let colors = [RGBColor.red, RGBColor.green, RGBColor.blue]
        let palette = Palette(colors: colors)

        let reversed = palette.reversed()

        #expect(reversed.colors.first == RGBColor.blue)
        #expect(reversed.colors.last == RGBColor.red)
    }

    @Test("Shuffled")
    func shuffled() {
        let colors = [RGBColor.red, RGBColor.green, RGBColor.blue, RGBColor.yellow]
        let palette = Palette(colors: colors)

        var rng = RandomSource(seed: 42)
        let shuffled = palette.shuffled(using: &rng)

        #expect(shuffled.count == palette.count)
    }

    @Test("Random color")
    func randomColor() {
        let palette = Palette(colors: [RGBColor.red, RGBColor.green, RGBColor.blue])

        var rng = RandomSource(seed: 42)
        let color = palette.randomColor(using: &rng)

        #expect(palette.colors.contains(color))
    }

    @Test("Hex init")
    func hexInit() {
        let palette = Palette(hexColors: ["#FF0000", "#00FF00", "#0000FF"])

        #expect(palette != nil)
        #expect(palette?.count == 3)
    }

    @Test("Count")
    func count() {
        let palette = Palette(colors: [.red, .green, .blue])
        #expect(palette.count == 3)
    }

    @Test("Presets")
    func presets() {
        let presets = [
            Palette.rainbow,
            Palette.pastel,
            Palette.neon,
            Palette.ocean,
            Palette.sunset,
            Palette.forest,
            Palette.fire,
            Palette.ice,
            Palette.grayscale,
            Palette.warm,
            Palette.cool
        ]

        for preset in presets {
            #expect(preset.colors.count > 0)
        }
    }
}

@Suite("Gradient")
struct GradientTests {
    @Test("Init with colors")
    func initWithColors() {
        let gradient = Gradient(colors: [RGBColor.black, RGBColor.white])

        #expect(gradient.stops.count == 2)
        #expect(gradient.stops[0].position == 0.0)
        #expect(gradient.stops[1].position == 1.0)
    }

    @Test("Init with stops")
    func initWithStops() {
        let stops = [
            Gradient.Stop(color: .red, position: 0.0),
            Gradient.Stop(color: .green, position: 0.5),
            Gradient.Stop(color: .blue, position: 1.0)
        ]

        let gradient = Gradient(stops: stops)

        #expect(gradient.stops.count == 3)
    }

    @Test("Sample")
    func sample() {
        let gradient = Gradient(colors: [RGBColor.black, RGBColor.white])

        let start = gradient.sample(at: 0.0)
        let mid = gradient.sample(at: 0.5)
        let end = gradient.sample(at: 1.0)

        #expect(start == RGBColor.black)
        #expect(end == RGBColor.white)
        #expect(abs(mid.red - 0.5) < 0.01)
    }

    @Test("Sample count")
    func sampleCount() {
        let gradient = Gradient(colors: [RGBColor.red, RGBColor.blue])
        let colors = gradient.sample(count: 10)

        #expect(colors.count == 10)
        #expect(colors.first == RGBColor.red)
        #expect(colors.last == RGBColor.blue)
    }

    @Test("Palette")
    func palette() {
        let gradient = Gradient(colors: [RGBColor.red, RGBColor.blue])
        let palette = gradient.palette(colorCount: 5)

        #expect(palette.count == 5)
    }

    @Test("Reversed")
    func reversed() {
        let gradient = Gradient(colors: [RGBColor.red, RGBColor.blue])
        let reversed = gradient.reversed()

        #expect(reversed.sample(at: 0.0) == RGBColor.blue)
        #expect(reversed.sample(at: 1.0) == RGBColor.red)
    }

    @Test("Presets")
    func presets() {
        let presets = [
            Gradient.grayscale,
            Gradient.rainbow,
            Gradient.sunrise,
            Gradient.sunset,
            Gradient.ocean,
            Gradient.fire,
            Gradient.ice,
            Gradient.forest,
            Gradient.lavender,
            Gradient.gold,
            Gradient.copper,
            Gradient.viridis,
            Gradient.plasma
        ]

        for preset in presets {
            #expect(preset.stops.count > 0)
            let sampled = preset.sample(at: 0.5)
            #expect(sampled.red >= 0.0)
            #expect(sampled.red <= 1.0)
        }
    }
}
