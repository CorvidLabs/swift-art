---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-swift-art
artifact: research
---

# Research

- The full implementation contains 31 `Art`, 8 `ArtTerminal`, and 10 conditional `ArtUI` source files: 49 files and 6,846 source LOC.
- Eleven committed test files exercise 255 tests in 36 suites across core/color, noise, fractals, L-systems, automata, geometry, particles, terminal, and SwiftUI behavior.
- The parser identifies 411 distinct exported symbols. Each canonical API row is sourced from an audited declaration, adjacent source documentation, or an explicit field/case description; no generated stubs remain.
- Swift 6 builds `Art` and `ArtTerminal` cross-platform and includes `ArtUI` only when SwiftUI is importable. `swift-color` is a runtime bridge dependency; the DocC plugin is documentation-only.
- Existing hosted workflows independently cover Ubuntu, macOS, CodeQL, and main-branch DocC Pages publication.
