---
spec: art.spec.md
---

## Requirements

### REQ-art-001

The `Art` product SHALL provide Sendable 2D/3D points, seeded xorshift randomness, clamped RGB/HSL colors, color-space and swift-color bridges, interpolation, common colors, typed errors, and deterministic collection, point, and color sampling.

Acceptance Criteria
- Core and color tests pass for construction, bounds, conversion, operators, distances, vector products, deterministic sequences, collection operations, and error descriptions.

### REQ-art-002

The library SHALL provide 2D and 3D Perlin, simplex, Worley, and layered fractal noise with seeded determinism, selectable Worley distance metrics, normalization and range mapping, nearest-distance sampling, turbulence, and ridged variants.

Acceptance Criteria
- Noise tests pass for repeatability, ranges, dimensions, distance modes, octave composition, normalization, mapping, turbulence, and ridges.

### REQ-art-003

The library SHALL provide Mandelbrot and Julia escape sampling and presets, Sierpinski chaos, subdivision and carpet generation, and Koch curve and snowflake generation with committed iteration, containment, boundary, smoothing, and point-count behavior.

Acceptance Criteria
- Fractal tests pass for membership, escape counts, smoothing, normalized values, deterministic chaos, recursive subdivision, carpet cells, Koch growth, and snowflake variants.

### REQ-art-004

The library SHALL provide deterministic L-system rewriting, history, fluent construction, canonical presets, seeded stochastic generation, and turtle interpretation of drawing, movement, turn, branch-stack, reversal, bounds, and normalization commands.

Acceptance Criteria
- L-system tests pass for generation, histories, builders, presets, stochastic repeatability, turtle state and lines, stack behavior, bounds, and normalization.

### REQ-art-005

The library SHALL provide Conway Game of Life grids and patterns plus clamped Wolfram elementary cellular automata with safe cell access, deterministic randomization, stepping, histories, population counts, and named rules.

Acceptance Criteria
- Cellular-automata tests pass for initialization, cell access, still lifes, oscillators, patterns, clearing, randomization, rule tables, histories, and named-rule descriptions.

### REQ-art-006

The library SHALL provide triangles, rectangles, segments, circles, polygons, regular and star shapes, Voronoi nearest-site cells, rectangular, triangular and hexagonal tessellations, midpoint, Catmull-Clark and quadtree subdivision, containment, intersection, measurement, and spatial queries.

Acceptance Criteria
- Geometry tests pass for measurements, centroids, containment, intersections, regular shapes, Voronoi queries, grids, recursive and adaptive subdivision, and leaf enumeration.

### REQ-art-007

The library SHALL provide mutable 2D/3D particles, emitters and presets, gravity, wind, drag, attractor, repeller and vortex forces, and particle systems that integrate motion, age and forces, remove dead values, enforce capacity, reset state, and filter by age or bounds.

Acceptance Criteria
- Particle tests pass for lifetime and integration, mass-scaled force application, every force family, deterministic emission, bursts, system updates, cleanup, capacity, reset, and 3D behavior.

### REQ-art-008

The library SHALL provide color harmonies, palettes, gradients and presets with safe empty behavior, interpolation, sampling, reversal, deterministic shuffling and random selection, and committed perceptual palette data.

Acceptance Criteria
- Color tests pass for harmony families, palette construction, indexing, sampling and presets, gradient stops, sampling and reversal, and RGB/HSL conversion.

### REQ-art-009

The `ArtTerminal` product SHALL provide bounded ASCII canvases, brightness palettes, primitive drawing, noise, fractal, automata and L-system renderers, Bresenham line rendering, and timed animation helpers with configurable frame rate and clearing.

Acceptance Criteria
- ArtTerminal tests pass and all terminal exports compile against `Art` while preserving exact canvas dimensions and line separation.

### REQ-art-010

On SwiftUI-capable Apple platforms, `ArtUI` SHALL provide color conversion, render configuration, interactive and static automata, fractal, geometry, L-system, noise and particle views plus main-actor PNG, JPEG and TIFF export with typed failures.

Acceptance Criteria
- ArtUI tests and macOS build pass; Linux continues to build and test the non-SwiftUI products independently.

### REQ-art-011

The repository SHALL govern all 49 source files at 100% SpecSync file, LOC, and parsed-export coverage and preserve native macOS and Ubuntu, CodeQL, and independent DocC Pages workflows around the immutable Trust gate.

Acceptance Criteria
- Released SpecSync 5.0.1 reports every parsed export, 49/49 source files, and 6,846/6,846 source LOC.
- All 255 tests across 36 suites pass on the native macOS lane; preserved hosted platform and security checks pass on the final commit.

## Out of Scope

- GPU acceleration, raster/vector editing, audio/video rendering, network services, persistent scene formats, cross-platform SwiftUI emulation, and changes to existing algorithms or public product behavior.
