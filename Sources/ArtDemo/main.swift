import Foundation
import Art
import ArtUI
import ArtTerminal

// ArtDemo - A command-line demo showcasing swift-art capabilities

print("""
╔═══════════════════════════════════════════════════════════════╗
║                     swift-art Demo                             ║
║              Generative Art & Computational Creativity         ║
╚═══════════════════════════════════════════════════════════════╝
""")

// MARK: - Noise Demo

print("\n📊 Perlin Noise (ASCII)\n")

let perlin = PerlinNoise(seed: 42)
let noiseArt = perlin.renderASCII(
    width: 60,
    height: 20,
    scale: 0.08,
    palette: .blocks
)
print(noiseArt)

// MARK: - Mandelbrot Demo

print("\n🌀 Mandelbrot Set (ASCII)\n")

let mandelbrot = Mandelbrot(maxIterations: 50)
let mandelbrotArt = mandelbrot.renderASCII(
    width: 70,
    height: 25,
    palette: .extended
)
print(mandelbrotArt)

// MARK: - Cellular Automata Demo

print("\n🔬 Rule 110 Elementary CA\n")

var rule110 = ElementaryCA.wellKnown(.rule110, size: 71)
rule110.setSingleCenterCell()
let caArt = rule110.renderHistoryASCII(
    generations: 20,
    aliveChar: "█",
    deadChar: " "
)
print(caArt)

// MARK: - L-System Demo

print("\n🌿 Koch Curve L-System\n")

let kochCurve = LSystem.kochCurve
let kochArt = kochCurve.renderASCII(
    generations: 3,
    width: 60,
    height: 15,
    lineChar: "●"
)
print(kochArt)

// MARK: - Game of Life Demo

print("\n🎮 Game of Life (5 generations)\n")

var gameOfLife = GameOfLife(width: 40, height: 15)
gameOfLife.randomize(probability: 0.3, seed: 12345)

for gen in 0..<5 {
    print("Generation \(gen):")
    print(gameOfLife.renderASCII())
    print()
    gameOfLife.step()
}

// MARK: - Color Harmony Demo

print("\n🎨 Color Harmonies\n")

let baseColor = RGBColor(red: 0.2, green: 0.5, blue: 0.8)
print("Base color: \(baseColor.hexString)")

let complementary = Harmony.complementary(of: baseColor)
print("Complementary: \(complementary.map { $0.hexString }.joined(separator: ", "))")

let triadic = Harmony.triadic(of: baseColor)
print("Triadic: \(triadic.map { $0.hexString }.joined(separator: ", "))")

let analogous = Harmony.analogous(of: baseColor)
print("Analogous: \(analogous.map { $0.hexString }.joined(separator: ", "))")

// MARK: - Summary

print("""

╔═══════════════════════════════════════════════════════════════╗
║                     Demo Complete!                             ║
║                                                                 ║
║  Available Modules:                                            ║
║  • Art        - Core algorithms (noise, fractals, CA, etc.)   ║
║  • ArtUI      - SwiftUI views for rendering                   ║
║  • ArtTerminal - ASCII/Terminal rendering                     ║
║                                                                 ║
║  For SwiftUI usage, import ArtUI and use views like:          ║
║  • NoiseView, MandelbrotView, LSystemView                     ║
║  • GameOfLifeView, ElementaryCAView                           ║
║  • ParticleSystemView, VoronoiView                            ║
╚═══════════════════════════════════════════════════════════════╝
""")
