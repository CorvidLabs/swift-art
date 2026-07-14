---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-swift-art
artifact: context
---

# Context

Swift Art is an established Swift 6 package with 49 source files and 11 test files across a cross-platform computation library, terminal rendering, and conditional SwiftUI rendering/export. The migration adds verified governance while documenting the complete existing contract: 411 parsed exports, 6,846 source LOC, and 255 tests in 36 suites.

No `Sources/`, `Tests/`, package, dependency, or public behavior changes are part of this migration. Existing macOS, Ubuntu, CodeQL, and DocC Pages workflows remain independent of the unified Trust gate.
