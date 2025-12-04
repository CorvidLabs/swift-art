# swift-art

[![macOS](https://img.shields.io/github/actions/workflow/status/CorvidLabs/swift-art/macOS.yml?label=macOS&branch=main)](https://github.com/CorvidLabs/swift-art/actions/workflows/macOS.yml)
[![Ubuntu](https://img.shields.io/github/actions/workflow/status/CorvidLabs/swift-art/ubuntu.yml?label=Ubuntu&branch=main)](https://github.com/CorvidLabs/swift-art/actions/workflows/ubuntu.yml)
[![License](https://img.shields.io/github/license/CorvidLabs/swift-art)](https://github.com/CorvidLabs/swift-art/blob/main/LICENSE)
[![Version](https://img.shields.io/github/v/release/CorvidLabs/swift-art)](https://github.com/CorvidLabs/swift-art/releases)

> **Pre-1.0 Notice**: This library is under active development. The API may change between minor versions until 1.0.

A comprehensive Swift package for generative art and computational creativity, providing elegant, protocol-oriented abstractions for creating beautiful algorithmic art.

## Features

- **Pure Swift 6** with strict concurrency support
- **All types are Sendable** for safe concurrent usage
- **No external dependencies** (except swift-docc-plugin for documentation)
- **Protocol-oriented design** with value types
- **Type-safe** with strong compile-time guarantees
- **Comprehensive modules** covering noise, fractals, L-systems, cellular automata, particles, geometry, and color

## Supported Platforms

- iOS 16.0+
- macOS 13.0+
- tvOS 16.0+
- watchOS 9.0+
- visionOS 1.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/CorvidLabs/swift-art.git", from: "0.1.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies...
2. Enter package URL: `https://github.com/CorvidLabs/swift-art.git`
3. Select version and add to your target

## Module Organization

### Core
- **Point**: 2D and 3D point representations
- **Color**: RGBA color with various color space conversions
- **RandomSource**: Protocol for random number generation
- **ArtError**: Error types for the Art framework

### Noise Generation
- **NoiseGenerator**: Protocol for all noise generators
- **PerlinNoise**: Classic Perlin noise for smooth natural patterns
- **SimplexNoise**: Improved simplex noise with better performance
- **WorleyNoise**: Cellular/Voronoi noise for organic textures
- **FractalNoise**: Layered noise with octaves for complex patterns

### Fractals
- **Mandelbrot**: The classic Mandelbrot set
- **JuliaSet**: Julia set fractals with customizable parameters
- **Sierpinski**: Sierpinski triangle and variations
- **KochCurve**: Koch snowflake and curve variations

### L-Systems
- **LSystem**: Lindenmayer system for procedural generation
- **Turtle**: Turtle graphics interpreter for L-systems
- **Presets**: Common L-system presets (trees, plants, curves)

### Cellular Automata
- **GameOfLife**: Conway's Game of Life
- **ElementaryCA**: Elementary cellular automata (Rule 30, 110, etc.)

### Particle Systems
- **Particle**: Individual particle with position, velocity, acceleration
- **Force**: Force vectors for particle simulation
- **ParticleSystem**: System for managing multiple particles
- **Emitter**: Particle emitter with various emission patterns

### Geometry
- **Polygon**: Regular and irregular polygons
- **Shapes**: Circle, ellipse, rectangle, line primitives
- **Tessellation**: Tiling patterns
- **Voronoi**: Voronoi diagrams and Delaunay triangulation
- **Subdivision**: Subdivision surfaces

### Color
- **Harmony**: Color harmony rules (complementary, triadic, etc.)
- **Gradient**: Linear and radial gradients
- **Palette**: Color palette generation and management

## Usage Examples

### Perlin Noise

```swift
import Art

let noise = PerlinNoise(seed: 42)

// Generate 2D noise
for y in 0..<100 {
    for x in 0..<100 {
        let value = noise.noise(x: Double(x) / 10.0, y: Double(y) / 10.0)
        // value is between -1.0 and 1.0
    }
}

// Generate 3D noise for animation
let animatedValue = noise.noise(
    x: Double(x) / 10.0,
    y: Double(y) / 10.0,
    z: time
)
```

### Fractal Generation

```swift
import Art

let mandelbrot = Mandelbrot(
    width: 800,
    height: 600,
    maxIterations: 100
)

for y in 0..<600 {
    for x in 0..<800 {
        let iterations = mandelbrot.iterate(x: x, y: y)
        // Map iterations to colors
    }
}
```

### L-Systems and Turtle Graphics

```swift
import Art

// Create an L-system
let system = LSystem(
    axiom: "F",
    rules: ["F": "F+F--F+F"],
    angle: 60
)

// Generate iterations
let result = system.generate(iterations: 4)

// Interpret with turtle graphics
var turtle = Turtle(
    position: Point(x: 0, y: 0),
    angle: 0,
    stepSize: 10
)

let points = turtle.interpret(result, angleIncrement: system.angle)
// Use points to draw the fractal
```

### Particle System

```swift
import Art

var system = ParticleSystem()

// Add particles
for _ in 0..<100 {
    let particle = Particle(
        position: Point(x: 400, y: 300),
        velocity: Point(
            x: Double.random(in: -2...2),
            y: Double.random(in: -2...2)
        )
    )
    system.add(particle)
}

// Apply forces and update
let gravity = Force(x: 0, y: 0.1)
system.applyForce(gravity)
system.update(deltaTime: 1.0 / 60.0)
```

### Color Harmonies

```swift
import Art

let baseColor = Color(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0)

// Generate complementary colors
let complementary = Harmony.complementary(baseColor)

// Generate triadic color scheme
let triadic = Harmony.triadic(baseColor)

// Generate analogous colors
let analogous = Harmony.analogous(baseColor)
```

### Voronoi Diagrams

```swift
import Art

let points = (0..<20).map { _ in
    Point(
        x: Double.random(in: 0...800),
        y: Double.random(in: 0...600)
    )
}

let voronoi = Voronoi(sites: points, bounds: (800, 600))
let cells = voronoi.cells

// Use cells to render the diagram
```

### Cellular Automata

```swift
import Art

var life = GameOfLife(width: 100, height: 100)

// Set initial pattern (glider)
life.setAlive(x: 1, y: 0)
life.setAlive(x: 2, y: 1)
life.setAlive(x: 0, y: 2)
life.setAlive(x: 1, y: 2)
life.setAlive(x: 2, y: 2)

// Evolve the system
for _ in 0..<100 {
    life.step()
}
```

## Design Philosophy

This package follows modern Swift best practices in the style of 0xLeif:

- **Value types**: Structs and enums for most types
- **Protocol-oriented**: Composition over inheritance
- **Type safety**: Leveraging Swift's type system to prevent errors
- **Immutability**: Prefer `let` over `var`
- **Sendable**: Full concurrency support for Swift 6
- **Descriptive naming**: Clear, self-documenting APIs
- **Functional patterns**: Map, filter, reduce where appropriate
- **No force unwrapping**: Safe optional handling throughout

## Documentation

Full API documentation is available at [https://corvidlabs.github.io/swift-art/documentation/art/](https://corvidlabs.github.io/swift-art/documentation/art/)

## Advanced Usage

### Combining Noise Types

```swift
import Art

// Create layered noise by combining different noise types
let perlin = PerlinNoise(seed: 1)
let worley = WorleyNoise(seed: 2)

for y in 0..<height {
    for x in 0..<width {
        let p = perlin.noise(x: Double(x) / 50, y: Double(y) / 50)
        let w = worley.noise(x: Double(x) / 30, y: Double(y) / 30)
        let combined = (p + w) / 2.0
    }
}
```

### Custom L-System Rules

```swift
import Art

let dragonCurve = LSystem(
    axiom: "FX",
    rules: [
        "X": "X+YF+",
        "Y": "-FX-Y"
    ],
    angle: 90
)

let pattern = dragonCurve.generate(iterations: 10)
```

### Fractal Noise with Octaves

```swift
import Art

let fractalNoise = FractalNoise(
    baseNoise: PerlinNoise(seed: 42),
    octaves: 6,
    persistence: 0.5,
    lacunarity: 2.0
)

let value = fractalNoise.noise(x: x, y: y)
```

## Performance Considerations

- Noise generation is computationally intensive; consider caching results
- Particle systems scale linearly with particle count
- L-systems can grow exponentially; limit iterations for complex rules
- Use appropriate grid sizes for cellular automata based on your performance needs

## Contributing

Contributions are welcome! Please ensure all code:
- Follows Swift API Design Guidelines
- Includes tests for new functionality
- Maintains Swift 6 strict concurrency compliance
- Uses value types and protocol-oriented patterns
- Matches the coding style of the existing codebase

## License

MIT License - See LICENSE file for details

## Credits

Created by [Leif](https://github.com/CorvidLabs) with inspiration from Processing, p5.js, and the computational art community.
