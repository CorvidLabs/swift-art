---
module: art
version: 3
status: active
files:
  - Sources/Art/CellularAutomata/ElementaryCA.swift
  - Sources/Art/CellularAutomata/GameOfLife.swift
  - Sources/Art/Color/Gradient.swift
  - Sources/Art/Color/Harmony.swift
  - Sources/Art/Color/Palette.swift
  - Sources/Art/Core/ArtError.swift
  - Sources/Art/Core/Color+Bridge.swift
  - Sources/Art/Core/Color.swift
  - Sources/Art/Core/Point.swift
  - Sources/Art/Core/RandomSource.swift
  - Sources/Art/Fractals/JuliaSet.swift
  - Sources/Art/Fractals/KochCurve.swift
  - Sources/Art/Fractals/Mandelbrot.swift
  - Sources/Art/Fractals/Sierpinski.swift
  - Sources/Art/Geometry/Polygon.swift
  - Sources/Art/Geometry/Shapes.swift
  - Sources/Art/Geometry/Subdivision.swift
  - Sources/Art/Geometry/Tessellation.swift
  - Sources/Art/Geometry/Voronoi.swift
  - Sources/Art/LSystems/LSystem.swift
  - Sources/Art/LSystems/Presets.swift
  - Sources/Art/LSystems/Turtle.swift
  - Sources/Art/Noise/FractalNoise.swift
  - Sources/Art/Noise/NoiseGenerator.swift
  - Sources/Art/Noise/PerlinNoise.swift
  - Sources/Art/Noise/SimplexNoise.swift
  - Sources/Art/Noise/WorleyNoise.swift
  - Sources/Art/Particles/Emitter.swift
  - Sources/Art/Particles/Force.swift
  - Sources/Art/Particles/Particle.swift
  - Sources/Art/Particles/ParticleSystem.swift
  - Sources/ArtTerminal/Animation/TerminalAnimator.swift
  - Sources/ArtTerminal/ArtTerminal.swift
  - Sources/ArtTerminal/Core/ASCIICanvas.swift
  - Sources/ArtTerminal/Core/ASCIIRenderable.swift
  - Sources/ArtTerminal/Renderers/CellularAutomataASCII.swift
  - Sources/ArtTerminal/Renderers/FractalASCII.swift
  - Sources/ArtTerminal/Renderers/LSystemASCII.swift
  - Sources/ArtTerminal/Renderers/NoiseASCII.swift
  - Sources/ArtUI/ArtUI.swift
  - Sources/ArtUI/Core/ArtRenderConfiguration.swift
  - Sources/ArtUI/Core/ColorConversion.swift
  - Sources/ArtUI/Export/ImageExporter.swift
  - Sources/ArtUI/Views/CellularAutomataViews.swift
  - Sources/ArtUI/Views/FractalViews.swift
  - Sources/ArtUI/Views/GeometryViews.swift
  - Sources/ArtUI/Views/LSystemView.swift
  - Sources/ArtUI/Views/NoiseView.swift
  - Sources/ArtUI/Views/ParticleSystemView.swift
db_tables: []
depends_on: []
---

# Swift Art

## Purpose

Swift Art is a Swift 6 generative-art package with three products: a cross-platform `Art` computation library, an `ArtTerminal` ASCII renderer, and a conditional Apple-platform `ArtUI` SwiftUI renderer and image exporter. It provides deterministic seeded randomness, color models and palettes, coherent and cellular noise, complex-plane and recursive fractals, L-systems, cellular automata, particle simulation, planar geometry, tessellation and subdivision, terminal animation, and native SwiftUI visualization.

## Public API

### Exported Functions

| Export | Description |
|---|---|
| `ElementaryCA` | One-dimensional Wolfram cellular automaton with a clamped 0...255 rule, dead boundaries, stepping, history, and seeded state generation. |
| `rule` | The elementary-automaton Wolfram rule clamped to the inclusive 0...255 range. |
| `setCell` | Sets a cell to the given value. |
| `getCell` | Gets the value of a cell. |
| `step` | Advances the automaton by one generation. |
| `generateHistory` | Generates a history of states for the given number of generations. |
| `setSingleCenterCell` | Sets the initial state with a single cell in the center. |
| `randomize` | Randomizes the state. |
| `WellKnownRule` | Well-known elementary CA rules. |
| `description` | Human-readable text for a named elementary rule or typed framework error. |
| `wellKnown` | Creates an elementary CA with a well-known rule. |
| `init` | Creates an elementary CA with the given rule number (0-255). |
| `rule30` | Named Rule 30 case for chaotic elementary-automaton evolution. |
| `rule54` | Named Rule 54 case for Sierpinski-like elementary-automaton evolution. |
| `rule60` | Named Rule 60 case for Pascal-triangle-like elementary-automaton evolution. |
| `rule90` | Named Rule 90 XOR case for Sierpinski-triangle evolution. |
| `rule110` | Named Rule 110 case for Turing-complete elementary-automaton evolution. |
| `rule124` | Named Rule 124 case for growth-pattern elementary-automaton evolution. |
| `rule150` | Named Rule 150 case for checkerboard-like elementary-automaton evolution. |
| `rule184` | Named Rule 184 case modeling one-dimensional traffic flow. |
| `rule250` | Named Rule 250 case for symmetric elementary-automaton evolution. |
| `GameOfLife` | Finite Conway Game of Life grid with safe cell access, standard evolution, seeded randomization, population queries, and pattern placement. |
| `width` | Stored horizontal cell or canvas extent; Game of Life preserves the supplied grid width and ASCII canvases clamp it to at least one. |
| `height` | Stored vertical cell or canvas extent; Game of Life preserves the supplied grid height and ASCII canvases clamp it to at least one. |
| `isAlive` | Gets the state of a cell. |
| `livingCells` | Returns all living cells as coordinates. |
| `clear` | Clears the grid (sets all cells to dead). |
| `populationCount` | Returns the number of living cells. |
| `placePattern` | Places a pattern at the specified position. |
| `Pattern` | Places a pattern at the specified position. |
| `cells` | Stored Boolean rows for a reusable Game of Life pattern, or generated normalized cells for a tessellation/fractal result. |
| `glider` | Glider pattern. |
| `blinker` | Blinker pattern (oscillator). |
| `toad` | Toad pattern (oscillator). |
| `beacon` | Beacon pattern (oscillator). |
| `block` | Block pattern (still life). |
| `beehive` | Beehive pattern (still life). |
| `lwss` | Lightweight spaceship (LWSS). |
| `gosperGliderGun` | Gosper glider gun. |
| `Gradient` | Sorted multi-stop RGB gradient with clamped sampling, palette conversion, reversal, and built-in artistic and perceptual presets. |
| `Stop` | Gradient color-position pair whose position is clamped into 0...1. |
| `color` | RGB value carried by a gradient stop or particle and preserved through the associated operation. |
| `position` | Gradient-stop position clamped to 0...1, or mutable particle/force location in 2D/3D space. |
| `stops` | Gradient stops stored in ascending position order. |
| `sample` | Samples the gradient at the given position [0, 1]. |
| `palette` | Creates a palette from this gradient. |
| `reversed` | Returns a reversed gradient. |
| `grayscale` | Linear gradient from black to white. |
| `rainbow` | Rainbow gradient. |
| `sunrise` | Sunrise gradient. |
| `sunset` | Sunset gradient. |
| `ocean` | Ocean gradient. |
| `fire` | Fire gradient. |
| `ice` | Ice gradient. |
| `forest` | Forest gradient. |
| `lavender` | Lavender gradient. |
| `gold` | Gold gradient. |
| `copper` | Copper gradient. |
| `viridis` | Viridis gradient (perceptually uniform, colorblind-friendly). |
| `plasma` | Plasma gradient (perceptually uniform, colorblind-friendly). |
| `Harmony` | Namespace for complementary, triadic, tetradic, analogous, split-complementary, monochromatic, shade, tint, and tone color generation. |
| `complementary` | Generates a complementary color (opposite on the color wheel). |
| `triadic` | Generates a triadic color scheme (3 colors evenly spaced on the color wheel). |
| `tetradic` | Generates a tetradic color scheme (4 colors in a rectangle on the color wheel). |
| `analogous` | Generates an analogous color scheme (adjacent colors on the color wheel). |
| `splitComplementary` | Generates a split complementary color scheme. |
| `monochromatic` | Generates a monochromatic color scheme (same hue, different saturation/lightness). |
| `shades` | Generates a shade variation (darker versions). |
| `tints` | Generates a tint variation (lighter versions). |
| `tones` | Generates a tone variation (grayed versions). |
| `HarmonyType` | Typed selection of every supported color-harmony algorithm and its configurable parameters. |
| `Palette` | Ordered RGB color collection with wrapped lookup, interpolated sampling, deterministic selection and shuffling, reversal, and presets. |
| `colors` | Ordered RGB values stored by a palette or cycled by a renderer. |
| `randomColor` | Returns a random color from the palette. |
| `count` | Returns the number of colors in the palette. |
| `shuffled` | Creates a new palette with shuffled colors. |
| `warm` | Warm colors palette. |
| `cool` | Cool colors palette. |
| `pastel` | Pastel palette. |
| `neon` | Neon palette. |
| `ArtError` | Typed framework error carrying diagnostic context for invalid input, ranges, colors, configuration, computation, and unavailable implementations. |
| `invalidInput` | ArtError case carrying diagnostic context for invalid caller input. |
| `invalidRange` | ArtError case carrying diagnostic context for an invalid numeric or collection range. |
| `invalidColor` | ArtError case carrying diagnostic context for invalid color data. |
| `invalidConfiguration` | ArtError case carrying diagnostic context for invalid framework configuration. |
| `computationFailed` | ArtError case carrying diagnostic context for a failed art computation. |
| `notImplemented` | ArtError case carrying diagnostic context for an unavailable implementation. |
| `asColor` | Convert to swift-color's Color type. |
| `asRGBColor` | Convert to swift-art's RGBColor type. |
| `asHSL` | Convert to swift-color's HSL type. |
| `asHSLColor` | Convert to swift-art's HSLColor type. |
| `RGBColor` | Sendable, hashable, codable red-green-blue-alpha color with clamped components, hex parsing, HSL conversion, and interpolation. |
| `red` | Clamped red component in 0...1, and the fully red built-in RGB color. |
| `green` | Clamped green component in 0...1, and the fully green built-in RGB color. |
| `blue` | Clamped blue component in 0...1, and the fully blue built-in RGB color. |
| `alpha` | Clamped opacity component in 0...1 preserved by RGB/HSL conversions. |
| `hexString` | Converts to hex string representation. |
| `toHSL` | Converts to HSL color space. |
| `lerp` | Linearly interpolates between this color and another. |
| `black` | Opaque RGB black preset `(0, 0, 0)` and the safe fallback for empty palette/gradient sampling. |
| `white` | Opaque RGB white preset `(1, 1, 1)`. |
| `yellow` | Opaque RGB yellow preset `(1, 1, 0)`. |
| `cyan` | Opaque RGB cyan preset `(0, 1, 1)`. |
| `magenta` | Opaque RGB magenta preset `(1, 0, 1)`. |
| `orange` | Opaque RGB orange preset `(1, 0.5, 0)` and the corresponding warm palette stop. |
| `purple` | Opaque RGB purple preset `(0.5, 0, 0.5)`. |
| `gray` | Opaque mid-gray RGB preset `(0.5, 0.5, 0.5)`. |
| `HSLColor` | Sendable, hashable, codable hue-saturation-lightness-alpha color with wrapped hue, clamped components, and RGB conversion. |
| `hue` | Hue in degrees [0, 360). |
| `saturation` | Saturation in range [0, 1]. |
| `lightness` | Lightness in range [0, 1]. |
| `toRGB` | Converts to RGB color space. |
| `Point2D` | Sendable, hashable, codable Cartesian point and vector with distance, magnitude, normalization, interpolation, and arithmetic. |
| `x` | Cartesian X coordinate used by the 2D/3D point and vector operations. |
| `y` | Cartesian Y coordinate used by the 2D/3D point and vector operations. |
| `zero` | The origin point (0, 0). |
| `distance` | Calculates the Euclidean distance to another point. |
| `manhattanDistance` | Calculates the Manhattan distance to another point. |
| `magnitude` | Returns the magnitude (length) of this point as a vector from origin. |
| `normalized` | Returns a normalized version of this point (unit vector). |
| `+` | Component-wise addition for two-dimensional and three-dimensional points/vectors. |
| `-` | Component-wise subtraction for two-dimensional and three-dimensional points/vectors. |
| `*` | Scalar multiplication for 2D/3D points in either operand order. |
| `/` | Scalar division for 2D/3D points. |
| `Point3D` | Sendable, hashable, codable three-dimensional point and vector with distance, magnitude, normalization, interpolation, dot/cross products, and arithmetic. |
| `z` | Cartesian Z coordinate used by three-dimensional point and vector operations. |
| `dot` | Computes the dot product with another point. |
| `cross` | Computes the cross product with another point. |
| `RandomSource` | Seedable xorshift64 generator for deterministic numbers, booleans, elements, shuffles, points, angles, and colors. |
| `nextUInt64` | Generates the next random UInt64 using xorshift64. |
| `nextDouble` | Generates a random Double in the range [0, 1). |
| `nextInt` | Generates a random Int in the range [0, upperBound). |
| `nextBool` | Generates a random Bool with the given probability of being true. |
| `nextElement` | Returns a random element from the given array. |
| `shuffle` | Shuffles an array in place using Fisher-Yates algorithm. |
| `nextPoint2D` | Generates a random Point2D within the specified bounds. |
| `nextPoint3D` | Generates a random Point3D within the specified bounds. |
| `nextAngle` | Generates a random angle in radians [0, 2π). |
| `nextColor` | Generates a random color with optional constraints. |
| `JuliaSet` | Complex-plane Julia-set sampler with escape counts, smooth coloring, containment, normalized iterations, and canonical constants. |
| `cReal` | Real component of the Julia set's fixed complex constant. |
| `cImaginary` | Imaginary component of the Julia set's fixed complex constant. |
| `maxIterations` | Maximum escape iterations used by Mandelbrot/Julia sampling and normalization. |
| `Sample` | A sample from the Julia set. |
| `iterations` | Number of iterations before escape. |
| `escaped` | Whether the point escaped to infinity. |
| `smoothValue` | Smooth coloring value for anti-aliasing. |
| `contains` | Checks if a point is in the Julia set. |
| `normalizedIterations` | Returns a normalized iteration count [0, 1] for coloring. |
| `classic` | Classic Julia set with interesting structure. |
| `dragon` | Dragon-like Julia set. |
| `dendrite` | Dendrite Julia set with branching patterns. |
| `spiral` | Spiral Julia set. |
| `douadyRabbit` | Douady rabbit Julia set. |
| `sanMarco` | San Marco Julia set. |
| `KochCurve` | Iterative Koch curve generator with closed snowflake and inverted anti-snowflake construction. |
| `generate` | Generates points for the Koch curve between two points. |
| `generateSnowflake` | Generates a Koch snowflake (three Koch curves forming a triangle). |
| `generateAntiSnowflake` | Generates an anti-snowflake (inverted Koch snowflake). |
| `Mandelbrot` | Complex-plane Mandelbrot sampler with escape counts, smooth coloring, containment, normalization, and local boundary detection. |
| `isBoundary` | Generates the boundary of the Mandelbrot set using edge detection. |
| `Sierpinski` | Namespace for seeded chaos-game points, recursive triangle subdivision and containment, and carpet cells. |
| `chaosGame` | Generates points for the Sierpinski triangle using the chaos game method. |
| `Triangle` | Three-vertex triangle value with area, perimeter, centroid, and barycentric containment; also used by Sierpinski subdivision. |
| `vertices` | Ordered points defining a Sierpinski triangle, geometric triangle, polygon, or Voronoi cell boundary. |
| `subdivide` | Splits a valid Sierpinski triangle into its three retained midpoint child triangles. |
| `subdivision` | Generates Sierpinski triangle using recursive subdivision. |
| `Carpet` | Sierpinski carpet generation and testing. |
| `size` | Sierpinski carpet radix used to compute the generated grid extent at a requested depth. |
| `generateCells` | Generates coordinates for all filled cells at the given depth. |
| `Polygon` | Hashable polygon with perimeter, shoelace area, centroid, edges, ray-cast containment, regular/star factories, and common shapes. |
| `vertexCount` | Number of vertices/sides. |
| `perimeter` | Calculates the perimeter of the polygon. |
| `area` | Calculates the area of the polygon using the shoelace formula. |
| `centroid` | Calculates the centroid of the polygon. |
| `edges` | Returns the line segments that make up the polygon. |
| `regular` | Creates a regular polygon with the given number of sides. |
| `star` | Creates a regular star polygon. |
| `triangle` | An equilateral triangle. |
| `square` | A square. |
| `pentagon` | A regular pentagon. |
| `hexagon` | A regular hexagon. |
| `octagon` | A regular octagon. |
| `Rectangle` | Axis-aligned rectangle with corners, measurements, containment, overlap testing, and intersection construction. |
| `origin` | Bottom-left position from which an axis-aligned rectangle's width and height extend. |
| `center` | Center point of the rectangle. |
| `minPoint` | Minimum point (bottom-left corner). |
| `maxPoint` | Maximum point (top-right corner). |
| `corners` | All four corners of the rectangle. |
| `intersects` | Checks if this rectangle intersects with another. |
| `intersection` | Returns the intersection of this rectangle with another. |
| `LineSegment` | Finite segment with length, midpoint, direction, interpolation, closest-point distance, and segment intersection. |
| `start` | Starting endpoint of a geometric line segment or turtle line. |
| `end` | Ending endpoint of a geometric line segment or turtle line. |
| `length` | Length of the line segment. |
| `midpoint` | Midpoint of the line segment. |
| `direction` | Direction vector of the line segment. |
| `normalizedDirection` | Normalized direction vector. |
| `point` | Checks if a point is inside the triangle. |
| `closestPoint` | Calculates the closest point on the line segment to the given point. |
| `Circle` | Center-radius circle with area, circumference, containment, intersection, and evenly spaced perimeter points. |
| `radius` | Circle radius, vortex influence radius, or shape/tessellation radius used by the enclosing API. |
| `circumference` | Circumference of the circle. |
| `points` | Returns points evenly distributed around the circle. |
| `Subdivision` | Namespace for triangle, Catmull-Clark, regular quadtree, and adaptive quadtree subdivision. |
| `subdivideTriangle` | Subdivides a triangle using the midpoint subdivision method. |
| `subdivideTriangles` | Subdivides triangles recursively. |
| `catmullClark` | Catmull-Clark subdivision for quadrilaterals. |
| `QuadtreeNode` | Recursive rectangle node with depth, optional four-way children, leaf traversal, and leaf rectangles. |
| `bounds` | Rectangle governed by a quadtree node or coordinate range used by a renderer/query. |
| `depth` | Current recursive quadtree level or requested fractal/subdivision recursion count. |
| `children` | Four child quadtree nodes before maximum depth, otherwise `nil` for a leaf. |
| `leaves` | Returns all leaf nodes. |
| `rectangles` | Returns all rectangles at the maximum depth. |
| `quadtree` | Creates a quadtree subdivision of a rectangle. |
| `adaptiveQuadtree` | Adaptive quadtree subdivision based on a condition function. |
| `Tessellation` | Namespace for square, hexagonal, triangular, brick, and finite Penrose-style polygon tilings. |
| `squareGrid` | Generates a square grid tessellation. |
| `hexagonalGrid` | Generates a hexagonal tessellation. |
| `triangularGrid` | Generates a triangular tessellation. |
| `brickPattern` | Generates a brick pattern tessellation. |
| `penroseTiling` | Generates a Penrose tiling (aperiodic tiling). |
| `Voronoi` | Site collection supporting nearest-site queries, cell indices, rasterization, approximate edges, distance fields, seeded sites, and relaxation. |
| `sites` | Stored point sites used for Voronoi nearest-neighbor, raster, edge, and relaxation queries. |
| `nearestSite` | Finds the nearest site to the given point. |
| `cellIndex` | Returns the index of the cell containing the given point. |
| `rasterize` | Generates a rasterized Voronoi diagram. |
| `generateEdges` | Generates cell boundaries using edge detection. |
| `distanceField` | Computes the distance to the nearest site at the given point. |
| `random` | Generates a random Voronoi diagram with the specified number of sites. |
| `relax` | Lloyd's relaxation algorithm for more evenly distributed sites. |
| `VoronoiCell` | Voronoi site and polygon value with derived area, perimeter, and centroid. |
| `site` | Finds the nearest site to the given point. |
| `LSystem` | Deterministic Lindenmayer-system axiom, character rules, angle, generation, history, fluent builder, presets, and stochastic helper. |
| `axiom` | Initial symbol string from which L-system generations are expanded. |
| `rules` | Character-to-string production map applied during each L-system generation. |
| `angle` | L-system turn angle in radians, also used as the default turtle angle increment. |
| `iterate` | Iterates the L-system for the specified number of generations. |
| `iterateWithHistory` | Generates multiple generations and returns all intermediate results. |
| `Builder` | Value-style fluent builder for an L-system axiom, production rules, and turn angle. |
| `build` | Produces an immutable LSystem from the builder's accumulated axiom, rules, and angle. |
| `builder` | Creates an empty value-style LSystem builder. |
| `kochCurve` | Koch curve L-system. |
| `sierpinskiTriangle` | Sierpinski triangle L-system. |
| `sierpinskiArrowhead` | Sierpinski arrowhead L-system. |
| `dragonCurve` | Dragon curve L-system. |
| `fractalPlant` | Fractal plant L-system. |
| `barnsleyFern` | Barnsley fern L-system. |
| `hilbertCurve` | Hilbert curve L-system. |
| `peanoCurve` | Peano curve L-system. |
| `gosperCurve` | Gosper curve (flowsnake) L-system. |
| `quadraticKochIsland` | Quadratic Koch island L-system. |
| `levyCurve` | Levy C curve L-system. |
| `crystal` | Crystal L-system. |
| `binaryTree` | Binary tree L-system. |
| `pentaplexity` | Pentaplexity L-system. |
| `mooreCurve` | Moore curve L-system. |
| `hexagonalGosper` | Hexagonal Gosper curve L-system. |
| `stochastic` | Creates a custom stochastic L-system that randomly chooses between rules. |
| `Turtle` | L-system turtle interpreter for drawing, movement, turning, branching, reversal, bounds, and fitted normalization. |
| `State` | Turtle position-and-angle state saved and restored by branch instructions. |
| `Line` | Turtle-produced line with start/end points plus derived length and midpoint. |
| `interpret` | Interprets an L-system string and generates lines. - instructions: The L-system string to interpret. - startPosition: Starting position of the turtle. - startAngle: Starting angle of the turtle (in radians). |
| `interpretWithState` | Interprets and returns both lines and final state. |
| `boundingBox` | Calculates the bounding box of the generated lines. |
| `normalize` | Normalizes lines to fit within the given bounds. |
| `FractalNoise` | Octave composition of any noise generator with persistence, lacunarity, scale, turbulence, and ridged sampling. |
| `turbulence` | Generates turbulence by using absolute values of noise. |
| `ridged` | Generates ridged noise (inverted and sharpened). |
| `NoiseGenerator` | Sendable protocol for 2D/3D noise sampling with point, normalization, and custom-range conveniences. |
| `mapped` | Maps the noise value to a custom range. |
| `PerlinNoise` | Seedable classic 2D/3D Perlin noise using a shuffled or canonical permutation table. |
| `SimplexNoise` | Seedable gradient simplex noise implementation for two and three dimensions. |
| `WorleyNoise` | Seedable 2D/3D cellular noise with selectable distance metric and nearest-feature-distance queries. |
| `DistanceFunction` | Worley feature-distance metric: Euclidean, Manhattan, Chebyshev, or parameterized Minkowski. |
| `sampleDistances` | Returns multiple closest distances for more advanced effects. |
| `euclidean` | Worley distance case using straight-line point distance. |
| `manhattan` | Worley distance case summing absolute coordinate differences. |
| `chebyshev` | Worley distance case using the greatest absolute coordinate difference. |
| `minkowski` | Worley distance case parameterized by exponent `p` for generalized Lp distance. |
| `EmitterConfig` | Mutable particle-emitter ranges for origin, rate, lifetime, speed, angle, mass, color, and color variation. |
| `emissionRate` | Particles emitted per unit elapsed time by an emitter configuration. |
| `particleLifetime` | Closed range from which each emitted particle lifetime is sampled. |
| `particleVelocity` | Closed speed range combined with a sampled emission angle for each emitted particle. |
| `emissionAngle` | Closed radians range from which each emitted particle direction is sampled. |
| `particleMass` | Closed mass range from which each emitted particle mass is sampled. |
| `particleColor` | Base RGB color assigned to emitted particles before optional seeded variation. |
| `colorVariation` | Maximum randomized per-channel particle color variation before clamping. |
| `Emitter` | Seeded particle emitter with elapsed-time emission, bursts, configuration-derived particles, and timer reset. |
| `config` | Mutable emitter configuration used for subsequent timed emission and bursts. |
| `emit` | Emits particles based on elapsed time. |
| `burst` | Emits a burst of particles. |
| `reset` | Resets the accumulated time. |
| `fountain` | Fountain-like particle emitter. |
| `explosion` | Explosion-like particle emitter. |
| `smoke` | Smoke-like particle emitter. |
| `sparkle` | Sparkle-like particle emitter. |
| `Force` | Sendable protocol that calculates a two-dimensional force vector for a particle. |
| `Force3D` | Sendable protocol that calculates a three-dimensional force vector for a particle. |
| `Gravity` | Constant downward force scaled by particle mass. |
| `strength` | Magnitude parameter applied by gravity, wind, attraction, repulsion, or vortex force calculation. |
| `calculate` | Computes the 2D/3D force vector contributed by a concrete force for the supplied particle. |
| `Gravity3D` | Normalized directional gravity force scaled by strength and particle mass. |
| `Wind` | Normalized directional wind with optional particle-identity-seeded turbulence. |
| `Drag` | Quadratic two-dimensional drag opposing particle velocity. |
| `coefficient` | Quadratic drag coefficient multiplied by squared particle speed. |
| `Drag3D` | Quadratic three-dimensional drag opposing particle velocity. |
| `Attractor` | Inverse-square attraction toward a 2D point with minimum and optional maximum distance. |
| `minDistance` | Lower distance clamp preventing singular inverse-square attraction or repulsion. |
| `maxDistance` | Optional upper influence distance beyond which attraction or repulsion returns zero. |
| `Attractor3D` | Inverse-square attraction toward a 3D point with minimum and optional maximum distance. |
| `Repeller` | Inverse-square repulsion from a 2D point with minimum and optional maximum distance. |
| `Vortex` | Radius-limited tangential force that weakens toward the vortex boundary. |
| `Particle` | Identifiable mutable 2D particle with position, velocity, acceleration, age, lifetime, mass, color, integration, and force application. |
| `id` | Stable UUID identifying a 2D or 3D particle and seeding deterministic turbulent wind. |
| `velocity` | Mutable 2D/3D particle velocity integrated from acceleration and then into position. |
| `acceleration` | Mutable accumulated 2D/3D acceleration reset before each system force pass. |
| `age` | Elapsed particle lifetime increased by each update delta. |
| `lifetime` | Particle expiry threshold; the particle remains alive only while age is lower. |
| `mass` | Particle mass used to convert force into acceleration and to scale gravity. |
| `normalizedAge` | Normalized age [0, 1]. |
| `update` | Updates the particle by the given time delta. |
| `applyForce` | Applies a force to the particle. |
| `resetAcceleration` | Resets the acceleration (typically done each frame). |
| `Particle3D` | Identifiable mutable 3D particle with position, velocity, acceleration, age, lifetime, mass, color, integration, and force application. |
| `ParticleSystem` | 2D particle collection that emits, applies forces, integrates, removes dead particles, enforces capacity, resets, and filters. |
| `particles` | Mutable ordered 2D/3D particle storage managed by the enclosing system. |
| `emitters` | Mutable emitter collection sampled during each 2D particle-system update. |
| `forces` | Mutable Sendable force collection applied to every particle during a system update. |
| `maxParticles` | Capacity enforced by dropping the oldest excess particles after updates. |
| `addEmitter` | Adds an emitter to the system. |
| `addForce` | Adds a force to the system. |
| `removeAllEmitters` | Removes all emitters. |
| `removeAllForces` | Removes all forces. |
| `clearParticles` | Clears all particles. |
| `particleCount` | Number of living particles. |
| `ParticleSystem3D` | 3D particle collection that applies forces, integrates, removes dead particles, enforces capacity, and accepts explicit particles. |
| `addParticle` | Adds a particle to the system. |
| `TerminalAnimator` | Frame-rate-controlled async terminal animator with optional ANSI screen clearing and string/canvas conveniences. |
| `fps` | The frames per second for the animation. |
| `clearScreen` | Whether to clear the screen between frames. |
| `animate` | Runs an animation loop. - frameCount: Number of frames to render (nil for infinite). - render: A closure that returns the canvas for each frame. |
| `animateString` | Runs an animation loop with a string-based renderer. - frameCount: Number of frames to render (nil for infinite). - render: A closure that returns the ASCII string for each frame. |
| `animateGameOfLife` | Animates a Game of Life instance in the terminal. - game: The initial game state (will be copied and evolved). - generations: Number of generations to animate (nil for infinite). - fps: Frames per second. - aliveChar: Character for living cells. - deadChar: Character for dead cells. |
| `animateASCII` | Runs an animated noise visualization in the terminal. - width: Canvas width. - height: Canvas height. - scale: Spatial scale. - timeScale: Temporal scale (speed of z-axis movement). - frames: Number of frames (nil for infinite). - fps: Frames per second. - palette: The character palette. |
| `ASCIICanvas` | Bounds-safe character grid with rendering, clearing, line, rectangle, fill, text, subscript, and description APIs. |
| `get` | Gets the character at the specified position. - x: The x coordinate (0 = left). - y: The y coordinate (0 = top). |
| `set` | Sets the character at the specified position. - character: The character to set. - position: The (x, y) position. |
| `render` | Renders the canvas to a multi-line string. |
| `drawHorizontalLine` | Draws a horizontal line. - y: The y coordinate. - fromX: Starting x coordinate. - toX: Ending x coordinate. - character: The character to draw with. |
| `drawVerticalLine` | Draws a vertical line. - x: The x coordinate. - fromY: Starting y coordinate. - toY: Ending y coordinate. - character: The character to draw with. |
| `drawRect` | Draws a rectangle outline. - x: Top-left x coordinate. - y: Top-left y coordinate. - rectWidth: Width of the rectangle. - rectHeight: Height of the rectangle. - character: The character to draw with. |
| `fillRect` | Fills a rectangle. - x: Top-left x coordinate. - y: Top-left y coordinate. - rectWidth: Width of the rectangle. - rectHeight: Height of the rectangle. - character: The character to fill with. |
| `drawText` | Draws text at the specified position. - text: The text to draw. - x: The starting x coordinate. - y: The y coordinate. |
| `subscript` | Subscript access to canvas characters. |
| `ASCIIRenderable` | Protocol for values that draw themselves into a mutable ASCII canvas under a render configuration. |
| `ASCIIRenderConfig` | ASCII palette and Y-axis orientation configuration with a standard default. |
| `invertY` | Whether to invert the Y axis. |
| `ASCIIPalette` | Non-empty brightness-ordered character palette with clamped lookup and six built-in ramps. |
| `characters` | Characters ordered from darkest to brightest. |
| `character` | Returns the character for a given brightness value [0, 1]. |
| `standard` | Standard ASCII palette using common punctuation. |
| `blocks` | Block characters for solid fills. |
| `minimal` | Minimal palette with just a few levels. |
| `binary` | Binary palette (just on/off). |
| `dots` | Dots palette. |
| `extended` | Extended grayscale using more characters. |
| `renderASCII` | Renders the Game of Life grid to an ASCII string. - aliveChar: Character for living cells. - deadChar: Character for dead cells. |
| `toASCIICanvas` | Creates an ASCII canvas with the grid rendered. |
| `renderHistoryASCII` | Renders the history to an ASCII string. - generations: Number of generations to generate. - aliveChar: Character for alive cells. - deadChar: Character for dead cells. |
| `ArtRenderConfiguration` | Sendable SwiftUI render colors, stroke width, point size, antialiasing flag, and dark/light presets. |
| `backgroundColor` | The background color for the canvas. |
| `strokeColor` | The default stroke color for lines and outlines. |
| `strokeWidth` | The default stroke width for lines. |
| `pointSize` | The default size for points/particles. |
| `antialiased` | Whether to apply antialiasing. |
| `light` | Light mode configuration with white background and black strokes. |
| `swiftUIColor` | Converts this RGBColor to a SwiftUI Color. |
| `ImageExporter` | Main-actor SwiftUI renderer that encodes views as PNG, JPEG, or platform-supported TIFF data/files. |
| `Format` | Image export selection for PNG, quality-parameterized JPEG, or TIFF. |
| `ExportError` | Typed image-export failure for rendering, encoding, unsupported platform, or file writing. |
| `export` | Exports a SwiftUI view to image data. - view: The view to export. - size: The size of the output image. - scale: The scale factor (default 2.0 for retina). - format: The image format. |
| `png` | Lossless PNG image-export format. |
| `jpeg` | JPEG image-export format carrying the caller's compression-quality value. |
| `tiff` | TIFF image-export format supported by the AppKit path and rejected by unsupported platforms. |
| `renderingFailed` | Export failure when SwiftUI ImageRenderer cannot produce a platform image. |
| `encodingFailed` | Export failure when a rendered platform image cannot encode the selected format. |
| `unsupportedPlatform` | Export failure when the requested image representation is unavailable on the compiled platform. |
| `writeFailed` | Export failure wrapping inability to write encoded image data to the destination URL. |
| `GameOfLifeView` | Interactive SwiftUI canvas bound to a Game of Life grid with configurable cells and optional grid lines. |
| `body` | SwiftUI view composition that renders the enclosing art value into a Canvas or TimelineView. |
| `GameOfLifeStaticView` | Non-interactive SwiftUI canvas for a snapshot of a Game of Life grid. |
| `ElementaryCAView` | SwiftUI canvas for supplied or generated elementary-automaton history. |
| `MandelbrotView` | SwiftUI pixel canvas mapping Mandelbrot smooth escape values through a gradient. |
| `MandelbrotBounds` | Complex-plane bounds for Mandelbrot rendering, including full-set and seahorse-valley presets. |
| `minReal` | Lower real-axis bound mapped to the left edge of a Mandelbrot or Julia view. |
| `maxReal` | Upper real-axis bound mapped to the right edge of a Mandelbrot or Julia view. |
| `minImaginary` | Lower imaginary-axis bound mapped into a Mandelbrot or Julia view. |
| `maxImaginary` | Upper imaginary-axis bound mapped into a Mandelbrot or Julia view. |
| `seahorseValley` | Zoomed view of the seahorse valley. |
| `JuliaSetView` | SwiftUI pixel canvas mapping Julia-set smooth escape values through a gradient. |
| `JuliaBounds` | Complex-plane bounds for Julia-set rendering with a full default range. |
| `SierpinskiView` | SwiftUI canvas that scales and fills recursively subdivided Sierpinski triangles. |
| `VoronoiView` | SwiftUI sampled nearest-site rendering with configurable cell colors, site markers, and edge markers. |
| `PolygonView` | SwiftUI path rendering for a polygon with optional fill and configurable stroke. |
| `HexagonalTessellationView` | SwiftUI rendering of a configurable hexagonal grid with cycled fills and optional strokes. |
| `LSystemView` | SwiftUI fitted line rendering for an expanded L-system or precomputed turtle lines. |
| `NoiseView` | SwiftUI pixel canvas mapping a generic 2D noise generator through a gradient. |
| `AnimatedNoiseView` | Timeline-driven SwiftUI noise canvas using the generator's third coordinate as time. |
| `ParticleSystemView` | Timeline-driven SwiftUI particle renderer that advances a private system near 60 frames per second. |
| `ParticleSystemStaticView` | Non-animated SwiftUI snapshot of current particle positions and lifetimes. |

## Invariants

- `Art` and `ArtTerminal` remain available anywhere the package builds; `ArtUI` is compiled only when SwiftUI is importable.
- Seeded generators, automata randomization, emitters, palettes, and stochastic construction are reproducible for the same seed and inputs.
- Public coordinate, color, noise, fractal, geometry, automata, particle, terminal, and rendering values preserve their documented bounds, defaults, ordering, and value semantics.
- Terminal canvases ignore out-of-bounds writes, return `nil` for out-of-bounds reads, and always have at least one row and column.
- SwiftUI views render the corresponding computation-layer values without changing computation semantics; image export stays main-actor isolated and reports typed format/platform/write failures.

## Behavioral Examples

- A seeded `PerlinNoise`, `SimplexNoise`, or `WorleyNoise` produces repeatable 2D/3D samples; `FractalNoise` layers a base generator and exposes turbulence and ridged variants.
- `GameOfLife.step()` applies Conway's neighbor rules, while `ElementaryCA.step()` applies the selected clamped Wolfram rule with dead boundary cells.
- An `LSystem` expands symbols, a `Turtle` interprets draw/move/turn/stack commands, and terminal or SwiftUI adapters fit the resulting lines to their output bounds.
- A `ParticleSystem` emits particles, resets and applies forces, integrates motion and age, removes expired particles, and enforces its configured maximum.
- Fractal, automata, noise, L-system, geometry, and particle values can be rendered to ASCII; Apple platforms additionally expose SwiftUI views and PNG/JPEG/TIFF export where supported.

## Error Cases

- Failable hex and palette initializers reject malformed color input; color components and gradient stops are clamped to their documented ranges.
- Geometry constructors that require at least three sides or exactly three vertices enforce those preconditions; degenerate and empty shapes return the documented zero, empty, or `nil` result.
- Noise, automata, palette, canvas, particle, and renderer methods use documented safe fallbacks for empty collections, invalid indices, zero vectors, dead particles, or out-of-bounds coordinates.
- `ImageExporter` distinguishes rendering, encoding, unsupported-platform, and file-write failures.
- `ArtError` preserves caller context for invalid input, range, color, configuration, computation, and unavailable implementation failures.

## Dependencies

- Swift 6 and Foundation.
- `CorvidLabs/swift-color` for bidirectional `RGBColor`/`HSLColor` bridges.
- SwiftUI plus AppKit or UIKit for the conditional `ArtUI` target and image export.
- `swift-docc-plugin` is a documentation-only package dependency and not part of runtime behavior.

## Change Log

- Version 1: Audited the complete 49-file public surface and adopted SpecSync 5.0.1 plus Trust 1.0.0 governance without changing product code.
| 2026-07-14 | CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-swift-art: Adopt SpecSync 5.0.1 and Trust 1.0.0 governance for swift-art |
| 2026-07-14 | CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-swift-art: Adopt SpecSync 5.0.1 and Trust 1.0.0 governance for swift-art |
