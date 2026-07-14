---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-swift-art
artifact: testing
---

# Testing

## Requirement Evidence

| Requirement | Native and source evidence |
|---|---|
| REQ-art-001 | `Tests/ArtTests/CoreTests.swift` and RGB/HSL cases in `Tests/ArtTests/ColorTests.swift` |
| REQ-art-002 | `Tests/ArtTests/NoiseTests.swift` |
| REQ-art-003 | `Tests/ArtTests/FractalTests.swift` |
| REQ-art-004 | `Tests/ArtTests/LSystemTests.swift` |
| REQ-art-005 | `Tests/ArtTests/CellularAutomataTests.swift` |
| REQ-art-006 | `Tests/ArtTests/GeometryTests.swift` |
| REQ-art-007 | `Tests/ArtTests/ParticleTests.swift` |
| REQ-art-008 | `Tests/ArtTests/ColorTests.swift` |
| REQ-art-009 | `Tests/ArtTerminalTests/ArtTerminalTests.swift` plus source review of canvas drawing, renderer, and animation exports |
| REQ-art-010 | `Tests/ArtUITests/ArtUITests.swift` plus macOS compilation of every conditional SwiftUI view and exporter |
| REQ-art-011 | Released SpecSync 5.0.1 strict coverage, all native suites, and the preserved hosted Trust, macOS, Ubuntu, and CodeQL checks |

`fledge lanes run verify` builds every locally available product and runs all 255 tests in 36 suites. `specsync check --strict --require-coverage 100 --force` must report 411/411 exports, 49/49 files, and 6,846/6,846 source LOC. The delivery diff must contain no `Sources/`, `Tests/`, `Package.swift`, or dependency changes.
